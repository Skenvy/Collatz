package io.github.skenvy;

import static org.junit.Assert.assertArrayEquals;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertThrows;
import static org.junit.Assert.assertTrue;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

import org.junit.Test;

import io.github.skenvy.Collatz.SequenceState;
import io.github.skenvy.Collatz.HailstoneSequence;
import io.github.skenvy.Collatz.TreeGraph;
import io.github.skenvy.Collatz.TreeGraphNode;

public class CollatzTest
{

  private static long wrapFunction(long n) {
    return Collatz.function(BigInteger.valueOf(n)).longValue();
  }

  private static long wrapFunction(long n, long P, long a, long b) {
    return Collatz.function(BigInteger.valueOf(n), BigInteger.valueOf(P), BigInteger.valueOf(a), BigInteger.valueOf(b)).longValue();
  }

    @Test
  public void testFunction_ZeroTrap() {
    // Default/Any (P,a,b); 0 trap
    assertEquals(0, wrapFunction(0));
  }

    @Test
  public void testFunction_OneCycle() {
    // Default/Any (P,a,b); 1 cycle; positives
    assertEquals(4, wrapFunction(1));
    assertEquals(2, wrapFunction(4));
    assertEquals(1, wrapFunction(2));
  }

    @Test
  public void testFunction_NegativeOneCycle() {
    // Default/Any (P,a,b); -1 cycle; negatives
    assertEquals(-2, wrapFunction(-1));
    assertEquals(-1, wrapFunction(-2));
  }

    @Test
  public void testFunction_WiderModuloSweep() {
    // Test a wider modulo sweep by upping P to 5, a to 2, and b to 3.
    assertEquals(5, wrapFunction(1, 5, 2, 3));
    assertEquals(7, wrapFunction(2, 5, 2, 3));
    assertEquals(9, wrapFunction(3, 5, 2, 3));
    assertEquals(11, wrapFunction(4, 5, 2, 3));
    assertEquals(1, wrapFunction(5, 5, 2, 3));
  }

    @Test
  public void testFunction_NegativeParamterisation() {
    // Test negative P, a and b. Modulo, used in the function, has ambiguous functionality
    // rather than the more definite euclidean, but we only use it's (0 mod P)
    // conjugacy class to determine functionality, so the flooring for negative P
    // doesn't cause any issue.
    assertEquals(-7, wrapFunction(1, -3, -2, -5));
    assertEquals(-9, wrapFunction(2, -3, -2, -5));
    assertEquals(-1, wrapFunction(3, -3, -2, -5));
  }

    @Test
  public void testFunction_AssertSaneParameterisation() {
    // Set P and a to 0 to assert on assertSaneParameterisation
    Exception exception;
    exception = assertThrows(Collatz.FailedSaneParameterCheck.class, () -> {wrapFunction(1, 0, 2, 3);});
    assertTrue(exception.getMessage().contains(Collatz.SaneParameterErrMsg.SANE_PARAMS_P.getErrorMessage()));
    exception = assertThrows(Collatz.FailedSaneParameterCheck.class, () -> {wrapFunction(1, 0, 0, 3);});
    assertTrue(exception.getMessage().contains(Collatz.SaneParameterErrMsg.SANE_PARAMS_P.getErrorMessage()));
    exception = assertThrows(Collatz.FailedSaneParameterCheck.class, () -> {wrapFunction(1, 1, 0, 3);});
    assertTrue(exception.getMessage().contains(Collatz.SaneParameterErrMsg.SANE_PARAMS_A.getErrorMessage()));
  }

  private static long[] wrapBigIntArr(BigInteger[] revs) {
    long[] wraps = new long[revs.length];
    for (int k = 0; k < wraps.length; k++) {
      wraps[k] = revs[k].longValue();
    }
    return wraps;
  }

  private static long[] wrapReverseFunction(long n) {
    BigInteger[] revs = Collatz.reverseFunction(BigInteger.valueOf(n));
    return wrapBigIntArr(revs);
  }

  private static long[] wrapReverseFunction(long n, long P, long a, long b) {
    BigInteger[] revs = Collatz.reverseFunction(BigInteger.valueOf(n), BigInteger.valueOf(P), BigInteger.valueOf(a), BigInteger.valueOf(b));
    return wrapBigIntArr(revs);
  }

