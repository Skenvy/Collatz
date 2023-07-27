"""
Provides the basic functionality to interact with the Collatz conjecture.
The parameterisation uses the same (P,a,b) notation as Conway's generalisations.
Besides the function and reverse function, there is also functionality to
retrieve the hailstone sequence, the "stopping time"/"total stopping time", or
tree-graph.
"""

from enum import Enum
from typing import Optional, Set
from math import inf as infinity


# The four known cycles for the standard parameterisation.
_KNOWN_CYCLES = [[1, 4, 2], [-1, -2], [-5, -14, -7, -20, -10],
                 [-17, -50, -25, -74, -37, -110, -55, -164, -82,
                  -41, -122, -61, -182, -91, -272, -136, -68, -34]]
# The current value up to which the standard parameterisation has been verified.
__VERIFIED_MAXIMUM = 295147905179352825856
# The current value down to which the standard parameterisation has been verified.
__VERIFIED_MINIMUM = -272  # TODO: Check the actual lowest bound.


class _ErrMsg(Enum):
    """
    Error message constant.
    """
    SANE_PARAMS_P = "'P' should not be 0 ~ violates modulo being non-zero."
    SANE_PARAMS_A = "'a' should not be 0 ~ violates the reversability."


class _CC(Enum):
    """
    Cycle Control: Descriptive flags to indicate when some event occurs in the
    hailstone sequences, when set to verbose, or stopping time check.
    """
    STOPPING_TIME = 'STOPPING_TIME'
    TOTAL_STOPPING_TIME = 'TOTAL_STOPPING_TIME'
    CYCLE_INIT = 'CYCLE_INIT'
    CYCLE_LENGTH = 'CYCLE_LENGTH'
    MAX_STOP_OOB = 'MAX_STOP_OOB'  # ~ "out of bounds"
    ZERO_STOP = 'ZERO_STOP'


def __assert_sane_parameterisation(P: int, a: int, _: int):
    """
    Handles the sanity check for the parameterisation (P,a,b) required by both
    the function and reverse function.

    Args:
        P (int): Modulus used to devide n, iff n is equivalent to (0 mod P).
        a (int): Factor by which to multiply n.
        b (int): Value to add to the scaled value of n.
    """
    # Sanity check (P,a,b) ~ P absolutely can't be 0. a "could" be zero
    # theoretically, although would violate the reversability (if ~a is 0 then a
    # value of "b" as the input to the reverse function would have a pre-emptive
    # value of every number not divisible by P). The function doesn't _have_ to
    # be reversable, but we are only interested in dealing with the class of
    # functions that exhibit behaviour consistant with the collatz function. If
    # _every_ input not divisable by P went straight to "b", it would simply
    # cause a cycle consisting of "b" and every b/P^z that is an integer. While
    # P in [-1, 1] could also be a reasonable check, as it makes every value
    # either a 1 or 2 length cycle, it's not strictly an illegal operation.
    # "b" being zero would cause behaviour not consistant with the collatz
    # function, but would not violate the reversability, so no check either.
    # " != 0" is redundant for python assertions.
    assert P, _ErrMsg.SANE_PARAMS_P.value
    assert a, _ErrMsg.SANE_PARAMS_A.value


def function(n: int, P: int = 2, a: int = 3, b: int = 1):
    """
    Returns the output of a single application of a Collatz-esque function.

    Args:
        n (int): The value on which to perform the Collatz-esque function

    Keyword Args:
        P (int): Modulus used to devide n, iff n is equivalent to (0 mod P).
            Default is 2.
        a (int): Factor by which to multiply n. Default is 3.
        b (int): Value to add to the scaled value of n. Default is 1.
    """
    __assert_sane_parameterisation(P, a, b)
    return n//P if n % P == 0 else (a*n+b)


