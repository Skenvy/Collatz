"""
Provides the basic functionality to interact with the Collatz conjecture. The
parameterisation uses the same (P,a,b) notation as Conway's generalisations.
Besides the function and reverse function, there is also functionality to retrieve
the hailstone sequence, the "stopping time"/"total stopping time", or tree-graph.

# Examples
```
julia> import Pkg; Pkg.add("Collatz"); using Collatz
```
"""
module Collatz
#TODO: ^ add jldoctest back to the above example when this is in general

export _ErrMsg, _CC, _KNOWN_CYCLES
export collatz_function, reverse_collatz_function, hailstone_sequence, stopping_time, tree_graph

"The four known cycles (besides 0->0), for the default parameterisation."
const _KNOWN_CYCLES = [[1, 4, 2], [-1, -2], [-5, -14, -7, -20, -10], [-17, -50, -25, -74, -37, -110, -55, -164, -82, -41, -122, -61, -182, -91, -272, -136, -68, -34]]
"The value up to which has been proven numerically, for the default parameterisation."
const __VERIFIED_MAXIMUM = 295147905179352825856
"The value down to which has been proven numerically, for the default parameterisation."
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
hailstone sequences, when set to verbose, or stopping time check. A module used
to wrap an enum to reference the values as `_CC.ABC` rather than `ABC::CC`

# Examples
```jldoctest
julia> string(_CC.STOPPING_TIME)
"STOPPING_TIME"
julia> string(_CC.TOTAL_STOPPING_TIME)
"TOTAL_STOPPING_TIME"
julia> string(_CC.CYCLE_INIT)
"CYCLE_INIT"
julia> string(_CC.CYCLE_LENGTH)
"CYCLE_LENGTH"
julia> string(_CC.MAX_STOP_OOB)
"MAX_STOP_OOB"
julia> string(_CC.ZERO_STOP)
"ZERO_STOP"
```
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
    __assert_sane_parameterisation(P, a, b)

Handles the sanity check for the parameterisation (P,a,b) required by both
the function and reverse function.

# Args
- `P::Integer`: Modulus used to devide n, iff n is equivalent to (0 mod P).
- `a::Integer`: Factor by which to multiply n.
- `b::Integer`: Value to add to the scaled value of n.
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
    collatz_function(n; P=2, a=3, b=1)

Returns the output of a single application of a Collatz-esque function.

# Args
- `n::Integer`: The value on which to perform the Collatz-esque function

# Kwargs
- `P::Integer=2`: Modulus used to devide n, iff n is equivalent to (0 mod P).
- `a::Integer=3`: Factor by which to multiply n.
- `b::Integer=1`: Value to add to the scaled value of n.

# Examples
```jldoctest
julia> collatz_function(5)
16
```
```jldoctest
julia> collatz_function(14, P=7)
2
```
```jldoctest
julia> collatz_function(15, P=7, a=5, b=3)
78
```
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
    reverse_collatz_function(n; P=2, a=3, b=1)

Returns the output of a single application of a Collatz-esque reverse function.

# Args
- `n::Integer`: The value on which to perform the reverse Collatz function

# Kwargs
- `P::Integer=2`: Modulus used to devide n, iff n is equivalent to (0 mod P).
- `a::Integer=3`: Factor by which to multiply n.
- `b::Integer=1`: Value to add to the scaled value of n.

# Examples
```jldoctest
julia> print(reverse_collatz_function(1))
[2]
```
```jldoctest
julia> print(reverse_collatz_function(4))
[1, 8]
```
```jldoctest
julia> print(reverse_collatz_function(3, P=-3, a=-2, b=-5))
[-9, -4]
```
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
        push!(pre_values, ((n-b)÷a))
        sort!(pre_values)
    end
    return pre_values
end


