"""
Provides the basic functionality to interact with the Collatz conjecture.
The parameterisation uses the same (P,a,b) notation as Conway's generalisations.
Besides the function and reverse function, there is also functionality to
retrieve the hailstone sequence, the "stopping time"/"total stopping time", or
tree-graph.
"""
module Collatz

export _ErrMsg, _CC, _KNOWN_CYCLES
export collatz, reverse_collatz, hailstone_sequence, stopping_time, tree_graph

const _KNOWN_CYCLES = [[1, 4, 2], [-1, -2], [-5, -14, -7, -20, -10], [-17, -50, -25, -74, -37, -110, -55, -164, -82, -41, -122, -61, -182, -91, -272, -136, -68, -34]]
const __VERIFIED_MAXIMUM = 295147905179352825856
const __VERIFIED_MINIMUM = -272  #&TODO: Check the actual lowest bound.


"""
Error message constant.
"""
module _ErrMsg
const SANE_PARAMS_P = "'P' should not be 0 ~ violates modulo being non-zero."
const SANE_PARAMS_A = "'a' should not be 0 ~ violates the reversability."
end # module _ErrMsg
import ._ErrMsg


"""
Cycle Control: Descriptive flags to indicate when some event occurs in the
hailstone sequences, when set to verbose, or stopping time check.
"""
module _CC
# The elements of an enum are accessed as string(ABC::CC) or just string(ABC) so
# wrap the enum in a module so they can be referenced as string(_CC.ABC)
@enum CC begin
    STOPPING_TIME
    TOTAL_STOPPING_TIME
    CYCLE_INIT
    CYCLE_LENGTH
    MAX_STOP_OOB  # ~ "out of bounds"
    ZERO_STOP
end # @enum CC
end # module _CC
import ._CC


"""
Handles the sanity check for the parameterisation (P,a,b) required by both
the function and reverse function.

Args:
    P (int): Modulus used to devide n, iff n is equivalent to (0 mod P).
    a (int): Factor by which to multiply n.
    b (int): Value to add to the scaled value of n.
"""
function __assert_sane_parameterisation(P::Integer, a::Integer, b::Integer)
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
    @assert P != zero(P) _ErrMsg.SANE_PARAMS_P
    @assert a != zero(a) _ErrMsg.SANE_PARAMS_A
end


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
function collatz_function(n::Integer; P::Integer=2, a::Integer=3, b::Integer=1)
    __assert_sane_parameterisation(P,a,b)
    if n%P == 0
        # In Julia, "Integer//Integer" creates a "Rational{Int64}" type, rather
        # than strict integer division (which is done instead with "÷"). See;
        # https://docs.julialang.org/en/v1/manual/mathematical-operations/
        # https://docs.julialang.org/en/v1/manual/complex-and-rational-numbers/
        # So we can either "n÷P", or "numerator(n//P)"
        return n÷P
    else
        return (a*n+b)
    end
end


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
function reverse_collatz_function(n::Integer; P::Integer=2, a::Integer=3, b::Integer=1)
    __assert_sane_parameterisation(P,a,b)
    # Every input can be reversed as the result of "n/P" division, which yields
    # "Pn"... {f(n) = an + b}≡{(f(n) - b)/a = n} ~ if n was such that the
    # muliplication step was taken instead of the division by the modulus, then
    # (f(n) - b)/a) must be an integer that is not in (0 mod P). Because we're
    # not placing restrictions on the parameters yet, although there is a better
    # way of shortcutting this for the default variables, we need to always
    # attempt (f(n) - b)/a)
    pre_values = [P*n]
    if (n-b)%a == 0 && (n-b)%(P*a) != 0
        # https://docs.julialang.org/en/v1/base/collections/#Base.push!
        push!(pre_values, ((n-b)÷a))
        # https://docs.julialang.org/en/v1/base/sort/
        sort!(pre_values)
    end
    return pre_values
end


"""
Checks if the initial value is greater than __VERIFIED_MAXIMUM or less than
__VERIFIED_MINIMUM. Only intended for the default parameterisation.

Args:
    x (int): The initial value to check if it is within range or not.
"""
function __initial_value_outside_verified_range(x::Integer)
    return (__VERIFIED_MAXIMUM < x) || (x < __VERIFIED_MINIMUM)
end


"""
Provides the appropriate lambda to use to check if iterations on an initial
value have reached either the stopping time, or total stopping time.

Args:
    n (int): The initial value to confirm against a stopping time check.
    total_stop (bool): If false, the lambda will confirm that iterations
        of n have reached the oriented stopping time to reach a value closer
        to 0. If true, the lambda will simply check equality to 1.
"""
function __stopping_time_terminus(n::Integer, total_stop::Bool)
    # https://docs.julialang.org/en/v1/manual/functions/#man-anonymous-functions
    if total_stop
        return (function (x) x == 1 end)
    elseif n >= 0
        return (function (x) x < n && x > 0 end)
    else
        return (function (x) x > n && x < 0 end)
    end
end


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
    verbose (bool): If set to verbose, the hailstone sequence will include
        control string sequences to provide information about how the
        sequence terminated, whether by reaching a stopping time or entering
        a cycle. Default is True.