    @Test
  public void testReverseFunction_ZeroTrap() {
    // Default (P,a,b); 0 trap [as b is not a multiple of a]
    assertArrayEquals(new long[]{0}, wrapReverseFunction(0));
  }

    @Test
  public void testReverseFunction_OneCycle() {
    // Default (P,a,b); 1 cycle; positives
    assertArrayEquals(new long[]{2}, wrapReverseFunction(1));
    assertArrayEquals(new long[]{8, 1}, wrapReverseFunction(4));
    assertArrayEquals(wrapReverseFunction(2), new long[]{4});
  }

    @Test
  public void testReverseFunction__NegativeOneCycle() {
    // Default (P,a,b); -1 cycle; negatives
    assertArrayEquals(new long[]{-2}, wrapReverseFunction(-1));
    assertArrayEquals(new long[]{-4, -1}, wrapReverseFunction(-2));
  }

    @Test
  public void testReverseFunction_WiderModuloSweep() {
    // Test a wider modulo sweep by upping P to 5, a to 2, and b to 3.
    assertArrayEquals(new long[]{5, -1}, wrapReverseFunction(1, 5, 2, 3));
    assertArrayEquals(new long[]{10}, wrapReverseFunction(2, 5, 2, 3));
    assertArrayEquals(new long[]{15}, wrapReverseFunction(3, 5, 2, 3)); // also tests !0
    assertArrayEquals(new long[]{20}, wrapReverseFunction(4, 5, 2, 3));
    assertArrayEquals(new long[]{25, 1}, wrapReverseFunction(5, 5, 2, 3));
  }

    @Test
  public void testReverseFunction_NegativeParamterisation() {
    // Test negative P, a and b. %, used in the function, is "floor" in python
    // rather than the more reasonable euclidean, but we only use it's (0 mod P)
    // conjugacy class to determine functionality, so the flooring for negative P
    // doesn't cause any issue.
    assertArrayEquals(new long[]{-3}, wrapReverseFunction(1, -3, -2, -5)); // != [-3, -3]
    assertArrayEquals(new long[]{-6}, wrapReverseFunction(2, -3, -2, -5));
    assertArrayEquals(new long[]{-9, -4}, wrapReverseFunction(3, -3, -2, -5));
  }

    @Test
  public void testReverseFunction_ZeroReversesOnB() {
    // If b is a multiple of a, but not of Pa, then 0 can have a reverse.
    assertArrayEquals(new long[]{0, 3}, wrapReverseFunction(0, 17, 2, -6));
    assertArrayEquals(new long[]{0}, wrapReverseFunction(0, 17, 2, 102));
  }

    @Test
  public void testReverseFunction_AssertSaneParameterisation() {
    // Set P and a to 0 to assert on __assert_sane_parameterisation
    Exception exception;
    exception = assertThrows(Collatz.FailedSaneParameterCheck.class, () -> {wrapReverseFunction(1, 0, 2, 3);});
    assertTrue(exception.getMessage().contains(Collatz.SaneParameterErrMsg.SANE_PARAMS_P.getErrorMessage()));
    exception = assertThrows(Collatz.FailedSaneParameterCheck.class, () -> {wrapReverseFunction(1, 0, 0, 3);});
    assertTrue(exception.getMessage().contains(Collatz.SaneParameterErrMsg.SANE_PARAMS_P.getErrorMessage()));
    exception = assertThrows(Collatz.FailedSaneParameterCheck.class, () -> {wrapReverseFunction(1, 1, 0, 3);});
    assertTrue(exception.getMessage().contains(Collatz.SaneParameterErrMsg.SANE_PARAMS_A.getErrorMessage()));
  }

  private static HailstoneSequence wrapHailstoneSequence(long n) {
    return Collatz.hailstoneSequence(BigInteger.valueOf(n), 1000);
  }

  private static HailstoneSequence wrapHailstoneSequence(long n, int maxTotalStoppingTime, boolean totalStoppingTime) {
    return wrapHailstoneSequence(n, Collatz.DEFAULT_P.longValue(), Collatz.DEFAULT_A.longValue(), Collatz.DEFAULT_B.longValue(), maxTotalStoppingTime, totalStoppingTime);
  }

