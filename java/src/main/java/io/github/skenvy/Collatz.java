package io.github.skenvy;

import java.math.BigInteger;
import java.util.Arrays;
import java.util.function.Function;

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
     * Default value for "P", the modulus condition.
     */
    public static final BigInteger DEFAULT_P = BigInteger.valueOf(2);

    /**
     * Default value for "a", the input's multiplicand.
     */
    public static final BigInteger DEFAULT_A = BigInteger.valueOf(3);

    /**
     * Default value for "b", the value added to the multiplied value.
     */
    public static final BigInteger DEFAULT_B = BigInteger.valueOf(1);

    /**
     * The four known cycles for the standard parameterisation.
     */
    public static final BigInteger[][] _KNOWN_CYCLES = new BigInteger[][]{
        Arrays.stream(new long[]{1, 4, 2}).mapToObj(x -> BigInteger.valueOf(x)).toArray(BigInteger[]::new),
        Arrays.stream(new long[]{-1, -2}).mapToObj(x -> BigInteger.valueOf(x)).toArray(BigInteger[]::new),
        Arrays.stream(new long[]{-5, -14, -7, -20, -10}).mapToObj(x -> BigInteger.valueOf(x)).toArray(BigInteger[]::new),
        Arrays.stream(new long[]{-17, -50, -25, -74, -37, -110, -55, -164, -82, -41, -122, -61, -182, -91, -272, -136, -68, -34}).mapToObj(x -> BigInteger.valueOf(x)).toArray(BigInteger[]::new)
    };

    /**
     * The current value up to which the standard parameterisation has been verified.
     */
    public static final BigInteger __VERIFIED_MAXIMUM = new BigInteger("295147905179352825856");
    
    /**
     * The current value down to which the standard parameterisation has been verified.
     * TODO: Check the actual lowest bound.
     */
    public static final BigInteger __VERIFIED_MINIMUM = BigInteger.valueOf(-272);

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
        return function(n, DEFAULT_P, DEFAULT_A, DEFAULT_B);
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
        return reverseFunction(n, DEFAULT_P, DEFAULT_A, DEFAULT_B);
    }

    /**
     * Provides the appropriate lambda to use to check if iterations on an initial
     * value have reached either the stopping time, or total stopping time.
     * @param n (BigInteger): The initial value to confirm against a stopping time check.
     * @param total_stop (boolean): If false, the lambda will confirm that iterations of n
     *              have reached the oriented stopping time to reach a value closer to 0.
     *              If true, the lambda will simply check equality to 1.
     * @return (Function<BigInteger, Boolean>): The lambda to check for the stopping time.
     */
    private static Function<BigInteger, Boolean> stoppingTimeTerminus(BigInteger n, boolean total_stop){
        if(total_stop){
            return (x) -> {return x.equals(BigInteger.ONE);};
        } else if (n.compareTo(BigInteger.ZERO) >= 0) {
            return (x) -> {return ((x.compareTo(n) == -1) && (x.compareTo(BigInteger.ZERO) == 1));};
        } else {
            return (x) -> {return ((x.compareTo(n) == 1) && (x.compareTo(BigInteger.ZERO) == -1));};
        }
    }

    /**
     * Contains the results of computing a hailstone sequence via Collatz.hailstoneSequence(~).
     */
    public static final class HailstoneSequence {

        /**
         * The set of values that comprise the hailstone sequence.
         */
        BigInteger[] values;

        /**
         * A terminal condition that reflects the final state of the hailstone sequencing,
         * whether than be that it succeeded at determining the stopping time, the total
         * stopping time, found a cycle, or got stuck on zero (or surpassed the max total).
         */
        _CC terminalCondition = null;

        /**
         * A status value that has different meanings depending on what the terminal condition
         * was. If the sequence completed either via reaching the stopping or total stopping time,
         * or getting stuck on zero, then this value is the stopping/terminal time. If the sequence
         * got stuck on a cycle, then this value is the cycle length. If the sequencing passes the
         * maximum stopping time then this is the value that was provided as that maximum.
         */
        int terminalStatus = 0;

        /**
         * Initialise a new Hailstone Sequence with an initial value and the maximum total stopping time.
         * @param initialValue
         * @param maxTotalStoppingTime
         */
        public HailstoneSequence(BigInteger initialValue, int maxTotalStoppingTime){
            if(initialValue.equals(BigInteger.ZERO)){
                // 0 is always an immediate stop.
                values = new BigInteger[]{BigInteger.ZERO};
                terminalCondition = _CC.ZERO_STOP;
                terminalStatus = 0;
            } else if(initialValue.equals(BigInteger.ONE)){
                // 1 is always an immediate stop, with 0 stopping time.
                values = new BigInteger[]{BigInteger.ONE};
                terminalCondition = _CC.TOTAL_STOPPING_TIME;
                terminalStatus = 0;
            } else {
                // Otherwise prepare the expected hailstone length
                values = new BigInteger[maxTotalStoppingTime+1];
                values[0] = initialValue;
            }
        }
    }

    /**
     * Returns a list of successive values obtained by iterating a Collatz-esque
     * function, until either 1 is reached, or the total amount of iterations
     * exceeds maxTotalStoppingTime, unless totalStoppingTime is False,
     * which will terminate the hailstone at the "stopping time" value, i.e. the
     * first value less than the initial value. While the sequence has the
     * capability to determine that it has encountered a cycle, the cycle from "1"
     * wont be attempted or reported as part of a cycle, regardless of default or
     * custom parameterisation, as "1" is considered a "total stop".
     * @param initialValue (BigInteger): The value to begin the hailstone sequence from.
     * @param P (BigInteger): Modulus used to devide n, iff n is equivalent to (0 mod P).
     * @param a (BigInteger): Factor by which to multiply n.
     * @param b (BigInteger): Value to add to the scaled value of n.
     * @param maxTotalStoppingTime (int): Maximum amount of times to iterate the function, if 1 is not reached.
     * @param totalStoppingTime (boolean): Whether or not to execute until the "total" stopping time
     *              (number of iterations to obtain 1) rather than the regular stopping time (number
     *              of iterations to reach a value less than the initial value).
     * @return (HailstoneSequence): A set of values that form the hailstone sequence.
     */
    public static HailstoneSequence hailstoneSequence(BigInteger initialValue, BigInteger P, BigInteger a, BigInteger b, int maxTotalStoppingTime, boolean totalStoppingTime){
        // Call out the function before any magic returns to trap bad values.
        BigInteger _throwaway = function(initialValue, P, a, b);
        // Start the hailstone sequence.
        Function<BigInteger, Boolean> terminate = stoppingTimeTerminus(initialValue, totalStoppingTime);
        int _maxTotalStoppingTime = Math.max(maxTotalStoppingTime, 1);
        HailstoneSequence hailstones = new HailstoneSequence(initialValue, _maxTotalStoppingTime);
        // If the initial value was 0 or 1, then the sequence would have already ended
        if(initialValue.equals(BigInteger.ZERO) || initialValue.equals(BigInteger.ONE)){
            return hailstones;
        }
        // Otherwise, run through the hailstones.
        BigInteger _next;
        int _finalK = 0;
        for(int k = 1; k <= _maxTotalStoppingTime; k++){
             _next = function(hailstones.values[k-1], P, a, b);
            // Check if the next hailstone is either the stopping time, total
            // stopping time, the same as the initial value, or stuck at zero.
            if(terminate.apply(_next)){
                hailstones.values[k] = _next;
                if(_next.equals(BigInteger.ONE)){
                    hailstones.terminalCondition = _CC.TOTAL_STOPPING_TIME;
                } else {
                    hailstones.terminalCondition = _CC.STOPPING_TIME;
                }
                hailstones.terminalStatus = k;
                _finalK = k;
                break;
            }
            if(Arrays.asList(hailstones.values).contains(_next)){
                hailstones.values[k] = _next;
                int cycle_init = 1;
                for(int j = 1; j <= k; j++){
                    if(hailstones.values[k-j].equals(_next)){
                        cycle_init = j;
                        break;
                    }
                }
                hailstones.terminalCondition = _CC.CYCLE_LENGTH;
                hailstones.terminalStatus = cycle_init;
                _finalK = k;
                break;
            }
            if(_next.equals(BigInteger.ZERO)){
                hailstones.values[k] = BigInteger.ZERO;
                hailstones.terminalCondition = _CC.ZERO_STOP;
                hailstones.terminalStatus = -k;
                _finalK = k;
                break;
            }
            hailstones.values[k] = _next;
        }
        if(hailstones.terminalCondition == null){
            hailstones.terminalCondition = _CC.MAX_STOP_OOB;
            hailstones.terminalStatus = _maxTotalStoppingTime;
        } else {
            BigInteger[] filledValues = new BigInteger[_finalK+1];
            System.arraycopy(hailstones.values, 0, filledValues, 0, filledValues.length);
            hailstones.values = filledValues;
        }
        return hailstones;
    }

    public static HailstoneSequence hailstoneSequence(BigInteger initialValue){
        return hailstoneSequence(initialValue, DEFAULT_P, DEFAULT_A, DEFAULT_B, 1000, true);
    }

    /**
     * Returns the stopping time, the amount of iterations required to reach a
     * value less than the initial value, or None if maxStoppingTime is exceeded.
     * Alternatively, if totalStoppingTime is True, then it will instead count
     * the amount of iterations to reach 1. If the sequence does not stop, but
     * instead ends in a cycle, the result will be (math.inf). If (P,a,b) are such
     * that it is possible to get stuck on zero, the result will be the negative of
     * what would otherwise be the "total stopping time" to reach 1, where 0 is
     * considered a "total stop" that should not occur as it does form a cycle of
     * length 1.
     * @param initialValue (BigInteger): The value for which to find the stopping time.
     * @param P (BigInteger): Modulus used to devide n, iff n is equivalent to (0 mod P).
     * @param a (BigInteger): Factor by which to multiply n.
     * @param b (BigInteger): Value to add to the scaled value of n.
     * @param maxStoppingTime (int): Maximum amount of times to iterate the function, if
     *              the stopping time is not reached. IF the maxStoppingTime is reached,
     *              the function will return None.
     * @param totalStoppingTime (bool): Whether or not to execute until the "total" stopping
     *              time (number of iterations to obtain 1) rather than the regular stopping
     *              time (number of iterations to reach a value less than the initial value).
     * @return
     */
    public static Double stoppingTime(BigInteger initialValue, BigInteger P, BigInteger a, BigInteger b, int maxStoppingTime, boolean totalStoppingTime){
        /* The information is contained in the hailstone sequence. Although the "max~time"
         * for hailstones is named for "total stopping" time and the "max~time" for this
         * "stopping time" function is _not_ "total", they are handled the same way, as
         * the default for "totalStoppingTime" for hailstones is true, but for this, is
         * false. Thus the naming difference. */
        HailstoneSequence hail = hailstoneSequence(initialValue, P, a, b, maxStoppingTime, totalStoppingTime);
        // For total/regular/zero stopping time, the value is already the same as
        // that present, for cycles we report infinity instead of the cycle length,
        // and for max stop out of bounds, we report null instead of the max stop cap
        switch(hail.terminalCondition) {
            case TOTAL_STOPPING_TIME:
                return (double) hail.terminalStatus;
            case STOPPING_TIME:
                return (double) hail.terminalStatus;
            case CYCLE_LENGTH:
                return Double.POSITIVE_INFINITY;
            case ZERO_STOP:
                return (double) hail.terminalStatus;
            case MAX_STOP_OOB:
                return null;
            default:
                return null;
        }
    }

    public static Double stoppingTime(BigInteger initialValue){
        return stoppingTime(initialValue, DEFAULT_P, DEFAULT_A, DEFAULT_B, 1000, false);
    }
}
