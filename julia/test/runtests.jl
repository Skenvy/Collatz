println("################################################################################")
# https://docs.julialang.org/en/v1/stdlib/Test/#Basic-Unit-Tests
using Test, Collatz


# Test function collatz_function(n::Integer; P::Integer=2, a::Integer=3, b::Integer=1)
@testset verbose = true "collatz_function" begin
    # Default/Any (P,a,b); 0 trap
    @test Collatz.collatz_function(0) == 0
    # Default/Any (P,a,b); 1 cycle; positives
    @test Collatz.collatz_function(1) == 4
    @test Collatz.collatz_function(4) == 2
    @test Collatz.collatz_function(2) == 1
    # Default/Any (P,a,b); -1 cycle; negatives
    @test Collatz.collatz_function(-1) == -2
    @test Collatz.collatz_function(-2) == -1
    # Test a wider modulo sweep by upping P to 5, a to 2, and b to 3.
    @test Collatz.collatz_function(1, P=5, a=2, b=3) == 5
    @test Collatz.collatz_function(2, P=5, a=2, b=3) == 7
    @test Collatz.collatz_function(3, P=5, a=2, b=3) == 9
    @test Collatz.collatz_function(4, P=5, a=2, b=3) == 11
    @test Collatz.collatz_function(5, P=5, a=2, b=3) == 1
    # Test negative P, a and b. %, used in the function, is "floor" in python
    # rather than the more reasonable euclidean, but we only use it's (0 mod P)
    # conjugacy class to determine functionality, so the flooring for negative P
    # doesn't cause any issue.
    @test Collatz.collatz_function(1, P=-3, a=-2, b=-5) == -7
    @test Collatz.collatz_function(2, P=-3, a=-2, b=-5) == -9
    @test Collatz.collatz_function(3, P=-3, a=-2, b=-5) == -1
    # Set P and a to 0 to @test on __assert_sane_parameterisation
    @test_throws AssertionError(_ErrMsg.SANE_PARAMS_P) Collatz.collatz_function(1, P=0, a=2, b=3)
    @test_throws AssertionError(_ErrMsg.SANE_PARAMS_P) Collatz.collatz_function(1, P=0, a=0, b=3)
    @test_throws AssertionError(_ErrMsg.SANE_PARAMS_A) Collatz.collatz_function(1, P=1, a=0, b=3)
end


# Test function reverse_collatz_function(n::Integer; P::Integer=2, a::Integer=3, b::Integer=1)
@testset verbose = true "reverse_collatz_function" begin
    # Default (P,a,b); 0 trap [as b is not a multiple of a]
    @test Collatz.reverse_collatz_function(0) == [0]
    # Default (P,a,b); 1 cycle; positives
    @test Collatz.reverse_collatz_function(1) == [2]
    @test Collatz.reverse_collatz_function(4) == [1, 8]
    @test Collatz.reverse_collatz_function(2) == [4]
    # Default (P,a,b); -1 cycle; negatives
    @test Collatz.reverse_collatz_function(-1) == [-2]
    @test Collatz.reverse_collatz_function(-2) == [-4, -1]
    # Test a wider modulo sweep by upping P to 5, a to 2, and b to 3.
    @test Collatz.reverse_collatz_function(1, P=5, a=2, b=3) == [-1, 5]
    @test Collatz.reverse_collatz_function(2, P=5, a=2, b=3) == [10]
    @test Collatz.reverse_collatz_function(3, P=5, a=2, b=3) == [15]  # also tests !0
    @test Collatz.reverse_collatz_function(4, P=5, a=2, b=3) == [20]
    @test Collatz.reverse_collatz_function(5, P=5, a=2, b=3) == [1, 25]
    # Test negative P, a and b. %, used in the function, is "floor" in python
    # rather than the more reasonable euclidean, but we only use it's (0 mod P)
    # conjugacy class to determine functionality, so the flooring for negative P
    # doesn't cause any issue.
    @test Collatz.reverse_collatz_function(1, P=-3, a=-2, b=-5) == [-3]  # != [-3, -3]
    @test Collatz.reverse_collatz_function(2, P=-3, a=-2, b=-5) == [-6]
    @test Collatz.reverse_collatz_function(3, P=-3, a=-2, b=-5) == [-9, -4]
    # Set P and a to 0 to @test on __assert_sane_parameterisation
    @test_throws AssertionError(_ErrMsg.SANE_PARAMS_P) Collatz.reverse_collatz_function(1, P=0, a=2, b=3)
    @test_throws AssertionError(_ErrMsg.SANE_PARAMS_P) Collatz.reverse_collatz_function(1, P=0, a=0, b=3)
    @test_throws AssertionError(_ErrMsg.SANE_PARAMS_A) Collatz.reverse_collatz_function(1, P=1, a=0, b=3)
    # If b is a multiple of a, but not of Pa, then 0 can have a reverse.
    @test Collatz.reverse_collatz_function(0, P=17, a=2, b=-6) == [0, 3]
    @test Collatz.reverse_collatz_function(0, P=17, a=2, b=102) == [0]
