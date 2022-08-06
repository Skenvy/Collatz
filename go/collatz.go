// Provides the basic functionality to interact with the Collatz conjecture.
// The parameterisation uses the same (P,a,b) notation as Conway's generalisations.
// Besides the function and reverse function, there is also functionality to
// retrieve the hailstone sequence, the "stopping time"/"total stopping time", or
// tree-graph.
package collatz

import (
	"fmt"
	"math"
	"math/big"
)

// Default value for P, the modulus condition.
const _DEFAULT_P int64 = 2

// Default value for a, the input's multiplicand.
const _DEFAULT_A int64 = 3

// Default value for b, the value added to the multiplied value.
const _DEFAULT_B int64 = 1

// We want _KNOWN_CYCLES, __VERIFIED_MAXIMUM, __VERIFIED_MINIMUM constants, but
// neither arrays, slices, or big.Int can be constant, so we need funcs instead.
// Will also need funcs for constant defaults.

// Default value for P, the modulus condition.
func DEFAULT_P() *big.Int {
	return big.NewInt(_DEFAULT_P)
}

// Default value for a, the input's multiplicand.
func DEFAULT_A() *big.Int {
	return big.NewInt(_DEFAULT_A)
}

// Default value for b, the value added to the multiplied value.
func DEFAULT_B() *big.Int {
	return big.NewInt(_DEFAULT_B)
}

// Return a big.Int with a value of 0.
func ZERO() *big.Int {
	return big.NewInt(0)
}

// Return a big.Int with a value of 1.
func ONE() *big.Int {
	return big.NewInt(1)
}

// Map an array of ints to an array of big ints, for some mapping function.
func __MAP_INTS_TO_BIGINTS(ai []int64, m func(int64) *big.Int) []*big.Int {
	aim := make([]*big.Int, len(ai))
	for index, value := range ai {
		aim[index] = m(value)
	}
	return aim
}

// Map an array of ints to an array of big ints with the same value.
func _MAP_INTS_TO_BIGINTS(ai []int64) []*big.Int {
	return __MAP_INTS_TO_BIGINTS(ai, func(value int64) *big.Int { return big.NewInt(value) })
}

// The four known cycles for the standard parameterisation
func KNOWN_CYCLES() [4][]*big.Int {
	return [4][]*big.Int{_MAP_INTS_TO_BIGINTS([]int64{1, 4, 2}), _MAP_INTS_TO_BIGINTS([]int64{-1, -2}),
		_MAP_INTS_TO_BIGINTS([]int64{-5, -14, -7, -20, -10}),
		_MAP_INTS_TO_BIGINTS([]int64{-17, -50, -25, -74, -37, -110, -55, -164, -82, -41, -122, -61, -182, -91, -272, -136, -68, -34})}
}

// The current value up to which the standard parameterisation has been verified.
func VERIFIED_MAXIMUM() *big.Int {
	VERIFIED_MAXIMUM := new(big.Int)
	VERIFIED_MAXIMUM, ok := VERIFIED_MAXIMUM.SetString("295147905179352825856", 10)
	if !ok {
		fmt.Println("__VERIFIED_MAXIMUM: SetString: error")
		return big.NewInt(1)
	}
	return VERIFIED_MAXIMUM
}

// The current value down to which the standard parameterisation has been verified.
func VERIFIED_MINIMUM() *big.Int {
	//TODO: Check the actual lowest bound.
	return big.NewInt(-272)
}

// A stringy struct is a more readable way of making
// an enum, but a struct cannot be const, only var.

// Error message constants, to be used as input to the FailedSaneParameterCheck
type SaneParameterErrMsg int64

const (
	// Message to print in the FailedSaneParameterCheck if P, the modulus, is zero.
	SANE_PARAMS_P SaneParameterErrMsg = iota
	// Message to print in the FailedSaneParameterCheck if a, the multiplicand, is zero.
	SANE_PARAMS_A
)

