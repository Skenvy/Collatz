package io.github.skenvy;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;
import java.util.function.Function;

/**
 * Provides the basic functionality to interact with the Collatz conjecture.
 * The parameterisation uses the same (P,a,b) notation as Conway's generalisations.
 * Besides the function and reverse function, there is also functionality to
 * retrieve the hailstone sequence, the "stopping time"/"total stopping time", or
 * tree-graph.
 */
public final class Collatz {

  /** Default value for {@code P}, the modulus condition. */
  public static final BigInteger DEFAULT_P = BigInteger.valueOf(2);

  /** Default value for {@code a}, the input's multiplicand. */
  public static final BigInteger DEFAULT_A = BigInteger.valueOf(3);

  /** Default value for {@code b}, the value added to the multiplied value. */
  public static final BigInteger DEFAULT_B = BigInteger.valueOf(1);

  /** The four known cycles for the standard parameterisation. */
  public static final BigInteger[][] KNOWN_CYCLES = new BigInteger[][]{
    Arrays.stream(new long[]{1, 4, 2}).mapToObj(x -> BigInteger.valueOf(x)).toArray(BigInteger[]::new),
    Arrays.stream(new long[]{-1, -2}).mapToObj(x -> BigInteger.valueOf(x)).toArray(BigInteger[]::new),
    Arrays.stream(new long[]{-5, -14, -7, -20, -10}).mapToObj(x -> BigInteger.valueOf(x)).toArray(BigInteger[]::new),
    Arrays.stream(new long[] { -17, -50, -25, -74, -37, -110, -55, -164, -82, -41, -122, -61, -182, -91, -272,
                    -136, -68, -34 }).mapToObj(x -> BigInteger.valueOf(x)).toArray(BigInteger[]::new)
  };

  /** The current value up to which the standard parameterisation has been verified. */
  public static final BigInteger VERIFIED_MAXIMUM = new BigInteger("295147905179352825856");

  /** The current value down to which the standard parameterisation has been verified. */
  // TODO: Check the actual lowest bound.
  public static final BigInteger VERIFIED_MINIMUM = BigInteger.valueOf(-272);

  /** Error message constants, to be used as input to the FailedSaneParameterCheck */
  protected enum SaneParameterErrMsg {

    /** Message to print in the FailedSaneParameterCheck if {@code P}, the modulus, is zero. */
    SANE_PARAMS_P("'P' should not be 0 ~ violates modulo being non-zero."),

    /** Message to print in the FailedSaneParameterCheck if {@code a}, the multiplicand, is zero. */
    SANE_PARAMS_A("'a' should not be 0 ~ violates the reversability.");

    /** The internal string contents; the error message. */
    private final String errorMessage;

    /**
     * Create a new instance with an error message.
     *
     * @param errorMessage (String): The message to pass to the thrown error.
     */
    private SaneParameterErrMsg(String errorMessage) {
      this.errorMessage = errorMessage;
    }

    /**
     * Retrieve the error message associated with the enum.
     * @return (String): The message to pass to the thrown error.
     */
    protected String getErrorMessage() {
      return this.errorMessage;
    }
  }

  /** Thrown when either {@code P}, the modulus, or {@code a}, the multiplicand, are zero. */
  static protected class FailedSaneParameterCheck extends ArithmeticException { 
    /**
     * Construct a FailedSaneParameterCheck with a message associated with the provided enum.
     *
     * @param errorEnum (SaneParameterErrMsg): The enum from which to extract the message.
     */
    public FailedSaneParameterCheck(SaneParameterErrMsg errorEnum) {
      super(errorEnum.getErrorMessage());
    }
  }

  /** SequenceState for Cycle Control: Descriptive flags to indicate when some event occurs in the
   *  hailstone sequences or tree graph reversal, when set to verbose, or stopping time check. */
  protected enum SequenceState {

    /** A Hailstone sequence state that indicates the stopping
     *  time, a value less than the initial, has been reached. */
    STOPPING_TIME("STOPPING_TIME"),

    /** A Hailstone sequence state that indicates the total
     *  stopping time, a value of 1, has been reached. */
    TOTAL_STOPPING_TIME("TOTAL_STOPPING_TIME"),

    /** A Hailstone and TreeGraph sequence state that indicates the
     *  first occurence of a value that subsequently forms a cycle. */
    CYCLE_INIT("CYCLE_INIT"),