"""
    __initial_value_outside_verified_range(x)

Checks if the initial value is greater than __VERIFIED_MAXIMUM or less than
__VERIFIED_MINIMUM. Only intended for the default parameterisation.

# Args
- `x::Integer`: The initial value to check if it is within range or not.
"""
function __initial_value_outside_verified_range(x::Integer)
    return (__VERIFIED_MAXIMUM < x) || (x < __VERIFIED_MINIMUM)
end


"""
    __stopping_time_terminus(n, total_stop)

Provides the appropriate lambda to use to check if iterations on an initial
value have reached either the stopping time, or total stopping time.

# Args
- `n::Integer`: The initial value to confirm against a stopping time check.
- `total_stop::Bool`: If false, the lambda will confirm that iterations
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


#TODO: Make the hailstone calc arbitrary integer safe!
"""
    hailstone_sequence(initial_value; P=2, a=3, b=1, max_total_stopping_time=1000, total_stopping_time=true, verbose=true)

Returns a list of successive values obtained by iterating a Collatz-esque function.
    
Until either 1 is reached, or the total amount of iterations
exceeds max_total_stopping_time. Unless total_stopping_time is False,
which will terminate the hailstone at the "stopping time" value, i.e. the
first value less than the initial value. While the sequence has the
capability to determine that it has encountered a cycle, the cycle from "1"
wont be attempted or reported as part of a cycle, regardless of default or
custom parameterisation, as "1" is considered a "total stop".

# Args
- `initial_value::Integer`: The value to begin the hailstone sequence from.

# Kwargs
- `P::Integer=2`: Modulus used to devide n, iff n is equivalent to (0 mod P).
- `a::Integer=3`: Factor by which to multiply n.
- `b::Integer=1`: Value to add to the scaled value of n.
- `max_total_stopping_time::Integer=1000`: Maximum amount of times to iterate the
    function, if 1 is not reached.
- `total_stopping_time::Bool=true`: Whether or not to execute until the "total"
    stopping time (number of iterations to obtain 1) rather than the regular stopping
    time (number of iterations to reach a value less than the initial value).
- `verbose::Bool=true`: If set to verbose, the hailstone sequence will include
    control string sequences to provide information about how the sequence
    terminated, whether by reaching a stopping time or entering a cycle.

