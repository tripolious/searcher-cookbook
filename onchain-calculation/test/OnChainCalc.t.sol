// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "forge-std/Test.sol";
import "../src/OnChainCalc.sol";

contract OnChainCalcTest is Test{

    OnChainCalc onChainCalc;

    function setUp() public {
        // we fork to a specific block so we can test against the live state
        vm.createSelectFork("mainnet", 	15219623);
        vm.chainId(1);

        // init our calculator
        onChainCalc = new OnChainCalc();
    }

    function testCalcWithProfit() public {
        /*
            Info: [0000000000000000000000000000000000000000][00][00]
            [0000000000000000000000000000000000000000] = pair
            [00] zeroForOne
            [00] fee (Uni3 = always 00) - Uni2 = % in xx like 30 (0x1e) for 0,3%

            ------------------------------------------------------------------------
            Test good one
            --- Profit ---
            amountIn    =   100000000000000000        (weth)
            amountOut1  =   1554200677028070011974    (suku)
            amountOut2  =   102862456067231144        (weth)
            => + 2862456067231144

            Start Uniswap V3: SUKU
            [0xbac293e8951fe43f1087cef98435890ffc702b9d][00][00]

            Next SushiSwap: SUKU
            [0x2979fa622ccb9f6b8925ca831f30c405077730c6][01][1e]

            ------------------------------------------------------------------------
            Test bad one
            --- LOOSING ---
            amountIn    = 1000000000000000      (weth)
            amountOut1  = 215103499841939514    (uni)
            amountOut2  = 994170264002462       (weth)
            => - 5829735997538

            Start Uniswap V3: UNI
            [0x1d42064fc4beb5f8aaf85f4617ae8b3b5b8bd801][00][00]

            Next Uniswap V2: UNI 6
            [0xd3d2e2692501a5c9ca623199d38826e513033a17][01][1e]

        */

        uint256[] memory testData = new uint256[](4);
        testData[0] = 0xbac293e8951fe43f1087cef98435890ffc702b9d0000; // Uniswap V3: SUKU
        testData[1] = 0x2979fa622ccb9f6b8925ca831f30c405077730c6011e; // SushiSwap: SUKU
        testData[2] = 0x1d42064fc4beb5f8aaf85f4617ae8b3b5b8bd8010000; // Uniswap V3: UNI
        testData[3] = 0xd3d2e2692501a5c9ca623199d38826e513033a17011e; // Uniswap V2: UNI 6

        uint256[] memory amounts = onChainCalc.calc(getAmountsToCheck(), testData);

        uint256 loops = amounts.length;

        for (uint256 i = 0; i < loops; i++) {
            console.log(amounts[i]);
        }
    }

    function getAmountsToCheck() internal pure returns (uint256[] memory amounts) {
        amounts = new uint256[](7);
        amounts[0] = 0.001 ether;
        amounts[1] = 0.005 ether;
        amounts[2] = 0.01 ether;
        amounts[3] = 0.05 ether;
        amounts[4] = 0.1 ether;
        amounts[5] = 0.5 ether;
        amounts[6] = 1 ether;
    }
}

