import pytest
from src import collatz
from src.collatz import _CC, _ErrMsg, _KNOWN_CYCLES


_REGEX_ERR_P_IS_ZERO = f"^{_ErrMsg.SANE_PARAMS_P.value}$"
_REGEX_ERR_A_IS_ZERO = f"^{_ErrMsg.SANE_PARAMS_A.value}$"


# Test def function(n:int, P:int=2, a:int=3, b:int=1)
def test_function():
    # Default/Any (P,a,b); 0 trap
    assert collatz.function(0) == 0
    # Default/Any (P,a,b); 1 cycle; positives
    assert collatz.function(1) == 4
    assert collatz.function(4) == 2
    assert collatz.function(2) == 1
    # Default/Any (P,a,b); -1 cycle; negatives
    assert collatz.function(-1) == -2
    assert collatz.function(-2) == -1
    # Test a wider modulo sweep by upping P to 5, a to 2, and b to 3.
    assert collatz.function(1, P=5, a=2, b=3) == 5
    assert collatz.function(2, P=5, a=2, b=3) == 7
    assert collatz.function(3, P=5, a=2, b=3) == 9
    assert collatz.function(4, P=5, a=2, b=3) == 11
    assert collatz.function(5, P=5, a=2, b=3) == 1
    # Test negative P, a and b. %, used in the function, is "floor" in python
    # rather than the more reasonable euclidean, but we only use it's (0 mod P)
    # conjugacy class to determine functionality, so the flooring for negative P
    # doesn't cause any issue.
    assert collatz.function(1, P=-3, a=-2, b=-5) == -7
    assert collatz.function(2, P=-3, a=-2, b=-5) == -9
    assert collatz.function(3, P=-3, a=-2, b=-5) == -1
    # Set P and a to 0 to assert on __assert_sane_parameterisation
    with pytest.raises(AssertionError, match=_REGEX_ERR_P_IS_ZERO):
        collatz.function(1, P=0, a=2, b=3)
    with pytest.raises(AssertionError, match=_REGEX_ERR_P_IS_ZERO):
        collatz.function(1, P=0, a=0, b=3)
    with pytest.raises(AssertionError, match=_REGEX_ERR_A_IS_ZERO):
        collatz.function(1, P=1, a=0, b=3)


# Test reverse_function(n:int, P:int=2, a:int=3, b:int=1):
def test_reverse_function():
    # Default/Any (P,a,b); 0 trap
    assert collatz.reverse_function(0) == [0]
    # Default/Any (P,a,b); 1 cycle; positives
    assert collatz.reverse_function(1) == [2]
    assert collatz.reverse_function(4) == [1, 8]
    assert collatz.reverse_function(2) == [4]
    # Default/Any (P,a,b); -1 cycle; negatives
    assert collatz.reverse_function(-1) == [-2]
    assert collatz.reverse_function(-2) == [-4, -1]
    # Test a wider modulo sweep by upping P to 5, a to 2, and b to 3.
    assert collatz.reverse_function(1, P=5, a=2, b=3) == [-1, 5]
    assert collatz.reverse_function(2, P=5, a=2, b=3) == [10]
    assert collatz.reverse_function(3, P=5, a=2, b=3) == [15]  # also tests !0
    assert collatz.reverse_function(4, P=5, a=2, b=3) == [20]
    assert collatz.reverse_function(5, P=5, a=2, b=3) == [1, 25]
    # Test negative P, a and b. %, used in the function, is "floor" in python
    # rather than the more reasonable euclidean, but we only use it's (0 mod P)
    # conjugacy class to determine functionality, so the flooring for negative P
    # doesn't cause any issue.
    assert collatz.reverse_function(1, P=-3, a=-2, b=-5) == [-3]  # != [-3, -3]
    assert collatz.reverse_function(2, P=-3, a=-2, b=-5) == [-6]
    assert collatz.reverse_function(3, P=-3, a=-2, b=-5) == [-9, -4]
    # Set P and a to 0 to assert on __assert_sane_parameterisation
    with pytest.raises(AssertionError, match=_REGEX_ERR_P_IS_ZERO):
        collatz.reverse_function(1, P=0, a=2, b=3)
    with pytest.raises(AssertionError, match=_REGEX_ERR_P_IS_ZERO):
        collatz.reverse_function(1, P=0, a=0, b=3)
    with pytest.raises(AssertionError, match=_REGEX_ERR_A_IS_ZERO):
        collatz.reverse_function(1, P=1, a=0, b=3)