// Get the string associated with the SaneParameterErrMsg
func (spem SaneParameterErrMsg) String() string {
	switch spem {
	case SANE_PARAMS_P:
		return "'P' should not be 0 ~ violates modulo being non-zero."
	case SANE_PARAMS_A:
		return "'a' should not be 0 ~ violates the reversability."
	}
	return "unknown"
}

// Thrown when either P, the modulus, or a, the multiplicand, are zero.
type FailedSaneParameterCheck SaneParameterErrMsg

// Construct a FailedSaneParameterCheck with a message associated with the provided enum.
func (fspc FailedSaneParameterCheck) Error() string {
	return fmt.Sprint(SaneParameterErrMsg(fspc).String())
}

// SequenceState for Cycle Control: Descriptive flags to indicate
// when some event occurs in the hailstone sequences or tree graph
// reversal, when set to verbose, or stopping time check.
type SequenceState int64

const (
	// A TreeGraph sequence state that indicates the lack of another state, as this state can't be nil
	NO_STATE SequenceState = iota
	// A Hailstone sequence state that indicates the stopping time, a value less than the initial, has been reached.
	STOPPING_TIME
	// A Hailstone sequence state that indicates the total stopping time, a value of 1, has been reached.
	TOTAL_STOPPING_TIME
	// A Hailstone and TreeGraph sequence state that indicates the first occurence of a value that subsequently forms a cycle.
	CYCLE_INIT
	// A Hailstone and TreeGraph sequence state that indicates the last occurence of a value that has already formed a cycle.
	CYCLE_LENGTH
	// A Hailstone and TreeGraph sequence state that indicates the sequence or traversal has executed some imposed 'maximum' amount of times.
	MAX_STOP_OUT_OF_BOUNDS
	// A Hailstone sequence state that indicates the sequence terminated by reaching "0", a special type of "stopping time".
	ZERO_STOP
)

// Get the string associated with the SequenceState
func (ss SequenceState) String() string {
	switch ss {
	case NO_STATE:
		return "NO_STATE"
	case STOPPING_TIME:
		return "STOPPING_TIME"
	case TOTAL_STOPPING_TIME:
		return "TOTAL_STOPPING_TIME"
	case CYCLE_INIT:
		return "CYCLE_INIT"
	case CYCLE_LENGTH:
		return "CYCLE_LENGTH"
	case MAX_STOP_OUT_OF_BOUNDS:
		return "MAX_STOP_OUT_OF_BOUNDS"
	case ZERO_STOP:
		return "ZERO_STOP"
	}
	return "unknown"
}

// Handles the sanity check for the parameterisation (P,a,b) required by both
// the function and reverse function.
// Args:
//     P (int): Modulus used to devide n, iff n is equivalent to (0 mod P).
//     a (int): Factor by which to multiply n.
//     b (int): Value to add to the scaled value of n.
func __assert_sane_parameterisation(P *big.Int, a *big.Int, b *big.Int) error {
	// Sanity check (P,a,b) ~ P absolutely can't be 0. a "could" be zero
	// theoretically, although would violate the reversability (if ~a is 0 then a
	// value of "b" as the input to the reverse function would have a pre-emptive
	// value of every number not divisible by P). The function doesn't _have_ to
	// be reversable, but we are only interested in dealing with the class of
	// functions that exhibit behaviour consistant with the collatz function. If
	// _every_ input not divisable by P went straight to "b", it would simply
	// cause a cycle consisting of "b" and every b/P^z that is an integer. While
	// P in [-1, 1] could also be a reasonable check, as it makes every value
	// either a 1 or 2 length cycle, it's not strictly an illegal operation.
	// "b" being zero would cause behaviour not consistant with the collatz
	// function, but would not violate the reversability, so no check either.
	// " != 0" is redundant for python assertions.
	if P.Cmp(ZERO()) == 0 {
		return FailedSaneParameterCheck(SANE_PARAMS_P)
	}
	if a.Cmp(ZERO()) == 0 {
		return FailedSaneParameterCheck(SANE_PARAMS_A)
	}
	return nil
}

