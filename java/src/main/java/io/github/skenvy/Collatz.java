package io.github.skenvy;

import java.math.BigInteger;
import java.util.Arrays;

/**
 * Provides the basic functionality to interact with the Collatz conjecture.
 * The parameterisation uses the same (P,a,b) notation as Conway's generalisations.
 * Besides the function and reverse function, there is also functionality to
 * retrieve the hailstone sequence, the "stopping time"/"total stopping time", or
 * tree-graph.
 */
public final class Collatz
{

    /**
     * Error message constant.
     */
    protected enum _ErrMsg {
        SANE_PARAMS_P("'P' should not be 0 ~ violates modulo being non-zero."),
        SANE_PARAMS_A("'a' should not be 0 ~ violates the reversability.");

        private final String label;

        private _ErrMsg(String label) {
            this.label = label;
        }

        protected String getLabel(){
            return this.label;
        }
    }

    /**
     * Cycle Control: Descriptive flags to indicate when some event occurs in the
     * hailstone sequences, when set to verbose, or stopping time check.
     */
    protected enum _CC {
        STOPPING_TIME("STOPPING_TIME"),
        TOTAL_STOPPING_TIME("TOTAL_STOPPING_TIME"),
        CYCLE_INIT("CYCLE_INIT"),
        CYCLE_LENGTH("CYCLE_LENGTH"),
        MAX_STOP_OOB("MAX_STOP_OOB"),
        ZERO_STOP("ZERO_STOP");

        private final String label;

        private _CC(String label) {
            this.label = label;
        }

        protected String getLabel(){
            return this.label;
        }
    }

    static protected class FailedSaneParameterCheck extends ArithmeticException { 
        public FailedSaneParameterCheck(String errorMessage) {
            super(errorMessage);
        }
    }

    /**
     * Handles the sanity check for the parameterisation (P,a,b) required by both
     * the function and reverse function.
     * @param P (BigInteger): Modulus used to devide n, iff n is equivalent to (0 mod P)
     * @param a (BigInteger): Factor by which to multiply n.
     * @param b (BigInteger): Value to add to the scaled value of n.
     */
    private static void assertSaneParameterisation(BigInteger P, BigInteger a, BigInteger b){
        /* Sanity check (P,a,b) ~ P absolutely can't be 0. a "could" be zero
         * theoretically, although would violate the reversability (if ~a is 0 then a
         * value of "b" as the input to the reverse function would have a pre-emptive
         * value of every number not divisible by P). The function doesn't _have_ to
         * be reversable, but we are only interested in dealing with the class of
         * functions that exhibit behaviour consistant with the collatz function. If
         * _every_ input not divisable by P went straight to "b", it would simply
         * cause a cycle consisting of "b" and every b/P^z that is an integer. While
         * P in [-1, 1] could also be a reasonable check, as it makes every value
         * either a 1 or 2 length cycle, it's not strictly an illegal operation.
         * "b" being zero would cause behaviour not consistant with the collatz
         * function, but would not violate the reversability, so no check either.
         * " != 0" is redundant for python assertions. */
        if(P == BigInteger.ZERO){
            throw new FailedSaneParameterCheck(_ErrMsg.SANE_PARAMS_P.getLabel());
        } else if(a == BigInteger.ZERO){
            throw new FailedSaneParameterCheck(_ErrMsg.SANE_PARAMS_A.getLabel());
        }
    }

    /**
     * Returns the output of a single application of a Collatz-esque function.
     * @param n (BigInteger): The value on which to perform the Collatz-esque function.
     * @param P (BigInteger): Modulus used to devide n, iff n is equivalent to (0 mod P).
     * @param a (BigInteger): Factor by which to multiply n.
     * @param b (BigInteger): Value to add to the scaled value of n.
     * @return (BigInteger): The result of the function
     */
    public static BigInteger function(BigInteger n, BigInteger P, BigInteger a, BigInteger b){
        assertSaneParameterisation(P,a,b);
        if(n.remainder(P) == BigInteger.ZERO){
            return n.divide(P);
        } else {
            return n.multiply(a).add(b);
        }
    }

    /**
     * Returns the output of a single application of a Collatz-esque function.
     * @param n (BigInteger): The value on which to perform the Collatz-esque function.
     * @return (BigInteger): The result of the function
     */
    public static BigInteger function(BigInteger n){
        return function(n, BigInteger.valueOf(2), BigInteger.valueOf(3), BigInteger.valueOf(1));
    }

    /**
     * Returns the output of a single application of a Collatz-esque reverse function.
     * @param n (BigInteger): The value on which to perform the reverse Collatz function.
     * @param P (BigInteger): Modulus used to devide n, iff n is equivalent to (0 mod P).
     * @param a (BigInteger): Factor by which to multiply n.
     * @param b (BigInteger): Value to add to the scaled value of n.
     * @return (BigInteger): The result of the function
     */
    public static BigInteger[] reverseFunction(BigInteger n, BigInteger P, BigInteger a, BigInteger b){
        assertSaneParameterisation(P,a,b);
        /*(n-b)%a == 0 && (n-b)%(P*a) != 0*/
        if(n.subtract(b).remainder(a) == BigInteger.ZERO && n.subtract(b).remainder(P.multiply(a)) != BigInteger.ZERO){
            // [P*n] + [(n-b)//a]
            BigInteger[] preVals = new BigInteger[]{P.multiply(n), n.subtract(b).divide(a)};
            Arrays.sort(preVals);
            return preVals;
        } else { // [P*n]
            return new BigInteger[]{P.multiply(n)};
        }
    }

    /**
     * Returns the output of a single application of a Collatz-esque reverse function.
     * @param n (BigInteger): The value on which to perform the reverse Collatz function.
     * @return (BigInteger): The result of the function
     */
    public static BigInteger[] reverseFunction(BigInteger n){
        return reverseFunction(n, BigInteger.valueOf(2), BigInteger.valueOf(3), BigInteger.valueOf(1));
    }
}