# Test def hailstone_sequence(initial_value:int, P:int=2, 
# a:int=3, b:int=1, max_total_stopping_time:int=1000,
# total_stopping_time:bool=True, verbose:bool=True)
def test_hailstone_sequence():
    # Test 0's immediated termination.
    assert collatz.hailstone_sequence(0) == [[_CC.ZERO_STOP.value, 0]]
    assert collatz.hailstone_sequence(0, verbose=False) == [0]
    # The cycle containing 1 wont yield a cycle termination, as 1 is considered
    # the "total stop" that is the special case termination.
    assert collatz.hailstone_sequence(1) == [[_CC.TOTAL_STOPPING_TIME.value, 0]]
    assert collatz.hailstone_sequence(1, verbose=False) == [1]
    # Test the 3 known default parameter's cycles (ignoring [1,4,2])
    # If not verbose, then the result will be the cycle plus the final value
    # being the start of the cycle. If verbose, then the output will be the
    # values not in the cycle, a CC flag, then the cycle and another CC flag.
    for kc in [kc for kc in _KNOWN_CYCLES if 1 not in kc]:
        assert collatz.hailstone_sequence(kc[0], verbose=False) == kc + [kc[0]]
        assert collatz.hailstone_sequence(kc[0]) == [_CC.CYCLE_INIT.value, kc,
                                            [_CC.CYCLE_LENGTH.value, len(kc)]]
    # Test the lead into a cycle by entering two of the cycles.
    seq = [kc for kc in _KNOWN_CYCLES if -5 in kc][0]
    seq = [seq[1]*4, seq[1]*2] + seq[1:] + [seq[0]]
    assert collatz.hailstone_sequence(-56, verbose=False) == seq + [seq[2]]
    assert collatz.hailstone_sequence(-56) == seq[:2] + [_CC.CYCLE_INIT.value,
                            seq[2:], [_CC.CYCLE_LENGTH.value, len(seq[2:])]]
    seq = [kc for kc in _KNOWN_CYCLES if -17 in kc][0]
    seq = [seq[1]*4, seq[1]*2] + seq[1:] + [seq[0]]
    assert collatz.hailstone_sequence(-200, verbose=False) == seq + [seq[2]]
    assert collatz.hailstone_sequence(-200) == seq[:2] + [_CC.CYCLE_INIT.value,
                            seq[2:], [_CC.CYCLE_LENGTH.value, len(seq[2:])]]
    # 1's cycle wont yield a description of it being a "cycle" as far as the
    # hailstones are concerned, which is to be expected, so..
    assert collatz.hailstone_sequence(4, verbose=False) == [4, 2, 1]
    assert collatz.hailstone_sequence(4) == [4, 2, 1,
                            [_CC.TOTAL_STOPPING_TIME.value, 2]]
    assert collatz.hailstone_sequence(16, verbose=False) == [16, 8, 4, 2, 1]
    assert collatz.hailstone_sequence(16) == [16, 8, 4, 2, 1,
                            [_CC.TOTAL_STOPPING_TIME.value, 4]]
    # Test the regular stopping time check.
    assert collatz.hailstone_sequence(4, total_stopping_time=False) == [4, 2,
                            [_CC.STOPPING_TIME.value, 1]]
    assert collatz.hailstone_sequence(5, total_stopping_time=False) == [5, 16,
                            8, 4, [_CC.STOPPING_TIME.value, 3]]
    # Test small max_total_stopping_time: (minimum internal value is one)
    assert collatz.hailstone_sequence(4, max_total_stopping_time=-100) == [4, 2,
                            [_CC.MAX_STOP_OOB.value, 1]]
    # Test the zero stop mid hailing. This wont happen with default params tho.
    assert collatz.hailstone_sequence(3, P=2, a=3, b=-9) == [3, 0,
                            [_CC.ZERO_STOP.value, -1]]


# Test def stopping_time(initial_value:int, P:int=2, a:int=3, b:int=1,
# max_stopping_time:int=1000, total_stopping_time:bool=False)
def test_stopping_time():
    pass


# Test def tree_graph(initial_value:int, max_orbit_distance:int, P:int=2,
# a:int=3, b:int=1, __cycle_prevention:Optional[Set[int]]=None)
def test_tree_graph():
    pass