  private static HailstoneSequence wrapHailstoneSequence(long n, long P, long a, long b, int maxTotalStoppingTime, boolean totalStoppingTime) {
    return Collatz.hailstoneSequence(BigInteger.valueOf(n), BigInteger.valueOf(P), BigInteger.valueOf(a), BigInteger.valueOf(b), maxTotalStoppingTime, totalStoppingTime);
  }

  private static void assertHailstoneSequence(HailstoneSequence hail, long[] expectedSequence, Collatz.SequenceState terminalCondition, long terminalStatus) {
    assertArrayEquals(expectedSequence, wrapBigIntArr(hail.values));
    assertEquals(terminalCondition, hail.terminalCondition);
    assertEquals(terminalStatus, hail.terminalStatus);
  }

    @Test
  public void testHailstoneSequence_ZeroTrap() {
    // Test 0's immediated termination.
    HailstoneSequence hail = wrapHailstoneSequence(0);
    assertHailstoneSequence(hail, new long[]{0}, Collatz.SequenceState.ZERO_STOP, 0);
  }

    @Test
  public void testHailstoneSequence_OnesCycleOnlyYieldsATotalStop() {
    HailstoneSequence hail;
    // The cycle containing 1 wont yield a cycle termination, as 1 is considered
    // the "total stop" that is the special case termination.
    hail = wrapHailstoneSequence(1);
    assertHailstoneSequence(hail, new long[]{1}, Collatz.SequenceState.TOTAL_STOPPING_TIME, 0);
    // 1's cycle wont yield a description of it being a "cycle" as far as the
    // hailstones are concerned, which is to be expected, so..
    hail = wrapHailstoneSequence(4);
    assertHailstoneSequence(hail, new long[]{4, 2, 1}, Collatz.SequenceState.TOTAL_STOPPING_TIME, 2);
    hail = wrapHailstoneSequence(16);
    assertHailstoneSequence(hail, new long[]{16, 8, 4, 2, 1}, Collatz.SequenceState.TOTAL_STOPPING_TIME, 4);
  }

    @Test
  public void testHailstoneSequence_KnownCycles() {
    HailstoneSequence hail;
    // Test the 3 known default parameter's cycles (ignoring [1,4,2])
    for (BigInteger[] kc : Collatz.KNOWN_CYCLES) {
      if (!Arrays.asList(kc).contains(BigInteger.ONE)) {
        hail = Collatz.hailstoneSequence(kc[0], 1000);
        BigInteger[] expected = new BigInteger[kc.length+1];
        for (int k = 0; k < kc.length; k++) {
          expected[k] = kc[k];
        }
        expected[kc.length] = kc[0];
        assertHailstoneSequence(hail, wrapBigIntArr(expected), Collatz.SequenceState.CYCLE_LENGTH, kc.length);
      }
    }
  }

    @Test
  public void testHailstoneSequence_Minus56() {
    // Test the lead into a cycle by entering two of the cycles; -5
    BigInteger[] seq = Collatz.KNOWN_CYCLES[2].clone();
    ArrayList<BigInteger> _seq = new ArrayList<BigInteger>();
    _seq.add(seq[1].multiply(BigInteger.valueOf(4)));
    _seq.add(seq[1].multiply(BigInteger.valueOf(2)));
    List<BigInteger> _rotInnerSeq = Arrays.asList(seq);
    Collections.rotate(_rotInnerSeq, -1);
    _seq.addAll(_rotInnerSeq);
    _seq.add(seq[0]); // The rotate also acts on seq, so we add [0] instead of [1]
    long[] expected = wrapBigIntArr(_seq.toArray(BigInteger[]::new));
    HailstoneSequence hail = wrapHailstoneSequence(-56);
    assertHailstoneSequence(hail, expected, Collatz.SequenceState.CYCLE_LENGTH, seq.length);
  }

