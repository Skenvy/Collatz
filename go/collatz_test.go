package collatz

import (
	"math"
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
	preNDivP, preANplusB := ReverseFunction(big.NewInt(n))
	var ret []int = []int{int(preNDivP.Int64())}
	if preANplusB != nil {
		ret = append(ret, int(preANplusB.Int64()))
	}
	return &ret
}

func wrapParamReverseFunction(n int64, P int64, a int64, b int64) (*[]int, error) {
	preNDivP, preANplusB, err := ParameterisedReverseFunction(big.NewInt(n), big.NewInt(P), big.NewInt(a), big.NewInt(b))
	if preNDivP == nil {
		return nil, err
	}
	var ret []int = []int{int(preNDivP.Int64())}
	if preANplusB != nil {
		ret = append(ret, int(preANplusB.Int64()))
	}
	return &ret, err
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
			var expected []*big.Int = make([]*big.Int, (len(*known_cycle) + 1))
			for k := 0; k < len(*known_cycle); k++ {
				expected[k] = (*known_cycle)[k]
			}
			expected[len(*known_cycle)] = (*known_cycle)[0]
			AssertHailstoneSequence(t, HailstoneSequenceDefault((*known_cycle)[0], 1000), nil, nil, wrapBigIntArr(expected), CYCLE_LENGTH, len(*known_cycle))
		}
	}
}

