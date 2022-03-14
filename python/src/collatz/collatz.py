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
    if (P,a,b) == (2,3,1):
        # If default values we can search the four known cycles
        for _known_cycle in __KNOWN_CYCLES:
            if initial_value in _known_cycle:
                return _known_cycle
        # otherwise, enable cycle detection if testing values outside range..
        if __initial_value_outside_verified_range(initial_value):
            # Cyclic checks for values outside the the verified range for the
            # default values is redundant unless on a very optimised system,
            # as the cycle lengths would need to be so large as to easily run
            # out of memory, and would not be using a parameterised version.
            cyclic = (lambda x: x == initial_value)
        else:
            cyclic = (lambda x: False)
    else:
        # or just enable cycle detection is not using default values.
        cyclic = (lambda x: x == initial_value)
    terminate = __stopping_time_terminus(initial_value, total_stopping_time)
    # Now start the hailstone.
    hailstone_sequence = [initial_value]
    for k in range(max_total_stopping_time):
        _next = function(hailstone_sequence[-1],P=P,a=a,b=b)
        hailstone_sequence += [_next]
        # Check if the next hailstone is either the stopping time, total
        # stopping time, the same as the initial value, or stuck at zero.
        if terminate(_next) or cyclic(_next) or _next == 0:
            break
    else:
        print(f'Hailstone for (P,a,b)=({P},{a},{b}) did not terminate by \
            {max_total_stopping_time}')
    return hailstone_sequence



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
    if (P,a,b) == (2,3,1):
        if __initial_value_outside_verified_range(initial_value):
            # Cyclic checks for values outside the the verified range for the
            # default values is redundant unless on a very optimised system,
            # as the cycle lengths would need to be so large as to easily run
            # out of memory, and would not be using a parameterised version.
            cyclic = (lambda x: x == initial_value)
        else:
            cyclic = (lambda x: False)
    else:
        # or just enable cycle detection is not using default values.
        cyclic = (lambda x: x == initial_value)
    terminate = __stopping_time_terminus(initial_value, total_stopping_time)
    # Now start the stopping time calc.
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


def tree_graph(initial_value:int, max_orbit_distance:int,
               P:int=2, a:int=3, b:int=1):
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
    """
    pass #TODO
