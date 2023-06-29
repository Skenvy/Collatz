/** The four known cycles (besides 0 cycling to itself), for the default parameterisation. */
export declare const KNOWN_CYCLES: bigint[][];
/** The current value up to which has been proven numerically, for the default parameterisation. */
export declare const VERIFIED_MAXIMUM: bigint;
/** The current value down to which has been proven numerically, for the default parameterisation. */
export declare const VERIFIED_MINIMUM: bigint;
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
 * Provides the appropriate lambda to use to check if iterations on an initial
 * value have reached either the stopping time, or total stopping time.
 * @param n - The initial value to confirm against a stopping time check.
 * @param totalStop - If false, the lambda will confirm that iterations of n
 *     have reached the oriented stopping time to reach a value closer to 0.
 *     If true, the lambda will simply check equality to 1.
 * @returns the lambda (arrow function expression) to check for the stopping time.
 */
export declare function stoppingTimeTerminus(n: bigint, totalStop: boolean): (_: bigint) => boolean;
//# sourceMappingURL=utilities.d.ts.map