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

import io.github.skenvy.Collatz.HailState;
import io.github.skenvy.Collatz.HailstoneSequence;
import io.github.skenvy.Collatz.TreeGraph;
import io.github.skenvy.Collatz.TreeGraphNode;

public class CollatzTest
{

    private static long wrapFunction(long n){
        return Collatz.function(BigInteger.valueOf(n)).longValue();
    }

    private static long wrapFunction(long n, long P, long a, long b){
        return Collatz.function(BigInteger.valueOf(n), BigInteger.valueOf(P), BigInteger.valueOf(a), BigInteger.valueOf(b)).longValue();
    }

    @Test
    public void testFunction(){
        // Default/Any (P,a,b); 0 trap
        assertEquals(0, wrapFunction(0));
        // Default/Any (P,a,b); 1 cycle; positives
        assertEquals(4, wrapFunction(1));
        assertEquals(2, wrapFunction(4));
        assertEquals(1, wrapFunction(2));
        // Default/Any (P,a,b); -1 cycle; negatives
        assertEquals(-2, wrapFunction(-1));
        assertEquals(-1, wrapFunction(-2));
        // Test a wider modulo sweep by upping P to 5, a to 2, and b to 3.
        assertEquals(5, wrapFunction(1, 5, 2, 3));
        assertEquals(7, wrapFunction(2, 5, 2, 3));
        assertEquals(9, wrapFunction(3, 5, 2, 3));
        assertEquals(11, wrapFunction(4, 5, 2, 3));
        assertEquals(1, wrapFunction(5, 5, 2, 3));
        // Test negative P, a and b. Modulo, used in the function, has ambiguous functionality
        // rather than the more definite euclidean, but we only use it's (0 mod P)
        // conjugacy class to determine functionality, so the flooring for negative P
        // doesn't cause any issue.
        assertEquals(-7, wrapFunction(1, -3, -2, -5));
        assertEquals(-9, wrapFunction(2, -3, -2, -5));
        assertEquals(-1, wrapFunction(3, -3, -2, -5));
        // Set P and a to 0 to assert on assertSaneParameterisation
        Exception exception;
        exception = assertThrows(Collatz.FailedSaneParameterCheck.class, () -> {wrapFunction(1, 0, 2, 3);});
        assertTrue(exception.getMessage().contains(Collatz.SaneParameterErrMsg.SANE_PARAMS_P.getLabel()));
        exception = assertThrows(Collatz.FailedSaneParameterCheck.class, () -> {wrapFunction(1, 0, 0, 3);});
        assertTrue(exception.getMessage().contains(Collatz.SaneParameterErrMsg.SANE_PARAMS_P.getLabel()));
        exception = assertThrows(Collatz.FailedSaneParameterCheck.class, () -> {wrapFunction(1, 1, 0, 3);});
        assertTrue(exception.getMessage().contains(Collatz.SaneParameterErrMsg.SANE_PARAMS_A.getLabel()));
    }

    private static long[] wrapBigIntArr(BigInteger[] revs){
        long[] wraps = new long[revs.length];
        for(int k = 0; k < wraps.length; k++){
            wraps[k] = revs[k].longValue();
        }
        return wraps;
    }

    private static long[] wrapReverseFunction(long n){
        BigInteger[] revs = Collatz.reverseFunction(BigInteger.valueOf(n));
        return wrapBigIntArr(revs);
    }

    private static long[] wrapReverseFunction(long n, long P, long a, long b){
        BigInteger[] revs = Collatz.reverseFunction(BigInteger.valueOf(n), BigInteger.valueOf(P), BigInteger.valueOf(a), BigInteger.valueOf(b));
        return wrapBigIntArr(revs);
    }

