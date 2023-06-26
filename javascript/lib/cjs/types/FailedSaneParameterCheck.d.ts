/**
 * Error message constants.
 * @remarks
 * To be used as input to the FailedSaneParameterCheck.
 */
export declare enum SaneParameterErrMsg {
    /** Message to print in the FailedSaneParameterCheck if P, the modulus, is zero. */
    SANE_PARAMS_P = "'P' should not be 0 ~ violates modulo being non-zero.",
    /** Message to print in the FailedSaneParameterCheck if a, the multiplicand, is zero. */
    SANE_PARAMS_A = "'a' should not be 0 ~ violates the reversability."
}
/**
 * FailedSaneParameterCheck
 * @remarks
 * An Error thrown when assertSaneParameterisation determines invalid parameterisation.
 * This is when either P, the modulus, or a, the multiplicand, are zero.
 */
export declare class FailedSaneParameterCheck extends Error {
    /**
     * Construct a FailedSaneParameterCheck with a message associated with the provided enum.
     * @param message - The enum from which to extract the message.
     */
    constructor(message: SaneParameterErrMsg);
}
/**
 * Assert Sane Parameters
 * @remarks
 * Handles the sanity check for the parameterisation (P,a,b) required by both
 * the function and reverse function.
 * @param P - Modulus used to devide n, iff n is equivalent to (0 mod P).
 * @param a - Factor by which to multiply n.
 * @param b - Value to add to the scaled value of n.
 * @throws FailedSaneParameterCheck
 * Thrown if either P or a are 0.
 */
export declare function assertSaneParameterisation(P: bigint, a: bigint, b: bigint): void;
//# sourceMappingURL=FailedSaneParameterCheck.d.ts.map