// Returns the output of a single application of a Collatz-esque function.
//     n (*big.Int): The value on which to perform the Collatz-esque function
//     P (*big.Int): Modulus used to devide n, iff n is equivalent to (0 mod P).
//     a (*big.Int): Factor by which to multiply n.
//     b (*big.Int): Value to add to the scaled value of n.
func ParameterisedFunction(n *big.Int, P *big.Int, a *big.Int, b *big.Int) (*big.Int, error) {
	err := __assert_sane_parameterisation(P, a, b)
	if err != nil {
		return nil, err
	}
	q, m := new(big.Int), new(big.Int)
	q, m = q.DivMod(n, P, m)
	if m.Cmp(ZERO()) == 0 { // n%P is zero
		return q, nil // n/P
	} else {
		return new(big.Int).Add(new(big.Int).Mul(a, n), b), nil //(a*n + b)
	}
}

// Returns the output of a single application of the Collatz function.
//     n (*big.Int): The value on which to perform the Collatz-esque function
func Function(n *big.Int) *big.Int {
	res, _ := ParameterisedFunction(n, DEFAULT_P(), DEFAULT_A(), DEFAULT_B())
	return res
}

// Returns the output of a single application of a Collatz-esque reverse function.
//     n (*big.Int): The value on which to perform the reverse Collatz function
//     P (*big.Int): Modulus used to devide n, iff n is equivalent to (0 mod P)
//     a (*big.Int): Factor by which to multiply n.
//     b (*big.Int): Value to add to the scaled value of n.
func ParameterisedReverseFunction(n *big.Int, P *big.Int, a *big.Int, b *big.Int) ([]*big.Int, error) {
	// Every input can be reversed as the result of "n/P" division, which yields
	// "Pn"... {f(n) = an + b}≡{(f(n) - b)/a = n} ~ if n was such that the
	// muliplication step was taken instead of the division by the modulus, then
	// (f(n) - b)/a) must be an integer that is not in (0 mod P). Because we're
	// not placing restrictions on the parameters yet, although there is a better
	// way of shortcutting this for the default variables, we need to always
	// attempt (f(n) - b)/a)
	err := __assert_sane_parameterisation(P, a, b)
	if err != nil {
		return nil, err
	}
	var pre_values []*big.Int = []*big.Int{new(big.Int).Mul(P, n)} // init as P*n
	// (n-b)%a is zero AND (n-b)%(P*a) is not zero
	n_sub_b := new(big.Int).Sub(n, b)
	q, m := new(big.Int), new(big.Int)
	q, m = q.DivMod(n_sub_b, a, m)
	if m.Cmp(ZERO()) == 0 && new(big.Int).Mod(n_sub_b, (new(big.Int).Mul(P, a))).Cmp(ZERO()) != 0 {
		pre_values = append(pre_values, q)
	}
	return pre_values, nil
}

// Returns the output of a single application of the Collatz reverse function.
//     n (*big.Int): The value on which to perform the reverse Collatz function
func ReverseFunction(n *big.Int) []*big.Int {
	res, _ := ParameterisedReverseFunction(n, DEFAULT_P(), DEFAULT_A(), DEFAULT_B())
	return res
}

// Provides the appropriate lambda to use to check if iterations on an initial
// value have reached either the stopping time, or total stopping time.
//     n (*big.Int): The initial value to confirm against a stopping time check.
//     total_stop (boolean): If false, the lambda will confirm that iterations of n
//          have reached the oriented stopping time to reach a value closer to 0.
//          If true, the lambda will simply check equality to 1.
// return (Function<*big.Int, Boolean>): The lambda to check for the stopping time.
func stoppingTimeTerminus(n *big.Int, total_stop bool) func(x *big.Int) bool {
	one := ONE()
	zero := ZERO()
	if total_stop {
		return func(x *big.Int) bool { return x.Cmp(one) == 0 }
	} else if n.Cmp(zero) >= 0 {
		return func(x *big.Int) bool { return ((x.Cmp(n) == -1) && (x.Cmp(zero) == 1)) }
	} else {
		return func(x *big.Int) bool { return ((x.Cmp(n) == 1) && (x.Cmp(zero) == -1)) }
	}
}

