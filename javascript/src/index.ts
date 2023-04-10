/** The four known cycles (besides 0 cycling to itself), for the default parameterisation. */
export const KNOWN_CYCLES: bigint[][] = [[1n, 4n, 2n], [-1n, -2n], [-5n, -14n, -7n, -20n, -10n],
  [-17n, -50n, -25n, -74n, -37n, -110n, -55n, -164n, -82n, -41n, -122n, -61n, -182n, -91n, -272n, -136n, -68n, -34n]];
/** The current value up to which has been proven numerically, for the default parameterisation. */
export const VERIFIED_MAXIMUM: bigint = 295147905179352825856n;
/** The current value down to which has been proven numerically, for the default parameterisation. */
export const VERIFIED_MINIMUM: bigint = -272n; // TODO: Check the actual lowest bound.

/**
 * Error message constants.
 * @remarks
 * To be used as input to the FailedSaneParameterCheck.
 */
export enum SaneParameterErrMsg {
  /** Message to print in the FailedSaneParameterCheck if P, the modulus, is zero. */
  SANE_PARAMS_P = "'P' should not be 0 ~ violates modulo being non-zero.",
  /** Message to print in the FailedSaneParameterCheck if a, the multiplicand, is zero. */
  SANE_PARAMS_A = "'a' should not be 0 ~ violates the reversability."
}

/**
 * FailedSaneParameterCheck
 * @remarks
 * An Error thrown when assertSaneParameterisation determines invalid parameterisation.
 * This is when either P, the modulus, or a, the multiplicand, are zero.
 */
export class FailedSaneParameterCheck extends Error {
  /**
   * Construct a FailedSaneParameterCheck with a message associated with the provided enum.
   * @param message - The enum from which to extract the message.
   */
  constructor(message: SaneParameterErrMsg) {
    super(message);
    this.name = 'FailedSaneParameterCheck';
  }
}

/**
 * SequenceState for Cycle Control
 * @remarks
 * Descriptive flags to indicate when some event occurs in the hailstone sequences
 * or tree graph reversal, when set to verbose, or stopping time check.
 */
export enum SequenceState {
  /** A Hailstone sequence state that indicates the stopping
   *  time, a value less than the initial, has been reached. */
  STOPPING_TIME = 'STOPPING_TIME',
  /** A Hailstone sequence state that indicates the total
   *  stopping time, a value of 1, has been reached. */
  TOTAL_STOPPING_TIME = 'TOTAL_STOPPING_TIME',
  /** A Hailstone and TreeGraph sequence state that indicates the
   *  first occurence of a value that subsequently forms a cycle. */
  CYCLE_INIT = 'CYCLE_INIT',
  /** A Hailstone and TreeGraph sequence state that indicates the
   *  last occurence of a value that has already formed a cycle. */
  CYCLE_LENGTH = 'CYCLE_LENGTH',
  /** A Hailstone and TreeGraph sequence state that indicates the sequence
   *  or traversal has executed some imposed 'maximum' amount of times. */
  MAX_STOP_OUT_OF_BOUNDS = 'MAX_STOP_OUT_OF_BOUNDS',
  /** A Hailstone sequence state that indicates the sequence terminated
   *  by reaching "0", a special type of "stopping time". */
  ZERO_STOP = 'ZERO_STOP',
}

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
export function assertSaneParameterisation(P:bigint, a:bigint, b:bigint): void {
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

/**
 * Parameterised inputs
 * @remarks
 * Allow (P,a,b) to be optional, keyword inputs.
 */
export interface Parameterised {
  /**
   * The only required input is "n", the value to perform the operations on.
   */
  n: bigint,
  /**
   * The modulus.
   * @defaultValue 2n
   */
  P?: bigint,
  /**
   * The multiplicand.
   * @defaultValue 3n
   */
  a?: bigint,
  /**
   * The addend.
   * @defaultValue 1n
   */
  b?: bigint
}

/**
 * Parameterised Collatz Function
 * @param n - The value on which to perform the Collatz-esque function
 * @param P - Modulus used to devide n, iff n is equivalent to (0 mod P). Default is 2.
 * @param a - Factor by which to multiply n. Default is 3.
 * @param b - Value to add to the scaled value of n. Default is 1.
 * @returns the output of a single application of a Collatz-esque function.
 * @throws FailedSaneParameterCheck
 * Thrown if either P or a are 0.
 */
export function Function({ n, P = 2n, a = 3n, b = 1n }: Parameterised): bigint {
  assertSaneParameterisation(P, a, b);
  return n % P === 0n ? n / P : (a * n + b);
}

/**
 * Parameterised Collatz Inverse Function
 * @param n - The value on which to perform the reverse Collatz function
 * @param P - Modulus used to devide n, iff n is equivalent to (0 mod P). Default is 2.
 * @param a - Factor by which to multiply n. Default is 3.
 * @param b - Value to add to the scaled value of n. Default is 1.
 * @returns the output of a single application of a Collatz-esque reverse function.
 * @throws FailedSaneParameterCheck
 * Thrown if either P or a are 0.
 */
export function ReverseFunction({ n, P = 2n, a = 3n, b = 1n }: Parameterised): bigint[] {
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
  } else {
    return [P * n];
  }
}

export default {
  Function,
  ReverseFunction,
};
