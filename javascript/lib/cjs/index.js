"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.stoppingTime = exports.hailstoneSequence = exports.HailstoneSequence = exports.reverseFunction = exports.collatzFunction = exports.assertSaneParameterisation = exports.SequenceState = exports.FailedSaneParameterCheck = exports.SaneParameterErrMsg = exports.VERIFIED_MINIMUM = exports.VERIFIED_MAXIMUM = exports.KNOWN_CYCLES = void 0;
/** The four known cycles (besides 0 cycling to itself), for the default parameterisation. */
exports.KNOWN_CYCLES = [[1n, 4n, 2n], [-1n, -2n], [-5n, -14n, -7n, -20n, -10n],
    [-17n, -50n, -25n, -74n, -37n, -110n, -55n, -164n, -82n, -41n, -122n, -61n, -182n, -91n, -272n, -136n, -68n, -34n]];
/** The current value up to which has been proven numerically, for the default parameterisation. */
exports.VERIFIED_MAXIMUM = 295147905179352825856n;
/** The current value down to which has been proven numerically, for the default parameterisation. */
exports.VERIFIED_MINIMUM = -272n; // TODO: Check the actual lowest bound.
/**
 * Error message constants.
 * @remarks
 * To be used as input to the FailedSaneParameterCheck.
 */
var SaneParameterErrMsg;
(function (SaneParameterErrMsg) {
    /** Message to print in the FailedSaneParameterCheck if P, the modulus, is zero. */
    SaneParameterErrMsg["SANE_PARAMS_P"] = "'P' should not be 0 ~ violates modulo being non-zero.";
    /** Message to print in the FailedSaneParameterCheck if a, the multiplicand, is zero. */
    SaneParameterErrMsg["SANE_PARAMS_A"] = "'a' should not be 0 ~ violates the reversability.";
})(SaneParameterErrMsg || (exports.SaneParameterErrMsg = SaneParameterErrMsg = {}));
/**
 * FailedSaneParameterCheck
 * @remarks
 * An Error thrown when assertSaneParameterisation determines invalid parameterisation.
 * This is when either P, the modulus, or a, the multiplicand, are zero.
 */
class FailedSaneParameterCheck extends Error {
    /**
     * Construct a FailedSaneParameterCheck with a message associated with the provided enum.
     * @param message - The enum from which to extract the message.
     */
    constructor(message) {
        super(message);
        this.name = 'FailedSaneParameterCheck';
    }
}
exports.FailedSaneParameterCheck = FailedSaneParameterCheck;
/**
 * SequenceState for Cycle Control
 * @remarks
 * Descriptive flags to indicate when some event occurs in the hailstone sequences
 * or tree graph reversal, when set to verbose, or stopping time check.
 */
var SequenceState;
(function (SequenceState) {
    /** A Hailstone sequence state that indicates the stopping
     *  time, a value less than the initial, has been reached. */
    SequenceState["STOPPING_TIME"] = "STOPPING_TIME";
    /** A Hailstone sequence state that indicates the total
     *  stopping time, a value of 1, has been reached. */
    SequenceState["TOTAL_STOPPING_TIME"] = "TOTAL_STOPPING_TIME";
    /** A Hailstone and TreeGraph sequence state that indicates the
     *  first occurence of a value that subsequently forms a cycle. */
    SequenceState["CYCLE_INIT"] = "CYCLE_INIT";
    /** A Hailstone and TreeGraph sequence state that indicates the
     *  last occurence of a value that has already formed a cycle. */
    SequenceState["CYCLE_LENGTH"] = "CYCLE_LENGTH";
    /** A Hailstone and TreeGraph sequence state that indicates the sequence
     *  or traversal has executed some imposed 'maximum' amount of times. */
    SequenceState["MAX_STOP_OUT_OF_BOUNDS"] = "MAX_STOP_OUT_OF_BOUNDS";
    /** A Hailstone sequence state that indicates the sequence terminated
     *  by reaching "0", a special type of "stopping time". */
    SequenceState["ZERO_STOP"] = "ZERO_STOP";
})(SequenceState || (exports.SequenceState = SequenceState = {}));
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
    if (P === 0n) {
        throw new FailedSaneParameterCheck(SaneParameterErrMsg.SANE_PARAMS_P);
    }
    if (a === 0n) {
        throw new FailedSaneParameterCheck(SaneParameterErrMsg.SANE_PARAMS_A);
    }
}
exports.assertSaneParameterisation = assertSaneParameterisation;
/**
 * Parameterised Collatz Function
 * @param parameterisedInputs - Allows non-default (P,a,b)
 * @param parameterisedInputs.n - The value on which to perform the Collatz-esque function
 * @param parameterisedInputs.P - Modulus used to devide n, iff n is equivalent to (0 mod P). Default is 2.
 * @param parameterisedInputs.a - Factor by which to multiply n. Default is 3.
 * @param parameterisedInputs.b - Value to add to the scaled value of n. Default is 1.
 * @returns the output of a single application of a Collatz-esque function.
 * @throws FailedSaneParameterCheck
 * Thrown if either P or a are 0.
 */
function collatzFunction({ n, P = 2n, a = 3n, b = 1n }) {
    assertSaneParameterisation(P, a, b);
    return n % P === 0n ? n / P : (a * n + b);
}
exports.collatzFunction = collatzFunction;
/**
 * Parameterised Collatz Inverse Function
 * @param parameterisedInputs - Allows non-default (P,a,b)
 * @param parameterisedInputs.n - The value on which to perform the reverse Collatz function
 * @param parameterisedInputs.P - Modulus used to devide n, iff n is equivalent to (0 mod P). Default is 2.
 * @param parameterisedInputs.a - Factor by which to multiply n. Default is 3.
 * @param parameterisedInputs.b - Value to add to the scaled value of n. Default is 1.
 * @returns the output of a single application of a Collatz-esque reverse function.
 * @throws FailedSaneParameterCheck
 * Thrown if either P or a are 0.
 */