// Contains the results of computing a hailstone sequence via {@code Collatz.hailstoneSequence(~)}.
type HailstoneSequence struct {
	// The set of values that comprise the hailstone sequence.
	values    []*big.Int
	terminate func(x *big.Int) bool
	// A terminal condition that reflects the final state of the hailstone sequencing,
	// whether than be that it succeeded at determining the stopping time, the total
	// stopping time, found a cycle, or got stuck on zero (or surpassed the max total).
	terminalCondition SequenceState
	// A status value that has different meanings depending on what the terminal condition
	// was. If the sequence completed either via reaching the stopping or total stopping time,
	// or getting stuck on zero, then this value is the stopping/terminal time. If the sequence
	// got stuck on a cycle, then this value is the cycle length. If the sequencing passes the
	// maximum stopping time then this is the value that was provided as that maximum.
	terminalStatus int
}

// Initialise and compute a new Hailstone Sequence.
//     initialValue (*big.Int): The value to begin the hailstone sequence from.
//     P (*big.Int): Modulus used to devide n, iff n is equivalent to (0 mod P).
//     a (*big.Int): Factor by which to multiply n.
//     b (*big.Int): Value to add to the scaled value of n.
//     maxTotalStoppingTime (int): Maximum amount of times to iterate the function, if 1 is not reached.
//     totalStoppingTime (boolean): Whether or not to execute until the "total" stopping time
//          (number of iterations to obtain 1) rather than the regular stopping time (number
//          of iterations to reach a value less than the initial value).
func ParameterisedHailstoneSequence(initialValue *big.Int, P *big.Int, a *big.Int, b *big.Int, maxTotalStoppingTime int, totalStoppingTime bool) (*HailstoneSequence, error) {
	// Call out the function before any magic returns to trap bad values.
	_, err := ParameterisedFunction(initialValue, P, a, b)
	if err != nil {
		return nil, err
	}
	var hs HailstoneSequence
	hs.terminate = stoppingTimeTerminus(initialValue, totalStoppingTime)
	if initialValue.Cmp(ZERO()) == 0 {
		// 0 is always an immediate stop.
		hs.values = []*big.Int{ZERO()}
		hs.terminalCondition = ZERO_STOP
		hs.terminalStatus = 0
	} else if initialValue.Cmp(ONE()) == 0 {
		// 1 is always an immediate stop, with 0 stopping time.
		hs.values = []*big.Int{ONE()}
		hs.terminalCondition = TOTAL_STOPPING_TIME
		hs.terminalStatus = 0
	} else {
		// Otherwise, hail!
		minMaxTotalStoppingTime := int(math.Max(float64(maxTotalStoppingTime), 1))
		hs.values = make([]*big.Int, 1, minMaxTotalStoppingTime+1)
		hs.values[0] = initialValue
		var cycleMap map[string]bool = make(map[string]bool, maxTotalStoppingTime+1)
		cycleMap[initialValue.String()] = true
		zero := ZERO()
		for k := 1; k <= minMaxTotalStoppingTime; k++ {
			next, err := ParameterisedFunction(hs.values[k-1], P, a, b)
			if err != nil {
				return nil, err
			}
			// Check if the next hailstone is either the stopping time, total
			// stopping time, the same as the initial value, or stuck at zero.
			if hs.terminate(next) {
				hs.values = append(hs.values, next)
				if next.Cmp(ONE()) == 0 {
					hs.terminalCondition = TOTAL_STOPPING_TIME
				} else {
					hs.terminalCondition = STOPPING_TIME
				}
				hs.terminalStatus = k
				return &hs, nil
			}
			if cycleMap[next.String()] {
				hs.values = append(hs.values, next)
				cycle_init := 1
				for j := 1; j <= k; j++ {
					if hs.values[k-j].Cmp(next) == 0 {
						cycle_init = j
						break
					}
				}
				hs.terminalCondition = CYCLE_LENGTH
				hs.terminalStatus = cycle_init
				return &hs, nil
			}
			if next.Cmp(zero) == 0 {
				hs.values = append(hs.values, zero)
				hs.terminalCondition = ZERO_STOP
				hs.terminalStatus = -k
				return &hs, nil
			}
			hs.values = append(hs.values, next)
			cycleMap[next.String()] = true
		}
		hs.terminalCondition = MAX_STOP_OUT_OF_BOUNDS
		hs.terminalStatus = minMaxTotalStoppingTime
	}
	return &hs, nil
}