    @Test
    public void testReverseFunction(){
        // Default (P,a,b); 0 trap [as b is not a multiple of a]
        assertArrayEquals(new long[]{0}, wrapReverseFunction(0));
        // Default (P,a,b); 1 cycle; positives
        assertArrayEquals(new long[]{2}, wrapReverseFunction(1));
        assertArrayEquals(new long[]{8, 1}, wrapReverseFunction(4));
        assertArrayEquals(wrapReverseFunction(2), new long[]{4});
        // Default (P,a,b); -1 cycle; negatives
        assertArrayEquals(new long[]{-2}, wrapReverseFunction(-1));
        assertArrayEquals(new long[]{-4, -1}, wrapReverseFunction(-2));
        // Test a wider modulo sweep by upping P to 5, a to 2, and b to 3.
        assertArrayEquals(new long[]{5, -1}, wrapReverseFunction(1, 5, 2, 3));
        assertArrayEquals(new long[]{10}, wrapReverseFunction(2, 5, 2, 3));
        assertArrayEquals(new long[]{15}, wrapReverseFunction(3, 5, 2, 3)); // also tests !0
        assertArrayEquals(new long[]{20}, wrapReverseFunction(4, 5, 2, 3));
        assertArrayEquals(new long[]{25, 1}, wrapReverseFunction(5, 5, 2, 3));
        // Test negative P, a and b. %, used in the function, is "floor" in python
        // rather than the more reasonable euclidean, but we only use it's (0 mod P)
        // conjugacy class to determine functionality, so the flooring for negative P
        // doesn't cause any issue.
        assertArrayEquals(new long[]{-3}, wrapReverseFunction(1, -3, -2, -5)); // != [-3, -3]
        assertArrayEquals(new long[]{-6}, wrapReverseFunction(2, -3, -2, -5));
        assertArrayEquals(new long[]{-9, -4}, wrapReverseFunction(3, -3, -2, -5));
        // Set P and a to 0 to assert on __assert_sane_parameterisation
        Exception exception;
        exception = assertThrows(Collatz.FailedSaneParameterCheck.class, () -> {wrapReverseFunction(1, 0, 2, 3);});
        assertTrue(exception.getMessage().contains(Collatz.SaneParameterErrMsg.SANE_PARAMS_P.getLabel()));
        exception = assertThrows(Collatz.FailedSaneParameterCheck.class, () -> {wrapReverseFunction(1, 0, 0, 3);});
        assertTrue(exception.getMessage().contains(Collatz.SaneParameterErrMsg.SANE_PARAMS_P.getLabel()));
        exception = assertThrows(Collatz.FailedSaneParameterCheck.class, () -> {wrapReverseFunction(1, 1, 0, 3);});
        assertTrue(exception.getMessage().contains(Collatz.SaneParameterErrMsg.SANE_PARAMS_A.getLabel()));
        // If b is a multiple of a, but not of Pa, then 0 can have a reverse.
        assertArrayEquals(new long[]{0, 3}, wrapReverseFunction(0, 17, 2, -6));
        assertArrayEquals(new long[]{0}, wrapReverseFunction(0, 17, 2, 102));
    }

    private static HailstoneSequence wrapHailstoneSequence(long n){
        return Collatz.hailstoneSequence(BigInteger.valueOf(n));
    }

    private static HailstoneSequence wrapHailstoneSequence(long n, int maxTotalStoppingTime, boolean totalStoppingTime){
        return wrapHailstoneSequence(n, Collatz.DEFAULT_P.longValue(), Collatz.DEFAULT_A.longValue(), Collatz.DEFAULT_B.longValue(), maxTotalStoppingTime, totalStoppingTime);
    }

    private static HailstoneSequence wrapHailstoneSequence(long n, long P, long a, long b, int maxTotalStoppingTime, boolean totalStoppingTime){
        return Collatz.hailstoneSequence(BigInteger.valueOf(n), BigInteger.valueOf(P), BigInteger.valueOf(a), BigInteger.valueOf(b), maxTotalStoppingTime, totalStoppingTime);
    }

    private static void assertHailstoneSequence(HailstoneSequence hail, long[] expectedSequence, Collatz.HailState terminalCondition, long terminalStatus){
        assertArrayEquals(expectedSequence, wrapBigIntArr(hail.values));
        assertEquals(terminalCondition, hail.terminalCondition);
        assertEquals(terminalStatus, hail.terminalStatus);
    }

