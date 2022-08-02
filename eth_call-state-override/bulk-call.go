package main

import (
	"flag"
	"github.com/ethereum/go-ethereum/accounts/abi"
	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/common/hexutil"
	"github.com/ethereum/go-ethereum/rpc"
	"log"
	"math/big"
	"strings"
)

var rpc_url = flag.String("rpc", "", "rpc connection")

type OverwriteData map[common.Address]OverwriteCode
type OverwriteCode struct {
	Code string `json:"code"`
}
type RequestData struct {
	To   common.Address `json:"to"`
	Data string         `json:"data"`
}

func main() {
	flag.Parse()
	client, err := rpc.Dial(*rpc_url)
	if err != nil {
		log.Fatalf("cant connect to node: %s", err)
	}
	log.Println("connected to node")

	// array of pairs we want to check
	uni2Pairs := []common.Address{
		common.HexToAddress("0xB4e16d0168e52d35CaCD2c6185b44281Ec28C9Dc"),
		common.HexToAddress("0x3139Ffc91B99aa94DA8A2dc13f1fC36F9BDc98eE"),
		common.HexToAddress("0x12EDE161c702D1494612d19f05992f43aa6A26FB"),
	}

	var batch = make([]rpc.BatchElem, len(uni2Pairs))
	for key, val := range uni2Pairs {
		var result hexutil.Bytes
		var overWriteData = make(OverwriteData, 1)
		overWriteData[val] = OverwriteCode{
			Code: getUni2ReserveInfoByteCode(),
		}
		batch[key] = rpc.BatchElem{
			Method: "eth_call",
			Args: []interface{}{
				RequestData{
					To:   val,
					Data: "0x0902f1ac", // function sig 0902f1ac from our custom contract (getReserves())
				},
				"latest",
				overWriteData,
			},
			Result: &result,
		}
	}

	log.Println("making batch-call")
	if err := client.BatchCall(batch); err != nil {
		log.Fatalf("err in batch-call: %s", err)
	}

	contractAbi, err := abi.JSON(strings.NewReader(getUni2ReserveInfoAbi()))
	if err != nil {
		log.Fatalf("cant create contractAbi: %s", err)
	}

	for _, val := range batch {
		batchSingleRes := val.Result.(*hexutil.Bytes)
		res, err := contractAbi.Unpack("getReserves", *batchSingleRes)
		if err != nil {
			log.Printf("error in unpacking token res batch: %s", err)
		}

		pairAddr := res[0].(common.Address)
		reserve0 := res[2].(*big.Int)
		reserve1 := res[1].(*big.Int)

		log.Printf("Pair %s - reserve0: %s - reserver1: %s", pairAddr, reserve0.String(), reserve1.String())
	}
}

// func-sig 0902f1ac
// deployed byte-code of our fake contract Uni2ReserveInfo
func getUni2ReserveInfoByteCode() string {
	return "0x6080604052348015600f57600080fd5b506004361060285760003560e01c80630902f1ac14602d575b600080fd5b604860085430916001600160701b03607083901c8116921690565b604080516001600160a01b0390941684526001600160701b03928316602085015291169082015260600160405180910390f3fea26469706673582212208101b7b741aca654ea3905a1f312faf60095ff393dd12db2819b295c049478ee64736f6c634300080f0033"
}

func getUni2ReserveInfoAbi() string {
	return `[
		{
			"inputs": [],
			"name": "getReserves",
			"outputs": [
				{
					"internalType": "address",
					"name": "pair",
					"type": "address"
				},
				{
					"internalType": "uint112",
					"name": "reserve0",
					"type": "uint112"
				},
				{
					"internalType": "uint112",
					"name": "reserve1",
					"type": "uint112"
				}
			],
			"stateMutability": "view",
			"type": "function"
		}
	]`
}
