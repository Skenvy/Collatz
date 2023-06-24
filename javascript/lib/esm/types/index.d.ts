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
export interface CollatzParameters {
    /**
     * The value on which to perform the operations; singular or iteratively.
     */
    n: bigint;
    /**
     * The modulus. Modulus used to devide n, iff n is equivalent to (0 mod P).
     * @defaultValue 2n
     */
    P?: bigint;
    /**
     * The multiplicand. Factor by which to multiply n.
     * @defaultValue 3n
     */
    a?: bigint;
    /**
     * The addend. Value to add to the scaled value of n.
     * @defaultValue 1n
     */
    b?: bigint;
}
/**
 * Parameterised Collatz Function
 * @param AnyNameHere - various options
 * @param AnyNameHere.n - The value on which to perform the Collatz-esque function
 * @param AnyNameHere.P - Modulus used to devide n, iff n is equivalent to (0 mod P). Default is 2.
 * @param AnyNameHere.a - Factor by which to multiply n. Default is 3.
 * @param AnyNameHere.b - Value to add to the scaled value of n. Default is 1.
 * @returns the output of a single application of a Collatz-esque function.
 * @throws FailedSaneParameterCheck
 * Thrown if either P or a are 0.
 */
export declare function collatzFunction({ n, P, a, b }: {
    n: bigint;
    P?: bigint;
    a?: bigint;
    b?: bigint;
}): bigint;
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
export declare function reverseFunction({ n, P, a, b }: CollatzParameters): bigint[];
/** Contains the results of computing a hailstone sequence. */
export declare class HailstoneSequence {
    /** The set of values that comprise the hailstone sequence. */
    readonly values: bigint[];
    /** The stopping time terminal condition */
    readonly terminate: (_: bigint) => boolean;
    /** A terminal condition that reflects the final state of the hailstone sequencing,
     *  whether than be that it succeeded at determining the stopping time, the total
     *  stopping time, found a cycle, or got stuck on zero (or surpassed the max total). */
    readonly terminalCondition: SequenceState;
    /** A status value that has different meanings depending on what the terminal condition
     *  was. If the sequence completed either via reaching the stopping or total stopping time,
     *  or getting stuck on zero, then this value is the stopping/terminal time. If the sequence
     *  got stuck on a cycle, then this value is the cycle length. If the sequencing passes the
     *  maximum stopping time then this is the value that was provided as that maximum. */
    readonly terminalStatus: number;
    /**
     * Initialise and compute a new Hailstone Sequence.
     * @param initialValue - The value to begin the hailstone sequence from.
     * @param P - Modulus used to devide n, iff n is equivalent to (0 mod P).
     * @param a - Factor by which to multiply n.
     * @param b - Value to add to the scaled value of n.
     * @param maxTotalStoppingTime - Maximum amount of times to iterate the function, if 1 is not reached.
     * @param totalStoppingTime - Whether or not to execute until the "total" stopping time
     *    (number of iterations to obtain 1) rather than the regular stopping time (number
     *    of iterations to reach a value less than the initial value).
     */
    constructor(initialValue: bigint, P: bigint, a: bigint, b: bigint, maxTotalStoppingTime: number, totalStoppingTime: boolean);
}
/**
 * Returns a list of successive values obtained by iterating a Collatz-esque
 * function, until either 1 is reached, or the total amount of iterations
 * exceeds maxTotalStoppingTime, unless totalStoppingTime is False,
 * which will terminate the hailstone at the "stopping time" value, i.e. the
 * first value less than the initial value. While the sequence has the
 * capability to determine that it has encountered a cycle, the cycle from "1"
 * wont be attempted or reported as part of a cycle, regardless of default or
 * custom parameterisation, as "1" is considered a "total stop".
 * @param initialValue - The value to begin the hailstone sequence from.
 * @param P - Modulus used to devide n, iff n is equivalent to (0 mod P).
 * @param a - Factor by which to multiply n.
 * @param b - Value to add to the scaled value of n.
 * @param maxTotalStoppingTime - Maximum amount of times to iterate the function, if 1 is not reached.
 * @param totalStoppingTime - Whether or not to execute until the "total" stopping time
 *     (number of iterations to obtain 1) rather than the regular stopping time (number
 *     of iterations to reach a value less than the initial value).
 * @return (HailstoneSequence): A set of values that form the hailstone sequence.
 */
export declare function hailstoneSequence({ n, P, a, b }: CollatzParameters, maxTotalStoppingTime: number, totalStoppingTime: boolean): HailstoneSequence;
declare const _default: {
    collatzFunction: typeof collatzFunction;
    reverseFunction: typeof reverseFunction;
    HailstoneSequence: typeof HailstoneSequence;
    hailstoneSequence: typeof hailstoneSequence;
};
export default _default;
//# sourceMappingURL=index.d.ts.map