    @Test
    public void testHailstoneSequence(){
        HailstoneSequence hail;
        // Test 0's immediated termination.
        hail = wrapHailstoneSequence(0);
        assertHailstoneSequence(hail, new long[]{0}, Collatz.HailState.ZERO_STOP, 0);
        // The cycle containing 1 wont yield a cycle termination, as 1 is considered
        // the "total stop" that is the special case termination.
        hail = wrapHailstoneSequence(1);
        assertHailstoneSequence(hail, new long[]{1}, Collatz.HailState.TOTAL_STOPPING_TIME, 0);
        // Test the 3 known default parameter's cycles (ignoring [1,4,2])
        for(BigInteger[] kc : Collatz.KNOWN_CYCLES){
            if(!Arrays.asList(kc).contains(BigInteger.ONE)){
                hail = Collatz.hailstoneSequence(kc[0]);
                BigInteger[] expected = new BigInteger[kc.length+1];
                for(int k = 0; k < kc.length; k++){
                    expected[k] = kc[k];
                }
                expected[kc.length] = kc[0];
                assertHailstoneSequence(hail, wrapBigIntArr(expected), Collatz.HailState.CYCLE_LENGTH, kc.length);
            }
        }
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
        hail = wrapHailstoneSequence(-56);
        assertHailstoneSequence(hail, expected, Collatz.HailState.CYCLE_LENGTH, seq.length);
        // Test the lead into a cycle by entering two of the cycles; -17
        seq = Collatz.KNOWN_CYCLES[3].clone();
        _seq = new ArrayList<BigInteger>();
        _seq.add(seq[1].multiply(BigInteger.valueOf(4)));
        _seq.add(seq[1].multiply(BigInteger.valueOf(2)));
        _rotInnerSeq = Arrays.asList(seq);
        Collections.rotate(_rotInnerSeq, -1);
        _seq.addAll(_rotInnerSeq);
        _seq.add(seq[0]); // The rotate also acts on seq, so we add [0] instead of [1]
        expected = wrapBigIntArr(_seq.toArray(BigInteger[]::new));
        hail = wrapHailstoneSequence(-200);
        assertHailstoneSequence(hail, expected, Collatz.HailState.CYCLE_LENGTH, seq.length);
        // 1's cycle wont yield a description of it being a "cycle" as far as the
        // hailstones are concerned, which is to be expected, so..
        hail = wrapHailstoneSequence(4);
        assertHailstoneSequence(hail, new long[]{4, 2, 1}, Collatz.HailState.TOTAL_STOPPING_TIME, 2);
        hail = wrapHailstoneSequence(16);
        assertHailstoneSequence(hail, new long[]{16, 8, 4, 2, 1}, Collatz.HailState.TOTAL_STOPPING_TIME, 4);
        // Test the regular stopping time check.
        hail = wrapHailstoneSequence(4, 1000, false);
        assertHailstoneSequence(hail, new long[]{4, 2}, Collatz.HailState.STOPPING_TIME, 1);
        hail = wrapHailstoneSequence(5, 1000, false);
        assertHailstoneSequence(hail, new long[]{5, 16, 8, 4}, Collatz.HailState.STOPPING_TIME, 3);
        // Test small max_total_stopping_time: (minimum internal value is one)
        hail = wrapHailstoneSequence(4, -100, true);
        assertHailstoneSequence(hail, new long[]{4, 2}, Collatz.HailState.MAX_STOP_OUT_OF_BOUNDS, 1);
        // Test the zero stop mid hailing. This wont happen with default params tho.
        hail = wrapHailstoneSequence(3, 2, 3, -9, 100, true);
        assertHailstoneSequence(hail, new long[]{3, 0}, Collatz.HailState.ZERO_STOP, -1);
        // Lastly, while the function wont let you use a P value of 0, 1 and -1 are
        // still allowed, although they will generate immediate 1 or 2 length cycles
        // respectively, so confirm the behaviour of each of these hailstones.
        hail = wrapHailstoneSequence(3, 1, 3, 1, 100, true);
        assertHailstoneSequence(hail, new long[]{3, 3}, Collatz.HailState.CYCLE_LENGTH, 1);
        hail = wrapHailstoneSequence(3, -1, 3, 1, 100, true);
        assertHailstoneSequence(hail, new long[]{3, -3, 3}, Collatz.HailState.CYCLE_LENGTH, 2);
        // Set P and a to 0 to assert on __assert_sane_parameterisation
        Exception exception;
        exception = assertThrows(Collatz.FailedSaneParameterCheck.class, () -> {wrapHailstoneSequence(1, 0, 2, 3, 1000, true);});
        assertTrue(exception.getMessage().contains(Collatz.SaneParameterErrMsg.SANE_PARAMS_P.getLabel()));
        exception = assertThrows(Collatz.FailedSaneParameterCheck.class, () -> {wrapHailstoneSequence(1, 0, 0, 3, 1000, true);});
        assertTrue(exception.getMessage().contains(Collatz.SaneParameterErrMsg.SANE_PARAMS_P.getLabel()));
        exception = assertThrows(Collatz.FailedSaneParameterCheck.class, () -> {wrapHailstoneSequence(1, 1, 0, 3, 1000, true);});
        assertTrue(exception.getMessage().contains(Collatz.SaneParameterErrMsg.SANE_PARAMS_A.getLabel()));
    }