// Initialise and compute a new Hailstone Sequence.
//     initialValue (*big.Int): The value to begin the hailstone sequence from.
//     P (*big.Int): Modulus used to devide n, iff n is equivalent to (0 mod P).
//     a (*big.Int): Factor by which to multiply n.
//     b (*big.Int): Value to add to the scaled value of n.
//     maxTotalStoppingTime (int): Maximum amount of times to iterate the function, if 1 is not reached.
//     totalStoppingTime (boolean): Whether or not to execute until the "total" stopping time
//          (number of iterations to obtain 1) rather than the regular stopping time (number
//          of iterations to reach a value less than the initial value).
func HailstoneSequenceDefault(initialValue *big.Int, maxTotalStoppingTime int) *HailstoneSequence {
	ret, _ := ParameterisedHailstoneSequence(initialValue, DEFAULT_P(), DEFAULT_A(), DEFAULT_B(), maxTotalStoppingTime, true)
	return ret
}

// Returns the stopping time, the amount of iterations required to reach a
// value less than the initial value, or -Inf if maxStoppingTime is exceeded.
// Alternatively, if totalStoppingTime is True, then it will instead count
// the amount of iterations to reach 1. If the sequence does not stop, but
// instead ends in a cycle, the result will be +Inf.
// If (P,a,b) are such that it is possible to get stuck on zero, the result
// will be the negative of what would otherwise be the "total stopping time"
// to reach 1, where 0 is considered a "total stop" that should not occur as
// it does form a cycle of length 1.
//     initialValue (*big.Int): The value for which to find the stopping time.
//     P (*big.Int): Modulus used to devide n, iff n is equivalent to (0 mod P).
//     a (*big.Int): Factor by which to multiply n.
//     b (*big.Int): Value to add to the scaled value of n.
//     maxStoppingTime (int): Maximum amount of times to iterate the function, if
//          the stopping time is not reached. IF the maxStoppingTime is reached,
//          the function will return null.
//     totalStoppingTime (bool): Whether or not to execute until the "total" stopping
//          time (number of iterations to obtain 1) rather than the regular stopping
//          time (number of iterations to reach a value less than the initial value).
// return (float64): The stopping time, or, in a special case, infinity, null or a negative.
func ParameterisedStoppingTime(initialValue *big.Int, P *big.Int, a *big.Int, b *big.Int, maxStoppingTime int, totalStoppingTime bool) (float64, error) {
	// The information is contained in the hailstone sequence. Although the "max~time"
	// for hailstones is named for "total stopping" time and the "max~time" for this
	// "stopping time" function is _not_ "total", they are handled the same way, as
	// the default for "totalStoppingTime" for hailstones is true, but for this, is
	// false. Thus the naming difference.
	hail, err := ParameterisedHailstoneSequence(initialValue, P, a, b, maxStoppingTime, totalStoppingTime)
	// For total/regular/zero stopping time, the value is already the same as
	// that present, for cycles we report infinity instead of the cycle length,
	// and for max stop out of bounds, we report null instead of the max stop cap
	if err != nil {
		return math.Inf(-1), err
	}
	switch hail.terminalCondition {
	case STOPPING_TIME:
		return float64(hail.terminalStatus), nil
	case TOTAL_STOPPING_TIME:
		return float64(hail.terminalStatus), nil
	case CYCLE_LENGTH:
		return math.Inf(1), nil
	case MAX_STOP_OUT_OF_BOUNDS:
		return math.Inf(-1), nil
	case ZERO_STOP:
		return float64(hail.terminalStatus), nil
	}
	return math.Inf(-1), nil
}