    @Test
  public void testHailstoneSequence_Minus200() {
    // Test the lead into a cycle by entering two of the cycles; -17
    BigInteger[] seq = Collatz.KNOWN_CYCLES[3].clone();
    ArrayList<BigInteger> _seq = new ArrayList<BigInteger>();
    _seq.add(seq[1].multiply(BigInteger.valueOf(4)));
    _seq.add(seq[1].multiply(BigInteger.valueOf(2)));
    List<BigInteger> _rotInnerSeq = Arrays.asList(seq);
    Collections.rotate(_rotInnerSeq, -1);
    _seq.addAll(_rotInnerSeq);
    _seq.add(seq[0]); // The rotate also acts on seq, so we add [0] instead of [1]
    long[] expected = wrapBigIntArr(_seq.toArray(BigInteger[]::new));
    HailstoneSequence hail = wrapHailstoneSequence(-200);
    assertHailstoneSequence(hail, expected, Collatz.SequenceState.CYCLE_LENGTH, seq.length);
  }

    @Test
  public void testHailstoneSequence_RegularStoppingTime() {
    HailstoneSequence hail;
    // Test the regular stopping time check.
    hail = wrapHailstoneSequence(4, 1000, false);
    assertHailstoneSequence(hail, new long[]{4, 2}, Collatz.SequenceState.STOPPING_TIME, 1);
    hail = wrapHailstoneSequence(5, 1000, false);
    assertHailstoneSequence(hail, new long[]{5, 16, 8, 4}, Collatz.SequenceState.STOPPING_TIME, 3);
  }

    @Test
  public void testHailstoneSequence_NegativeMaxTotalStoppingTime() {
    // Test small max total stopping time: (minimum internal value is one)
    HailstoneSequence hail = wrapHailstoneSequence(4, -100, true);
    assertHailstoneSequence(hail, new long[]{4, 2}, Collatz.SequenceState.MAX_STOP_OUT_OF_BOUNDS, 1);
  }

    @Test
  public void testHailstoneSequence_ZeroStopMidHail() {
    // Test the zero stop mid hailing. This wont happen with default params tho.
    HailstoneSequence hail = wrapHailstoneSequence(3, 2, 3, -9, 100, true);
    assertHailstoneSequence(hail, new long[]{3, 0}, Collatz.SequenceState.ZERO_STOP, -1);
  }

    @Test
  public void testHailstoneSequence_UnitaryPCausesAlmostImmediateCycles() {
    HailstoneSequence hail;
    // Lastly, while the function wont let you use a P value of 0, 1 and -1 are
    // still allowed, although they will generate immediate 1 or 2 length cycles
    // respectively, so confirm the behaviour of each of these hailstones.
    hail = wrapHailstoneSequence(3, 1, 3, 1, 100, true);
    assertHailstoneSequence(hail, new long[]{3, 3}, Collatz.SequenceState.CYCLE_LENGTH, 1);
    hail = wrapHailstoneSequence(3, -1, 3, 1, 100, true);
    assertHailstoneSequence(hail, new long[]{3, -3, 3}, Collatz.SequenceState.CYCLE_LENGTH, 2);
  }

    @Test
  public void testHailstoneSequence_AssertSaneParameterisation() {
    // Set P and a to 0 to assert on __assert_sane_parameterisation
    Exception exception;
    exception = assertThrows(Collatz.FailedSaneParameterCheck.class, () -> {wrapHailstoneSequence(1, 0, 2, 3, 1000, true);});
    assertTrue(exception.getMessage().contains(Collatz.SaneParameterErrMsg.SANE_PARAMS_P.getErrorMessage()));
    exception = assertThrows(Collatz.FailedSaneParameterCheck.class, () -> {wrapHailstoneSequence(1, 0, 0, 3, 1000, true);});
    assertTrue(exception.getMessage().contains(Collatz.SaneParameterErrMsg.SANE_PARAMS_P.getErrorMessage()));
    exception = assertThrows(Collatz.FailedSaneParameterCheck.class, () -> {wrapHailstoneSequence(1, 1, 0, 3, 1000, true);});
    assertTrue(exception.getMessage().contains(Collatz.SaneParameterErrMsg.SANE_PARAMS_A.getErrorMessage()));
  }

  private static Double wrapStoppingTime(long n) {
    return Collatz.stoppingTime(BigInteger.valueOf(n));
  }

  private static Double wrapStoppingTime(long n, int maxStoppingTime, boolean totalStoppingTime) {
    return wrapStoppingTime(n, Collatz.DEFAULT_P.longValue(), Collatz.DEFAULT_A.longValue(), Collatz.DEFAULT_B.longValue(), maxStoppingTime, totalStoppingTime);
  }