end


# Test function hailstone_sequence(initial_value::Integer; P::Integer=2, a::Integer=3, b::Integer=1, max_total_stopping_time::Integer=1000, total_stopping_time::Bool=true, verbose::Bool=true)
@testset verbose = true "hailstone_sequence" begin
    # Test 0's immediated termination.
    @test Collatz.hailstone_sequence(0) == [[_CC.ZERO_STOP, 0]]
    @test Collatz.hailstone_sequence(0, verbose=false) == [0]
    # The cycle containing 1 wont yield a cycle termination, as 1 is considered
    # the "total stop" that is the special case termination.
    @test Collatz.hailstone_sequence(1) == [[_CC.TOTAL_STOPPING_TIME, 0]]
    @test Collatz.hailstone_sequence(1, verbose=false) == [1]
    # Test the 3 known default parameter's cycles (ignoring [1,4,2])
    # If not verbose, then the result will be the cycle plus the final value
    # being the start of the cycle. If verbose, then the output will be the
    # values not in the cycle, a CC flag, then the cycle and another CC flag.
    for kc in [kc for kc in _KNOWN_CYCLES if !(1 in kc)]
        _temp_kc = deepcopy(kc); push!(_temp_kc, _temp_kc[1])
        @test Collatz.hailstone_sequence(kc[1], verbose=false) == _temp_kc
        @test Collatz.hailstone_sequence(kc[1]) == [_CC.CYCLE_INIT, kc, [_CC.CYCLE_LENGTH, length(kc)]]
    end
    # Test the lead into a cycle by entering two of the cycles.
    seq = [kc for kc in _KNOWN_CYCLES if -5 in kc][1]
    seq = append!(append!([seq[2]*4, seq[2]*2], seq[2:length(seq)]), [seq[1]])
    @test Collatz.hailstone_sequence(-56, verbose=false) == push!(deepcopy(seq), seq[3])
    @test Collatz.hailstone_sequence(-56) == [seq[1], seq[2], _CC.CYCLE_INIT, seq[3:length(seq)], [_CC.CYCLE_LENGTH, length(seq)-2]]
    seq = [kc for kc in _KNOWN_CYCLES if -17 in kc][1]
    seq = append!(append!([seq[2]*4, seq[2]*2], seq[2:length(seq)]), [seq[1]])
    @test Collatz.hailstone_sequence(-200, verbose=false) == push!(deepcopy(seq), seq[3])
    @test Collatz.hailstone_sequence(-200) == [seq[1], seq[2], _CC.CYCLE_INIT, seq[3:length(seq)], [_CC.CYCLE_LENGTH, length(seq)-2]]
    # 1's cycle wont yield a description of it being a "cycle" as far as the
    # hailstones are concerned, which is to be expected, so..
    @test Collatz.hailstone_sequence(4, verbose=false) == [4, 2, 1]
    @test Collatz.hailstone_sequence(4) == [4, 2, 1, [_CC.TOTAL_STOPPING_TIME, 2]]
    @test Collatz.hailstone_sequence(16, verbose=false) == [16, 8, 4, 2, 1]
    @test Collatz.hailstone_sequence(16) == [16, 8, 4, 2, 1, [_CC.TOTAL_STOPPING_TIME, 4]]
    # Test the regular stopping time check.
    @test Collatz.hailstone_sequence(4, total_stopping_time=false) == [4, 2, [_CC.STOPPING_TIME, 1]]
    @test Collatz.hailstone_sequence(5, total_stopping_time=false) == [5, 16, 8, 4, [_CC.STOPPING_TIME, 3]]
    # Test small max_total_stopping_time: (minimum internal value is one)
    @test Collatz.hailstone_sequence(4, max_total_stopping_time=-100) == [4, 2, [_CC.MAX_STOP_OOB, 1]]
    # Test the zero stop mid hailing. This wont happen with default params tho.
    @test Collatz.hailstone_sequence(3, P=2, a=3, b=-9) == [3, 0, [_CC.ZERO_STOP, -1]]
    # Lastly, while the function wont let you use a P value of 0, 1 and -1 are
    # still allowed, although they will generate immediate 1 or 2 length cycles
    # respectively, so confirm the behaviour of each of these hailstones.
    @test Collatz.hailstone_sequence(3, P=1, verbose=false) == [3, 3]
    @test Collatz.hailstone_sequence(3, P=-1, verbose=false) == [3, -3, 3]
    # Set P and a to 0 to @test on __assert_sane_parameterisation
    @test_throws AssertionError(_ErrMsg.SANE_PARAMS_P) Collatz.hailstone_sequence(1, P=0, a=2, b=3)
    @test_throws AssertionError(_ErrMsg.SANE_PARAMS_P) Collatz.hailstone_sequence(1, P=0, a=0, b=3)
    @test_throws AssertionError(_ErrMsg.SANE_PARAMS_A) Collatz.hailstone_sequence(1, P=1, a=0, b=3)
