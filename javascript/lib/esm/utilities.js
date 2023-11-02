"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.stoppingTimeTerminus = exports.SequenceState = exports.VERIFIED_MINIMUM = exports.VERIFIED_MAXIMUM = exports.KNOWN_CYCLES = void 0;
/** The four known cycles (besides 0 cycling to itself), for the default parameterisation. */
exports.KNOWN_CYCLES = [[1n, 4n, 2n], [-1n, -2n], [-5n, -14n, -7n, -20n, -10n],
    [-17n, -50n, -25n, -74n, -37n, -110n, -55n, -164n, -82n, -41n, -122n, -61n, -182n, -91n, -272n, -136n, -68n, -34n]];
/** The current value up to which has been proven numerically, for the default parameterisation. */
exports.VERIFIED_MAXIMUM = 295147905179352825856n;
/** The current value down to which has been proven numerically, for the default parameterisation. */
exports.VERIFIED_MINIMUM = -272n; // TODO: Check the actual lowest bound.
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
exports.stoppingTimeTerminus = stoppingTimeTerminus;
