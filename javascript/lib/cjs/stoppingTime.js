"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.stoppingTime = stoppingTime;
const utilities_js_1 = require("./utilities.js");
const HailstoneSequence_js_1 = require("./HailstoneSequence.js");
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
 * @returns the stopping time, or, in a special case, infinity, null or a negative.
 */
function stoppingTime({ initialValue, P = 2n, a = 3n, b = 1n, maxStoppingTime = 1000, totalStoppingTime = false }) {
    /* The information is contained in the hailstone sequence. Although the "max~time"
     * for hailstones is named for "total stopping" time and the "max~time" for this
     * "stopping time" function is _not_ "total", they are handled the same way, as
     * the default for "totalStoppingTime" for hailstones is true, but for this, is
     * false. Thus the naming difference. */
    const hail = (0, HailstoneSequence_js_1.hailstoneSequence)({ initialValue: initialValue, P: P, a: a, b: b, maxTotalStoppingTime: maxStoppingTime, totalStoppingTime: totalStoppingTime });
    // For total/regular/zero stopping time, the value is already the same as
    // that present, for cycles we report infinity instead of the cycle length,
    // and for max stop out of bounds, we report null instead of the max stop cap
    switch (hail.terminalCondition) {
        case utilities_js_1.SequenceState.TOTAL_STOPPING_TIME:
            return hail.terminalStatus;
        case utilities_js_1.SequenceState.STOPPING_TIME:
            return hail.terminalStatus;
        case utilities_js_1.SequenceState.CYCLE_LENGTH:
            return Number.POSITIVE_INFINITY; // Also just "Infinity"
        case utilities_js_1.SequenceState.ZERO_STOP:
            return hail.terminalStatus;
        case utilities_js_1.SequenceState.MAX_STOP_OUT_OF_BOUNDS:
            return null;
        default:
            return null;
    }
}
exports.default = {
    stoppingTime,
};
