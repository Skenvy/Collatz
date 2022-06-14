package io.github.skenvy;

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

    @Test
    public void testReverseFunction(){
        // # Default (P,a,b); 0 trap [as b is not a multiple of a]
        // assert collatz.reverse_function(0) == [0]
        // # Default (P,a,b); 1 cycle; positives
        // assert collatz.reverse_function(1) == [2]
        // assert collatz.reverse_function(4) == [1, 8]
        // assert collatz.reverse_function(2) == [4]
        // # Default (P,a,b); -1 cycle; negatives
        // assert collatz.reverse_function(-1) == [-2]
        // assert collatz.reverse_function(-2) == [-4, -1]
        // # Test a wider modulo sweep by upping P to 5, a to 2, and b to 3.
        // assert collatz.reverse_function(1, P=5, a=2, b=3) == [-1, 5]
        // assert collatz.reverse_function(2, P=5, a=2, b=3) == [10]
        // assert collatz.reverse_function(3, P=5, a=2, b=3) == [15]  # also tests !0
        // assert collatz.reverse_function(4, P=5, a=2, b=3) == [20]
        // assert collatz.reverse_function(5, P=5, a=2, b=3) == [1, 25]
        // # Test negative P, a and b. %, used in the function, is "floor" in python
        // # rather than the more reasonable euclidean, but we only use it's (0 mod P)
        // # conjugacy class to determine functionality, so the flooring for negative P
        // # doesn't cause any issue.
        // assert collatz.reverse_function(1, P=-3, a=-2, b=-5) == [-3]  # != [-3, -3]
        // assert collatz.reverse_function(2, P=-3, a=-2, b=-5) == [-6]
        // assert collatz.reverse_function(3, P=-3, a=-2, b=-5) == [-9, -4]
        // # Set P and a to 0 to assert on __assert_sane_parameterisation
        // with pytest.raises(AssertionError, match=_REGEX_ERR_P_IS_ZERO):
        //     collatz.reverse_function(1, P=0, a=2, b=3)
        // with pytest.raises(AssertionError, match=_REGEX_ERR_P_IS_ZERO):
        //     collatz.reverse_function(1, P=0, a=0, b=3)
        // with pytest.raises(AssertionError, match=_REGEX_ERR_A_IS_ZERO):
        //     collatz.reverse_function(1, P=1, a=0, b=3)
        // # If b is a multiple of a, but not of Pa, then 0 can have a reverse.
        // assert collatz.reverse_function(0, P=17, a=2, b=-6) == [0, 3]
        // assert collatz.reverse_function(0, P=17, a=2, b=102) == [0]
    }
}