end


# Test function stopping_time(initial_value::Integer; P::Integer=2, a::Integer=3, b::Integer=1, max_stopping_time::Integer=1000, total_stopping_time::Bool=false)
@testset verbose = true "stopping_time" begin
    # Test 0's immediated termination.
    @test Collatz.stopping_time(0) == 0
    # The cycle containing 1 wont yield a cycle termination, as 1 is considered
    # the "total stop" that is the special case termination.
    @test Collatz.stopping_time(1) == 0
    # Test the 3 known default parameter's cycles (ignoring [1,4,2])
    # If not verbose, then the result will be the cycle plus the final value
    # being the start of the cycle. If verbose, then the output will be the
    # values not in the cycle, a CC flag, then the cycle and another CC flag.
    for c in [kc for kc in _KNOWN_CYCLES if !(1 in kc)]
        @test Collatz.stopping_time(c[1], total_stopping_time=true) == Base.Inf
    end
    # Test the lead into a cycle by entering two of the cycles. -56;-5, -200;-17
    @test Collatz.stopping_time(-56, total_stopping_time=true) == Base.Inf
    @test Collatz.stopping_time(-200, total_stopping_time=true) == Base.Inf
    # 1's cycle wont yield a description of it being a "cycle" as far as the
    # hailstones are concerned, which is to be expected, so..
    @test Collatz.stopping_time(4, total_stopping_time=true) == 2
    @test Collatz.stopping_time(16, total_stopping_time=true) == 4
    # Test the regular stopping time check.
    @test Collatz.stopping_time(4) == 1
    @test Collatz.stopping_time(5) == 3
    # Test small max_total_stopping_time: (minimum internal value is one)
    @test Collatz.stopping_time(5, max_stopping_time=-100) == nothing
    # Test the zero stop mid hailing. This wont happen with default params tho.
    @test Collatz.stopping_time(3, P=2, a=3, b=-9) == -1
    # Lastly, while the function wont let you use a P value of 0, 1 and -1 are
    # still allowed, although they will generate immediate 1 or 2 length cycles
    # respectively, so confirm the behaviour of each of these stopping times.
    @test Collatz.stopping_time(3, P=1) == Base.Inf
    @test Collatz.stopping_time(3, P=-1) == Base.Inf
    # One last one for the fun of it..
    @test Collatz.stopping_time(27, total_stopping_time=true) == 111
    # And for a bit more fun, common trajectories on
    for x in 0:0  #TODO: Extend this up to 0:4 when hailstone is made arbitrary integer safe.
        @test Collatz.stopping_time(27+576460752303423488*x) == 96
    end
    # Set P and a to 0 to @test on __assert_sane_parameterisation
    @test_throws AssertionError(_ErrMsg.SANE_PARAMS_P) Collatz.stopping_time(1, P=0, a=2, b=3)
    @test_throws AssertionError(_ErrMsg.SANE_PARAMS_P) Collatz.stopping_time(1, P=0, a=0, b=3)
    @test_throws AssertionError(_ErrMsg.SANE_PARAMS_A) Collatz.stopping_time(1, P=1, a=0, b=3)
