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

func wrapBigIntArr(vals []*big.Int) *[]int {
	var wraps []int = make([]int, len(vals))
	for index, val := range vals {
		wraps[index] = int(val.Int64())
	}
	return &wraps
}

func wrapReverseFunction(n int64) *[]int {
	vals := ReverseFunction(big.NewInt(n))
	var ret []int = []int{}
	for _, val := range vals {
		ret = append(ret, int(val.Int64()))
	}
	return &ret
}

func wrapParamReverseFunction(n int64, P int64, a int64, b int64) (*[]int, error) {
	vals, err := ParameterisedReverseFunction(big.NewInt(n), big.NewInt(P), big.NewInt(a), big.NewInt(b))
	if vals == nil {
		return nil, err
	}
	var ret *[]int = wrapBigIntArr(vals)
	return ret, err
}

func TestReverseFunction_ZeroTrap(t *testing.T) {
	// Default (P,a,b); 0 trap [as b is not a multiple of a]
	AssertEqual(t, wrapReverseFunction(0), nil, nil, &[]int{0})
}

func TestReverseFunction_OneCycle(t *testing.T) {
	// Default (P,a,b); 1 cycle; positives
	AssertEqual(t, wrapReverseFunction(1), nil, nil, &[]int{2})
	AssertEqual(t, wrapReverseFunction(4), nil, nil, &[]int{8, 1})
	AssertEqual(t, wrapReverseFunction(2), nil, nil, &[]int{4})
}

func TestReverseFunction_NegativeOneCycle(t *testing.T) {
	// Default (P,a,b); -1 cycle; negatives
	AssertEqual(t, wrapReverseFunction(-1), nil, nil, &[]int{-2})
	AssertEqual(t, wrapReverseFunction(-2), nil, nil, &[]int{-4, -1})
}

func TestReverseFunction_WiderModuloSweep(t *testing.T) {
	// Test a wider modulo sweep by upping P to 5, a to 2, and b to 3.
	val, err := wrapParamReverseFunction(1, 5, 2, 3)
	AssertEqual(t, val, err, nil, &[]int{5, -1})
	val, err = wrapParamReverseFunction(2, 5, 2, 3)
	AssertEqual(t, val, err, nil, &[]int{10})
	val, err = wrapParamReverseFunction(3, 5, 2, 3)
	AssertEqual(t, val, err, nil, &[]int{15}) // also tests !0
	val, err = wrapParamReverseFunction(4, 5, 2, 3)
	AssertEqual(t, val, err, nil, &[]int{20})
	val, err = wrapParamReverseFunction(5, 5, 2, 3)
	AssertEqual(t, val, err, nil, &[]int{25, 1})
}

func TestReverseFunction_NegativeParamterisation(t *testing.T) {
	// Test negative P, a and b. %, used in the function, is "floor" in python
	// rather than the more reasonable euclidean, but we only use it's (0 mod P)
	// conjugacy class to determine functionality, so the flooring for negative P
	// doesn't cause any issue.
	val, err := wrapParamReverseFunction(1, -3, -2, -5)
	AssertEqual(t, val, err, nil, &[]int{-3}) // != [-3, -3]
	val, err = wrapParamReverseFunction(2, -3, -2, -5)
	AssertEqual(t, val, err, nil, &[]int{-6})
	val, err = wrapParamReverseFunction(3, -3, -2, -5)
	AssertEqual(t, val, err, nil, &[]int{-9, -4})
}