    private static Double wrapStoppingTime(long n){
        return Collatz.stoppingTime(BigInteger.valueOf(n));
    }

    private static Double wrapStoppingTime(long n, int maxStoppingTime, boolean totalStoppingTime){
        return wrapStoppingTime(n, Collatz.DEFAULT_P.longValue(), Collatz.DEFAULT_A.longValue(), Collatz.DEFAULT_B.longValue(), maxStoppingTime, totalStoppingTime);
    }

    private static Double wrapStoppingTime(long n, long P, long a, long b, int maxStoppingTime, boolean totalStoppingTime){
        return Collatz.stoppingTime(BigInteger.valueOf(n), BigInteger.valueOf(P), BigInteger.valueOf(a), BigInteger.valueOf(b), maxStoppingTime, totalStoppingTime);
    }

    @Test
    public void testStoppingTime(){
        // Test 0's immediated termination.
        assertEquals(Double.valueOf(0), wrapStoppingTime(0));
        // The cycle containing 1 wont yield a cycle termination, as 1 is considered
        // the "total stop" that is the special case termination.
        assertEquals(Double.valueOf(0), wrapStoppingTime(1));
        // Test the 3 known default parameter's cycles (ignoring [1,4,2])
        for(BigInteger[] kc : Collatz.KNOWN_CYCLES){
            if(!Arrays.asList(kc).contains(BigInteger.ONE)){
                for(BigInteger c : kc){
                    assertEquals(Double.valueOf(Double.POSITIVE_INFINITY), wrapStoppingTime(c.longValue(), 100, true));
                }
            }
        }
        // Test the lead into a cycle by entering two of the cycles. -56;-5, -200;-17
        assertEquals(Double.valueOf(Double.POSITIVE_INFINITY), wrapStoppingTime(-56, 100, true));
        assertEquals(Double.valueOf(Double.POSITIVE_INFINITY), wrapStoppingTime(-200, 100, true));
        // 1's cycle wont yield a description of it being a "cycle" as far as the
        // hailstones are concerned, which is to be expected, so..
        assertEquals(Double.valueOf(2), wrapStoppingTime(4, 100, true));
        assertEquals(Double.valueOf(4), wrapStoppingTime(16, 100, true));
        // Test the regular stopping time check.
        assertEquals(Double.valueOf(1), wrapStoppingTime(4));
        assertEquals(Double.valueOf(3), wrapStoppingTime(5));
        // Test small max_total_stopping_time: (minimum internal value is one)
        assertEquals(null, wrapStoppingTime(5, -100, true));
        // Test the zero stop mid hailing. This wont happen with default params tho.
        assertEquals(Double.valueOf(-1), wrapStoppingTime(3, 2, 3, -9, 100, false));
        // Lastly, while the function wont let you use a P value of 0, 1 and -1 are
        // still allowed, although they will generate immediate 1 or 2 length cycles
        // respectively, so confirm the behaviour of each of these stopping times.
        assertEquals(Double.valueOf(Double.POSITIVE_INFINITY), wrapStoppingTime(3, 1, 3, 1, 100, false));
        assertEquals(Double.valueOf(Double.POSITIVE_INFINITY), wrapStoppingTime(3, -1, 3, 1, 100, false));
        // One last one for the fun of it..
        assertEquals(Double.valueOf(111), wrapStoppingTime(27, 1000, true));
        // # And for a bit more fun, common trajectories on
        for(int k = 0; k < 5; k++){
            BigInteger input = BigInteger.valueOf(27).add(BigInteger.valueOf(k).multiply(new BigInteger("576460752303423488")));
            Double stop = Collatz.stoppingTime(input, Collatz.DEFAULT_P, Collatz.DEFAULT_A, Collatz.DEFAULT_B, 1000, false);
            assertEquals(Double.valueOf(96), stop);
        }
        // Set P and a to 0 to assert on __assert_sane_parameterisation
        Exception exception;
        exception = assertThrows(Collatz.FailedSaneParameterCheck.class, () -> {wrapStoppingTime(1, 0, 2, 3, 1000, false);});
        assertTrue(exception.getMessage().contains(Collatz.SaneParameterErrMsg.SANE_PARAMS_P.getLabel()));
        exception = assertThrows(Collatz.FailedSaneParameterCheck.class, () -> {wrapStoppingTime(1, 0, 0, 3, 1000, false);});
        assertTrue(exception.getMessage().contains(Collatz.SaneParameterErrMsg.SANE_PARAMS_P.getLabel()));
        exception = assertThrows(Collatz.FailedSaneParameterCheck.class, () -> {wrapStoppingTime(1, 1, 0, 3, 1000, false);});
        assertTrue(exception.getMessage().contains(Collatz.SaneParameterErrMsg.SANE_PARAMS_A.getLabel()));
    }