# Examples
```jldoctest
julia> print(hailstone_sequence(16, verbose=false))
[16, 8, 4, 2, 1]
```
```jldoctest
julia> print(hailstone_sequence(16))
Any[16, 8, 4, 2, 1, Any["TOTAL_STOPPING_TIME", 4]]
```
```jldoctest
julia> print(hailstone_sequence(761, P=5, a=2, b=3, verbose=false))
[761, 1525, 305, 61, 125, 25, 5, 1]
```
# Example cycle!
```jldoctest
julia> print(hailstone_sequence(-56))
Any[-56, -28, "CYCLE_INIT", Any[-14, -7, -20, -10, -5], Any["CYCLE_LENGTH", 5]]
```
```jldoctest
julia> print(hailstone_sequence(-56, verbose=false))
[-56, -28, -14, -7, -20, -10, -5, -14]
```
"""
function hailstone_sequence(initial_value::Integer; P::Integer=2, a::Integer=3, b::Integer=1, max_total_stopping_time::Integer=1000, total_stopping_time::Bool=true, verbose::Bool=true)
    # Call out the collatz_function before any magic returns to trap bad values.
    _ = collatz_function(initial_value,P=P,a=a,b=b)
    # 0 is always an immediate stop.
    if initial_value == 0; if verbose; return [[string(_CC.ZERO_STOP), 0]]; else; return [0]; end; end
    # 1 is always an immediate stop, with 0 stopping time.
    if initial_value == 1; if verbose; return [[string(_CC.TOTAL_STOPPING_TIME), 0]]; else; return [1]; end; end
    terminate = __stopping_time_terminus(initial_value, total_stopping_time)
    # Start the hailstone sequence.
    _max_total_stopping_time = max(max_total_stopping_time, 1)
    hailstone = [initial_value] # Initialises as Vector{Integer}
    if verbose; hailstone = Vector{Any}(hailstone); end
    cyclic = (function (x) x in hailstone end)
    for k in 1:_max_total_stopping_time
        _next = collatz_function(last(hailstone),P=P,a=a,b=b)
        # Check if the next hailstone is either the stopping time, total
        # stopping time, the same as the initial value, or stuck at zero.
        if terminate(_next)
            push!(hailstone, _next)
            if verbose
                if _next == 1
                    m = string(_CC.TOTAL_STOPPING_TIME)
                else
                    m = string(_CC.STOPPING_TIME)
                end
                push!(hailstone, [m, length(hailstone)-1])
            end
            break
        end
        if cyclic(_next)
            cycle_init = 0
            for j in 0:(length(hailstone)-1)
                if hailstone[length(hailstone)-j] == _next
                    # Because Julia is 1-based indexed, add 1 to the J
                    cycle_init = j+1
                    break
                end
            end
            if verbose
                hailstone = append!(hailstone[1:(length(hailstone)-cycle_init)], [string(_CC.CYCLE_INIT), hailstone[(length(hailstone)-cycle_init+1):length(hailstone)], [string(_CC.CYCLE_LENGTH), cycle_init]])
            else
                push!(hailstone, _next)
            end
            break
        end
        if _next == 0
            push!(hailstone, 0)
            if verbose
                push!(hailstone, [string(_CC.ZERO_STOP), -(length(hailstone)-1)])
            end
            break
        end
        push!(hailstone, _next)
    end
    # Julia has no for ~ else yet https://github.com/JuliaLang/julia/issues/1289
    if length(hailstone) >= max_total_stopping_time
        if verbose
            push!(hailstone, [string(_CC.MAX_STOP_OOB), _max_total_stopping_time])
        end
    end
    return hailstone
end


"""
    stopping_time(initial_value; P=2, a=3, b=1, max_stopping_time=1000, total_stopping_time=false)

Returns the stopping time, the amount of iterations required to reach a
value less than the initial value, or nothing if max_stopping_time is exceeded.

Alternatively, if total_stopping_time is True, then it will instead count
the amount of iterations to reach 1. If the sequence does not stop, but
instead ends in a cycle, the result will be infinity. If (P,a,b) are such
that it is possible to get stuck on zero, the result will be the negative of
what would otherwise be the "total stopping time" to reach 1, where 0 is
considered a "total stop" that should not occur as it does form a cycle of
length 1.

# Args
- `initial_value::Integer`: The value for which to find the stopping time.

# Kwargs
- `P::Integer=2`: Modulus used to devide n, iff n is equivalent to (0 mod P).
- `a::Integer=3`: Factor by which to multiply n.
- `b::Integer=1`: Value to add to the scaled value of n.
- `max_stopping_time::Integer=1000`: Maximum amount of times to iterate the function, if the stopping
    time is not reached. IF the max_stopping_time is reached, the function will return nothing.
- `total_stopping_time::Bool=false`: Whether or not to execute until the "total"
    stopping time (number of iterations to obtain 1) rather than the regular
    stopping time (number of iterations to reach a value less than the initial value).