func TestReverseFunction_ZeroReversesOnB(t *testing.T) {
	// If b is a multiple of a, but not of Pa, then 0 can have a reverse.
	val, err := wrapParamReverseFunction(0, 17, 2, -6)
	AssertEqual(t, val, err, nil, &[]int{0, 3})
	val, err = wrapParamReverseFunction(0, 17, 2, 102)
	AssertEqual(t, val, err, nil, &[]int{0})
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

func wrapHailstoneSequenceDefault(n int64) *HailstoneSequence {
	hs := HailstoneSequenceDefault(big.NewInt(n), 1000)
	return hs
}

func wrapHailstoneSequenceInterim(n int64, maxTotalStoppingTime int, totalStoppingTime bool) (*HailstoneSequence, error) {
	ret, err := ParameterisedHailstoneSequence(big.NewInt(n), DEFAULT_P(), DEFAULT_A(), DEFAULT_B(), maxTotalStoppingTime, totalStoppingTime)
	return ret, err
}

func wrapParameterisedHailstoneSequence(n int64, P int64, a int64, b int64, maxTotalStoppingTime int, totalStoppingTime bool) (*HailstoneSequence, error) {
	ret, err := ParameterisedHailstoneSequence(big.NewInt(n), big.NewInt(P), big.NewInt(a), big.NewInt(b), maxTotalStoppingTime, totalStoppingTime)
	return ret, err
}

func AssertHailstoneSequence(t *testing.T, hs *HailstoneSequence, received_error interface{}, expected_error error, expectedSequence *[]int, expectedTerminalCondition SequenceState, expectedTerminalStatus int) {
	if expected_error == nil {
		AssertEqual(t, wrapBigIntArr(hs.values), received_error, expected_error, expectedSequence)
		AssertEqual(t, hs.terminalCondition, received_error, expected_error, expectedTerminalCondition)
		AssertEqual(t, hs.terminalStatus, received_error, expected_error, expectedTerminalStatus)
	} else {
		AssertEqual(t, nil, received_error, expected_error, nil)
	}
}

func TestHailstoneSequence_ZeroTrap(t *testing.T) {
	// Test 0's immediated termination.
	AssertHailstoneSequence(t, wrapHailstoneSequenceDefault(0), nil, nil, &[]int{0}, ZERO_STOP, 0)
}

func TestHailstoneSequence_OnesCycleOnlyYieldsATotalStop(t *testing.T) {
	// The cycle containing 1 wont yield a cycle termination, as 1 is considered
	// the "total stop" that is the special case termination.
	AssertHailstoneSequence(t, wrapHailstoneSequenceDefault(1), nil, nil, &[]int{1}, TOTAL_STOPPING_TIME, 0)
	// 1's cycle wont yield a description of it being a "cycle" as far as the
	// hailstones are concerned, which is to be expected, so..
	AssertHailstoneSequence(t, wrapHailstoneSequenceDefault(4), nil, nil, &[]int{4, 2, 1}, TOTAL_STOPPING_TIME, 2)
	AssertHailstoneSequence(t, wrapHailstoneSequenceDefault(16), nil, nil, &[]int{16, 8, 4, 2, 1}, TOTAL_STOPPING_TIME, 4)
}

func TestHailstoneSequence_KnownCycles(t *testing.T) {
	// Test the 3 known default parameter's cycles (ignoring [1,4,2])
	for index, known_cycle := range KNOWN_CYCLES() {
		// if !reflect.DeepEqual(_MAP_INTS_TO_BIGINTS([]int64{1, 4, 2}), known_cycle) {
		if index != 0 {
			var expected []*big.Int = make([]*big.Int, (len(known_cycle) + 1))
			for k := 0; k < len(known_cycle); k++ {
				expected[k] = known_cycle[k]
			}
			expected[len(known_cycle)] = known_cycle[0]
			AssertHailstoneSequence(t, HailstoneSequenceDefault(known_cycle[0], 1000), nil, nil, wrapBigIntArr(expected), CYCLE_LENGTH, len(known_cycle))
		}
	}
}

func TestHailstoneSequence_Minus56(t *testing.T) {
	// Test the lead into a cycle by entering two of the cycles; -5
	var seq []*big.Int = KNOWN_CYCLES()[2]
	var _seq []*big.Int = make([]*big.Int, 2, len(seq)+3)
	_seq[0] = new(big.Int).Mul(seq[1], big.NewInt(4))
	_seq[1] = new(big.Int).Mul(seq[1], big.NewInt(2))
	_seq = append(_seq, seq[1:]...)
	_seq = append(_seq, seq[0:2]...)
	print(cap(_seq))
	AssertHailstoneSequence(t, wrapHailstoneSequenceDefault(-56), nil, nil, wrapBigIntArr(_seq), CYCLE_LENGTH, len(seq))
}

func TestHailstoneSequence_Minus200(t *testing.T) {
	// Test the lead into a cycle by entering two of the cycles; -17
	var seq []*big.Int = KNOWN_CYCLES()[3]
	var _seq []*big.Int = make([]*big.Int, 2, len(seq)+3)
	_seq[0] = new(big.Int).Mul(seq[1], big.NewInt(4))
	_seq[1] = new(big.Int).Mul(seq[1], big.NewInt(2))
	_seq = append(_seq, seq[1:]...)
	_seq = append(_seq, seq[0:2]...)
	AssertHailstoneSequence(t, wrapHailstoneSequenceDefault(-200), nil, nil, wrapBigIntArr(_seq), CYCLE_LENGTH, len(seq))
}

func TestHailstoneSequence_RegularStoppingTime(t *testing.T) {
	// Test the regular stopping time check.
	hail, err := wrapHailstoneSequenceInterim(4, 1000, false)
	AssertHailstoneSequence(t, hail, err, nil, &[]int{4, 2}, STOPPING_TIME, 1)
	hail, err = wrapHailstoneSequenceInterim(5, 1000, false)
	AssertHailstoneSequence(t, hail, err, nil, &[]int{5, 16, 8, 4}, STOPPING_TIME, 3)
}

func TestHailstoneSequence_NegativeMaxTotalStoppingTime(t *testing.T) {
	// Test small max total stopping time: (minimum internal value is one)
	hail, err := wrapHailstoneSequenceInterim(4, -100, true)
	AssertHailstoneSequence(t, hail, err, nil, &[]int{4, 2}, MAX_STOP_OUT_OF_BOUNDS, 1)
}

func TestHailstoneSequence_ZeroStopMidHail(t *testing.T) {
	// Test the zero stop mid hailing. This wont happen with default params tho.
	hail, err := wrapParameterisedHailstoneSequence(3, 2, 3, -9, 100, true)
	AssertHailstoneSequence(t, hail, err, nil, &[]int{3, 0}, ZERO_STOP, -1)
}

func TestHailstoneSequence_UnitaryPCausesAlmostImmediateCycles(t *testing.T) {
	// Lastly, while the function wont let you use a P value of 0, 1 and -1 are
	// still allowed, although they will generate immediate 1 or 2 length cycles
	// respectively, so confirm the behaviour of each of these hailstones.
	hail, err := wrapParameterisedHailstoneSequence(3, 1, 3, 1, 100, true)
	AssertHailstoneSequence(t, hail, err, nil, &[]int{3, 3}, CYCLE_LENGTH, 1)
	hail, err = wrapParameterisedHailstoneSequence(3, -1, 3, 1, 100, true)
	AssertHailstoneSequence(t, hail, err, nil, &[]int{3, -3, 3}, CYCLE_LENGTH, 2)
}

func TestHailstoneSequence_AssertSaneParameterisation(t *testing.T) {
	// Set P and a to 0 to assert on __assert_sane_parameterisation
	val, err := wrapParameterisedHailstoneSequence(1, 0, 2, 3, 1000, true)
	AssertEqual(t, val, err, FailedSaneParameterCheck(SANE_PARAMS_P), 0)
	val, err = wrapParameterisedHailstoneSequence(1, 0, 0, 3, 1000, true)
	AssertEqual(t, val, err, FailedSaneParameterCheck(SANE_PARAMS_P), 0)
	val, err = wrapParameterisedHailstoneSequence(1, 1, 0, 3, 1000, true)
	AssertEqual(t, val, err, FailedSaneParameterCheck(SANE_PARAMS_A), 0)
}
