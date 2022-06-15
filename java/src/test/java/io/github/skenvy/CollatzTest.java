package io.github.skenvy;

import static org.junit.Assert.assertArrayEquals;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertThrows;
import static org.junit.Assert.assertTrue;

import java.math.BigInteger;

import org.junit.Test;

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

    private static long[] wrapReverseFunctionInner(BigInteger[] revs){
        long[] wraps = new long[revs.length];
        for(int k = 0; k < wraps.length; k++){
            wraps[k] = revs[k].longValue();
        }
        return wraps;
    }

    private static long[] wrapReverseFunction(long n){
        BigInteger[] revs = Collatz.reverseFunction(BigInteger.valueOf(n));
        return wrapReverseFunctionInner(revs);
    }

    private static long[] wrapReverseFunction(long n, long P, long a, long b){
        BigInteger[] revs = Collatz.reverseFunction(BigInteger.valueOf(n), BigInteger.valueOf(P), BigInteger.valueOf(a), BigInteger.valueOf(b));
        return wrapReverseFunctionInner(revs);
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
}