    /** A Hailstone and TreeGraph sequence state that indicates the
     *  last occurence of a value that has already formed a cycle. */
    CYCLE_LENGTH("CYCLE_LENGTH"),

    /** A Hailstone and TreeGraph sequence state that indicates the sequence
     *  or traversal has executed some imposed 'maximum' amount of times. */
    MAX_STOP_OUT_OF_BOUNDS("MAX_STOP_OUT_OF_BOUNDS"),

    /** A Hailstone sequence state that indicates the sequence terminated
     *  by reaching "0", a special type of "stopping time". */
    ZERO_STOP("ZERO_STOP");

    /** The internal string contents; the sequence state. */
    private final String label;

    /**
     * Create a new instance with a sequence state.
     *
     * @param label (String): The stringy form of the enum.
     */
    private SequenceState(String label) {
      this.label = label;
    }

    /**
     * Retrieve the sequence state string associated with the enum.
     *
     * @return (String): The stringy form of the enum.
     */
    protected String getLabel() {
      return this.label;
    }
  }

  /**
   * Handles the sanity check for the parameterisation (P,a,b) required by both
   * the function and reverse function.
   *
   * @param P (BigInteger): Modulus used to devide n, iff n is equivalent to (0 mod P)
   * @param a (BigInteger): Factor by which to multiply n.
   * @param b (BigInteger): Value to add to the scaled value of n.
   */
  private static void assertSaneParameterisation(BigInteger P, BigInteger a, BigInteger b) {
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
     * function, but would not violate the reversability, so no check either. */
    if (P == BigInteger.ZERO) {
      throw new FailedSaneParameterCheck(SaneParameterErrMsg.SANE_PARAMS_P);
    } else if (a == BigInteger.ZERO) {
      throw new FailedSaneParameterCheck(SaneParameterErrMsg.SANE_PARAMS_A);
    }
  }

  /**
   * Returns the output of a single application of a Collatz-esque function.
   *
   * @param n (BigInteger): The value on which to perform the Collatz-esque function.
   * @param P (BigInteger): Modulus used to devide n, iff n is equivalent to (0 mod P).
   * @param a (BigInteger): Factor by which to multiply n.
   * @param b (BigInteger): Value to add to the scaled value of n.
   * @return (BigInteger): The result of the function
   */
  public static BigInteger function(BigInteger n, BigInteger P, BigInteger a, BigInteger b) {
    assertSaneParameterisation(P,a,b);
    if (n.remainder(P) == BigInteger.ZERO) {
      return n.divide(P);
    } else {
      return n.multiply(a).add(b);
    }
  }

  /**
   * Returns the output of a single application of the Collatz function.
   *
   * @param n (BigInteger): The value on which to perform the Collatz function.
   * @return (BigInteger): The result of the function
   */
  public static BigInteger function(BigInteger n) {
    return function(n, DEFAULT_P, DEFAULT_A, DEFAULT_B);
  }

  /**
   * Returns the output of a single application of a Collatz-esque reverse function. If
   * only one value is returned, it is the value that would be divided by P. If two values
   * are returned, the first is the value that would be divided by P, and the second value
   * is that which would undergo the multiply and add step, regardless of which is larger.
   *
   * @param n (BigInteger): The value on which to perform the reverse Collatz function.
   * @param P (BigInteger): Modulus used to devide n, iff n is equivalent to (0 mod P).
   * @param a (BigInteger): Factor by which to multiply n.
   * @param b (BigInteger): Value to add to the scaled value of n.
   * @return (BigInteger): The result of the function
   */
  public static BigInteger[] reverseFunction(BigInteger n, BigInteger P, BigInteger a, BigInteger b) {
    assertSaneParameterisation(P,a,b);
    /*(n-b)%a == 0 && (n-b)%(P*a) != 0*/
    if (n.subtract(b).remainder(a) == BigInteger.ZERO && n.subtract(b).remainder(P.multiply(a)) != BigInteger.ZERO) {
      // [P*n] + [(n-b)//a]
      BigInteger[] preVals = new BigInteger[]{P.multiply(n), n.subtract(b).divide(a)};
      return preVals;
    } else { // [P*n]
      return new BigInteger[]{P.multiply(n)};
    }
  }

