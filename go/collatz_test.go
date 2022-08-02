package collatz

import (
	"math/big"
	"reflect"
	"runtime/debug"
	"testing"
)

// AssertEqual checks if values are equal
func AssertEqual(t *testing.T, received_value interface{}, received_error interface{}, expected_error error, expected_value interface{}) {
	if received_error != expected_error {
		// If the expected and received error are different, it's an error.
		t.Errorf("Compare Errors: Received \"%v\" (type %v), expected \"%v\" (type %v)", received_error, reflect.TypeOf(received_error), expected_error, reflect.TypeOf(expected_error))
	} else if expected_error != nil {
		// If expected error is not nil and matched the received error we abandon the value check.
		return
	}
	// If the expected error and actual error were both nil, then we test the values.
	if reflect.DeepEqual(received_value, expected_value) {
		return
	}
	// There was no error, but the values don't match!
	debug.PrintStack()
	t.Errorf("Compare Values: Received \"%v\" (type %v), expected \"%v\" (type %v)", received_value, reflect.TypeOf(received_value), expected_value, reflect.TypeOf(expected_value))
}

func wrapFunction(n int64) int {
	return int(Function(big.NewInt(n)).Int64())
}

func wrapParamFunction(n int64, P int64, a int64, b int64) (int, error) {
	val, err := ParameterisedFunction(big.NewInt(n), big.NewInt(P), big.NewInt(a), big.NewInt(b))
	if val == nil {
		return 0, err
	}
	return int(val.Int64()), err
}

func TestFunction_ZeroTrap(t *testing.T) {
	// Default/Any (P,a,b); 0 trap
	AssertEqual(t, wrapFunction(0), nil, nil, 0)
}

func TestFunction_OneCycle(t *testing.T) {
	// Default/Any (P,a,b); 1 cycle; positives
	AssertEqual(t, wrapFunction(1), nil, nil, 4)
	AssertEqual(t, wrapFunction(4), nil, nil, 2)
	AssertEqual(t, wrapFunction(2), nil, nil, 1)
}

func TestFunction_NegativeOneCycle(t *testing.T) {
	// Default/Any (P,a,b); -1 cycle; negatives
	AssertEqual(t, wrapFunction(-1), nil, nil, -2)
	AssertEqual(t, wrapFunction(-2), nil, nil, -1)
}

func TestFunction_WiderModuloSweep(t *testing.T) {
	// Test a wider modulo sweep by upping P to 5, a to 2, and b to 3.
	val, err := wrapParamFunction(1, 5, 2, 3)
	AssertEqual(t, val, err, nil, 5)
	val, err = wrapParamFunction(2, 5, 2, 3)
	AssertEqual(t, val, err, nil, 7)
	val, err = wrapParamFunction(3, 5, 2, 3)
	AssertEqual(t, val, err, nil, 9)
	val, err = wrapParamFunction(4, 5, 2, 3)
	AssertEqual(t, val, err, nil, 11)
	val, err = wrapParamFunction(5, 5, 2, 3)
	AssertEqual(t, val, err, nil, 1)
}

func TestFunction_NegativeParamterisation(t *testing.T) {
	// Test negative P, a and b. Modulo, used in the function, has ambiguous functionality
	// rather than the more definite euclidean, but we only use it's (0 mod P)
	// conjugacy class to determine functionality, so the flooring for negative P
	// doesn't cause any issue.
	val, err := wrapParamFunction(1, -3, -2, -5)
	AssertEqual(t, val, err, nil, -7)
	val, err = wrapParamFunction(2, -3, -2, -5)
	AssertEqual(t, val, err, nil, -9)
	val, err = wrapParamFunction(3, -3, -2, -5)
	AssertEqual(t, val, err, nil, -1)
}

func TestFunction_AssertSaneParameterisation(t *testing.T) {
	// Set P and a to 0 to assert on assertSaneParameterisation
	val, err := wrapParamFunction(1, 0, 2, 3)
	AssertEqual(t, val, err, FailedSaneParameterCheck(SANE_PARAMS_P), 0)
	val, err = wrapParamFunction(1, 0, 0, 3)
	AssertEqual(t, val, err, FailedSaneParameterCheck(SANE_PARAMS_P), 0)
	val, err = wrapParamFunction(1, 1, 0, 3)
	AssertEqual(t, val, err, FailedSaneParameterCheck(SANE_PARAMS_A), 0)
}

