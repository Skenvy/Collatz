/**
 * Error message constants.
 * @remarks
 * To be used as input to the FailedSaneParameterCheck.
 */
export var SaneParameterErrMsg;
(function (SaneParameterErrMsg) {
    /** Message to print in the FailedSaneParameterCheck if P, the modulus, is zero. */
    SaneParameterErrMsg["SANE_PARAMS_P"] = "'P' should not be 0 ~ violates modulo being non-zero.";
    /** Message to print in the FailedSaneParameterCheck if a, the multiplicand, is zero. */
    SaneParameterErrMsg["SANE_PARAMS_A"] = "'a' should not be 0 ~ violates the reversability.";
})(SaneParameterErrMsg || (SaneParameterErrMsg = {}));
/**
 * FailedSaneParameterCheck
 * @remarks
 * An Error thrown when assertSaneParameterisation determines invalid parameterisation.
 * This is when either P, the modulus, or a, the multiplicand, are zero.
 */
export class FailedSaneParameterCheck extends Error {
    /**
     * Construct a FailedSaneParameterCheck with a message associated with the provided enum.
     * @param message - The enum from which to extract the message.
     */
    constructor(message) {
        super(message);
        this.name = 'FailedSaneParameterCheck';
    }
}
/**
 * Assert Sane Parameters
 * @remarks
 * Handles the sanity check for the parameterisation (P,a,b) required by both
 * the function and reverse function.
 * @param P - Modulus used to devide n, iff n is equivalent to (0 mod P).
 * @param a - Factor by which to multiply n.
 * @throws FailedSaneParameterCheck
 * Thrown if either P or a are 0.
 */
export function assertSaneParameterisation(P, a, _b) {
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
    if (P === 0n) {
        throw new FailedSaneParameterCheck(SaneParameterErrMsg.SANE_PARAMS_P);
    }
    if (a === 0n) {
        throw new FailedSaneParameterCheck(SaneParameterErrMsg.SANE_PARAMS_A);
    }
}
