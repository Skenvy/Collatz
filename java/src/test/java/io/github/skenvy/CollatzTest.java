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

import io.github.skenvy.Collatz.HailstoneSequence;

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
        assertTrue(exception.getMessage().contains(Collatz._ErrMsg.SANE_PARAMS_P.getLabel()));
        exception = assertThrows(Collatz.FailedSaneParameterCheck.class, () -> {wrapFunction(1, 0, 0, 3);});
        assertTrue(exception.getMessage().contains(Collatz._ErrMsg.SANE_PARAMS_P.getLabel()));
        exception = assertThrows(Collatz.FailedSaneParameterCheck.class, () -> {wrapFunction(1, 1, 0, 3);});
        assertTrue(exception.getMessage().contains(Collatz._ErrMsg.SANE_PARAMS_A.getLabel()));
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
        assertArrayEquals(new long[]{1, 8}, wrapReverseFunction(4));
        assertArrayEquals(wrapReverseFunction(2), new long[]{4});
        // Default (P,a,b); -1 cycle; negatives
        assertArrayEquals(new long[]{-2}, wrapReverseFunction(-1));
        assertArrayEquals(new long[]{-4, -1}, wrapReverseFunction(-2));
        // Test a wider modulo sweep by upping P to 5, a to 2, and b to 3.
        assertArrayEquals(new long[]{-1, 5}, wrapReverseFunction(1, 5, 2, 3));
        assertArrayEquals(new long[]{10}, wrapReverseFunction(2, 5, 2, 3));
        assertArrayEquals(new long[]{15}, wrapReverseFunction(3, 5, 2, 3)); // also tests !0
        assertArrayEquals(new long[]{20}, wrapReverseFunction(4, 5, 2, 3));
        assertArrayEquals(new long[]{1, 25}, wrapReverseFunction(5, 5, 2, 3));
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
        assertTrue(exception.getMessage().contains(Collatz._ErrMsg.SANE_PARAMS_P.getLabel()));
        exception = assertThrows(Collatz.FailedSaneParameterCheck.class, () -> {wrapReverseFunction(1, 0, 0, 3);});
        assertTrue(exception.getMessage().contains(Collatz._ErrMsg.SANE_PARAMS_P.getLabel()));
        exception = assertThrows(Collatz.FailedSaneParameterCheck.class, () -> {wrapReverseFunction(1, 1, 0, 3);});
        assertTrue(exception.getMessage().contains(Collatz._ErrMsg.SANE_PARAMS_A.getLabel()));
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

    private static void assertHailstoneSequence(HailstoneSequence hail, long[] expectedSequence, Collatz._CC terminalCondition, long terminalStatus){
        assertArrayEquals(expectedSequence, wrapBigIntArr(hail.values));
        assertEquals(terminalCondition, hail.terminalCondition);
        assertEquals(terminalStatus, hail.terminalStatus);
    }

    @Test
    public void testHailstoneSequence(){
        HailstoneSequence hail;
        // Test 0's immediated termination.
        hail = wrapHailstoneSequence(0);
        assertHailstoneSequence(hail, new long[]{0}, Collatz._CC.ZERO_STOP, 0);
        // The cycle containing 1 wont yield a cycle termination, as 1 is considered
        // the "total stop" that is the special case termination.
        hail = wrapHailstoneSequence(1);
        assertHailstoneSequence(hail, new long[]{1}, Collatz._CC.TOTAL_STOPPING_TIME, 0);
        // Test the 3 known default parameter's cycles (ignoring [1,4,2])
        for(BigInteger[] kc : Collatz._KNOWN_CYCLES){
            if(!Arrays.asList(kc).contains(BigInteger.ONE)){
                hail = Collatz.hailstoneSequence(kc[0]);
                BigInteger[] expected = new BigInteger[kc.length+1];
                for(int k = 0; k < kc.length; k++){
                    expected[k] = kc[k];
                }
                expected[kc.length] = kc[0];
                assertHailstoneSequence(hail, wrapBigIntArr(expected), Collatz._CC.CYCLE_LENGTH, kc.length);
            }
        }
        // Test the lead into a cycle by entering two of the cycles; -5
        BigInteger[] seq = Collatz._KNOWN_CYCLES[2].clone();
        ArrayList<BigInteger> _seq = new ArrayList<BigInteger>();
        _seq.add(seq[1].multiply(BigInteger.valueOf(4)));
        _seq.add(seq[1].multiply(BigInteger.valueOf(2)));
        List<BigInteger> _rotInnerSeq = Arrays.asList(seq);
        Collections.rotate(_rotInnerSeq, -1);
        _seq.addAll(_rotInnerSeq);
        _seq.add(seq[0]); // The rotate also acts on seq, so we add [0] instead of [1]
        long[] expected = wrapBigIntArr(_seq.toArray(BigInteger[]::new));
        hail = wrapHailstoneSequence(-56);
        assertHailstoneSequence(hail, expected, Collatz._CC.CYCLE_LENGTH, seq.length);
        // Test the lead into a cycle by entering two of the cycles; -17
        seq = Collatz._KNOWN_CYCLES[3].clone();
        _seq = new ArrayList<BigInteger>();
        _seq.add(seq[1].multiply(BigInteger.valueOf(4)));
        _seq.add(seq[1].multiply(BigInteger.valueOf(2)));
        _rotInnerSeq = Arrays.asList(seq);
        Collections.rotate(_rotInnerSeq, -1);
        _seq.addAll(_rotInnerSeq);
        _seq.add(seq[0]); // The rotate also acts on seq, so we add [0] instead of [1]
        expected = wrapBigIntArr(_seq.toArray(BigInteger[]::new));
        hail = wrapHailstoneSequence(-200);
        assertHailstoneSequence(hail, expected, Collatz._CC.CYCLE_LENGTH, seq.length);
        // 1's cycle wont yield a description of it being a "cycle" as far as the
        // hailstones are concerned, which is to be expected, so..
        hail = wrapHailstoneSequence(4);
        assertHailstoneSequence(hail, new long[]{4, 2, 1}, Collatz._CC.TOTAL_STOPPING_TIME, 2);
        hail = wrapHailstoneSequence(16);
        assertHailstoneSequence(hail, new long[]{16, 8, 4, 2, 1}, Collatz._CC.TOTAL_STOPPING_TIME, 4);
        // Test the regular stopping time check.
        hail = wrapHailstoneSequence(4, 1000, false);
        assertHailstoneSequence(hail, new long[]{4, 2}, Collatz._CC.STOPPING_TIME, 1);
        hail = wrapHailstoneSequence(5, 1000, false);
        assertHailstoneSequence(hail, new long[]{5, 16, 8, 4}, Collatz._CC.STOPPING_TIME, 3);
        // Test small max_total_stopping_time: (minimum internal value is one)
        hail = wrapHailstoneSequence(4, -100, true);
        assertHailstoneSequence(hail, new long[]{4, 2}, Collatz._CC.MAX_STOP_OOB, 1);
        // Test the zero stop mid hailing. This wont happen with default params tho.
        hail = wrapHailstoneSequence(3, 2, 3, -9, 100, true);
        assertHailstoneSequence(hail, new long[]{3, 0}, Collatz._CC.ZERO_STOP, -1);
        // Lastly, while the function wont let you use a P value of 0, 1 and -1 are
        // still allowed, although they will generate immediate 1 or 2 length cycles
        // respectively, so confirm the behaviour of each of these hailstones.
        hail = wrapHailstoneSequence(3, 1, 3, 1, 100, true);
        assertHailstoneSequence(hail, new long[]{3, 3}, Collatz._CC.CYCLE_LENGTH, 1);
        hail = wrapHailstoneSequence(3, -1, 3, 1, 100, true);
        assertHailstoneSequence(hail, new long[]{3, -3, 3}, Collatz._CC.CYCLE_LENGTH, 2);
        // Set P and a to 0 to assert on __assert_sane_parameterisation
        Exception exception;
        exception = assertThrows(Collatz.FailedSaneParameterCheck.class, () -> {wrapHailstoneSequence(1, 0, 2, 3, 1, true);});
        assertTrue(exception.getMessage().contains(Collatz._ErrMsg.SANE_PARAMS_P.getLabel()));
        exception = assertThrows(Collatz.FailedSaneParameterCheck.class, () -> {wrapHailstoneSequence(1, 0, 0, 3, 1, true);});
        assertTrue(exception.getMessage().contains(Collatz._ErrMsg.SANE_PARAMS_P.getLabel()));
        exception = assertThrows(Collatz.FailedSaneParameterCheck.class, () -> {wrapHailstoneSequence(1, 1, 0, 3, 1, true);});
        assertTrue(exception.getMessage().contains(Collatz._ErrMsg.SANE_PARAMS_A.getLabel()));
    }
}