end


# Test function tree_graph(initial_value::Integer, max_orbit_distance::Integer; P::Integer=2, a::Integer=3, b::Integer=1, __cycle_prevention::Union{Set{Integer},Nothing}=nothing)
@testset verbose = true "tree_graph" begin
    C = _CC.CYCLE_INIT  # Shorthand the cycle terminus
    D = Dict()  # Just to colourise the below in the editor..
    # # The default zero trap
    # @test Collatz.tree_graph(0, 0) == {0:D}
    # @test Collatz.tree_graph(0, 1) == {0:{C:0}}
    # @test Collatz.tree_graph(0, 2) == {0:{C:0}}
    # # The roundings of the 1 cycle.
    # @test Collatz.tree_graph(1, 1) == {1:{2:D}}
    # @test Collatz.tree_graph(1, 0) == {1:D}
    # @test Collatz.tree_graph(1, 1) == {1:{2:D}}
    # @test Collatz.tree_graph(1, 2) == {1:{2:{4:D}}}
    # @test Collatz.tree_graph(1, 3) == {1:{2:{4:{C:1,8:D}}}}
    # @test Collatz.tree_graph(2, 3) == {2:{4:{1:{C:2},8:{16:D}}}}
    # @test Collatz.tree_graph(4, 3) == {4:{1:{2:{C:4}},8:{16:{5:D,32:D}}}}
    # # The roundings of the -1 cycle
    # @test Collatz.tree_graph(-1, 1) == {-1:{-2:D}}
    # @test Collatz.tree_graph(-1, 2) == {-1:{-2:{-4:D,C:-1}}}
    # # Test a wider modulo sweep by upping P to 5, a to 2, and b to 3.
    # T = lambda x,y: {1:{-1:x,5:y}}
    # orb_1 = T(D,D)
    # orb_2 = T({-5:D,-2:D},{C:1,25:D})
    # T = lambda x,y,z: {1:{-1:{-5:x,-2:y},5:{C:1,25:z}}}
    # orb_3 = T({-25:D,-4:D},{-10:D},{11:D,125:D})
    # @test Collatz.tree_graph(1, 1, P=5, a=2, b=3) == orb_1
    # @test Collatz.tree_graph(1, 2, P=5, a=2, b=3) == orb_2
    # @test Collatz.tree_graph(1, 3, P=5, a=2, b=3) == orb_3
    # # Test negative P, a and b.
    # orb_1 = {1:{-3:D}}
    # T = lambda x,y: {1:{-3:{-1:x,9:y}}}
    # orb_2 = T(D,D)
    # orb_3 = T({-2:D,3:D},{-27:D,-7:D})
    # @test Collatz.tree_graph(1, 1, P=-3, a=-2, b=-5) == orb_1
    # @test Collatz.tree_graph(1, 2, P=-3, a=-2, b=-5) == orb_2
    # @test Collatz.tree_graph(1, 3, P=-3, a=-2, b=-5) == orb_3
    # Set P and a to 0 to @test on __assert_sane_parameterisation
    @test_throws AssertionError(_ErrMsg.SANE_PARAMS_P) Collatz.tree_graph(1, 1, P=0, a=2, b=3)
    @test_throws AssertionError(_ErrMsg.SANE_PARAMS_P) Collatz.tree_graph(1, 1, P=0, a=0, b=3)
    @test_throws AssertionError(_ErrMsg.SANE_PARAMS_A) Collatz.tree_graph(1, 1, P=1, a=0, b=3)
    # If b is a multiple of a, but not of Pa, then 0 can have a reverse.
    @test Collatz.tree_graph(0, 1, P=17, a=2, b=-6) == Dict(0=>Dict(C=>0,3=>D))
    @test Collatz.tree_graph(0, 1, P=17, a=2, b=102) == Dict(0=>Dict(C=>0))
end

println("################################################################################")
