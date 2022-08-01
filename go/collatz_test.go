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

func wrapFunction(n int64) int {
	return int(Function(big.NewInt(n)).Int64())
}

func wrapParamFunction(n int64, P int64, a int64, b int64) int {
	return int(ParameterisedFunction(big.NewInt(n), big.NewInt(P), big.NewInt(a), big.NewInt(b)).Int64())
}

func TestFunction_ZeroTrap(t *testing.T) {
	// Default/Any (P,a,b); 0 trap
	AssertEqual(t, wrapFunction(0), 0)
}

func TestFunction_OneCycle(t *testing.T) {
	// Default/Any (P,a,b); 1 cycle; positives
	AssertEqual(t, wrapFunction(1), 4)
	AssertEqual(t, wrapFunction(4), 2)
	AssertEqual(t, wrapFunction(2), 1)
}

func TestFunction_NegativeOneCycle(t *testing.T) {
	// Default/Any (P,a,b); -1 cycle; negatives
	AssertEqual(t, wrapFunction(-1), -2)
	AssertEqual(t, wrapFunction(-2), -1)
}

func TestFunction_WiderModuloSweep(t *testing.T) {
	// Test a wider modulo sweep by upping P to 5, a to 2, and b to 3.
	AssertEqual(t, wrapParamFunction(1, 5, 2, 3), 5)
	AssertEqual(t, wrapParamFunction(2, 5, 2, 3), 7)
	AssertEqual(t, wrapParamFunction(3, 5, 2, 3), 9)
	AssertEqual(t, wrapParamFunction(4, 5, 2, 3), 11)
	AssertEqual(t, wrapParamFunction(5, 5, 2, 3), 1)
}

func TestFunction_NegativeParamterisation(t *testing.T) {
	// Test negative P, a and b. Modulo, used in the function, has ambiguous functionality
	// rather than the more definite euclidean, but we only use it's (0 mod P)
	// conjugacy class to determine functionality, so the flooring for negative P
	// doesn't cause any issue.
	AssertEqual(t, wrapParamFunction(1, -3, -2, -5), -7)
	AssertEqual(t, wrapParamFunction(2, -3, -2, -5), -9)
	AssertEqual(t, wrapParamFunction(3, -3, -2, -5), -1)
}

// TestHelloEmpty calls greetings.Hello with an empty string,
// checking for an error.
func TestReverseFunction(t *testing.T) {
	AssertEqual(t, ReverseFunction(ZERO()), []*big.Int{ZERO()})
}