func wrapReverseFunction(n int64) []int {
	vals := ReverseFunction(big.NewInt(n))
	var ret []int = []int{}
	for _, val := range vals {
		ret = append(ret, int(val.Int64()))
	}
	return ret
}

func wrapParamReverseFunction(n int64, P int64, a int64, b int64) ([]int, error) {
	vals, err := ParameterisedReverseFunction(big.NewInt(n), big.NewInt(P), big.NewInt(a), big.NewInt(b))
	if vals == nil {
		return nil, err
	}
	var ret []int = []int{}
	for _, val := range vals {
		ret = append(ret, int(val.Int64()))
	}
	return ret, err
}

func TestReverseFunction_ZeroTrap(t *testing.T) {
	// Default (P,a,b); 0 trap [as b is not a multiple of a]
	AssertEqual(t, wrapReverseFunction(0), nil, nil, []int{0})
}

func TestReverseFunction_OneCycle(t *testing.T) {
	// Default (P,a,b); 1 cycle; positives
	AssertEqual(t, wrapReverseFunction(1), nil, nil, []int{2})
	AssertEqual(t, wrapReverseFunction(4), nil, nil, []int{8, 1})
	AssertEqual(t, wrapReverseFunction(2), nil, nil, []int{4})
}

func TestReverseFunction_NegativeOneCycle(t *testing.T) {
	// Default (P,a,b); -1 cycle; negatives
	AssertEqual(t, wrapReverseFunction(-1), nil, nil, []int{-2})
	AssertEqual(t, wrapReverseFunction(-2), nil, nil, []int{-4, -1})
}

func TestReverseFunction_WiderModuloSweep(t *testing.T) {
	// Test a wider modulo sweep by upping P to 5, a to 2, and b to 3.
	val, err := wrapParamReverseFunction(1, 5, 2, 3)
	AssertEqual(t, val, err, nil, []int{5, -1})
	val, err = wrapParamReverseFunction(2, 5, 2, 3)
	AssertEqual(t, val, err, nil, []int{10})
	val, err = wrapParamReverseFunction(3, 5, 2, 3)
	AssertEqual(t, val, err, nil, []int{15}) // also tests !0
	val, err = wrapParamReverseFunction(4, 5, 2, 3)
	AssertEqual(t, val, err, nil, []int{20})
	val, err = wrapParamReverseFunction(5, 5, 2, 3)
	AssertEqual(t, val, err, nil, []int{25, 1})
}

func TestReverseFunction_NegativeParamterisation(t *testing.T) {
	// Test negative P, a and b. %, used in the function, is "floor" in python
	// rather than the more reasonable euclidean, but we only use it's (0 mod P)
	// conjugacy class to determine functionality, so the flooring for negative P
	// doesn't cause any issue.
	val, err := wrapParamReverseFunction(1, -3, -2, -5)
	AssertEqual(t, val, err, nil, []int{-3}) // != [-3, -3]
	val, err = wrapParamReverseFunction(2, -3, -2, -5)
	AssertEqual(t, val, err, nil, []int{-6})
	val, err = wrapParamReverseFunction(3, -3, -2, -5)
	AssertEqual(t, val, err, nil, []int{-9, -4})
}

func TestReverseFunction_ZeroReversesOnB(t *testing.T) {
	// If b is a multiple of a, but not of Pa, then 0 can have a reverse.
	val, err := wrapParamReverseFunction(0, 17, 2, -6)
	AssertEqual(t, val, err, nil, []int{0, 3})
	val, err = wrapParamReverseFunction(0, 17, 2, 102)
	AssertEqual(t, val, err, nil, []int{0})
}

func TestReverseFunction_AssertSaneParameterisation(t *testing.T) {
	// Set P and a to 0 to assert on assertSaneParameterisation
	val, err := wrapParamReverseFunction(1, 0, 2, 3)
	AssertEqual(t, val, err, FailedSaneParameterCheck(SANE_PARAMS_P), 0)
	val, err = wrapParamReverseFunction(1, 0, 0, 3)
	AssertEqual(t, val, err, FailedSaneParameterCheck(SANE_PARAMS_P), 0)
	val, err = wrapParamReverseFunction(1, 1, 0, 3)
	AssertEqual(t, val, err, FailedSaneParameterCheck(SANE_PARAMS_A), 0)
}
