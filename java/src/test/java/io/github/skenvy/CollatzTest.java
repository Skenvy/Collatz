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
        assertEquals(wrapFunction(0), 0);
        // Default/Any (P,a,b); 1 cycle; positives
        assertEquals(wrapFunction(1), 4);
        assertEquals(wrapFunction(4), 2);
        assertEquals(wrapFunction(2), 1);
        // Default/Any (P,a,b); -1 cycle; negatives
        assertEquals(wrapFunction(-1), -2);
        assertEquals(wrapFunction(-2), -1);
        // Test a wider modulo sweep by upping P to 5, a to 2, and b to 3.
        assertEquals(wrapFunction(1, 5, 2, 3), 5);
        assertEquals(wrapFunction(2, 5, 2, 3), 7);
        assertEquals(wrapFunction(3, 5, 2, 3), 9);
        assertEquals(wrapFunction(4, 5, 2, 3), 11);
        assertEquals(wrapFunction(5, 5, 2, 3), 1);
        // Test negative P, a and b. Modulo, used in the function, has ambiguous functionality
        // rather than the more definite euclidean, but we only use it's (0 mod P)
        // conjugacy class to determine functionality, so the flooring for negative P
        // doesn't cause any issue.
        assertEquals(wrapFunction(1, -3, -2, -5), -7);
        assertEquals(wrapFunction(2, -3, -2, -5), -9);
        assertEquals(wrapFunction(3, -3, -2, -5), -1);
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
        assertArrayEquals(wrapReverseFunction(0), new long[]{0});
        // Default (P,a,b); 1 cycle; positives
        assertArrayEquals(wrapReverseFunction(1), new long[]{2});
        assertArrayEquals(wrapReverseFunction(4), new long[]{1, 8});
        assertArrayEquals(wrapReverseFunction(2), new long[]{4});
        // Default (P,a,b); -1 cycle; negatives
        assertArrayEquals(wrapReverseFunction(-1), new long[]{-2});
        assertArrayEquals(wrapReverseFunction(-2), new long[]{-4, -1});
        // Test a wider modulo sweep by upping P to 5, a to 2, and b to 3.
        assertArrayEquals(wrapReverseFunction(1, 5, 2, 3), new long[]{-1, 5});
        assertArrayEquals(wrapReverseFunction(2, 5, 2, 3), new long[]{10});
        assertArrayEquals(wrapReverseFunction(3, 5, 2, 3), new long[]{15}); // also tests !0
        assertArrayEquals(wrapReverseFunction(4, 5, 2, 3), new long[]{20});
        assertArrayEquals(wrapReverseFunction(5, 5, 2, 3), new long[]{1, 25});
        // Test negative P, a and b. %, used in the function, is "floor" in python
        // rather than the more reasonable euclidean, but we only use it's (0 mod P)
        // conjugacy class to determine functionality, so the flooring for negative P
        // doesn't cause any issue.
        assertArrayEquals(wrapReverseFunction(1, -3, -2, -5), new long[]{-3}); // != [-3, -3]
        assertArrayEquals(wrapReverseFunction(2, -3, -2, -5), new long[]{-6});
        assertArrayEquals(wrapReverseFunction(3, -3, -2, -5), new long[]{-9, -4});
        // Set P and a to 0 to assert on __assert_sane_parameterisation
        Exception exception;
        exception = assertThrows(Collatz.FailedSaneParameterCheck.class, () -> {wrapReverseFunction(1, 0, 2, 3);});
        assertTrue(exception.getMessage().contains(Collatz._ErrMsg.SANE_PARAMS_P.getLabel()));
        exception = assertThrows(Collatz.FailedSaneParameterCheck.class, () -> {wrapReverseFunction(1, 0, 0, 3);});
        assertTrue(exception.getMessage().contains(Collatz._ErrMsg.SANE_PARAMS_P.getLabel()));
        exception = assertThrows(Collatz.FailedSaneParameterCheck.class, () -> {wrapReverseFunction(1, 1, 0, 3);});
        assertTrue(exception.getMessage().contains(Collatz._ErrMsg.SANE_PARAMS_A.getLabel()));
        // If b is a multiple of a, but not of Pa, then 0 can have a reverse.
        assertArrayEquals(wrapReverseFunction(0, 17, 2, -6), new long[]{0, 3});
        assertArrayEquals(wrapReverseFunction(0, 17, 2, 102), new long[]{0});
    }

    private static HailstoneSequence wrapHailstoneSequence(long n){
        return Collatz.hailstoneSequence(BigInteger.valueOf(n));
    }

    private static HailstoneSequence wrapHailstoneSequence(long n, long P, long a, long b, int maxTotalStoppingTime, boolean totalStoppingTime){
        return Collatz.hailstoneSequence(BigInteger.valueOf(n), BigInteger.valueOf(P), BigInteger.valueOf(a), BigInteger.valueOf(b), maxTotalStoppingTime, totalStoppingTime);
    }

    @Test
    public void testHailstoneSequence(){
        HailstoneSequence hail;
        // Test 0's immediated termination.
        hail = wrapHailstoneSequence(0);
        assertArrayEquals(wrapBigIntArr(hail.values), new long[]{0});
        assertEquals(hail.terminalCondition, Collatz._CC.ZERO_STOP);
        assertEquals(hail.terminalStatus, 0);
        // The cycle containing 1 wont yield a cycle termination, as 1 is considered
        // the "total stop" that is the special case termination.
        hail = wrapHailstoneSequence(1);
        assertArrayEquals(wrapBigIntArr(hail.values), new long[]{1});
        assertEquals(hail.terminalCondition, Collatz._CC.TOTAL_STOPPING_TIME);
        assertEquals(hail.terminalStatus, 0);
        // Test the 3 known default parameter's cycles (ignoring [1,4,2])
        for(BigInteger[] kc : Collatz._KNOWN_CYCLES){
            if(!Arrays.asList(kc).contains(BigInteger.ONE)){
                hail = Collatz.hailstoneSequence(kc[0]);
                assertEquals(hail.terminalCondition, Collatz._CC.CYCLE_LENGTH);
                assertEquals(hail.terminalStatus, kc.length);
                BigInteger[] expected = new BigInteger[kc.length+1];
                for(int k = 0; k < kc.length; k++){
                    expected[k] = kc[k];
                }
                expected[kc.length] = kc[0];
                assertArrayEquals(hail.values, expected);
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
        assertArrayEquals(wrapBigIntArr(hail.values), expected);
        assertEquals(hail.terminalCondition, Collatz._CC.CYCLE_LENGTH);
        assertEquals(hail.terminalStatus, seq.length);
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
        assertArrayEquals(wrapBigIntArr(hail.values), expected);
        assertEquals(hail.terminalCondition, Collatz._CC.CYCLE_LENGTH);
        assertEquals(hail.terminalStatus, seq.length);
        // TODO: Finish converting the python test cases to this.
        // # 1's cycle wont yield a description of it being a "cycle" as far as the
        // # hailstones are concerned, which is to be expected, so..
        // assert collatz.hailstone_sequence(4, verbose=False) == [4, 2, 1]
        // assert collatz.hailstone_sequence(4) == [4, 2, 1, [_CC.TOTAL_STOPPING_TIME.value, 2]]
        // assert collatz.hailstone_sequence(16, verbose=False) == [16, 8, 4, 2, 1]
        // assert collatz.hailstone_sequence(16) == [16, 8, 4, 2, 1, [_CC.TOTAL_STOPPING_TIME.value, 4]]
        // # Test the regular stopping time check.
        // assert collatz.hailstone_sequence(4, total_stopping_time=False) == [4, 2, [_CC.STOPPING_TIME.value, 1]]
        // assert collatz.hailstone_sequence(5, total_stopping_time=False) == [5, 16, 8, 4, [_CC.STOPPING_TIME.value, 3]]
        // # Test small max_total_stopping_time: (minimum internal value is one)
        // assert collatz.hailstone_sequence(4, max_total_stopping_time=-100) == [4, 2, [_CC.MAX_STOP_OOB.value, 1]]
        // # Test the zero stop mid hailing. This wont happen with default params tho.
        // assert collatz.hailstone_sequence(3, P=2, a=3, b=-9) == [3, 0, [_CC.ZERO_STOP.value, -1]]
        // # Lastly, while the function wont let you use a P value of 0, 1 and -1 are
        // # still allowed, although they will generate immediate 1 or 2 length cycles
        // # respectively, so confirm the behaviour of each of these hailstones.
        // assert collatz.hailstone_sequence(3, P=1, verbose=False) == [3, 3]
        // assert collatz.hailstone_sequence(3, P=-1, verbose=False) == [3, -3, 3]
        // # Set P and a to 0 to assert on __assert_sane_parameterisation
        // with pytest.raises(AssertionError, match=_REGEX_ERR_P_IS_ZERO):
        //     collatz.hailstone_sequence(1, P=0, a=2, b=3)
        // with pytest.raises(AssertionError, match=_REGEX_ERR_P_IS_ZERO):
        //     collatz.hailstone_sequence(1, P=0, a=0, b=3)
        // with pytest.raises(AssertionError, match=_REGEX_ERR_A_IS_ZERO):
        //     collatz.hailstone_sequence(1, P=1, a=0, b=3)
    }
}
