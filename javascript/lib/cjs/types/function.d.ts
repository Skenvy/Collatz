/**
 * Parameterised inputs
 * @remarks
 * Allow (P,a,b) to be optional, keyword inputs.
 */
export interface CollatzFunctionParameters {
    /**
     * The value on which to perform the Collatz-esque function
     */
    n: bigint;
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
}
/**
 * Parameterised Collatz Function
 * @param parameterisedInputs - Allows non-default (P,a,b)
 * @returns the output of a single application of a Collatz-esque function.
 * @throws FailedSaneParameterCheck
 * Thrown if either P or a are 0.
 */
export declare function collatzFunction({ n, P, a, b }: CollatzFunctionParameters): bigint;
/**
 * Parameterised Collatz Inverse Function
 * @param parameterisedInputs - Allows non-default (P,a,b)
 * @returns the output of a single application of a Collatz-esque reverse function.
 * @throws FailedSaneParameterCheck
 * Thrown if either P or a are 0.
 */
export declare function reverseFunction({ n, P, a, b }: CollatzFunctionParameters): bigint[];
//# sourceMappingURL=function.d.ts.map