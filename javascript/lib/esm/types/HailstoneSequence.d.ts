import { SequenceState } from './utilities.ts';
/**
 * Parameterised inputs
 * @remarks
 * Allows non-default (P,a,b); and other options.
 */
export interface CollatzHailstoneParameters {
    /**
     * The value on which to perform the Collatz-esque function
     */
    initialValue: bigint;
    /**
     * Modulus used to devide n, iff n is equivalent to (0 mod P).
     * @defaultValue 2n
     */
    P?: bigint;
    /**
     * Factor by which to multiply n.
     * @defaultValue 3n
     */
    a?: bigint;
    /**
     * Value to add to the scaled value of n.
     * @defaultValue 1n
     */
    b?: bigint;
    /**
     * Maximum amount of times to iterate the function, if 1 is not reached.
     * @defaultValue 1000
     */
    maxTotalStoppingTime?: number;
    /**
     * Whether or not to execute until the "total" stopping time (number of
     * iterations to obtain 1) rather than the regular stopping time (number
     * of iterations to reach a value less than the initial value).
     * @defaultValue true
     */
    totalStoppingTime?: boolean;
}
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
     * @returns the hailstone sequence computed for the parameters provided.
     * @throws FailedSaneParameterCheck
     * Thrown if either P or a are 0.
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
 * @param parameterisedInputs - Allows non-default (P,a,b); and other options.
 * @returns A HailstoneSequence, a set of values that form the hailstone sequence.
 * @throws FailedSaneParameterCheck
 * Thrown if either P or a are 0.
 */
export declare function hailstoneSequence({ initialValue, P, a, b, maxTotalStoppingTime, totalStoppingTime }: CollatzHailstoneParameters): HailstoneSequence;
//# sourceMappingURL=HailstoneSequence.d.ts.map