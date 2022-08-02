package main

import (
	"fmt"
	"math/big"
	"os"
	"strconv"

	collatz "github.com/Skenvy/Collatz/go"
)

func main() {
	intVar, _ := strconv.ParseInt(os.Args[1], 10, 64)
	msg := collatz.Function(big.NewInt(intVar))
	fmt.Println(msg)
}