  private static Double wrapStoppingTime(long n, long P, long a, long b, int maxStoppingTime, boolean totalStoppingTime) {
    return Collatz.stoppingTime(BigInteger.valueOf(n), BigInteger.valueOf(P), BigInteger.valueOf(a), BigInteger.valueOf(b), maxStoppingTime, totalStoppingTime);
  }

    @Test
  public void testStoppingTime_ZeroTrap() {
    // Test 0's immediated termination.
    assertEquals(Double.valueOf(0), wrapStoppingTime(0));
  }

    @Test
  public void testStoppingTime_OnesCycleOnlyYieldsATotalStop() {
    // The cycle containing 1 wont yield a cycle termination, as 1 is considered
    // the "total stop" that is the special case termination.
    assertEquals(Double.valueOf(0), wrapStoppingTime(1));
    // 1's cycle wont yield a description of it being a "cycle" as far as the
    // hailstones are concerned, which is to be expected, so..
    assertEquals(Double.valueOf(2), wrapStoppingTime(4, 100, true));
    assertEquals(Double.valueOf(4), wrapStoppingTime(16, 100, true));
  }

    @Test
  public void testStoppingTime_KnownCyclesYieldInfinity() {
    // Test the 3 known default parameter's cycles (ignoring [1,4,2])
    for (BigInteger[] kc : Collatz.KNOWN_CYCLES) {
      if (!Arrays.asList(kc).contains(BigInteger.ONE)) {
        for (BigInteger c : kc) {
          assertEquals(Double.valueOf(Double.POSITIVE_INFINITY), wrapStoppingTime(c.longValue(), 100, true));
        }
      }
    }
  }

    @Test
  public void testStoppingTime_KnownCycleLeadIns() {
    // Test the lead into a cycle by entering two of the cycles. -56;-5, -200;-17
    assertEquals(Double.valueOf(Double.POSITIVE_INFINITY), wrapStoppingTime(-56, 100, true));
    assertEquals(Double.valueOf(Double.POSITIVE_INFINITY), wrapStoppingTime(-200, 100, true));
  }

    @Test
  public void testStoppingTime_RegularStoppingTime() {
    // Test the regular stopping time check.
    assertEquals(Double.valueOf(1), wrapStoppingTime(4));
    assertEquals(Double.valueOf(3), wrapStoppingTime(5));
  }

    @Test
  public void testStoppingTime_NegativeMaxTotalStoppingTime() {
    // Test small max total stopping time: (minimum internal value is one)
    assertEquals(null, wrapStoppingTime(5, -100, true));
  }

    @Test
  public void testStoppingTime_ZeroStopMidHail() {
    // Test the zero stop mid hailing. This wont happen with default params tho.
    assertEquals(Double.valueOf(-1), wrapStoppingTime(3, 2, 3, -9, 100, false));
  }

    @Test
  public void testStoppingTime_UnitaryPCausesAlmostImmediateCycles() {
    // Lastly, while the function wont let you use a P value of 0, 1 and -1 are
    // still allowed, although they will generate immediate 1 or 2 length cycles
    // respectively, so confirm the behaviour of each of these stopping times.
    assertEquals(Double.valueOf(Double.POSITIVE_INFINITY), wrapStoppingTime(3, 1, 3, 1, 100, false));
    assertEquals(Double.valueOf(Double.POSITIVE_INFINITY), wrapStoppingTime(3, -1, 3, 1, 100, false));
  }

    @Test
  public void testStoppingTime_MultiplesOf576460752303423488Plus27() {
    // One last one for the fun of it..
    assertEquals(Double.valueOf(111), wrapStoppingTime(27, 1000, true));
    // # And for a bit more fun, common trajectories on
    for (int k = 0; k < 5; k++) {
      BigInteger input = BigInteger.valueOf(27).add(BigInteger.valueOf(k).multiply(new BigInteger("576460752303423488")));
      Double stop = Collatz.stoppingTime(input, Collatz.DEFAULT_P, Collatz.DEFAULT_A, Collatz.DEFAULT_B, 1000, false);
      assertEquals(Double.valueOf(96), stop);
    }
  }

