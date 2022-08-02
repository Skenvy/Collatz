// Provides the basic functionality to interact with the Collatz conjecture.
// The parameterisation uses the same (P,a,b) notation as Conway's generalisations.
// Besides the function and reverse function, there is also functionality to
// retrieve the hailstone sequence, the "stopping time"/"total stopping time", or
// tree-graph.
package collatz

import (
	"fmt"
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
func KNOWN_CYCLES_INT() [4][]*big.Int {
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
	// A Hailstone sequence state that indicates the stopping time, a value less than the initial, has been reached.
	STOPPING_TIME SequenceState = iota
	// A Hailstone sequence state that indicates the total stopping time, a value of 1, has been reached.
	TOTAL_STOPPING_TIME
	// A Hailstone and TreeGraph sequence state that indicates the first occurence of a value that subsequently forms a cycle.
	CYCLE_INIT
	// A Hailstone and TreeGraph sequence state that indicates the last occurence of a value that has already formed a cycle.
	CYCLE_LENGTH
	// A Hailstone and TreeGraph sequence state that indicates the sequence or traversal has executed some imposed 'maximum' amount of times.
	MAX_STOP_OOB
	// A Hailstone sequence state that indicates the sequence terminated by reaching "0", a special type of "stopping time".
	ZERO_STOP
)

// Get the string associated with the SequenceState
func (ss SequenceState) String() string {
	switch ss {
	case STOPPING_TIME:
		return "STOPPING_TIME"
	case TOTAL_STOPPING_TIME:
		return "TOTAL_STOPPING_TIME"
	case CYCLE_INIT:
		return "CYCLE_INIT"
	case CYCLE_LENGTH:
		return "CYCLE_LENGTH"
	case MAX_STOP_OOB:
		return "MAX_STOP_OOB"
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