// Returns the stopping time, the amount of iterations required to reach a
// value less than the initial value, or -Inf if maxStoppingTime is exceeded.
//     initialValue (*big.Int): The value for which to find the stopping time.
// return (float64): The stopping time, or, in a cycle case, infinity.
func StoppingTime(initialValue *big.Int) float64 {
	stop, _ := ParameterisedStoppingTime(initialValue, DEFAULT_P(), DEFAULT_A(), DEFAULT_B(), 1000, false)
	return stop
}

// Nodes that form a "tree graph", structured as a tree, with their own node's value,
// as well as references to either possible child node, where a node can only ever have
// two children, as there are only ever two reverse values. Also records any possible
// "terminal sequence state", whether that be that the "orbit distance" has been reached,
// as an "out of bounds" stop, which is the regularly expected terminal state. Other
// terminal states possible however include the cycle state and cycle length (end) states.
type TreeGraphNode struct {
	// The value of this node in the tree.
	nodeValue *big.Int
	// The terminal state; null if not a terminal node, MAX_STOP_OUT_OF_BOUNDS if the maxOrbitDistance
	// has been reached, CYCLE_LENGTH if the node's value is found to have occured previously, or
	// CYCLE_INIT, retroactively applied when a CYCLE_LENGTH state node is found.
	terminalSequenceState SequenceState
	// The "Pre N/P" child of this node that is always
	// present if this is not a terminal node.
	preNDivPNode *TreeGraphNode
	// The "Pre aN+b" child of this node that is present
	// if it exists and this is not a terminal node.
	preANplusBNode *TreeGraphNode
	// A map of previous graph nodes which maps instances of
	// TreeGraphNode to themselves, to enable cycle detection.
	cycleCheck map[string]*TreeGraphNode
}

// Create an instance of TreeGraphNode which will yield its entire sub-tree of all child nodes.
//     nodeValue (*big.Int): The value for which to find the tree graph node reversal.
//     maxOrbitDistance (int): The maximum distance/orbit/branch length to travel.
//     P (*big.Int): Modulus used to devide n, iff n is equivalent to (0 mod P).
//     a (*big.Int): Factor by which to multiply n.
//     b (*big.Int): Value to add to the scaled value of n.
func newTreeGraphRootNode(nodeValue *big.Int, maxOrbitDistance int, P *big.Int, a *big.Int, b *big.Int) (*TreeGraphNode, error) {
	this := new(TreeGraphNode)
	this.nodeValue = nodeValue
	if int(math.Max(float64(maxOrbitDistance), 0)) == 0 {
		this.terminalSequenceState = MAX_STOP_OUT_OF_BOUNDS
		this.preNDivPNode = nil
		this.preANplusBNode = nil
		this.cycleCheck = nil
	} else {
		reverses, err := ParameterisedReverseFunction(nodeValue, P, a, b)
		if err != nil {
			return nil, err
		}
		this.cycleCheck = make(map[string]*TreeGraphNode, 1+int(math.Pow(2, float64(maxOrbitDistance))))
		this.cycleCheck[nodeValue.String()] = this
		preNDivPNode, err := newTreeGraphInnerNode(reverses[0], maxOrbitDistance-1, P, a, b, this.cycleCheck)
		if err != nil {
			return nil, err
		}
		this.preNDivPNode = preNDivPNode
		if len(reverses) == 2 {
			preANplusBNode, err := newTreeGraphInnerNode(reverses[1], maxOrbitDistance-1, P, a, b, this.cycleCheck)
			if err != nil {
				return nil, err
			}
			this.preANplusBNode = preANplusBNode
		} else {
			this.preANplusBNode = nil
		}
	}
	return this, nil
}

