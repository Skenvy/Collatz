// The four known cycles (besides 0->0), for the default parameterisation.
export const _KNOWN_CYCLES = [[1n, 4n, 2n], [-1n, -2n], [-5n, -14n, -7n, -20n, -10n],
    [-17n, -50n, -25n, -74n, -37n, -110n, -55n, -164n, -82n, -41n, -122n, -61n, -182n, -91n, -272n, -136n, -68n, -34n]];
// The value up to which has been proven numerically, for the default parameterisation."
export const __VERIFIED_MAXIMUM = 295147905179352825856n;
// The value down to which has been proven numerically, for the default parameterisation."
export const __VERIFIED_MINIMUM = -272n; // TODO: Check the actual lowest bound.
// Error message constant.
export var _ErrMsg;
(function (_ErrMsg) {
    _ErrMsg["SANE_PARAMS_P"] = "'P' should not be 0 ~ violates modulo being non-zero.";
    _ErrMsg["SANE_PARAMS_A"] = "'a' should not be 0 ~ violates the reversability.";
})(_ErrMsg || (_ErrMsg = {}));
export class FailedSaneParameterCheck extends Error {
    constructor(message) {
        super(message);
        this.name = "FailedSaneParameterCheck";
    }
}
// Cycle Control: Descriptive flags to indicate when some event occurs in the
// hailstone sequences, when set to verbose, or stopping time check.
export var _CC;
(function (_CC) {
    _CC["STOPPING_TIME"] = "STOPPING_TIME";
    _CC["TOTAL_STOPPING_TIME"] = "TOTAL_STOPPING_TIME";
    _CC["CYCLE_INIT"] = "CYCLE_INIT";
    _CC["CYCLE_LENGTH"] = "CYCLE_LENGTH";
    _CC["MAX_STOP_OUT_OF_BOUNDS"] = "MAX_STOP_OUT_OF_BOUNDS";
    _CC["ZERO_STOP"] = "ZERO_STOP";
})(_CC || (_CC = {}));
// """
// Handles the sanity check for the parameterisation (P,a,b) required by both
// the function and reverse function.
// Args:
//     P (bigint): Modulus used to devide n, iff n is equivalent to (0 mod P).
//     a (bigint): Factor by which to multiply n.
//     b (bigint): Value to add to the scaled value of n.
// """
export function __assert_sane_parameterisation(P, a, b) {
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
    if (P === 0n) {
        throw new FailedSaneParameterCheck(_ErrMsg.SANE_PARAMS_P);
    }
    if (a === 0n) {
        throw new FailedSaneParameterCheck(_ErrMsg.SANE_PARAMS_A);
    }
}
// """
// Returns the output of a single application of a Collatz-esque function.
// Args:
//     n (bigint): The value on which to perform the Collatz-esque function
// Kwargs:
//     P (bigint): Modulus used to devide n, iff n is equivalent to (0 mod P).
//         Default is 2.
//     a (bigint): Factor by which to multiply n. Default is 3.
//     b (bigint): Value to add to the scaled value of n. Default is 1.
// """
export function Function({ n, P = 2n, a = 3n, b = 1n }) {
    __assert_sane_parameterisation(P, a, b);
    return n % P === 0n ? n / P : (a * n + b);
}
export default {
    Function,
};
