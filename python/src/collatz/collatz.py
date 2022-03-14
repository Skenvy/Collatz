from typing import Optional


"""
Provides the basic functionality to interact with the Collatz conjecture.
The parameterisation uses the same (P,a,b) notation as Conway's generalisations.
Besides the function and reverse function, there is also functionality to
retrieve the hailstone sequence, the "stopping time"/"total stopping time", or
tree-graph.
"""


__KNOWN_CYCLES = [[1, 4, 2], [-1, -2], [-5, -14, -7, -20, -10], 
[-17,-50,-25,-74,-37,-110,-55,-164,-82,-41,-122,-61,-182,-91,-272,-136,-68,-34]]
__VERIFIED_MAXIMUM = 295147905179352825856
__VERIFIED_MINIMUM = -272  #TODO: Check the actual lowest bound.


def function(n:int, P:int=2, a:int=3, b:int=1):
    """
    Returns the output of a single application of a Collatz-esque function.

    Args:
        n (int): The value on which to perform the Collatz-esque function
    
    Kwargs:
        P (int): Modulus used to devide n, iff n is equivalent to (0 mod P).
            Default is 2.
        a (int): Factor by which to multiply n. Default is 3.
        b (int): Value to add to the scaled value of n. Default is 1.
    """
    return n//P if n%P == 0 else (a*n+b)


