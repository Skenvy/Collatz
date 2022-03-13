"""
Provides the basic functionality to interact with the Collatz conjecture.
The parameterisation uses the same (P,a,b) notation as Conway's generalisations.
Besides the function and reverse function, there is also functionality to
retrieve the hailstone sequence, the "stopping time"/"total stopping time", or
tree-graph.
"""


def function(n:int):
    """
    Returns the output of a single application of the Collatz function. An alias
    of the parameterised_function(n,P,a,b).

    Args:
        n (int): The value on which to perform the Collatz function
    """
    return parameterised_function(n)


def parameterised_function(n:int, P:int = 2, a:int = 3, b:int=1):
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


def parameterised_hailstone_sequence(initial_value:int, P:int = 2, a:int = 3,
                                     b:int=1, max_total_stopping_time:int=1000,
                                     terminate_at_stopping_time:bool=False):
    """
    *

    Args:
        initial_value (int):
    
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


def parameterised_stopping_time(initial_value:int, P:int = 2, a:int = 3,
                                b:int=1, max_stopping_time:int=1000,
                                total_stopping_time:bool=False):
    """
    *

    Args:
        initial_value (int):
    
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


def parameterised_reverse_function(n:int, P:int = 2, a:int = 3, b:int=1):
    """
    *

    Args:
        n (int):
    
    Kwargs:
        P (int): Modulus used to devide n, iff n is equivalent to (0 mod P)
            Default is 2.
        a (int): Factor by which to multiply n. Default is 3.
        b (int): Value to add to the scaled value of n. Default is 1.
    """
    pass #TODO


def parameterised_tree_graph(initial_value:int, max_orbit_distance:int,
                             P:int = 2, a:int = 3, b:int=1):
    """
    *

    Args:
        initial_value (int):
        max_orbit_distance (int): Maximum amount of times to iterate the reverse
            function. There is no natural 
    
    Kwargs:
        P (int): Modulus used to devide n, iff n is equivalent to (0 mod P)
            Default is 2.
        a (int): Factor by which to multiply n. Default is 3.
        b (int): Value to add to the scaled value of n. Default is 1.
    """
    pass #TODO