    @Test
  public void testStoppingTime_AssertSaneParameterisation() {
    // Set P and a to 0 to assert on __assert_sane_parameterisation
    Exception exception;
    exception = assertThrows(Collatz.FailedSaneParameterCheck.class, () -> {wrapStoppingTime(1, 0, 2, 3, 1000, false);});
    assertTrue(exception.getMessage().contains(Collatz.SaneParameterErrMsg.SANE_PARAMS_P.getErrorMessage()));
    exception = assertThrows(Collatz.FailedSaneParameterCheck.class, () -> {wrapStoppingTime(1, 0, 0, 3, 1000, false);});
    assertTrue(exception.getMessage().contains(Collatz.SaneParameterErrMsg.SANE_PARAMS_P.getErrorMessage()));
    exception = assertThrows(Collatz.FailedSaneParameterCheck.class, () -> {wrapStoppingTime(1, 1, 0, 3, 1000, false);});
    assertTrue(exception.getMessage().contains(Collatz.SaneParameterErrMsg.SANE_PARAMS_A.getErrorMessage()));
  }

  private static TreeGraph wrapTreeGraph(long nodeValue, int maxOrbitDistance, long P, long a, long b) {
    return Collatz.treeGraph(BigInteger.valueOf(nodeValue), maxOrbitDistance, BigInteger.valueOf(P), BigInteger.valueOf(a), BigInteger.valueOf(b));
  }

  private static TreeGraph wrapTreeGraph(long nodeValue, int maxOrbitDistance) {
    return Collatz.treeGraph(BigInteger.valueOf(nodeValue), maxOrbitDistance);
  }

  /**
   * Create a "terminal" graph node with null children and the terminal
   * condition that indicates it has reached the maximum orbit of the tree.
   * @param n
   * @return
   */
  private static TreeGraphNode wrapTGN_TerminalNode(long n) {
    return new TreeGraphNode(BigInteger.valueOf(n), SequenceState.MAX_STOP_OUT_OF_BOUNDS, null, null);
  }

  /**
   * Create a "cyclic terminal" graph node with null children and the "cycle termination" condition.
   * @param n
   * @return
   */
  private static TreeGraphNode wrapTGN_CyclicTerminal(long n) {
    return new TreeGraphNode(BigInteger.valueOf(n), SequenceState.CYCLE_LENGTH, null, null);
  }

  /**
   * Create a "cyclic start" graph node with given children and the "cycle start" condition.
   * @param n
   * @param preNDivPNode
   * @param preANplusBNode
   * @return
   */
  private static TreeGraphNode wrapTGN_CyclicStart(long n, TreeGraphNode preNDivPNode, TreeGraphNode preANplusBNode) {
    return new TreeGraphNode(BigInteger.valueOf(n), SequenceState.CYCLE_INIT, preNDivPNode, preANplusBNode);
  }

  /**
   * Create a graph node with no terminal state, with given children.
   * @param n
   * @param preNDivPNode
   * @param preANplusBNode
   * @return
   */
  private static TreeGraphNode wrapTGN_Generic(long n, TreeGraphNode preNDivPNode, TreeGraphNode preANplusBNode) {
    return new TreeGraphNode(BigInteger.valueOf(n), null, preNDivPNode, preANplusBNode);
  }

    @Test
  public void testTreeGraph_ZeroTrap() {
    // ":D" for terminal, "C:" for cyclic end
    TreeGraphNode expectedRoot;
    // The default zero trap
    // {0:D}
    expectedRoot = wrapTGN_TerminalNode(0);
    assertEquals(new TreeGraph(expectedRoot), wrapTreeGraph(0, 0));
    // {0:{C:0}}
    expectedRoot = wrapTGN_CyclicStart(0, wrapTGN_CyclicTerminal(0), null);
    assertEquals(new TreeGraph(expectedRoot), wrapTreeGraph(0, 1));
    assertEquals(new TreeGraph(expectedRoot), wrapTreeGraph(0, 2));
  }

