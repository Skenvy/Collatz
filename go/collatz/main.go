package main

import (
	"fmt"

	collatz "github.com/Skenvy/Collatz/go"
)

func main() {
	// Get a greeting message and print it.
	msg, _ := collatz.Hello("Gladys")
	fmt.Println(msg)
}
