"""
Provides the basic functionality to interact with the Collatz conjecture.
The parameterisation uses the same (P,a,b) notation as Conway's generalisations.
Besides the function and reverse function, there is also functionality to
retrieve the hailstone sequence, the "stopping time"/"total stopping time", or
tree-graph.
"""


def function(n:int, P:int = 2, a:int = 3, b:int=1):
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


def hailstone_sequence(initial_value:int, P:int = 2, a:int = 3,
                       b:int=1, max_total_stopping_time:int=1000,
                       terminate_at_stopping_time:bool=False):
    """
    Returns a list of successive values obtained by iterating a Collatz-esque
    function, until either 1 is reached, or the total amount of iterations
    exceeds max_total_stopping_time, unless terminate_at_stopping_time is True,
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
        terminate_at_stopping_time (bool): Whether or not to stop iterating once
            the stopping time has been reached, as opposed to iterating until
            either the "total stopping time", or max_total_stopping_time.
            Default is False.
    """
    pass #TODO


def stopping_time(initial_value:int, P:int = 2, a:int = 3,
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
    pass #TODO


def reverse_function(n:int, P:int = 2, a:int = 3, b:int=1):
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


def tree_graph(initial_value:int, max_orbit_distance:int,
               P:int = 2, a:int = 3, b:int=1):
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
