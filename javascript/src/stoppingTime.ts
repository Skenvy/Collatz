import { SequenceState } from './utilities';
import { hailstoneSequence } from './HailstoneSequence';

/**
 * Parameterised inputs
 * @remarks
 * Allows non-default (P,a,b); and other options.
 */
export interface CollatzStoppingTimeParameters {
  /**
   * The value on which to perform the Collatz-esque function
   */
  initialValue: bigint,
  /**
   * Modulus used to devide n, iff n is equivalent to (0 mod P).
   * @defaultValue 2n
   */
  P?: bigint,
  /**
   * Factor by which to multiply n.
   * @defaultValue 3n
   */
  a?: bigint,
  /**
   * Value to add to the scaled value of n.
   * @defaultValue 1n
   */
  b?: bigint
  /**
   * Maximum amount of times to iterate the function, if the stopping time is not
   * reached. IF the maxStoppingTime is reached, the function will return null.
   * @defaultValue 1000
   */
  maxStoppingTime?: number,
  /**
   * Whether or not to execute until the "total" stopping time (number of
   * iterations to obtain 1) rather than the regular stopping time (number
   * of iterations to reach a value less than the initial value).
   * @defaultValue true
   */
  totalStoppingTime?: boolean
}

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
export function stoppingTime({ initialValue, P = 2n, a = 3n, b = 1n, maxStoppingTime = 1000, totalStoppingTime = false }:
  CollatzStoppingTimeParameters): number | null {
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

export default {
  stoppingTime,
};
