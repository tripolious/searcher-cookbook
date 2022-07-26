package main

import (
	"log"
	"os"
)

func main() {
	rpcUrl := os.Getenv("RPC_MAINNET")
	if rpcUrl == "" {
		log.Fatalln("need RPC_MAINNET env")
	}

}