function reverseFunction({ n, P = 2n, a = 3n, b = 1n }) {
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
exports.reverseFunction = reverseFunction;
/**
 * Provides the appropriate lambda to use to check if iterations on an initial
 * value have reached either the stopping time, or total stopping time.
 * @param n - The initial value to confirm against a stopping time check.
 * @param totalStop - If false, the lambda will confirm that iterations of n
 *     have reached the oriented stopping time to reach a value closer to 0.
 *     If true, the lambda will simply check equality to 1.
 * @returns the lambda (arrow function expression) to check for the stopping time.
 */
function stoppingTimeTerminus(n, totalStop) {
    if (totalStop) {
        return (x) => { return x === 1n; };
    }
    else if (n >= 0n) {
        return (x) => { return x < n && x > 0; };
    }
    else {
        return (x) => { return x > n && x < 0; };
    }
}
/** Contains the results of computing a hailstone sequence. */
class HailstoneSequence {
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
exports.HailstoneSequence = HailstoneSequence;
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
 * @param parameterisedInputs.initialValue - The value to begin the hailstone sequence from.
 * @param parameterisedInputs.P - Modulus used to devide n, iff n is equivalent to (0 mod P). Default is 2.
 * @param parameterisedInputs.a - Factor by which to multiply n. Default is 3.
 * @param parameterisedInputs.b - Value to add to the scaled value of n. Default is 1.
 * @param parameterisedInputs.maxTotalStoppingTime - Maximum amount of times to iterate the function, if 1 is not reached.
 * @param parameterisedInputs.totalStoppingTime - Whether or not to execute until the "total" stopping time
 *     (number of iterations to obtain 1) rather than the regular stopping time (number
 *     of iterations to reach a value less than the initial value).
 * @returns A HailstoneSequence, a set of values that form the hailstone sequence.
 * @throws FailedSaneParameterCheck
 * Thrown if either P or a are 0.
 */
function hailstoneSequence({ initialValue, P = 2n, a = 3n, b = 1n, maxTotalStoppingTime = 1000, totalStoppingTime = true }) {
    // Call out the function before any magic returns to trap bad values.
    const throwaway = collatzFunction({ n: initialValue, P: P, a: a, b: b });
    // Return the hailstone sequence.
    return new HailstoneSequence(initialValue, P, a, b, maxTotalStoppingTime, totalStoppingTime);
}
exports.hailstoneSequence = hailstoneSequence;
/**
 * Returns the stopping time, the amount of iterations required to reach a
 * value less than the initial value, or null if maxStoppingTime is exceeded.
 * Alternatively, if totalStoppingTime is True, then it will instead count
 * the amount of iterations to reach 1. If the sequence does not stop, but
 * instead ends in a cycle, the result will be (Double.POSITIVE_INFINITY).
 * If (P,a,b) are such that it is possible to get stuck on zero, the result
 * will be the negative of what would otherwise be the "total stopping time"
 * to reach 1, where 0 is considered a "total stop" that should not occur as
 * it does form a cycle of length 1.
 * @param parameterisedInputs - Allows non-default (P,a,b); and other options.
 * @param parameterisedInputs.initialValue - The value for which to find the stopping time.
 * @param parameterisedInputs.P - Modulus used to devide n, iff n is equivalent to (0 mod P). Default is 2.
 * @param parameterisedInputs.a - Factor by which to multiply n. Default is 3.
 * @param parameterisedInputs.b - Value to add to the scaled value of n. Default is 1.
 * @param parameterisedInputs.maxStoppingTime - Maximum amount of times to iterate the function, if
 *     the stopping time is not reached. IF the maxStoppingTime is reached,
 *     the function will return null.
 * @param parameterisedInputs.totalStoppingTime - Whether or not to execute until the "total" stopping
 *     time (number of iterations to obtain 1) rather than the regular stopping
 *     time (number of iterations to reach a value less than the initial value).
 * @returns the stopping time, or, in a special case, infinity, null or a negative.
 */
function stoppingTime({ initialValue, P = 2n, a = 3n, b = 1n, maxStoppingTime = 1000, totalStoppingTime = false }) {
    /* The information is contained in the hailstone sequence. Although the "max~time"
     * for hailstones is named for "total stopping" time and the "max~time" for this
     * "stopping time" function is _not_ "total", they are handled the same way, as
     * the default for "totalStoppingTime" for hailstones is true, but for this, is
     * false. Thus the naming difference. */
    const hail = hailstoneSequence({ initialValue: initialValue, P: P, a: a, b: b, maxTotalStoppingTime: maxStoppingTime, totalStoppingTime: totalStoppingTime });
    // For total/regular/zero stopping time, the value is already the same as
    // that present, for cycles we report infinity instead of the cycle length,
    // and for max stop out of bounds, we report null instead of the max stop cap
    switch (hail.terminalCondition) {
        case SequenceState.TOTAL_STOPPING_TIME:
            return hail.terminalStatus;
        case SequenceState.STOPPING_TIME:
            return hail.terminalStatus;
        case SequenceState.CYCLE_LENGTH:
            return Number.POSITIVE_INFINITY; // Also just "Infinity"
        case SequenceState.ZERO_STOP:
            return hail.terminalStatus;
        case SequenceState.MAX_STOP_OUT_OF_BOUNDS:
            return null;
        default:
            return null;
    }
}
exports.stoppingTime = stoppingTime;
exports.default = {
    collatzFunction,
    reverseFunction,
    HailstoneSequence,
    hailstoneSequence,
    stoppingTime,
};