"""
function hailstone_sequence(initial_value::Integer; P::Integer=2, a::Integer=3, b::Integer=1, max_total_stopping_time::Integer=1000, total_stopping_time::Bool=True, verbose::Bool=True) #TODO:
    # Call out the collatz_function before any magic returns to trap bad values.
    _ = collatz_function(initial_value,P=P,a=a,b=b)
    # 0 is always an immediate stop.
    if initial_value == 0; if verbose; return [[_CC.ZERO_STOP, 0]]; else; return [0]; end; end
    # 1 is always an immediate stop, with 0 stopping time.
    if initial_value == 1; if verbose; return [[_CC.TOTAL_STOPPING_TIME, 0]]; else; return [1]; end; end
    terminate = __stopping_time_terminus(initial_value, total_stopping_time)
    # Start the hailstone sequence.
    _max_total_stopping_time = max(max_total_stopping_time, 1)
    hailstone = [initial_value]
    cyclic = (function (x) x in hailstone end)
    for k in 1:_max_total_stopping_time
        _next = collatz_function(last(hailstone),P=P,a=a,b=b)
        # Check if the next hailstone is either the stopping time, total
        # stopping time, the same as the initial value, or stuck at zero.
        if terminate(_next)
            push!(hailstone, _next)
            if verbose
                if _next == 1
                    m = _CC.TOTAL_STOPPING_TIME 
                else
                    m = _CC.STOPPING_TIME
                end
                push!(hailstone, [m, length(hailstone)-1])
            end
            break
        end
        if cyclic(_next)
            cycle_init = 1
            for j in 0:(length(hailstone)-1)
                if hailstone[length(hailstone)-j] == _next
                    cycle_init = j
                    break
                end
            end
            if verbose
                hailstone = hailstone[1:(length(hailstone)-cycle_init)] + [_CC.CYCLE_INIT, hailstone[(length(hailstone)-cycle_init):length(hailstone)], [_CC.CYCLE_LENGTH, cycle_init]]
            else
                push!(hailstone, _next)
            end
            break
        end
        if _next == 0
            push!(hailstone, 0)
            if verbose
                push!(hailstone, [_CC.ZERO_STOP, -(length(hailstone)-1)])
            end
            break
        end
        push!(hailstone, _next)
    end
    # Julia has no for ~ else yet https://github.com/JuliaLang/julia/issues/1289
    if length(hailstone) >= max_total_stopping_time
        if verbose
            push!(hailstone, [_CC.MAX_STOP_OOB, _max_total_stopping_time])
        end
    end
    return hailstone
end


#TODO: from math import inf as infinity
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
function stopping_time(initial_value::Integer; P::Integer=2, a::Integer=3, b::Integer=1, max_stopping_time::Integer=1000, total_stopping_time::Bool=False) #TODO:
    # The information is contained in the verbose form of a hailstone sequence.
    # Although the "max_~_time" for hailstones is name for "total stopping" time
    # and the "max_~_time" for this "stopping time" function is _not_ "total",
    # they are handled the same way, as the default for "total_stopping_time"
    # for hailstones is true, but for this, is false. Thus the naming difference
#     end_msg = last(hailstone_sequence(initial_value, P=P, a=a, b=b, verbose=True, max_total_stopping_time=max_stopping_time, total_stopping_time=total_stopping_time))
    # For total/regular/zero stopping time, the value is already the same as
    # that present, for cycles we report infinity instead of the cycle length,
    # and for max stop out of bounds, we report None instead of the max stop cap
#     return {_CC.TOTAL_STOPPING_TIME: end_msg[1],
#             _CC.STOPPING_TIME: end_msg[1],
#             _CC.CYCLE_LENGTH: infinity,
#             _CC.ZERO_STOP: end_msg[1],
#             _CC.MAX_STOP_OOB: None,
#             }.get(end_msg[0], None)
    return 1
end


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
function tree_graph(initial_value::Integer, max_orbit_distance::Integer; P::Integer=2, a::Integer=3, b::Integer=1, __cycle_prevention::Union{Set{Integer},Nothing}=nothing) #TODO:
#     # Call out the reverse_collatz_function before any magic returns to trap bad values.
#     _ = reverse_collatz_function(initial_value,P=P,a=a,b=b)
#     tgraph = {initial_value:{}}
#     if max(0, max_orbit_distance) == 0:
#         return tgraph
#     # Handle cycle prevention for recursive calls ~
#     # Shouldn't use a mutable object initialiser for a default.
#     if __cycle_prevention is None:
#         __cycle_prevention = set()
#     __cycle_prevention.add(initial_value)
#     for branch_value in reverse_collatz_function(initial_value, P=P, a=a, b=b):
#         if branch_value in __cycle_prevention:
#             tgraph[initial_value][_CC.CYCLE_INIT] = branch_value
#         else:
#             tgraph[initial_value][branch_value] = tree_graph(branch_value,
#                 max_orbit_distance-1, P=P, a=a, b=b,
#                 __cycle_prevention=__cycle_prevention)[branch_value]
#     return tgraph
    return 1
end

end # module