def reverse_function(n:int, P:int=2, a:int=3, b:int=1):
    """
    Returns the output of a single application of a Collatz-esque reverse
    function.

    Args:
        n (int): The value on which to perform the reverse Collatz function
    
    Kwargs:
        P (int): Modulus used to devide n, iff n is equivalent to (0 mod P)
            Default is 2.
        a (int): Factor by which to multiply n. Default is 3.
        b (int): Value to add to the scaled value of n. Default is 1.
    """
    # Every input can be reversed as the result of "n/P" division, which yields
    # "Pn"... {f(n) = an + b}≡{(f(n) - b)/a = n} ~ if n was such that the
    # muliplication step was taken instead of the division by the modulus, then
    # (f(n) - b)/a) must be an integer that is not in (0 mod P). Because we're
    # not placing restrictions on the parameters yet, although there is a better
    # way of shortcutting this for the default variables, we need to always
    # attempt (f(n) - b)/a)
    pre_values = [P*n]
    if (n-b)%a == 0 and (n-b)%(P*a) != 0:
        pre_values += [(n-b)//a]
    return pre_values


def __initial_value_outside_verified_range(x:int):
    """
    Checks if the initial value is greater than __VERIFIED_MAXIMUM or less than
    __VERIFIED_MINIMUM. Only intended for the default parameterisation.

    Args:
        x (int): The initial value to check if it is within range or not.
    """
    return (__VERIFIED_MAXIMUM < x) or (x < __VERIFIED_MINIMUM)


def __stopping_time_terminus(n:int, total_stop:bool):
    """
    Provides the appropriate lambda to use to check if iterations on an initial
    value have reached either the stopping time, or total stopping time.

    Args:
        n (int): The initial value to confirm against a stopping time check.
        total_stop (bool): If false, the lambda will confirm that iterations
            of n have reached the oriented stopping time to reach a value closer
            to 0. If true, the lambda will simply check equality to 1.
    """
    return (lambda x: x == 1) if total_stop else (lambda x: abs(x) < abs(n))


def hailstone_sequence(initial_value:int, P:int=2, a:int=3,
                       b:int=1, max_total_stopping_time:int=1000,
                       total_stopping_time:bool=True):
    """
    Returns a list of successive values obtained by iterating a Collatz-esque
    function, until either 1 is reached, or the total amount of iterations
    exceeds max_total_stopping_time, unless total_stopping_time is False,
    which will terminate the hailstone at the "stopping time" value, i.e. the
    first value less than the initial value.

    Args:
        initial_value (int): The value to begin the hailstone sequence from.
    
    Kwargs:
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
    """
    # 0 is always an immediate stop.
    if initial_value == 0:
        return [0]
    terminate = __stopping_time_terminus(initial_value, total_stopping_time)
    # Start the hailstone sequence.
    hailstone = [initial_value]
    cyclic = (lambda x: x in hailstone)
    for k in range(max_total_stopping_time):
        _next = function(hailstone[-1],P=P,a=a,b=b)
        # Check if the next hailstone is either the stopping time, total
        # stopping time, the same as the initial value, or stuck at zero.
        if terminate(_next):
            hailstone += [_next, f"Reached stopping time {len(hailstone)}"]
            break
        if cyclic(_next):
            cycle_init = 1
            for j in range(len(hailstone)):
                if hailstone[-j] == _next:
                    cycle_init = j
                    break
            # If the initial value is a value in the cycle it will say the length is 0.
            hailstone = hailstone[:-cycle_init] + ['Cycle initiated', hailstone[-cycle_init:], f"Cycle detected, length {cycle_init}"]
            break
        if _next == 0:
            hailstone += [0, "Trapped on zero."]
            break
        hailstone += [_next]
    else:
        hailstone += [f'Hailstone for (P,a,b)=({P},{a},{b}) did not terminate by \
            {max_total_stopping_time}']
    return hailstone


#TODO: Fix the stopping time to keep it up to date with the changes to hailstones.
def stopping_time(initial_value:int, P:int=2, a:int=3,
                  b:int=1, max_stopping_time:int=1000,
                  total_stopping_time:bool=False):
    """
    Returns the stopping time, the amount of iterations required to reach a
    value less than the initial value, or None if max_stopping_time is exceeded.
    Alternatively, if total_stopping_time is True, then it will instead count
    the amount of iterations to reach 1.

    Args:
        initial_value (int): The value for which to find the stopping time.
    
    Kwargs:
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
    # 0 is always an immediate stop.
    if initial_value == 0:
        return 0
    terminate = __stopping_time_terminus(initial_value, total_stopping_time)
    # Now start the stopping time calc.
    cyclic = (lambda x: x == initial_value)
    iter_val = initial_value
    for k in range(max_stopping_time):
        iter_val = function(iter_val,P=P,a=a,b=b)
        # Check if the next value is either the stopping time, total
        # stopping time, the same as the initial value, or stuck at zero.
        # For stopping time determinations, a zero will be considered
        # interchangable with the regular termination at a total stop of 1.
        # Which is not possible with default values..
        if terminate(iter_val) or cyclic(iter_val) or iter_val == 0:
            print(f'Stopping time for (P,a,b)=({P},{a},{b}) ~ {initial_value} \
                stopping at {iter_val}, is {k+1} iterations.')
            return k+1
    else:
        print(f'Stopping time for (P,a,b)=({P},{a},{b}) did not terminate by \
            {max_stopping_time}')
        return None


def tree_graph(initial_value:int, max_orbit_distance:int, P:int=2, a:int=3,
               b:int=1, __cycle_prevention:Optional[set[int]]=None):
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
    
    Kwargs:
        P (int): Modulus used to devide n, iff n is equivalent to (0 mod P)
            Default is 2.
        a (int): Factor by which to multiply n. Default is 3.
        b (int): Value to add to the scaled value of n. Default is 1.
    
    Internal Kwargs:
        __cycle_prevention (set[int]): Used to prevent cycles from precipitating
            by keeping track of all values added across previous nest depths.
    """
    tgraph = {initial_value:{}}
    if max(0, max_orbit_distance) == 0:
        return tgraph
    # Handle cycle prevention for recursive calls ~
    # Shouldn't use a mutable object initialiser for a default.
    if __cycle_prevention is None:
        __cycle_prevention = set()
    __cycle_prevention.add(initial_value)
    for branch_value in reverse_function(initial_value, P=P, a=a, b=b):
        if branch_value in __cycle_prevention:
            tgraph[initial_value][branch_value] = {"cycle present"}
        else:
            tgraph[initial_value][branch_value] = tree_graph(branch_value,
                max_orbit_distance-1, P=P, a=a, b=b,
                __cycle_prevention=__cycle_prevention)[branch_value]
    return tgraph
