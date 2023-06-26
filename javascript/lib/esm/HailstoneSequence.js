import { SequenceState, stoppingTimeTerminus } from './utilities';
import { collatzFunction } from './function';
/** Contains the results of computing a hailstone sequence. */
export class HailstoneSequence {
    /** The set of values that comprise the hailstone sequence. */
    values;
    /** The stopping time terminal condition */
    terminate;
    /** A terminal condition that reflects the final state of the hailstone sequencing,
     *  whether than be that it succeeded at determining the stopping time, the total
     *  stopping time, found a cycle, or got stuck on zero (or surpassed the max total). */
    terminalCondition;
    /** A status value that has different meanings depending on what the terminal condition
     *  was. If the sequence completed either via reaching the stopping or total stopping time,
     *  or getting stuck on zero, then this value is the stopping/terminal time. If the sequence
     *  got stuck on a cycle, then this value is the cycle length. If the sequencing passes the
     *  maximum stopping time then this is the value that was provided as that maximum. */
    terminalStatus;
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
    constructor(initialValue, P, a, b, maxTotalStoppingTime, totalStoppingTime) {
        this.terminate = stoppingTimeTerminus(initialValue, totalStoppingTime);
        if (initialValue === 0n) {
            // 0 is always an immediate stop.
            this.values = [0n];
            this.terminalCondition = SequenceState.ZERO_STOP;
            this.terminalStatus = 0;
        }
        else if (initialValue === 1n) {
            // 1 is always an immediate stop, with 0 stopping time.
            this.values = [1n];
            this.terminalCondition = SequenceState.TOTAL_STOPPING_TIME;
            this.terminalStatus = 0;
        }
        else {
            // Otherwise, hail!
            const minMaxTotalStoppingTime = Math.max(maxTotalStoppingTime, 1);
            this.values = [initialValue];
            let next;
            for (let k = 1; k <= minMaxTotalStoppingTime; k += 1) {
                next = collatzFunction({ n: this.values[k - 1], P: P, a: a, b: b });
                // Check if the next hailstone is either the stopping time, total
                // stopping time, the same as the initial value, or stuck at zero.
                if (this.terminate(next)) {
                    this.values.push(next);
                    if (next === 1n) {
                        this.terminalCondition = SequenceState.TOTAL_STOPPING_TIME;
                    }
                    else {
                        this.terminalCondition = SequenceState.STOPPING_TIME;
                    }
                    this.terminalStatus = k;
                    return;
                }
                if (this.values.includes(next)) {
                    this.values.push(next);
                    let cycleInit = 1;
                    for (let j = 1; j <= k; j += 1) {
                        if (this.values[k - j] === next) {
                            cycleInit = j;
                            break;
                        }
                    }
                    this.terminalCondition = SequenceState.CYCLE_LENGTH;
                    this.terminalStatus = cycleInit;
                    return;
                }
                if (next === 0n) {
                    this.values.push(0n);
                    this.terminalCondition = SequenceState.ZERO_STOP;
                    this.terminalStatus = -k;
                    return;
                }
                this.values.push(next);
            }
            this.terminalCondition = SequenceState.MAX_STOP_OUT_OF_BOUNDS;
            this.terminalStatus = minMaxTotalStoppingTime;
        }
    }
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
export function hailstoneSequence({ initialValue, P = 2n, a = 3n, b = 1n, maxTotalStoppingTime = 1000, totalStoppingTime = true }) {
    // Call out the function before any magic returns to trap bad values.
    const throwaway = collatzFunction({ n: initialValue, P: P, a: a, b: b });
    // Return the hailstone sequence.
    return new HailstoneSequence(initialValue, P, a, b, maxTotalStoppingTime, totalStoppingTime);
}
