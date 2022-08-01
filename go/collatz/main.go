package main

import (
	"fmt"
	"math/big"

	collatz "github.com/Skenvy/Collatz/go"
)

func main() {
	// Get a greeting message and print it.
	msg := collatz.Function(big.NewInt(27))
	fmt.Println(msg)
}
