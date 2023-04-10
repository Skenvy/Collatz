"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.ReverseFunction = exports.Function = exports.assertSaneParameterisation = exports.SequenceState = exports.FailedSaneParameterCheck = exports.SaneParameterErrMsg = exports.VERIFIED_MINIMUM = exports.VERIFIED_MAXIMUM = exports.KNOWN_CYCLES = void 0;
// The four known cycles (besides 0->0), for the default parameterisation.
exports.KNOWN_CYCLES = [[1n, 4n, 2n], [-1n, -2n], [-5n, -14n, -7n, -20n, -10n],
    [-17n, -50n, -25n, -74n, -37n, -110n, -55n, -164n, -82n, -41n, -122n, -61n, -182n, -91n, -272n, -136n, -68n, -34n]];
// The value up to which has been proven numerically, for the default parameterisation."
exports.VERIFIED_MAXIMUM = 295147905179352825856n;
// The value down to which has been proven numerically, for the default parameterisation."
exports.VERIFIED_MINIMUM = -272n; // TODO: Check the actual lowest bound.
// Error message constant.
var SaneParameterErrMsg;
(function (SaneParameterErrMsg) {
    SaneParameterErrMsg["SANE_PARAMS_P"] = "'P' should not be 0 ~ violates modulo being non-zero.";
    SaneParameterErrMsg["SANE_PARAMS_A"] = "'a' should not be 0 ~ violates the reversability.";
})(SaneParameterErrMsg = exports.SaneParameterErrMsg || (exports.SaneParameterErrMsg = {}));
class FailedSaneParameterCheck extends Error {
    constructor(message) {
        super(message);
        this.name = 'FailedSaneParameterCheck';
    }
}
exports.FailedSaneParameterCheck = FailedSaneParameterCheck;
// Cycle Control: Descriptive flags to indicate when some event occurs in the
// hailstone sequences, when set to verbose, or stopping time check.
var SequenceState;
(function (SequenceState) {
    SequenceState["STOPPING_TIME"] = "STOPPING_TIME";
    SequenceState["TOTAL_STOPPING_TIME"] = "TOTAL_STOPPING_TIME";
    SequenceState["CYCLE_INIT"] = "CYCLE_INIT";
    SequenceState["CYCLE_LENGTH"] = "CYCLE_LENGTH";
    SequenceState["MAX_STOP_OUT_OF_BOUNDS"] = "MAX_STOP_OUT_OF_BOUNDS";
    SequenceState["ZERO_STOP"] = "ZERO_STOP";
})(SequenceState = exports.SequenceState || (exports.SequenceState = {}));
// """
// Handles the sanity check for the parameterisation (P,a,b) required by both
// the function and reverse function.
// Args:
//     P (bigint): Modulus used to devide n, iff n is equivalent to (0 mod P).
//     a (bigint): Factor by which to multiply n.
//     b (bigint): Value to add to the scaled value of n.
// """
function assertSaneParameterisation(P, a, b) {
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
        throw new FailedSaneParameterCheck(SaneParameterErrMsg.SANE_PARAMS_P);
    }
    if (a === 0n) {
        throw new FailedSaneParameterCheck(SaneParameterErrMsg.SANE_PARAMS_A);
    }
}
exports.assertSaneParameterisation = assertSaneParameterisation;
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
function Function({ n, P = 2n, a = 3n, b = 1n }) {
    assertSaneParameterisation(P, a, b);
    return n % P === 0n ? n / P : (a * n + b);
}
exports.Function = Function;
// """
// Returns the output of a single application of a Collatz-esque reverse
// function.
// Args:
//     n (int): The value on which to perform the reverse Collatz function
// Kwargs:
//     P (int): Modulus used to devide n, iff n is equivalent to (0 mod P)
//         Default is 2.
//     a (int): Factor by which to multiply n. Default is 3.
//     b (int): Value to add to the scaled value of n. Default is 1.
// """
function ReverseFunction({ n, P = 2n, a = 3n, b = 1n }) {
    assertSaneParameterisation(P, a, b);
    // Every input can be reversed as the result of "n/P" division, which yields
    // "Pn"... {f(n) = an + b}≡{(f(n) - b)/a = n} ~ if n was such that the
    // muliplication step was taken instead of the division by the modulus, then
    // (f(n) - b)/a) must be an integer that is not in (0 mod P). Because we're
    // not placing restrictions on the parameters yet, although there is a better
    // way of shortcutting this for the default variables, we need to always
    // attempt (f(n) - b)/a)
    if ((n - b) % a === 0n && (n - b) % (P * a) !== 0n) {
        return [(P * n), ((n - b) / a)];
    }
    else {
        return [P * n];
    }
}
exports.ReverseFunction = ReverseFunction;
exports.default = {
    Function,
    ReverseFunction,
};