  /**
   * Returns the output of a single application of the Collatz reverse function. If
   * only one value is returned, it is the value that would be divided by 2. If two values
   * are returned, the first is the value that would be divided by 2, and the second value
   * is that which would undergo the 3N+1 step, regardless of which is larger.
   *
   * @param n (BigInteger): The value on which to perform the reverse Collatz function.
   * @return (BigInteger): The result of the function
   */
  public static BigInteger[] reverseFunction(BigInteger n) {
    return reverseFunction(n, DEFAULT_P, DEFAULT_A, DEFAULT_B);
  }

  /**
   * Provides the appropriate lambda to use to check if iterations on an initial
   * value have reached either the stopping time, or total stopping time.
   *
   * @param n (BigInteger): The initial value to confirm against a stopping time check.
   * @param total_stop (boolean): If false, the lambda will confirm that iterations of n
   *     have reached the oriented stopping time to reach a value closer to 0.
   *     If true, the lambda will simply check equality to 1.
   * @return (Function<BigInteger, Boolean>): The lambda to check for the stopping time.
   */
  private static Function<BigInteger, Boolean> stoppingTimeTerminus(BigInteger n, boolean total_stop) {
    if (total_stop) {
      return (x) -> {return x.equals(BigInteger.ONE);};
    } else if (n.compareTo(BigInteger.ZERO) >= 0) {
      return (x) -> {return ((x.compareTo(n) == -1) && (x.compareTo(BigInteger.ZERO) == 1));};
    } else {
      return (x) -> {return ((x.compareTo(n) == 1) && (x.compareTo(BigInteger.ZERO) == -1));};
    }
  }

  /** Contains the results of computing a hailstone sequence via {@code Collatz.hailstoneSequence(~)}. */
  public static final class HailstoneSequence {

    /** The set of values that comprise the hailstone sequence. */
    final BigInteger[] values;

    final private Function<BigInteger, Boolean> terminate;

    /** A terminal condition that reflects the final state of the hailstone sequencing,
     *  whether than be that it succeeded at determining the stopping time, the total
     *  stopping time, found a cycle, or got stuck on zero (or surpassed the max total). */
    final SequenceState terminalCondition;

    /** A status value that has different meanings depending on what the terminal condition
     *  was. If the sequence completed either via reaching the stopping or total stopping time,
     *  or getting stuck on zero, then this value is the stopping/terminal time. If the sequence
     *  got stuck on a cycle, then this value is the cycle length. If the sequencing passes the
     *  maximum stopping time then this is the value that was provided as that maximum. */
    final int terminalStatus;

