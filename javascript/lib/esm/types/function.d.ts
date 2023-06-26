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
export declare function collatzFunction({ n, P, a, b }: {
    n: bigint;
    P?: bigint;
    a?: bigint;
    b?: bigint;
}): bigint;
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
export declare function reverseFunction({ n, P, a, b }: {
    n: bigint;
    P?: bigint;
    a?: bigint;
    b?: bigint;
}): bigint[];
//# sourceMappingURL=function.d.ts.map