// Create an instance of TreeGraphNode which will yield its entire sub-tree of all child nodes.
// This is used internally by itself and the public constructor to pass the cycle checking map,
// recursively determining subsequent child nodes.
//     nodeValue (*big.Int): The value for which to find the tree graph node reversal.
//     maxOrbitDistance (int): The maximum distance/orbit/branch length to travel.
//     P (*big.Int): Modulus used to devide n, iff n is equivalent to (0 mod P).
//     a (*big.Int): Factor by which to multiply n.
//     b (*big.Int): Value to add to the scaled value of n.
//     cycleCheck (Map<TreeGraphNode,TreeGraphNode>): Checks if this node's value already occurred.
func newTreeGraphInnerNode(nodeValue *big.Int, maxOrbitDistance int, P *big.Int, a *big.Int, b *big.Int, cycleCheck map[string]*TreeGraphNode) (*TreeGraphNode, error) {
	this := new(TreeGraphNode)
	this.nodeValue = nodeValue
	this.cycleCheck = cycleCheck
	if this.cycleCheck[nodeValue.String()] != nil {
		this.cycleCheck[nodeValue.String()].terminalSequenceState = CYCLE_INIT
		this.terminalSequenceState = CYCLE_LENGTH
		this.preNDivPNode = nil
		this.preANplusBNode = nil
	} else if int(math.Max(float64(maxOrbitDistance), 0)) == 0 {
		this.terminalSequenceState = MAX_STOP_OUT_OF_BOUNDS
		this.preNDivPNode = nil
		this.preANplusBNode = nil
	} else {
		this.cycleCheck[nodeValue.String()] = this
		this.terminalSequenceState = NO_STATE
		reverses, err := ParameterisedReverseFunction(nodeValue, P, a, b)
		if err != nil {
			return nil, err
		}
		preNDivPNode, err := newTreeGraphInnerNode(reverses[0], maxOrbitDistance-1, P, a, b, this.cycleCheck)
		if err != nil {
			return nil, err
		}
		this.preNDivPNode = preNDivPNode
		if len(reverses) == 2 {
			preANplusBNode, err := newTreeGraphInnerNode(reverses[1], maxOrbitDistance-1, P, a, b, this.cycleCheck)
			if err != nil {
				return nil, err
			}
			this.preANplusBNode = preANplusBNode
		} else {
			this.preANplusBNode = nil
		}
	}
	return this, nil
}

// Create an instance of TreeGraphNode by directly passing it the values required to instantiate,
// intended to be used in testing by manually creating trees in reverse, by passing expected child
// nodes to their parents until the entire expected tree is created.
//     nodeValue (*big.Int): The value expected of this node.
//     terminalSequenceState (SequenceState): The expected sequence state;
//       null, MAX_STOP_OUT_OF_BOUNDS, CYCLE_INIT or CYCLE_LENGTH.
//     preNDivPNode (TreeGraphNode): The expected "Pre N/P" child node.
//     preANplusBNode (TreeGraphNode): The expected "Pre aN+b" child node.
func newTreeGraphNode(nodeValue *big.Int, terminalSequenceState SequenceState, preNDivPNode *TreeGraphNode, preANplusBNode *TreeGraphNode) *TreeGraphNode {
	this := new(TreeGraphNode)
	this.nodeValue = nodeValue
	this.terminalSequenceState = terminalSequenceState
	this.preNDivPNode = preNDivPNode
	this.preANplusBNode = preANplusBNode
	this.cycleCheck = nil
	return this
}

// A much stricter equality check than the {@code equals(Object obj)} override.
// This will only confirm an equality if the whole subtree of both nodes, including
// node values, sequence states, and child nodes, checked recursively, are equal.
//     t1 (*TreeGraphNode): The TreeGraphNode with which to compare equality.
//     t2 (*TreeGraphNode): The TreeGraphNode with which to compare equality.
// return {@code true}, if the entire sub-trees are equal.
func subTreeEquals(t1 *TreeGraphNode, t2 *TreeGraphNode) bool {
	if t1.nodeValue.Cmp(t2.nodeValue) != 0 || t1.terminalSequenceState != t2.terminalSequenceState {
		return false
	}
	if t1.preNDivPNode == nil && t2.preNDivPNode != nil {
		return false
	}
	if t1.preNDivPNode != nil && !subTreeEquals(t1.preNDivPNode, t2.preNDivPNode) {
		return false
	}
	if t1.preANplusBNode == nil && t2.preANplusBNode != nil {
		return false
	}
	if t1.preANplusBNode != nil && !subTreeEquals(t1.preANplusBNode, t2.preANplusBNode) {
		return false
	}
	return true
}