    @Test
  public void testTreeGraph_RootOfOneYieldsTheOneCycle() {
    // ":D" for terminal, "C:" for cyclic end
    TreeGraphNode expectedRoot;
    // The roundings of the 1 cycle.
    // {1:D}
    expectedRoot = wrapTGN_TerminalNode(1);
    assertEquals(new TreeGraph(expectedRoot), wrapTreeGraph(1, 0));
    // {1:{2:D}}
    expectedRoot = wrapTGN_Generic(1, wrapTGN_TerminalNode(2), null);
    assertEquals(new TreeGraph(expectedRoot), wrapTreeGraph(1, 1));
    // {1:{2:{4:D}}}
    expectedRoot = wrapTGN_Generic(1, wrapTGN_Generic(2, wrapTGN_TerminalNode(4), null), null);
    assertEquals(new TreeGraph(expectedRoot), wrapTreeGraph(1, 2));
    // {1:{2:{4:{C:1,8:D}}}}
    expectedRoot = wrapTGN_CyclicStart(1, wrapTGN_Generic(2, wrapTGN_Generic(4, wrapTGN_TerminalNode(8), wrapTGN_CyclicTerminal(1)), null), null);
    assertEquals(new TreeGraph(expectedRoot), wrapTreeGraph(1, 3));
  }

    @Test
  public void testTreeGraph_RootOfTwoAndFourYieldTheOneCycle() {
    // ":D" for terminal, "C:" for cyclic end
    TreeGraphNode expectedRoot;
    // {2:{4:{1:{C:2},8:{16:D}}}}
    expectedRoot = wrapTGN_CyclicStart(2, wrapTGN_Generic(4, wrapTGN_Generic(8, wrapTGN_TerminalNode(16), null),
                                                                 wrapTGN_Generic(1, wrapTGN_CyclicTerminal(2), null)), null);
    assertEquals(new TreeGraph(expectedRoot), wrapTreeGraph(2, 3));
    // {4:{1:{2:{C:4}},8:{16:{5:D,32:D}}}}
    expectedRoot = wrapTGN_CyclicStart(4, wrapTGN_Generic(8, wrapTGN_Generic(16, wrapTGN_TerminalNode(32), wrapTGN_TerminalNode(5)), null),
                                              wrapTGN_Generic(1, wrapTGN_Generic(2, wrapTGN_CyclicTerminal(4), null), null));
    assertEquals(new TreeGraph(expectedRoot), wrapTreeGraph(4, 3));
  }

    @Test
  public void testTreeGraph_RootOfMinusOneYieldsTheMinusOneCycle() {
    // ":D" for terminal, "C:" for cyclic end
    TreeGraphNode expectedRoot;
    // The roundings of the -1 cycle
    // {-1:{-2:D}}
    expectedRoot = wrapTGN_Generic(-1, wrapTGN_TerminalNode(-2), null);
    assertEquals(new TreeGraph(expectedRoot), wrapTreeGraph(-1, 1));
    // {-1:{-2:{-4:D,C:-1}}}
    expectedRoot = wrapTGN_CyclicStart(-1, wrapTGN_Generic(-2, wrapTGN_TerminalNode(-4), wrapTGN_CyclicTerminal(-1)), null);
    assertEquals(new TreeGraph(expectedRoot), wrapTreeGraph(-1, 2));
  }

    @Test
  public void testTreeGraph_WiderModuloSweep() {
    // ":D" for terminal, "C:" for cyclic end
    TreeGraphNode expectedRoot;
    // Test a wider modulo sweep by upping P to 5, a to 2, and b to 3.
    // Orbit distance of 1 ~= {1:{-1:D,5:D}}
    expectedRoot = wrapTGN_Generic(1, wrapTGN_TerminalNode(5), wrapTGN_TerminalNode(-1));
    assertEquals(new TreeGraph(expectedRoot), wrapTreeGraph(1, 1, 5, 2, 3));
    // Orbit distance of 2 ~= {1:{-1:{-5:D,-2:D},5:{C:1,25:D}}}
    expectedRoot = wrapTGN_CyclicStart(1, wrapTGN_Generic(5, wrapTGN_TerminalNode(25), wrapTGN_CyclicTerminal(1)),
                                              wrapTGN_Generic(-1, wrapTGN_TerminalNode(-5), wrapTGN_TerminalNode(-2)));
    assertEquals(new TreeGraph(expectedRoot), wrapTreeGraph(1, 2, 5, 2, 3));
    // Orbit distance of 3 ~=  {1:{-1:{-5:{-25:D,-4:D},-2:{-10:D}},5:{C:1,25:{11:D,125:D}}}}
    expectedRoot = wrapTGN_CyclicStart(1, wrapTGN_Generic(5, wrapTGN_Generic(25, wrapTGN_TerminalNode(125), wrapTGN_TerminalNode(11)), wrapTGN_CyclicTerminal(1)),
                                              wrapTGN_Generic(-1, wrapTGN_Generic(-5, wrapTGN_TerminalNode(-25), wrapTGN_TerminalNode(-4)), wrapTGN_Generic(-2, wrapTGN_TerminalNode(-10), null)));
    assertEquals(new TreeGraph(expectedRoot), wrapTreeGraph(1, 3, 5, 2, 3));
  }

