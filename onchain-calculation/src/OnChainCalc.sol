// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "./interfaces/UniswapV2PairInterface.sol";
import "./interfaces/UniswapV3PoolActionsInterface.sol";

contract OnChainCalc {

    /*
        get trade amounts for uni2 / uni3 1-way trades

        checkAmounts = amounts we want to check for trading
        - [0.001 eth, 0.01 eth, 0.1 eth, 1 eth] we search then for what trade we get the best amountOut and return it in amounts

        _data = pairs to check for trading, always pair0 (amount in) plus pair1 (amount out)
        - [pair0, pair1, pair0, pair2] will check for trades between pair0<->pair1 and pair0<->pair2
        - we use uint256 as we store [pair][zeroForOne][fee] in it
            => [0000000000000000000000000000000000000000][00][00] format
            fee = 25 0.25% / 30 for 0.3%

        amounts will return for every pair trade check amountIn, amountOut1 and amountOut2
    */

    function calc(uint256[] calldata checkAmounts, uint256[] calldata _data) external returns(uint256[] memory amounts) {
        amounts = new uint256[](_data.length + (_data.length / 2));
        uint256 index = 0xF;
        uint256 counter;
        uint256 loops = _data.length;

        for(uint256 i = 0; i < loops; i + i++) {

            if(index == 0xF) {
                index = 0;
                amounts[i + counter] = checkAmounts[0];
                counter++;
            }

            amounts[i + counter] = getAmountForTrade(_data[i], amounts[i + counter - 1]);

            index++;
            if(index == 2) {
                index = 0xF;
                if(amounts[i + counter] > checkAmounts[0]) {
                    (
                        amounts[i + counter - 2],
                        amounts[i + counter - 1],
                        amounts[i + counter]
                    ) = getBestSwap(checkAmounts, _data[i - 1], _data[i]);
                }
            }

        }

        return amounts;
    }

    function getBestSwap(uint256[] memory checkAmounts, uint256 tradeOne, uint256 tradeTwo) internal returns (uint256 startAmount, uint256 amountOut1, uint256 amountOut2) {
        uint256 bestProfit;
        uint256 currentAmountOut1;
        uint256 currentAmountOut2;

        startAmount = checkAmounts[0];
        amountOut1 = 0;
        amountOut2 = 0;

        for(uint256 i = 0; i < checkAmounts.length; i++) {
            currentAmountOut1 = getAmountForTrade(tradeOne, checkAmounts[i]);
            currentAmountOut2 = getAmountForTrade(tradeTwo, currentAmountOut1);
            if(currentAmountOut2 > checkAmounts[i] && (currentAmountOut2 - checkAmounts[i]) > bestProfit) {
                bestProfit = currentAmountOut2 - checkAmounts[i];
                amountOut1 = currentAmountOut1;
                amountOut2 = currentAmountOut2;
                startAmount = checkAmounts[i];
            } else {
                break;
            }
        }
    }

    function getAmountForTrade(uint256 poolInfo, uint256 tradeAmount) internal returns (uint256 amountOut) {
        address pool;
        uint256 fee;
        bool zeroForOne;

        assembly {
            pool := shr(16, poolInfo)
            zeroForOne := shr(248, shl(240, poolInfo))
            fee := shr(248, shl(248, poolInfo))
        }

        if (fee == 0) {
            amountOut = getUniV3AmountOut(tradeAmount, pool, zeroForOne);
        }
        else {
            (uint256 reserveIn, uint256 reserveOut) = getUniV2Reserves(pool, zeroForOne);
            amountOut = getUniV2AmountOut(tradeAmount, reserveIn, reserveOut, fee);
        }
    }

    function getUniV2Reserves(address pair, bool zeroForOne) internal view returns (uint256 reserveA, uint256 reserveB) {

        (uint112 reserve0, uint112 reserve1) = UniswapV2PairInterface(pair).getReserves();

        if(zeroForOne) {
            reserveA = reserve0;
            reserveB = reserve1;
        } else {
            reserveA = reserve1;
            reserveB = reserve0;
        }
    }

    function getUniV2AmountOut(uint256 amountIn, uint256 reserveIn, uint256 reserveOut, uint256 fee) internal pure returns (uint256 out) {
        assembly {
            let aiwf := mul(amountIn, sub(10000, fee))
            out := div(mul(reserveOut,aiwf), add(mul(reserveIn,10000),aiwf))
        }
    }

    // we use a try catch to handle the uniswapV3SwapCallback where we will revert with the amount received as error
    function getUniV3AmountOut(uint256 tradingAmount, address pair, bool zeroForOne) internal returns (uint256 out) {
        uint160 sqrtPriceLimitX96 = zeroForOne ? uint160(4295128740) : uint160(1461446703485210103287273052203988822378723970341);

        try
        UniswapV3PoolActionsInterface(pair).swap(address(this), zeroForOne, int256(tradingAmount), sqrtPriceLimitX96, abi.encode(tradingAmount))
        {} catch (bytes memory reason) {
            if (reason.length != 32) {
                return 0;
            }
            return abi.decode(reason, (uint256));
        }
        return 0;
    }

    function uniswapV3SwapCallback(
        int256 amount0Delta,
        int256 amount1Delta,
        bytes memory data
    ) external pure {
        require(amount0Delta > 0 || amount1Delta > 0);

        (uint256 tradingAmount) = abi.decode(data, (uint256));

        (uint256 amountToPay, uint256 amountReceived) =
        amount0Delta > 0
        ? (uint256(amount0Delta), uint256(-amount1Delta))
        : (uint256(amount1Delta), uint256(-amount0Delta));

        if(amountToPay != tradingAmount) {
            amountReceived = 0;
        }

        assembly {
            let ptr := mload(0x40)
            mstore(ptr, amountReceived)
            revert(ptr, 32)
        }
    }
}