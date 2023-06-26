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
export declare function stoppingTime({ initialValue, P, a, b, maxStoppingTime, totalStoppingTime }: {
    initialValue: bigint;
    P?: bigint;
    a?: bigint;
    b?: bigint;
    maxStoppingTime?: number;
    totalStoppingTime?: boolean;
}): number | null;
//# sourceMappingURL=stoppingTime.d.ts.map