def reverse_function(n: int, P: int = 2, a: int = 3, b: int = 1):
    """
    Returns the output of a single application of a Collatz-esque reverse
    function.

    Args:
        n (int): The value on which to perform the reverse Collatz function

    Keyword Args:
        P (int): Modulus used to devide n, iff n is equivalent to (0 mod P).
            Default is 2.
        a (int): Factor by which to multiply n. Default is 3.
        b (int): Value to add to the scaled value of n. Default is 1.
    """
    __assert_sane_parameterisation(P, a, b)
    # Every input can be reversed as the result of "n/P" division, which yields
    # "Pn"... {f(n) = an + b}≡{(f(n) - b)/a = n} ~ if n was such that the
    # muliplication step was taken instead of the division by the modulus, then
    # (f(n) - b)/a) must be an integer that is not in (0 mod P). Because we're
    # not placing restrictions on the parameters yet, although there is a better
    # way of shortcutting this for the default variables, we need to always
    # attempt (f(n) - b)/a)
    pre_values = [P*n]
    if (n-b) % a == 0 and (n-b) % (P*a) != 0:
        pre_values += [(n-b)//a]
        pre_values.sort()
    return pre_values


def __initial_value_outside_verified_range(x: int):
    """
    Checks if the initial value is greater than __VERIFIED_MAXIMUM or less than
    __VERIFIED_MINIMUM. Only intended for the default parameterisation.

    Args:
        x (int): The initial value to check if it is within range or not.
    """
    return (__VERIFIED_MAXIMUM < x) or (x < __VERIFIED_MINIMUM)


def __stopping_time_terminus(n: int, total_stop: bool):
    """
    Provides the appropriate lambda to use to check if iterations on an initial
    value have reached either the stopping time, or total stopping time.

    Args:
        n (int): The initial value to confirm against a stopping time check.
        total_stop (bool): If false, the lambda will confirm that iterations
            of n have reached the oriented stopping time to reach a value closer
            to 0. If true, the lambda will simply check equality to 1.
    """
    return (lambda x: x == 1) if total_stop else (
        (lambda x: x < n and x > 0) if n >= 0 else (lambda x: x > n and x < 0))


def hailstone_sequence(initial_value: int, P: int = 2, a: int = 3,
                       b: int = 1, max_total_stopping_time: int = 1000,
                       total_stopping_time: bool = True, verbose: bool = True):
    """
    Returns a list of successive values obtained by iterating a Collatz-esque
    function, until either 1 is reached, or the total amount of iterations
    exceeds max_total_stopping_time, unless total_stopping_time is False,
    which will terminate the hailstone at the "stopping time" value, i.e. the
    first value less than the initial value. While the sequence has the
    capability to determine that it has encountered a cycle, the cycle from "1"
    wont be attempted or reported as part of a cycle, regardless of default or
    custom parameterisation, as "1" is considered a "total stop".

    Args:
        initial_value (int): The value to begin the hailstone sequence from.

    Keyword Args:
        P (int): Modulus used to devide n, iff n is equivalent to (0 mod P)
            Default is 2.
        a (int): Factor by which to multiply n. Default is 3.
        b (int): Value to add to the scaled value of n. Default is 1.
        max_total_stopping_time (int): Maximum amount of times to iterate the
            function, if 1 is not reached. Default is 1000.
        total_stopping_time (bool): Whether or not to execute until the "total"
            stopping time (number of iterations to obtain 1) rather than the
            regular stopping time (number of iterations to reach a value less
            than the initial value). Default is True.
        verbose (bool): If set to verbose, the hailstone sequence will include
            control string sequences to provide information about how the
            sequence terminated, whether by reaching a stopping time or entering
            a cycle. Default is True.
    """
    # Call out the function before any magic returns to trap bad values.
    _ = function(initial_value, P=P, a=a, b=b)
    # 0 is always an immediate stop.
    if initial_value == 0:
        return [[_CC.ZERO_STOP.value, 0]] if verbose else [0]
    # 1 is always an immediate stop, with 0 stopping time.
    if initial_value == 1:
        return [[_CC.TOTAL_STOPPING_TIME.value, 0]] if verbose else [1]
    terminate = __stopping_time_terminus(initial_value, total_stopping_time)
    # Start the hailstone sequence.
    _max_total_stopping_time = max(max_total_stopping_time, 1)
    hailstone = [initial_value]
    cyclic = (lambda x: x in hailstone)
    for _ in range(_max_total_stopping_time):
        _next = function(hailstone[-1], P=P, a=a, b=b)
        # Check if the next hailstone is either the stopping time, total
        # stopping time, the same as the initial value, or stuck at zero.
        if terminate(_next):
            hailstone += [_next]
            if verbose:
                m = _CC.TOTAL_STOPPING_TIME if _next == 1 else _CC.STOPPING_TIME
                hailstone += [[m.value, len(hailstone)-1]]
            break
        if cyclic(_next):
            cycle_init = 1
            for j in range(1, len(hailstone)+1):
                if hailstone[-j] == _next:
                    cycle_init = j
                    break
            if verbose:
                hailstone = hailstone[:-cycle_init] + [
                    _CC.CYCLE_INIT.value,
                    hailstone[-cycle_init:],
                    [_CC.CYCLE_LENGTH.value, cycle_init]
                ]
            else:
                hailstone += [_next]
            break
        if _next == 0:
            hailstone += [0]
            if verbose:
                hailstone += [[_CC.ZERO_STOP.value, -(len(hailstone)-1)]]
            break
        hailstone += [_next]
    else:
        if verbose:
            hailstone += [[_CC.MAX_STOP_OOB.value, _max_total_stopping_time]]
    return hailstone


def stopping_time(initial_value: int, P: int = 2, a: int = 3,
                  b: int = 1, max_stopping_time: int = 1000,
                  total_stopping_time: bool = False):
    """
    Returns the stopping time, the amount of iterations required to reach a
    value less than the initial value, or None if max_stopping_time is exceeded.
    Alternatively, if total_stopping_time is True, then it will instead count
    the amount of iterations to reach 1. If the sequence does not stop, but
    instead ends in a cycle, the result will be (math.inf). If (P,a,b) are such
    that it is possible to get stuck on zero, the result will be the negative of
    what would otherwise be the "total stopping time" to reach 1, where 0 is
    considered a "total stop" that should not occur as it does form a cycle of
    length 1.

    Args:
        initial_value (int): The value for which to find the stopping time.

    Keyword Args:
        P (int): Modulus used to devide n, iff n is equivalent to (0 mod P)
            Default is 2.
        a (int): Factor by which to multiply n. Default is 3.
        b (int): Value to add to the scaled value of n. Default is 1.
        max_stopping_time (int): Maximum amount of times to iterate the
            function, if the stopping time is not reached. IF the
            max_stopping_time is reached, the function will return None.
            Default is 1000.
        total_stopping_time (bool): Whether or not to execute until the "total"
            stopping time (number of iterations to obtain 1) rather than the
            regular stopping time (number of iterations to reach a value less
            than the initial value). Default is False.
    """
    # The information is contained in the verbose form of a hailstone sequence.
    # Although the "max_~_time" for hailstones is name for "total stopping" time
    # and the "max_~_time" for this "stopping time" function is _not_ "total",
    # they are handled the same way, as the default for "total_stopping_time"
    # for hailstones is true, but for this, is false. Thus the naming difference
    end_msg = hailstone_sequence(initial_value, P=P, a=a, b=b, verbose=True,
                                 max_total_stopping_time=max_stopping_time,
                                 total_stopping_time=total_stopping_time)[-1]
    # For total/regular/zero stopping time, the value is already the same as
    # that present, for cycles we report infinity instead of the cycle length,
    # and for max stop out of bounds, we report None instead of the max stop cap
    return {_CC.TOTAL_STOPPING_TIME.value: end_msg[1],
            _CC.STOPPING_TIME.value: end_msg[1],
            _CC.CYCLE_LENGTH.value: infinity,
            _CC.ZERO_STOP.value: end_msg[1],
            _CC.MAX_STOP_OOB.value: None,
            }.get(end_msg[0], None)


def tree_graph(initial_value: int, max_orbit_distance: int, P: int = 2, a: int = 3,
               b: int = 1, __cycle_prevention: Optional[Set[int]] = None):
    """
    Returns nested dictionaries that model the directed tree graph up to a
    maximum nesting of max_orbit_distance, with the initial_value as the root.

    Args:
        initial_value (int): The root value of the directed tree graph.
        max_orbit_distance (int): Maximum amount of times to iterate the reverse
            function. There is no natural termination to populating the tree
            graph, equivalent to the termination of hailstone sequences or
            stopping time attempts, so this is not an optional argument like
            max_stopping_time / max_total_stopping_time, as it is the intended
            target of orbits to obtain, rather than a limit to avoid uncapped
            computation.

    Keyword Args:
        P (int): Modulus used to devide n, iff n is equivalent to (0 mod P)
            Default is 2.
        a (int): Factor by which to multiply n. Default is 3.
        b (int): Value to add to the scaled value of n. Default is 1.

    Internal Keyword Args:
        __cycle_prevention (set[int]): Used to prevent cycles from precipitating
            by keeping track of all values added across previous nest depths.
    """
    # Call out the reverse_function before any magic returns to trap bad values.
    _ = reverse_function(initial_value, P=P, a=a, b=b)
    tgraph = {initial_value: {}}
    if max(0, max_orbit_distance) == 0:
        return tgraph
    # Handle cycle prevention for recursive calls ~
    # Shouldn't use a mutable object initialiser for a default.
    if __cycle_prevention is None:
        __cycle_prevention = set()
    __cycle_prevention.add(initial_value)
    for branch_value in reverse_function(initial_value, P=P, a=a, b=b):
        if branch_value in __cycle_prevention:
            tgraph[initial_value][_CC.CYCLE_INIT.value] = branch_value
        else:
            tgraph[initial_value][branch_value] = tree_graph(
                branch_value, max_orbit_distance-1, P=P, a=a, b=b,
                __cycle_prevention=__cycle_prevention)[branch_value]
    return tgraph
