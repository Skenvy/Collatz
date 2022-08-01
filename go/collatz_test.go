package collatz

import (
	"math/big"
	"reflect"
	"testing"
)

// AssertEqual checks if values are equal
func AssertEqual(t *testing.T, a interface{}, b interface{}) {
	if reflect.DeepEqual(a, b) {
		return
	}
	// debug.PrintStack()
	t.Errorf("Received %v (type %v), expected %v (type %v)", a, reflect.TypeOf(a), b, reflect.TypeOf(b))
}

// TestHelloName calls greetings.Hello with a name, checking
// for a valid return value.
func TestFunction(t *testing.T) {
	AssertEqual(t, Function(ZERO()), ZERO())
}

// TestHelloEmpty calls greetings.Hello with an empty string,
// checking for an error.
func TestReverseFunction(t *testing.T) {
	AssertEqual(t, ReverseFunction(ZERO()), []*big.Int{ZERO()})
}