    private static TreeGraphNode wrapTerminalTreeGraphNode(long n){
        return new TreeGraphNode(BigInteger.valueOf(n), HailState.MAX_STOP_OUT_OF_BOUNDS, null, null, null);
    }

    private static TreeGraphNode wrapCyclicTerminalTreeGraphNode(long n){
        return new TreeGraphNode(BigInteger.valueOf(n), HailState.CYCLE_LENGTH, null, null, null);
    }

    private static TreeGraphNode wrapCyclicStartTreeGraphNode(long n, TreeGraphNode preNDivPNode, TreeGraphNode preANplusBNode){
        return new TreeGraphNode(BigInteger.valueOf(n), HailState.CYCLE_INIT, preNDivPNode, preANplusBNode, null);
    }

    private static TreeGraphNode wrapGenericTreeGraphNode(long n, TreeGraphNode preNDivPNode, TreeGraphNode preANplusBNode){
        return new TreeGraphNode(BigInteger.valueOf(n), null, preNDivPNode, preANplusBNode, null);
    }

    @Test
    public void testTreeGraph(){
        // ":D" for terminal, "C:" for cyclic end
        TreeGraph expected;
        // The default zero trap
        /*{0:D}*/ expected = new TreeGraph(wrapTerminalTreeGraphNode(0));
        assertEquals(expected, Collatz.treeGraph(BigInteger.valueOf(0), 0));
        /*{0:{C:0}}*/ expected = new TreeGraph(wrapCyclicStartTreeGraphNode(0, wrapCyclicTerminalTreeGraphNode(0), null));
        assertEquals(expected, Collatz.treeGraph(BigInteger.valueOf(0), 1));
        assertEquals(expected, Collatz.treeGraph(BigInteger.valueOf(0), 2));
        // The roundings of the 1 cycle.
        /*{1:D}*/ expected = new TreeGraph(wrapTerminalTreeGraphNode(1));
        assertEquals(expected, Collatz.treeGraph(BigInteger.valueOf(1), 0));
        /*{1:{2:D}}*/ expected = new TreeGraph(wrapGenericTreeGraphNode(1, wrapTerminalTreeGraphNode(2), null));
        assertEquals(expected, Collatz.treeGraph(BigInteger.valueOf(1), 1));
        /*{1:{2:{4:D}}}*/ expected = new TreeGraph(wrapGenericTreeGraphNode(1, wrapGenericTreeGraphNode(2, wrapTerminalTreeGraphNode(4), null), null));
        assertEquals(expected, Collatz.treeGraph(BigInteger.valueOf(1), 2));
        /*{1:{2:{4:{C:1,8:D}}}}*/ expected = new TreeGraph(wrapCyclicStartTreeGraphNode(1, wrapGenericTreeGraphNode(2, wrapGenericTreeGraphNode(4, wrapTerminalTreeGraphNode(8), wrapCyclicTerminalTreeGraphNode(1)), null), null));
        assertEquals(expected, Collatz.treeGraph(BigInteger.valueOf(1), 3));
        /*{2:{4:{1:{C:2},8:{16:D}}}}*/ expected = new TreeGraph(wrapCyclicStartTreeGraphNode(2, wrapGenericTreeGraphNode(4, wrapGenericTreeGraphNode(8, wrapTerminalTreeGraphNode(16), null), wrapGenericTreeGraphNode(1, wrapCyclicTerminalTreeGraphNode(2), null)), null));
        assertEquals(expected, Collatz.treeGraph(BigInteger.valueOf(2), 3));
        /*{4:{1:{2:{C:4}},8:{16:{5:D,32:D}}}}*/ expected = new TreeGraph(wrapCyclicStartTreeGraphNode(4, wrapGenericTreeGraphNode(8, wrapGenericTreeGraphNode(16, wrapTerminalTreeGraphNode(32), wrapTerminalTreeGraphNode(5)), null), wrapGenericTreeGraphNode(1, wrapGenericTreeGraphNode(2, wrapCyclicTerminalTreeGraphNode(4), null), null)));
        assertEquals(expected, Collatz.treeGraph(BigInteger.valueOf(4), 3));
        // # The roundings of the -1 cycle
        // assert collatz.tree_graph(-1, 1) == {-1:{-2:D}}
        // assert collatz.tree_graph(-1, 2) == {-1:{-2:{-4:D,C:-1}}}
        // # Test a wider modulo sweep by upping P to 5, a to 2, and b to 3.
        // T = lambda x,y: {1:{-1:x,5:y}}
        // orb_1 = T(D,D)
        // orb_2 = T({-5:D,-2:D},{C:1,25:D})
        // T = lambda x,y,z: {1:{-1:{-5:x,-2:y},5:{C:1,25:z}}}
        // orb_3 = T({-25:D,-4:D},{-10:D},{11:D,125:D})
        // assert collatz.tree_graph(1, 1, P=5, a=2, b=3) == orb_1
        // assert collatz.tree_graph(1, 2, P=5, a=2, b=3) == orb_2
        // assert collatz.tree_graph(1, 3, P=5, a=2, b=3) == orb_3
        // # Test negative P, a and b.
        // orb_1 = {1:{-3:D}}
        // T = lambda x,y: {1:{-3:{-1:x,9:y}}}
        // orb_2 = T(D,D)
        // orb_3 = T({-2:D,3:D},{-27:D,-7:D})
        // assert collatz.tree_graph(1, 1, P=-3, a=-2, b=-5) == orb_1
        // assert collatz.tree_graph(1, 2, P=-3, a=-2, b=-5) == orb_2
        // assert collatz.tree_graph(1, 3, P=-3, a=-2, b=-5) == orb_3
        // # Set P and a to 0 to assert on __assert_sane_parameterisation
        // with pytest.raises(AssertionError, match=_REGEX_ERR_P_IS_ZERO):
        //     collatz.tree_graph(1, 1, P=0, a=2, b=3)
        // with pytest.raises(AssertionError, match=_REGEX_ERR_P_IS_ZERO):
        //     collatz.tree_graph(1, 1, P=0, a=0, b=3)
        // with pytest.raises(AssertionError, match=_REGEX_ERR_A_IS_ZERO):
        //     collatz.tree_graph(1, 1, P=1, a=0, b=3)
        // # If b is a multiple of a, but not of Pa, then 0 can have a reverse.
        // assert collatz.tree_graph(0, 1, P=17, a=2, b=-6) == {0:{C:0,3:D}}
        // assert collatz.tree_graph(0, 1, P=17, a=2, b=102) == {0:{C:0}}
    }
}