    /**
     * Initialise and compute a new Hailstone Sequence.
   *
     * @param initialValue (BigInteger): The value to begin the hailstone sequence from.
     * @param P (BigInteger): Modulus used to devide n, iff n is equivalent to (0 mod P).
     * @param a (BigInteger): Factor by which to multiply n.
     * @param b (BigInteger): Value to add to the scaled value of n.
     * @param maxTotalStoppingTime (int): Maximum amount of times to iterate the function, if 1 is not reached.
     * @param totalStoppingTime (boolean): Whether or not to execute until the "total" stopping time
     *     (number of iterations to obtain 1) rather than the regular stopping time (number
     *     of iterations to reach a value less than the initial value).
     */
    public HailstoneSequence(BigInteger initialValue, BigInteger P, BigInteger a, BigInteger b, int maxTotalStoppingTime, boolean totalStoppingTime) {
      terminate = stoppingTimeTerminus(initialValue, totalStoppingTime);
      if (initialValue.equals(BigInteger.ZERO)) {
        // 0 is always an immediate stop.
        values = new BigInteger[]{BigInteger.ZERO};
        terminalCondition = SequenceState.ZERO_STOP;
        terminalStatus = 0;
      } else if (initialValue.equals(BigInteger.ONE)) {
        // 1 is always an immediate stop, with 0 stopping time.
        values = new BigInteger[]{BigInteger.ONE};
        terminalCondition = SequenceState.TOTAL_STOPPING_TIME;
        terminalStatus = 0;
      } else {
        // Otherwise, hail!
        int minMaxTotalStoppingTime = Math.max(maxTotalStoppingTime, 1);
        ArrayList<BigInteger> preValues = new ArrayList<BigInteger>(minMaxTotalStoppingTime + 1);
        preValues.add(initialValue);
        BigInteger next;
        for (int k = 1; k <= minMaxTotalStoppingTime; k++) {
          next = function(preValues.get(k - 1), P, a, b);
          // Check if the next hailstone is either the stopping time, total
          // stopping time, the same as the initial value, or stuck at zero.
          if (terminate.apply(next)) {
            preValues.add(next);
            if (next.equals(BigInteger.ONE)) {
              terminalCondition = SequenceState.TOTAL_STOPPING_TIME;
            } else {
              terminalCondition = SequenceState.STOPPING_TIME;
            }
            terminalStatus = k;
            values = new BigInteger[preValues.size()];
            preValues.toArray(values);
            return;
          }
          if (preValues.contains(next)) {
            preValues.add(next);
            int cycle_init = 1;
            for (int j = 1; j <= k; j++) {
              if (preValues.get(k - j).equals(next)) {
                cycle_init = j;
                break;
              }
            }
            terminalCondition = SequenceState.CYCLE_LENGTH;
            terminalStatus = cycle_init;
            values = new BigInteger[preValues.size()];
            preValues.toArray(values);
            return;
          }
          if (next.equals(BigInteger.ZERO)) {
            preValues.add(BigInteger.ZERO);
            terminalCondition = SequenceState.ZERO_STOP;
            terminalStatus = -k;
            values = new BigInteger[preValues.size()];
            preValues.toArray(values);
            return;
          }
          preValues.add(next);
        }
        terminalCondition = SequenceState.MAX_STOP_OUT_OF_BOUNDS;
        terminalStatus = minMaxTotalStoppingTime;
        values = new BigInteger[preValues.size()];
        preValues.toArray(values);
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
   *
   * @param initialValue (BigInteger): The value to begin the hailstone sequence from.
   * @param P (BigInteger): Modulus used to devide n, iff n is equivalent to (0 mod P).
   * @param a (BigInteger): Factor by which to multiply n.
   * @param b (BigInteger): Value to add to the scaled value of n.
   * @param maxTotalStoppingTime (int): Maximum amount of times to iterate the function, if 1 is not reached.
   * @param totalStoppingTime (boolean): Whether or not to execute until the "total" stopping time
   *     (number of iterations to obtain 1) rather than the regular stopping time (number
   *     of iterations to reach a value less than the initial value).
   * @return (HailstoneSequence): A set of values that form the hailstone sequence.
   */
  public static HailstoneSequence hailstoneSequence(BigInteger initialValue, BigInteger P, BigInteger a, BigInteger b, int maxTotalStoppingTime, boolean totalStoppingTime) {
    // Call out the function before any magic returns to trap bad values.
        @SuppressWarnings("unused")
    final BigInteger _throwaway = function(initialValue, P, a, b);
    // Return the hailstone sequence.
    return new HailstoneSequence(initialValue, P, a, b, maxTotalStoppingTime, totalStoppingTime);
  }

  /**
   * Returns a list of successive values obtained by iterating the Collatz function,
   * until either 1 is reached, or the total amount of iterations exceeds maxTotalStoppingTime.
   *
   * @param initialValue (BigInteger): The value to begin the hailstone sequence from.
   * @param maxTotalStoppingTime (int): Maximum amount of times to iterate the function, if 1 is not reached.
   * @return (HailstoneSequence): A set of values that form the hailstone sequence.
   */
  public static HailstoneSequence hailstoneSequence(BigInteger initialValue, int maxTotalStoppingTime) {
    return hailstoneSequence(initialValue, DEFAULT_P, DEFAULT_A, DEFAULT_B, maxTotalStoppingTime, true);
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
   *
   * @param initialValue (BigInteger): The value for which to find the stopping time.
   * @param P (BigInteger): Modulus used to devide n, iff n is equivalent to (0 mod P).
   * @param a (BigInteger): Factor by which to multiply n.
   * @param b (BigInteger): Value to add to the scaled value of n.
   * @param maxStoppingTime (int): Maximum amount of times to iterate the function, if
   *     the stopping time is not reached. IF the maxStoppingTime is reached,
   *     the function will return null.
   * @param totalStoppingTime (bool): Whether or not to execute until the "total" stopping
   *     time (number of iterations to obtain 1) rather than the regular stopping
   *     time (number of iterations to reach a value less than the initial value).
   * @return (Double): The stopping time, or, in a special case, infinity, null or a negative.
   */
  public static Double stoppingTime(BigInteger initialValue, BigInteger P, BigInteger a, BigInteger b, int maxStoppingTime, boolean totalStoppingTime) {
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
      case MAX_STOP_OUT_OF_BOUNDS:
        return null;
      default:
        return null;
    }
  }

  /**
   * Returns the stopping time, the amount of iterations required to reach a
   * value less than the initial value, or null if maxStoppingTime is exceeded.
   * Alternatively, if totalStoppingTime is True, then it will instead count
   * the amount of iterations to reach 1. If the sequence does not stop, but
   * instead ends in a cycle, the result will be (Double.POSITIVE_INFINITY).
   *
   * @param initialValue (BigInteger): The value for which to find the stopping time.
   * @return (Double): The stopping time, or, in a cycle case, infinity.
   */
  public static Double stoppingTime(BigInteger initialValue) {
    return stoppingTime(initialValue, DEFAULT_P, DEFAULT_A, DEFAULT_B, 1000, false);
  }

  /**
   * Nodes that form a "tree graph", structured as a tree, with their own node's value,
   * as well as references to either possible child node, where a node can only ever have
   * two children, as there are only ever two reverse values. Also records any possible
   * "terminal sequence state", whether that be that the "orbit distance" has been reached,
   * as an "out of bounds" stop, which is the regularly expected terminal state. Other
   * terminal states possible however include the cycle state and cycle length (end) states.
   */
  public static final class TreeGraphNode {

    /** The value of this node in the tree. */
    final BigInteger nodeValue;

    /** The terminal state; null if not a terminal node, MAX_STOP_OUT_OF_BOUNDS if the maxOrbitDistance
     *  has been reached, CYCLE_LENGTH if the node's value is found to have occured previously, or
     *  CYCLE_INIT, retroactively applied when a CYCLE_LENGTH state node is found. */
    // The only variable of TreeGraphNode to not be "final" as it must be possible to update retroactively.
    SequenceState terminalSequenceState = null;

    /** The "Pre N/P" child of this node that is always
     *  present if this is not a terminal node. */
    final TreeGraphNode preNDivPNode;

    /** The "Pre aN+b" child of this node that is present
     *  if it exists and this is not a terminal node. */
    final TreeGraphNode preANplusBNode;

    /** A map of previous graph nodes which maps instances of
     *  TreeGraphNode to themselves, to enable cycle detection. */
    private final Map<BigInteger,TreeGraphNode> cycleCheck;

    /**
     * Create an instance of TreeGraphNode which will yield its entire sub-tree of all child nodes.
     *
     * @param nodeValue (BigInteger): The value for which to find the tree graph node reversal.
     * @param maxOrbitDistance (int): The maximum distance/orbit/branch length to travel.
     * @param P (BigInteger): Modulus used to devide n, iff n is equivalent to (0 mod P).
     * @param a (BigInteger): Factor by which to multiply n.
     * @param b (BigInteger): Value to add to the scaled value of n.
     */
    public TreeGraphNode(BigInteger nodeValue, int maxOrbitDistance, BigInteger P, BigInteger a, BigInteger b) {
      this.nodeValue = nodeValue;
      if (Math.max(0, maxOrbitDistance) == 0) {
        this.terminalSequenceState = SequenceState.MAX_STOP_OUT_OF_BOUNDS;
        this.preNDivPNode = null;
        this.preANplusBNode = null;
        this.cycleCheck = null;
      } else {
        BigInteger[] reverses = reverseFunction(nodeValue, P, a, b);
        cycleCheck = new HashMap<BigInteger,TreeGraphNode>();
        this.cycleCheck.put(this.nodeValue, this);
        this.preNDivPNode = new TreeGraphNode(reverses[0], maxOrbitDistance - 1, P, a, b, this.cycleCheck);
        if (reverses.length == 2) {
          this.preANplusBNode = new TreeGraphNode(reverses[1], maxOrbitDistance - 1, P, a, b, this.cycleCheck);
        } else {
          this.preANplusBNode = null;
        }
      }

    }

    /**
     * Create an instance of TreeGraphNode which will yield its entire sub-tree of all child nodes.
     * This is used internally by itself and the public constructor to pass the cycle checking map,
     * recursively determining subsequent child nodes.
     *
     * @param nodeValue (BigInteger): The value for which to find the tree graph node reversal.
     * @param maxOrbitDistance (int): The maximum distance/orbit/branch length to travel.
     * @param P (BigInteger): Modulus used to devide n, iff n is equivalent to (0 mod P).
     * @param a (BigInteger): Factor by which to multiply n.
     * @param b (BigInteger): Value to add to the scaled value of n.
     * @param cycleCheck (Map<TreeGraphNode,TreeGraphNode>): Checks if this node's value already occurred.
     */
    private TreeGraphNode(BigInteger nodeValue, int maxOrbitDistance, BigInteger P, BigInteger a, BigInteger b, Map<BigInteger,TreeGraphNode> cycleCheck) {
      this.nodeValue = nodeValue;
      this.cycleCheck = cycleCheck;
      if (this.cycleCheck.keySet().contains(this.nodeValue)) {
        this.cycleCheck.get(this.nodeValue).terminalSequenceState = SequenceState.CYCLE_INIT;
        this.terminalSequenceState = SequenceState.CYCLE_LENGTH;
        this.preNDivPNode = null;
        this.preANplusBNode = null;
      } else if (Math.max(0, maxOrbitDistance) == 0) {
        this.terminalSequenceState = SequenceState.MAX_STOP_OUT_OF_BOUNDS;
        this.preNDivPNode = null;
        this.preANplusBNode = null;
      } else {
        this.cycleCheck.put(this.nodeValue, this);
        this.terminalSequenceState = null;
        BigInteger[] reverses = reverseFunction(nodeValue, P, a, b);
        this.preNDivPNode = new TreeGraphNode(reverses[0], maxOrbitDistance - 1, P, a, b, this.cycleCheck);
        if (reverses.length == 2) {
          this.preANplusBNode = new TreeGraphNode(reverses[1], maxOrbitDistance - 1, P, a, b, this.cycleCheck);
        } else {
          this.preANplusBNode = null;
        }
      }
    }

    /**
     * Create an instance of TreeGraphNode by directly passing it the values required to instantiate,
     * intended to be used in testing by manually creating trees in reverse, by passing expected child
     * nodes to their parents until the entire expected tree is created.
     *
     * @param nodeValue (BigInteger): The value expected of this node.
     * @param terminalSequenceState (SequenceState): The expected sequence state;
     *     null, MAX_STOP_OUT_OF_BOUNDS, CYCLE_INIT or CYCLE_LENGTH.
     * @param preNDivPNode (TreeGraphNode): The expected "Pre N/P" child node.
     * @param preANplusBNode (TreeGraphNode): The expected "Pre aN+b" child node.
     */
    public TreeGraphNode(BigInteger nodeValue, SequenceState terminalSequenceState, TreeGraphNode preNDivPNode, TreeGraphNode preANplusBNode) {
      this.nodeValue = nodeValue;
      this.terminalSequenceState = terminalSequenceState;
      this.preNDivPNode = preNDivPNode;
      this.preANplusBNode = preANplusBNode;
      this.cycleCheck = null;
    }

    /** The equality between TreeGraphNodes is determined exclusively by the
     *  node's value, independent of the child nodes or sequence states that
     *  would be relevant to the node's status relative to the tree. */
        @Override
    public boolean equals(Object obj) {
      if (obj == null) {
        return false;
      }
      if (obj.getClass() != this.getClass()) {
        return false;
      }
      final TreeGraphNode tgn = (TreeGraphNode) obj;
      return this.nodeValue.equals(tgn.nodeValue);
    }

    /** The hashCode of a TreeGraphNode is determined by the
     *  node's value, the child nodes and sequence state. */
        @Override
    public int hashCode() {
      int hash = this.nodeValue.hashCode();
      hash = 17 * hash + (this.terminalSequenceState != null ? this.terminalSequenceState.hashCode() : 0);
      hash = 17 * hash + (this.preNDivPNode != null ? this.preNDivPNode.hashCode() : 0);
      hash = 17 * hash + (this.preANplusBNode != null ? this.preANplusBNode.hashCode() : 0);
      return hash;
    }

    /**
     * A much stricter equality check than the {@code equals(Object obj)} override.
     * This will only confirm an equality if the whole subtree of both nodes, including
     * node values, sequence states, and child nodes, checked recursively, are equal.
     *
     * @param tgn (TreeGraphNode): The TreeGraphNode with which to compare equality.
     * @return {@code true}, if the entire sub-trees are equal.
     */
    public boolean subTreeEquals(TreeGraphNode tgn) {
      if (!this.nodeValue.equals(tgn.nodeValue) || this.terminalSequenceState != tgn.terminalSequenceState) {
        return false;
      }
      if (this.preNDivPNode == null && tgn.preNDivPNode != null) {
        return false;
      }
      if (this.preNDivPNode != null && !this.preNDivPNode.subTreeEquals(tgn.preNDivPNode)) {
        return false;
      }
      if (this.preANplusBNode == null && tgn.preANplusBNode != null) {
        return false;
      }
      if (this.preANplusBNode != null && !this.preANplusBNode.subTreeEquals(tgn.preANplusBNode)) {
        return false;
      }
      return true;
    }
  }

  /** Contains the results of computing the Tree Graph via {@code Collatz.treeGraph(~)}.
   *  Contains the root node of a tree of {@code TreeGraphNode}'s.*/
  public static final class TreeGraph {

    /** The root node of the tree of {@code TreeGraphNode}'s. */
    final TreeGraphNode root;

    /**
     * Create a new TreeGraph with the root node defined by the inputs.
     *
     * @param nodeValue (BigInteger): The value for which to find the tree graph node reversal.
     * @param maxOrbitDistance (int): The maximum distance/orbit/branch length to travel.
     * @param P (BigInteger): Modulus used to devide n, iff n is equivalent to (0 mod P).
     * @param a (BigInteger): Factor by which to multiply n.
     * @param b (BigInteger): Value to add to the scaled value of n.
     */
    public TreeGraph(BigInteger nodeValue, int maxOrbitDistance, BigInteger P, BigInteger a, BigInteger b) {
      this.root = new TreeGraphNode(nodeValue, maxOrbitDistance, P, a, b);
    }

    /**
     * Create a new TreeGraph by directly passing it the root node.
     * Intended to be used in testing by manually creating trees.
     *
     * @param root (TreeGraphNode): The root node of the tree.
     */
    public TreeGraph(TreeGraphNode root) {
      this.root = root;
    }

    /** The hashCode of a TreeGraph is determined
     *  by the hash of the root node. */
        @Override
    public int hashCode() {
      return 29 * this.root.hashCode();
    }

    /** The equality between {@code TreeGraph}'s is determined by the equality check on subtrees. 
     *  A subtree check will be done on both {@code TreeGraph}'s root nodes. */
        @Override
    public boolean equals(Object obj) {
      // Generic checks
      if (obj == null) {
        return false;
      }
      if (obj.getClass() != this.getClass()) {
        return false;
      }
      // Check immediate fields
      final TreeGraph tg = (TreeGraph) obj;
      return this.root.subTreeEquals(tg.root);
    }
  }

  /**
   * Returns a directed tree graph of the reverse function values up to a maximum
   * nesting of maxOrbitDistance, with the initialValue as the root.
   *
   * @param initialValue (BigInteger): The root value of the directed tree graph.
   * @param maxOrbitDistance (int): Maximum amount of times to iterate the reverse
   *     function. There is no natural termination to populating the tree
   *     graph, equivalent to the termination of hailstone sequences or
   *     stopping time attempts, so this is not an optional argument like
   *     maxStoppingTime / maxTotalStoppingTime, as it is the intended target
   *     of orbits to obtain, rather than a limit to avoid uncapped computation.
   * @param P (BigInteger): Modulus used to devide n, iff n is equivalent to (0 mod P).
   * @param a (BigInteger): Factor by which to multiply n.
   * @param b (BigInteger): Value to add to the scaled value of n.
   */
  public static TreeGraph treeGraph(BigInteger initialValue, int maxOrbitDistance, BigInteger P, BigInteger a, BigInteger b) {
    return new TreeGraph(initialValue, maxOrbitDistance, P, a, b);
  }

  /**
   * Returns a directed tree graph of the reverse function values up to a maximum
   * nesting of maxOrbitDistance, with the initialValue as the root.
   *
   * @param initialValue (BigInteger): The root value of the directed tree graph.
   * @param maxOrbitDistance (int): Maximum amount of times to iterate the reverse
   *     function. There is no natural termination to populating the tree
   *     graph, equivalent to the termination of hailstone sequences or
   *     stopping time attempts, so this is not an optional argument like
   *     maxStoppingTime / maxTotalStoppingTime, as it is the intended target
   *     of orbits to obtain, rather than a limit to avoid uncapped computation.
   */
  public static TreeGraph treeGraph(BigInteger initialValue, int maxOrbitDistance) {
    return treeGraph(initialValue, maxOrbitDistance, DEFAULT_P, DEFAULT_A, DEFAULT_B);
  }
}