    @Test
  public void testTreeGraph_NegativeParamterisation() {
    // ":D" for terminal, "C:" for cyclic end
    TreeGraphNode expectedRoot;
    // Test negative P, a and b ~ P=-3, a=-2, b=-5
    // Orbit distance of 1 ~= {1:{-3:D}}
    expectedRoot = wrapTGN_Generic(1, wrapTGN_TerminalNode(-3), null);
    assertEquals(new TreeGraph(expectedRoot), wrapTreeGraph(1, 1, -3, -2, -5));
    // Orbit distance of 2 ~= {1:{-3:{-1:D,9:D}}}
    expectedRoot = wrapTGN_Generic(1, wrapTGN_Generic(-3, wrapTGN_TerminalNode(9), wrapTGN_TerminalNode(-1)), null);
    assertEquals(new TreeGraph(expectedRoot), wrapTreeGraph(1, 2, -3, -2, -5));
    // Orbit distance of 3 ~= {1:{-3:{-1:{-2:D,3:D},9:{-27:D,-7:D}}}}
    expectedRoot = wrapTGN_Generic(1, wrapTGN_Generic(-3, wrapTGN_Generic(9, wrapTGN_TerminalNode(-27), wrapTGN_TerminalNode(-7)),
                                                              wrapTGN_Generic(-1, wrapTGN_TerminalNode(3), wrapTGN_TerminalNode(-2))), null);
    assertEquals(new TreeGraph(expectedRoot), wrapTreeGraph(1, 3, -3, -2, -5));
  }

    @Test
  public void testTreeGraph_ZeroReversesOnB() {
    // ":D" for terminal, "C:" for cyclic end
    TreeGraphNode expectedRoot;
    // If b is a multiple of a, but not of Pa, then 0 can have a reverse.
    // {0:{C:0,3:D}}
    expectedRoot = wrapTGN_CyclicStart(0, wrapTGN_CyclicTerminal(0), wrapTGN_TerminalNode(3));
    assertEquals(new TreeGraph(expectedRoot), wrapTreeGraph(0, 1, 17, 2, -6));
    // {0:{C:0}}
    expectedRoot = wrapTGN_CyclicStart(0, wrapTGN_CyclicTerminal(0), null);
    assertEquals(new TreeGraph(expectedRoot), wrapTreeGraph(0, 1, 17, 2, 102));
  }

    @Test
  public void testTreeGraph_AssertSaneParameterisation() {
    // Set P and a to 0 to assert on __assert_sane_parameterisation
    Exception exception;
    exception = assertThrows(Collatz.FailedSaneParameterCheck.class, () -> {wrapTreeGraph(1, 1, 0, 2, 3);});
    assertTrue(exception.getMessage().contains(Collatz.SaneParameterErrMsg.SANE_PARAMS_P.getErrorMessage()));
    exception = assertThrows(Collatz.FailedSaneParameterCheck.class, () -> {wrapTreeGraph(1, 1, 0, 0, 3);});
    assertTrue(exception.getMessage().contains(Collatz.SaneParameterErrMsg.SANE_PARAMS_P.getErrorMessage()));
    exception = assertThrows(Collatz.FailedSaneParameterCheck.class, () -> {wrapTreeGraph(1, 1, 1, 0, 3);});
    assertTrue(exception.getMessage().contains(Collatz.SaneParameterErrMsg.SANE_PARAMS_A.getErrorMessage()));
  }
}
