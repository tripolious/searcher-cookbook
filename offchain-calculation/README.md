# off chain calculation for uni2 and uni3 pairs

I open-sourced [dexc](https://github.com/tripolious/dexc) to calculate trades off-chain.
You should always try to do most of your calculations and logic off chain.

I will update the package from time to time and add more DEXs to calculate swaps off chain.

You can find [examples](https://github.com/tripolious/dexc/tree/main/examples) to calculate swaps in the repo.

## Speed
Generally you should try to use the [package uint256](https://github.com/holiman/uint256) as it is 5-10 times faster than big.Int depending on your calculations.  
For uniswapv3 calculations you can save with [dexc](https://github.com/tripolious/dexc) an enormous amount of time for your calculations compared to the official [node sdk](https://github.com/Uniswap/v3-sdk) from uniswap or an on chain calculation.  

## Tips for uniswapv2
For uniswapv2 you need to set the `fee` when you create a new dex - for uniswapv2 it is for example `30` (0,3%), for other forks it could differ.  
To calculate a swap you need `reserve0` and `reserve1`. To get that information you could subscribe to the 
[Sync event](https://docs.uniswap.org/protocol/V2/reference/smart-contracts/pair#sync) 
or get it via [getreserves](https://docs.uniswap.org/protocol/V2/reference/smart-contracts/pair#getreserves).

## Tips for uniswapv3
For uniswapv3 you first need the basic information for the pool `tickSpacing` and `fee`.  
To calculate a swap you need the current `tick` + `sqrtPriceX96` and `liquidity`. 
To get that information you could subscribe to the [Swap event](https://docs.uniswap.org/protocol/reference/core/interfaces/pool/IUniswapV3PoolEvents#swap) 
or get it via [slot0](https://docs.uniswap.org/protocol/reference/core/interfaces/pool/IUniswapV3PoolState#slot0) 
plus [liquidity](https://docs.uniswap.org/protocol/reference/core/interfaces/pool/IUniswapV3PoolState#liquidity)  
You also need the complete tickList, this you can build through the events 
[Mint](https://docs.uniswap.org/protocol/reference/core/interfaces/pool/IUniswapV3PoolEvents#mint), 
[Burn](https://docs.uniswap.org/protocol/reference/core/interfaces/pool/IUniswapV3PoolEvents#burn) and 
[Collect](https://docs.uniswap.org/protocol/reference/core/interfaces/pool/IUniswapV3PoolEvents#collect).  
If you just want to check the current `liquidityGross` and `liquidityNet` you can call `ticks` for that specific tick.