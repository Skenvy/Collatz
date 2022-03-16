import pytest
from src import collatz



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
    regex_err_P_is_zero = f"^{collatz._ErrMsg.SANE_PARAMS_P.value}$"
    regex_err_A_is_zero = f"^{collatz._ErrMsg.SANE_PARAMS_A.value}$"
    with pytest.raises(AssertionError, match=regex_err_P_is_zero):
        collatz.function(1, P=0, a=2, b=3)
    with pytest.raises(AssertionError, match=regex_err_P_is_zero):
        collatz.function(1, P=0, a=0, b=3)
    with pytest.raises(AssertionError, match=regex_err_A_is_zero):
        collatz.function(1, P=1, a=0, b=3)

# Test reverse_function(n:int, P:int=2, a:int=3, b:int=1):
def test_reverse_function():
    pass


# Test __initial_value_outside_verified_range(x:int)
def test___initial_value_outside_verified_range():
    pass


# Test __stopping_time_terminus(n:int, total_stop:bool)
def test___stopping_time_terminus():
    pass


# Test def hailstone_sequence(initial_value:int, P:int=2, a:int=3, b:int=1, max_total_stopping_time:int=1000, total_stopping_time:bool=True, verbose:bool=True)
def test_hailstone_sequence():
    pass


# Test def stopping_time(initial_value:int, P:int=2, a:int=3, b:int=1, max_stopping_time:int=1000, total_stopping_time:bool=False)
def test_stopping_time():
    pass


# Test def tree_graph(initial_value:int, max_orbit_distance:int, P:int=2, a:int=3, b:int=1, __cycle_prevention:Optional[Set[int]]=None)
def test_tree_graph():
    pass