// Contains the results of computing the Tree Graph via Collatz.treeGraph(~).
// Contains the root node of a tree of TreeGraphNode's.
type TreeGraph struct {
	// The root node of the tree of TreeGraphNode's.
	root *TreeGraphNode
}

// Create a new TreeGraph with the root node defined by the inputs.
//     nodeValue (*big.Int): The value for which to find the tree graph node reversal.
//     maxOrbitDistance (int): The maximum distance/orbit/branch length to travel.
//     P (*big.Int): Modulus used to devide n, iff n is equivalent to (0 mod P).
//     a (*big.Int): Factor by which to multiply n.
//     b (*big.Int): Value to add to the scaled value of n.

// Returns a directed tree graph of the reverse function values up to a maximum
// nesting of maxOrbitDistance, with the initialValue as the root.
//     initialValue (*big.Int): The root value of the directed tree graph.
//     maxOrbitDistance (int): Maximum amount of times to iterate the reverse
//          function. There is no natural termination to populating the tree
//          graph, equivalent to the termination of hailstone sequences or
//          stopping time attempts, so this is not an optional argument like
//          maxStoppingTime / maxTotalStoppingTime, as it is the intended target
//          of orbits to obtain, rather than a limit to avoid uncapped computation.
//     P (*big.Int): Modulus used to devide n, iff n is equivalent to (0 mod P).
//     a (*big.Int): Factor by which to multiply n.
//     b (*big.Int): Value to add to the scaled value of n.
func ParameterisedTreeGraph(nodeValue *big.Int, maxOrbitDistance int, P *big.Int, a *big.Int, b *big.Int) (*TreeGraph, error) {
	rootNode, err := newTreeGraphRootNode(nodeValue, maxOrbitDistance, P, a, b)
	if err != nil {
		return nil, err
	}
	return newTreeGraph(rootNode), nil
}

// Create a new TreeGraph by directly passing it the root node.
// Intended to be used in testing by manually creating trees.
//     root (TreeGraphNode): The root node of the tree.
func newTreeGraph(rootNode *TreeGraphNode) *TreeGraph {
	tree := new(TreeGraph)
	tree.root = rootNode
	return tree
}

// The equality between {@code TreeGraph}'s is determined by the equality check on subtrees.
// A subtree check will be done on both {@code TreeGraph}'s root nodes. */
func treeEquals(t1 *TreeGraph, t2 *TreeGraph) bool {
	if t1 == nil && t2 != nil {
		return false
	}
	if t1 != nil && t2 == nil {
		return false
	}
	if t1 == nil && t2 == nil {
		return true
	}
	return subTreeEquals(t1.root, t2.root)
}

// Returns a directed tree graph of the reverse function values up to a maximum
// nesting of maxOrbitDistance, with the initialValue as the root.
//     initialValue (*big.Int): The root value of the directed tree graph.
//     maxOrbitDistance (int): Maximum amount of times to iterate the reverse
//          function. There is no natural termination to populating the tree
//          graph, equivalent to the termination of hailstone sequences or
//          stopping time attempts, so this is not an optional argument like
//          maxStoppingTime / maxTotalStoppingTime, as it is the intended target
//          of orbits to obtain, rather than a limit to avoid uncapped computation.
func TreeGraphDefault(initialValue *big.Int, maxOrbitDistance int) (*TreeGraph, error) {
	return ParameterisedTreeGraph(initialValue, maxOrbitDistance, DEFAULT_P(), DEFAULT_A(), DEFAULT_B())
}
