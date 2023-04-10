/** The four known cycles (besides 0 cycling to itself), for the default parameterisation. */
export declare const KNOWN_CYCLES: bigint[][];
/** The current value up to which has been proven numerically, for the default parameterisation. */
export declare const VERIFIED_MAXIMUM: bigint;
/** The current value down to which has been proven numerically, for the default parameterisation. */
export declare const VERIFIED_MINIMUM: bigint;
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
 * SequenceState for Cycle Control
 * @remarks
 * Descriptive flags to indicate when some event occurs in the hailstone sequences
 * or tree graph reversal, when set to verbose, or stopping time check.
 */
export declare enum SequenceState {
    /** A Hailstone sequence state that indicates the stopping
     *  time, a value less than the initial, has been reached. */
    STOPPING_TIME = "STOPPING_TIME",
    /** A Hailstone sequence state that indicates the total
     *  stopping time, a value of 1, has been reached. */
    TOTAL_STOPPING_TIME = "TOTAL_STOPPING_TIME",
    /** A Hailstone and TreeGraph sequence state that indicates the
     *  first occurence of a value that subsequently forms a cycle. */
    CYCLE_INIT = "CYCLE_INIT",
    /** A Hailstone and TreeGraph sequence state that indicates the
     *  last occurence of a value that has already formed a cycle. */
    CYCLE_LENGTH = "CYCLE_LENGTH",
    /** A Hailstone and TreeGraph sequence state that indicates the sequence
     *  or traversal has executed some imposed 'maximum' amount of times. */
    MAX_STOP_OUT_OF_BOUNDS = "MAX_STOP_OUT_OF_BOUNDS",
    /** A Hailstone sequence state that indicates the sequence terminated
     *  by reaching "0", a special type of "stopping time". */
    ZERO_STOP = "ZERO_STOP"
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
/**
 * Parameterised inputs
 * @remarks
 * Allow (P,a,b) to be optional, keyword inputs.
 */
export interface Parameterised {
    /**
     * The only required input is "n", the value to perform the operations on.
     */
    n: bigint;
    /**
     * The modulus.
     * @defaultValue 2n
     */
    P?: bigint;
    /**
     * The multiplicand.
     * @defaultValue 3n
     */
    a?: bigint;
    /**
     * The addend.
     * @defaultValue 1n
     */
    b?: bigint;
}
/**
 * Parameterised Collatz Function
 * @param n - The value on which to perform the Collatz-esque function
 * @param P - Modulus used to devide n, iff n is equivalent to (0 mod P). Default is 2.
 * @param a - Factor by which to multiply n. Default is 3.
 * @param b - Value to add to the scaled value of n. Default is 1.
 * @returns the output of a single application of a Collatz-esque function.
 * @throws FailedSaneParameterCheck
 * Thrown if either P or a are 0.
 */
export declare function Function({ n, P, a, b }: Parameterised): bigint;
/**
 * Parameterised Collatz Inverse Function
 * @param n - The value on which to perform the reverse Collatz function
 * @param P - Modulus used to devide n, iff n is equivalent to (0 mod P). Default is 2.
 * @param a - Factor by which to multiply n. Default is 3.
 * @param b - Value to add to the scaled value of n. Default is 1.
 * @returns the output of a single application of a Collatz-esque reverse function.
 * @throws FailedSaneParameterCheck
 * Thrown if either P or a are 0.
 */
export declare function ReverseFunction({ n, P, a, b }: Parameterised): bigint[];
declare const _default: {
    Function: typeof Function;
    ReverseFunction: typeof ReverseFunction;
};
export default _default;
//# sourceMappingURL=index.d.ts.map