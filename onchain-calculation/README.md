# on chain calculation for uni2 and uni3 pairs

Here I show you, how you can use a smart contract to make calculations on chain to get exact trade amounts for uni2 / uni3 swaps.  
It's only for a simple calculation to do a two-way swap a -> b -> a 

### Tip
If you don't know [foundry](https://github.com/foundry-rs/foundry) - check it out and get familiar with it. It will speed up your contract development a lot.

## Usage
First export your rpc_url as an environment variable, or start the tests with the env set. You can use your own node, infura, alchemy or what ever you want.

```shell
export export RPC_MAINNET=https://your-node-url
forge test
```

You will see two different calculations for trades. One is profitable and one is not.  
Checkout test/OnChainCalc.t.sol and src/OnChainCalc.sol for some additional notes regarding the calldata.

```go
go run main.go
```
Here you can find an example how you can call the contract in your bot and work with the results.

The bytecode used in the eth_call was generated with
```shell
solc src/OnChainCalc.sol --bin-runtime --optimize
```
Of course, you could also deploy the contract, so you can use eth_call on that contract on chain.   

## What Next
- You can try to add a three-way swap where you trade a -> b -> c -> a 
- Add some more tests to the actual contract
- Implement logic to replace the fixed amounts we check with a better calculation algo
- Get inspired with what you can do