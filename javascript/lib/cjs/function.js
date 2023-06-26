"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.reverseFunction = exports.collatzFunction = void 0;
const FailedSaneParameterCheck_1 = require("./FailedSaneParameterCheck");
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
    (0, FailedSaneParameterCheck_1.assertSaneParameterisation)(P, a, b);
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
    (0, FailedSaneParameterCheck_1.assertSaneParameterisation)(P, a, b);
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
