// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

interface UniswapV2PairInterface {
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1);
}