# Examples
```jldoctest
julia> stopping_time(5)
3
julia> stopping_time(27)
96
julia> stopping_time(21, P=5, a=2, b=3, total_stopping_time=true)
Inf
```
"""
function stopping_time(initial_value::Integer; P::Integer=2, a::Integer=3, b::Integer=1, max_stopping_time::Integer=1000, total_stopping_time::Bool=false)
    # The information is contained in the verbose form of a hailstone sequence.
    # Although the "max_~_time" for hailstones is name for "total stopping" time
    # and the "max_~_time" for this "stopping time" function is _not_ "total",
    # they are handled the same way, as the default for "total_stopping_time"
    # for hailstones is true, but for this, is false. Thus the naming difference
    end_msg = last(hailstone_sequence(initial_value, P=P, a=a, b=b, verbose=true, max_total_stopping_time=max_stopping_time, total_stopping_time=total_stopping_time))
    # For total/regular/zero stopping time, the value is already the same as
    # that present, for cycles we report infinity instead of the cycle length,
    # and for max stop out of bounds, we report nothing instead of the max stop cap
    return get(Dict(string(_CC.TOTAL_STOPPING_TIME) => end_msg[2],
                    string(_CC.STOPPING_TIME) => end_msg[2],
                    string(_CC.CYCLE_LENGTH) => Inf, # infinity
                    string(_CC.ZERO_STOP) => end_msg[2],
                    string(_CC.MAX_STOP_OOB) => nothing,
                    ), end_msg[1], nothing)
end


"""
    tree_graph(initial_value, max_orbit_distance; P=2, a=3, b=1, __cycle_prevention=nothing)

Returns nested dictionaries that model the directed tree graph up to a
maximum nesting of max_orbit_distance, with the initial_value as the root.

# Args
- `initial_value::Integer`: The root value of the directed tree graph.
- `max_orbit_distance::Integer`: Maximum amount of times to iterate the reverse
    function. There is no natural termination to populating the tree graph, equivalent
    to the termination of hailstone sequences or stopping time attempts, so this is not
    an optional argument like max_stopping_time / max_total_stopping_time, as it is the
    intended target of orbits to obtain, rather than a limit to avoid uncapped computation.

# Kwargs
- `P::Integer=2`: Modulus used to devide n, iff n is equivalent to (0 mod P).
- `a::Integer=3`: Factor by which to multiply n.
- `b::Integer=1`: Value to add to the scaled value of n.

# Internal Kwargs
- `__cycle_prevention::Union{Set{Integer},Nothing}=nothing`: Used to prevent cycles
    from precipitatingby keeping track of all values added across previous nest depths.

# Examples
```jldoctest
julia> print(tree_graph(1, 3))
Dict{Int64, Dict{Any, Any}}(1 => Dict(2 => Dict{Any, Any}(4 => Dict{Any, Any}("CYCLE_INIT" => 1, 8 => Dict{Any, Any}()))))
julia> print(tree_graph(4, 3))
Dict{Int64, Dict{Any, Any}}(4 => Dict(8 => Dict{Any, Any}(16 => Dict{Any, Any}(5 => Dict{Any, Any}(), 32 => Dict{Any, Any}())), 1 => Dict{Any, Any}(2 => Dict{Any, Any}("CYCLE_INIT" => 4))))
```
"""
function tree_graph(initial_value::Integer, max_orbit_distance::Integer; P::Integer=2, a::Integer=3, b::Integer=1, __cycle_prevention::Union{Set{Integer},Nothing}=nothing)
    # Call out the reverse_collatz_function before any magic returns to trap bad values.
    _ = reverse_collatz_function(initial_value,P=P,a=a,b=b)
    tgraph = Dict(initial_value=>Dict())
    if max(0, max_orbit_distance) == 0; return tgraph; end
    # Handle cycle prevention for recursive calls ~
    # Shouldn't use a mutable object initialiser for a default.
    if __cycle_prevention == nothing; __cycle_prevention = Set{Integer}(); end
    push!(__cycle_prevention, initial_value)
    for branch_value in reverse_collatz_function(initial_value, P=P, a=a, b=b)
        if branch_value in __cycle_prevention
            tgraph[initial_value][string(_CC.CYCLE_INIT)] = branch_value
        else
            tgraph[initial_value][branch_value] = tree_graph(branch_value, max_orbit_distance-1, P=P, a=a, b=b, __cycle_prevention=__cycle_prevention)[branch_value]
        end
    end
    return tgraph
end

end # module
