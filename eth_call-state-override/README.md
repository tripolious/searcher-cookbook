# eth_call state override

As you maybe know you can use the third param in eth_call to override the state while you call the endpoint.  
This opens some possibilities, like query the chain or write a smart contract you don't need to deploy.

### bulk call to get reserves
In bulk-call.go you will find an example of how you can make a bulk call to eth_call and get the reserves from the pairs.  
The advantage of a bulk-call is, that you can run multiple smart contract calls with only one call to the node.  
You can use the bulk-call to group and reduce calls in general.

```go 
go run bulk-call/bulk-call.go --rpc _wss_connection_string_
```

### explanation
Normally the uni2 pair contract returns `_reserve0 uint112, _reserve1 uint112, _blockTimestampLast uint32`, but we want `address pair, uint112 reserve0, uint112 reserve1`

We use this contract to overwrite the state of original pair contract and return what we want.
```
//SPDX-License-Identifier: UNLICENSED
pragma solidity = 0.8.15;

contract Uni2ReserveInfo {

    function getReserves() public view returns (address pair, uint112 reserve0, uint112 reserve1) {
        assembly {
            let reserveHolder := sload(8)
            reserve0 := shr(144, shl(32, reserveHolder))
            reserve1 := shr(144, shl(144, reserveHolder))
        }
        pair = address(this);
    }
}
```

After you have your custom contract you need the deployed byte-code to use it to overwrite the state. To get the deployed byte-code you can use solc to generate it. 
```bash
solc Xyz.sol --bin-runtime --optimize
```

### Tips
Of course, you don't need to use assembly in your fake smart contract  
Here is an example without assembly
```
//SPDX-License-Identifier: UNLICENSED
pragma solidity = 0.6.12;

contract Uni3ReserveInfo {
    function getReserves(address pair) public view returns (address pairData, uint160 sqrtPriceX96, int24 tick, uint128 liquidity) {
        pairData = pair;
        (sqrtPriceX96, tick,,,,,) = IUniswapV3PoolData(pair).slot0();
        liquidity = IUniswapV3PoolData(pair).liquidity();
    }
}

interface IUniswapV3PoolData {
    function liquidity() external view returns (uint128);
    function slot0() external view returns (uint160 sqrtPriceX96, int24 tick, uint16 observationIndex, uint16 observationCardinality, uint16 observationCardinalityNext, uint8 feeProtocol, bool unlocked);
}
```

Generally you can also just use the BatchCall without an overwrite to reduce calls.