func TestHailstoneSequence_Minus56(t *testing.T) {
	// Test the lead into a cycle by entering two of the cycles; -5
	var seq []*big.Int = *KNOWN_CYCLES()[2]
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
	var seq []*big.Int = *KNOWN_CYCLES()[3]
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

func wrapStoppingTimeDefault(n int64) float64 {
	return StoppingTime(big.NewInt(n))
}

func wrapStoppingTimeInterim(n int64, maxStoppingTime int, totalStoppingTime bool) (float64, error) {
	return ParameterisedStoppingTime(big.NewInt(n), DEFAULT_P(), DEFAULT_A(), DEFAULT_B(), maxStoppingTime, totalStoppingTime)
}

func wrapParameterisedStoppingTime(n int64, P int64, a int64, b int64, maxStoppingTime int, totalStoppingTime bool) (float64, error) {
	return ParameterisedStoppingTime(big.NewInt(n), big.NewInt(P), big.NewInt(a), big.NewInt(b), maxStoppingTime, totalStoppingTime)
}

func TestStoppingTime_ZeroTrap(t *testing.T) {
	// Test 0's immediated termination.
	AssertEqual(t, wrapStoppingTimeDefault(0), nil, nil, 0.0)
}

func TestStoppingTime_OnesCycleOnlyYieldsATotalStop(t *testing.T) {
	// The cycle containing 1 wont yield a cycle termination, as 1 is considered
	// the "total stop" that is the special case termination.
	AssertEqual(t, wrapStoppingTimeDefault(1), nil, nil, 0.0)
	// 1's cycle wont yield a description of it being a "cycle" as far as the
	// hailstones are concerned, which is to be expected, so..
	val, err := wrapStoppingTimeInterim(4, 100, true)
	AssertEqual(t, val, err, nil, 2.0)
	val, err = wrapStoppingTimeInterim(16, 100, true)
	AssertEqual(t, val, err, nil, 4.0)
}

func TestStoppingTime_KnownCyclesYieldInfinity(t *testing.T) {
	// Test the 3 known default parameter's cycles (ignoring [1,4,2])
	for index, known_cycle := range KNOWN_CYCLES() {
		// if !reflect.DeepEqual(_MAP_INTS_TO_BIGINTS([]int64{1, 4, 2}), known_cycle) {
		if index != 0 {
			for _, cycle_values := range *known_cycle {
				val, err := wrapStoppingTimeInterim(cycle_values.Int64(), 100, true)
				AssertEqual(t, val, err, nil, math.Inf(1))
			}
		}
	}
}

func TestStoppingTime_KnownCycleLeadIns(t *testing.T) {
	// Test the lead into a cycle by entering two of the cycles. -56;-5, -200;-17
	val, err := wrapStoppingTimeInterim(-56, 100, true)
	AssertEqual(t, val, err, nil, math.Inf(1))
	val, err = wrapStoppingTimeInterim(-200, 100, true)
	AssertEqual(t, val, err, nil, math.Inf(1))
}

func TestStoppingTime_RegularStoppingTime(t *testing.T) {
	// Test the regular stopping time check.
	AssertEqual(t, wrapStoppingTimeDefault(4), nil, nil, 1.0)
	AssertEqual(t, wrapStoppingTimeDefault(5), nil, nil, 3.0)
}

func TestStoppingTime_NegativeMaxTotalStoppingTime(t *testing.T) {
	// Test small max total stopping time: (minimum internal value is one)
	val, err := wrapStoppingTimeInterim(5, -100, true)
	AssertEqual(t, val, err, nil, math.Inf(-1))
}

func TestStoppingTime_ZeroStopMidHail(t *testing.T) {
	// Test the zero stop mid hailing. This wont happen with default params tho.
	val, err := wrapParameterisedStoppingTime(3, 2, 3, -9, 100, false)
	AssertEqual(t, val, err, nil, -1.0)
}

func TestStoppingTime_UnitaryPCausesAlmostImmediateCycles(t *testing.T) {
	// Lastly, while the function wont let you use a P value of 0, 1 and -1 are
	// still allowed, although they will generate immediate 1 or 2 length cycles
	// respectively, so confirm the behaviour of each of these stopping times.
	val, err := wrapParameterisedStoppingTime(3, 1, 3, 1, 100, false)
	AssertEqual(t, val, err, nil, math.Inf(1))
	val, err = wrapParameterisedStoppingTime(3, -1, 3, 1, 100, false)
	AssertEqual(t, val, err, nil, math.Inf(1))
}

func TestStoppingTime_MultiplesOf576460752303423488Plus27(t *testing.T) {
	// One last one for the fun of it..
	val, err := wrapStoppingTimeInterim(27, 1000, true)
	AssertEqual(t, val, err, nil, 111.0)
	// # And for a bit more fun, common trajectories on
	mod_behaviour_factor := new(big.Int)
	mod_behaviour_factor, _ = mod_behaviour_factor.SetString("576460752303423488", 10)
	for k := 0; k < 5; k++ {
		input := new(big.Int).Add(big.NewInt(27), new(big.Int).Mul(big.NewInt(int64(k)), mod_behaviour_factor))
		val, err = ParameterisedStoppingTime(input, DEFAULT_P(), DEFAULT_A(), DEFAULT_B(), 1000, false)
		AssertEqual(t, val, err, nil, 96.0)
	}
}

func TestStoppingTime_AssertSaneParameterisation(t *testing.T) {
	// Set P and a to 0 to assert on __assert_sane_parameterisation
	val, err := wrapParameterisedStoppingTime(1, 0, 2, 3, 1000, false)
	AssertEqual(t, val, err, FailedSaneParameterCheck(SANE_PARAMS_P), 0)
	val, err = wrapParameterisedStoppingTime(1, 0, 0, 3, 1000, false)
	AssertEqual(t, val, err, FailedSaneParameterCheck(SANE_PARAMS_P), 0)
	val, err = wrapParameterisedStoppingTime(1, 1, 0, 3, 1000, false)
	AssertEqual(t, val, err, FailedSaneParameterCheck(SANE_PARAMS_A), 0)
}

func wrapParamTreeGraph(nodeValue int64, maxOrbitDistance int, P int64, a int64, b int64) (*TreeGraph, error) {
	return ParameterisedTreeGraph(big.NewInt(nodeValue), maxOrbitDistance, big.NewInt(P), big.NewInt(a), big.NewInt(b))
}

func wrapTreeGraph(nodeValue int64, maxOrbitDistance int) (*TreeGraph, error) {
	return TreeGraphDefault(big.NewInt(nodeValue), maxOrbitDistance)
}

// Create a "terminal" graph node with nil children and the terminal
// condition that indicates it has reached the maximum orbit of the tree.
func wrapTGN_TerminalNode(n int64) *TreeGraphNode {
	return newTreeGraphNode(big.NewInt(n), MAX_STOP_OUT_OF_BOUNDS, nil, nil, nil)
}

// Create a "cyclic terminal" graph node with nil children and the "cycle termination" condition.
func wrapTGN_CyclicTerminal(n int64) *TreeGraphNode {
	return newTreeGraphNode(big.NewInt(n), CYCLE_LENGTH, nil, nil, nil)
}

// Create a "cyclic start" graph node with given children and the "cycle start" condition.
//     n
//     preNDivPNode
//     preANplusBNode
func wrapTGN_CyclicStart(n int64, preNDivPNode *TreeGraphNode, preANplusBNode *TreeGraphNode, cycleCheck map[string]*TreeGraphNode) *TreeGraphNode {
	return newTreeGraphNode(big.NewInt(n), CYCLE_INIT, preNDivPNode, preANplusBNode, cycleCheck)
}

/**
 * Create a graph node with no terminal state, with given children.
 * @param n
 * @param preNDivPNode
 * @param preANplusBNode
 * @return
 */
func wrapTGN_Generic(n int64, preNDivPNode *TreeGraphNode, preANplusBNode *TreeGraphNode, cycleCheck map[string]*TreeGraphNode) *TreeGraphNode {
	return newTreeGraphNode(big.NewInt(n), NO_STATE, preNDivPNode, preANplusBNode, cycleCheck)
}

func TestTreeGraph_ZeroTrap(t *testing.T) {
	// ":D" for terminal, "C:" for cyclic end
	// The default zero trap
	// {0:D}
	received_tree, received_error := wrapTreeGraph(0, 0)
	expectedRoot := wrapTGN_TerminalNode(0)
	AssertEqual(t, received_tree, received_error, nil, newTreeGraph(expectedRoot))
	// {0:{C:0}}
	received_tree, received_error = wrapTreeGraph(0, 1)
	expectedRoot = wrapTGN_CyclicStart(0, wrapTGN_CyclicTerminal(0), nil, received_tree.root.cycleCheck)
	AssertEqual(t, received_tree, received_error, nil, newTreeGraph(expectedRoot))
	received_tree, received_error = wrapTreeGraph(0, 2)
	expectedRoot = wrapTGN_CyclicStart(0, wrapTGN_CyclicTerminal(0), nil, received_tree.root.cycleCheck)
	AssertEqual(t, received_tree, received_error, nil, newTreeGraph(expectedRoot))
}

func TestTreeGraph_RootOfOneYieldsTheOneCycle(t *testing.T) {
	// ":D" for terminal, "C:" for cyclic end
	// The roundings of the 1 cycle.
	// {1:D}
	received_tree, received_error := wrapTreeGraph(1, 0)
	expectedRoot := wrapTGN_TerminalNode(1)
	AssertEqual(t, received_tree, received_error, nil, newTreeGraph(expectedRoot))
	// {1:{2:D}}
	received_tree, received_error = wrapTreeGraph(1, 1)
	expectedRoot = wrapTGN_Generic(1, wrapTGN_TerminalNode(2), nil, received_tree.root.cycleCheck)
	AssertEqual(t, received_tree, received_error, nil, newTreeGraph(expectedRoot))
	// {1:{2:{4:D}}}
	received_tree, received_error = wrapTreeGraph(1, 2)
	expectedRoot = wrapTGN_Generic(1, wrapTGN_Generic(2, wrapTGN_TerminalNode(4), nil, received_tree.root.cycleCheck), nil, received_tree.root.cycleCheck)
	AssertEqual(t, received_tree, received_error, nil, newTreeGraph(expectedRoot))
	// {1:{2:{4:{C:1,8:D}}}}
	received_tree, received_error = wrapTreeGraph(1, 3)
	expectedRoot = wrapTGN_CyclicStart(1, wrapTGN_Generic(2, wrapTGN_Generic(4, wrapTGN_TerminalNode(8), wrapTGN_CyclicTerminal(1), received_tree.root.cycleCheck), nil, received_tree.root.cycleCheck), nil, received_tree.root.cycleCheck)
	AssertEqual(t, received_tree, received_error, nil, newTreeGraph(expectedRoot))
}

func TestTreeGraph_RootOfTwoAndFourYieldTheOneCycle(t *testing.T) {
	// ":D" for terminal, "C:" for cyclic end
	// {2:{4:{1:{C:2},8:{16:D}}}}
	received_tree, received_error := wrapTreeGraph(2, 3)
	expectedRoot := wrapTGN_CyclicStart(2, wrapTGN_Generic(4, wrapTGN_Generic(8, wrapTGN_TerminalNode(16), nil, received_tree.root.cycleCheck),
		wrapTGN_Generic(1, wrapTGN_CyclicTerminal(2), nil, received_tree.root.cycleCheck), received_tree.root.cycleCheck), nil, received_tree.root.cycleCheck)
	AssertEqual(t, received_tree, received_error, nil, newTreeGraph(expectedRoot))
	// {4:{1:{2:{C:4}},8:{16:{5:D,32:D}}}}
	received_tree, received_error = wrapTreeGraph(4, 3)
	expectedRoot = wrapTGN_CyclicStart(4, wrapTGN_Generic(8, wrapTGN_Generic(16, wrapTGN_TerminalNode(32), wrapTGN_TerminalNode(5), received_tree.root.cycleCheck), nil, received_tree.root.cycleCheck),
		wrapTGN_Generic(1, wrapTGN_Generic(2, wrapTGN_CyclicTerminal(4), nil, received_tree.root.cycleCheck), nil, received_tree.root.cycleCheck), received_tree.root.cycleCheck)
	AssertEqual(t, received_tree, received_error, nil, newTreeGraph(expectedRoot))
}

func TestTreeGraph_RootOfMinusOneYieldsTheMinusOneCycle(t *testing.T) {
	// ":D" for terminal, "C:" for cyclic end
	// The roundings of the -1 cycle
	// {-1:{-2:D}}
	received_tree, received_error := wrapTreeGraph(-1, 1)
	expectedRoot := wrapTGN_Generic(-1, wrapTGN_TerminalNode(-2), nil, received_tree.root.cycleCheck)
	AssertEqual(t, received_tree, received_error, nil, newTreeGraph(expectedRoot))
	// {-1:{-2:{-4:D,C:-1}}}
	received_tree, received_error = wrapTreeGraph(-1, 2)
	expectedRoot = wrapTGN_CyclicStart(-1, wrapTGN_Generic(-2, wrapTGN_TerminalNode(-4), wrapTGN_CyclicTerminal(-1), received_tree.root.cycleCheck), nil, received_tree.root.cycleCheck)
	AssertEqual(t, received_tree, received_error, nil, newTreeGraph(expectedRoot))
}

func TestTreeGraph_WiderModuloSweep(t *testing.T) {
	// ":D" for terminal, "C:" for cyclic end
	// Test a wider modulo sweep by upping P to 5, a to 2, and b to 3.
	// Orbit distance of 1 ~= {1:{-1:D,5:D}}
	received_tree, received_error := wrapParamTreeGraph(1, 1, 5, 2, 3)
	expectedRoot := wrapTGN_Generic(1, wrapTGN_TerminalNode(5), wrapTGN_TerminalNode(-1), received_tree.root.cycleCheck)
	AssertEqual(t, received_tree, received_error, nil, newTreeGraph(expectedRoot))
	// Orbit distance of 2 ~= {1:{-1:{-5:D,-2:D},5:{C:1,25:D}}}
	received_tree, received_error = wrapParamTreeGraph(1, 2, 5, 2, 3)
	expectedRoot = wrapTGN_CyclicStart(1, wrapTGN_Generic(5, wrapTGN_TerminalNode(25), wrapTGN_CyclicTerminal(1), received_tree.root.cycleCheck),
		wrapTGN_Generic(-1, wrapTGN_TerminalNode(-5), wrapTGN_TerminalNode(-2), received_tree.root.cycleCheck), received_tree.root.cycleCheck)
	AssertEqual(t, received_tree, received_error, nil, newTreeGraph(expectedRoot))
	// Orbit distance of 3 ~=  {1:{-1:{-5:{-25:D,-4:D},-2:{-10:D}},5:{C:1,25:{11:D,125:D}}}}
	received_tree, received_error = wrapParamTreeGraph(1, 3, 5, 2, 3)
	expectedRoot = wrapTGN_CyclicStart(1, wrapTGN_Generic(5, wrapTGN_Generic(25, wrapTGN_TerminalNode(125), wrapTGN_TerminalNode(11), received_tree.root.cycleCheck), wrapTGN_CyclicTerminal(1), received_tree.root.cycleCheck),
		wrapTGN_Generic(-1, wrapTGN_Generic(-5, wrapTGN_TerminalNode(-25), wrapTGN_TerminalNode(-4), received_tree.root.cycleCheck), wrapTGN_Generic(-2, wrapTGN_TerminalNode(-10), nil, received_tree.root.cycleCheck), received_tree.root.cycleCheck), received_tree.root.cycleCheck)
	AssertEqual(t, received_tree, received_error, nil, newTreeGraph(expectedRoot))
}

func TestTreeGraph_NegativeParamterisation(t *testing.T) {
	// ":D" for terminal, "C:" for cyclic end
	// Test negative P, a and b ~ P=-3, a=-2, b=-5
	// Orbit distance of 1 ~= {1:{-3:D}}
	received_tree, received_error := wrapParamTreeGraph(1, 1, -3, -2, -5)
	expectedRoot := wrapTGN_Generic(1, wrapTGN_TerminalNode(-3), nil, received_tree.root.cycleCheck)
	AssertEqual(t, received_tree, received_error, nil, newTreeGraph(expectedRoot))
	// Orbit distance of 2 ~= {1:{-3:{-1:D,9:D}}}
	received_tree, received_error = wrapParamTreeGraph(1, 2, -3, -2, -5)
	expectedRoot = wrapTGN_Generic(1, wrapTGN_Generic(-3, wrapTGN_TerminalNode(9), wrapTGN_TerminalNode(-1), received_tree.root.cycleCheck), nil, received_tree.root.cycleCheck)
	AssertEqual(t, received_tree, received_error, nil, newTreeGraph(expectedRoot))
	// Orbit distance of 3 ~= {1:{-3:{-1:{-2:D,3:D},9:{-27:D,-7:D}}}}
	received_tree, received_error = wrapParamTreeGraph(1, 3, -3, -2, -5)
	expectedRoot = wrapTGN_Generic(1, wrapTGN_Generic(-3, wrapTGN_Generic(9, wrapTGN_TerminalNode(-27), wrapTGN_TerminalNode(-7), received_tree.root.cycleCheck),
		wrapTGN_Generic(-1, wrapTGN_TerminalNode(3), wrapTGN_TerminalNode(-2), received_tree.root.cycleCheck), received_tree.root.cycleCheck), nil, received_tree.root.cycleCheck)
	AssertEqual(t, received_tree, received_error, nil, newTreeGraph(expectedRoot))
}

func TestTreeGraph_ZeroReversesOnB(t *testing.T) {
	// ":D" for terminal, "C:" for cyclic end
	// If b is a multiple of a, but not of Pa, then 0 can have a reverse.
	// {0:{C:0,3:D}}
	received_tree, received_error := wrapParamTreeGraph(0, 1, 17, 2, -6)
	expectedRoot := wrapTGN_CyclicStart(0, wrapTGN_CyclicTerminal(0), wrapTGN_TerminalNode(3), received_tree.root.cycleCheck)
	AssertEqual(t, received_tree, received_error, nil, newTreeGraph(expectedRoot))
	// {0:{C:0}}
	received_tree, received_error = wrapParamTreeGraph(0, 1, 17, 2, 102)
	expectedRoot = wrapTGN_CyclicStart(0, wrapTGN_CyclicTerminal(0), nil, received_tree.root.cycleCheck)
	AssertEqual(t, received_tree, received_error, nil, newTreeGraph(expectedRoot))
}

func TestTreeGraph_AssertSaneParameterisation(t *testing.T) {
	// Set P and a to 0 to assert on __assert_sane_parameterisation
	val, err := wrapParamTreeGraph(1, 1, 0, 2, 3)
	AssertEqual(t, val, err, FailedSaneParameterCheck(SANE_PARAMS_P), 0)
	val, err = wrapParamTreeGraph(1, 1, 0, 0, 3)
	AssertEqual(t, val, err, FailedSaneParameterCheck(SANE_PARAMS_P), 0)
	val, err = wrapParamTreeGraph(1, 1, 1, 0, 3)
	AssertEqual(t, val, err, FailedSaneParameterCheck(SANE_PARAMS_A), 0)
}
