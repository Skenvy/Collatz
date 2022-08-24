test_that("StoppingTime_ZeroTrap", {
    # Test 0's immediated termination.
    expect_equal(stopping_time(0), 0)
})

# test_that("StoppingTime_OnesCycleOnlyYieldsATotalStop", {
#     # The cycle containing 1 wont yield a cycle termination, as 1 is considered
#     # the "total stop" that is the special case termination.
#     expect_equal(Double.valueOf(0), stopping_time(1))
#     # 1's cycle wont yield a description of it being a "cycle" as far as the
#     # hailstones are concerned, which is to be expected, so..
#     expect_equal(Double.valueOf(2), stopping_time(4, 100, true))
#     expect_equal(Double.valueOf(4), stopping_time(16, 100, true))
# })

# test_that("StoppingTime_KnownCyclesYieldInfinity", {
#     # Test the 3 known default parameter's cycles (ignoring [1,4,2])
#     for(BigInteger[] kc : Collatz.KNOWN_CYCLES){
#         if(!Arrays.asList(kc).contains(BigInteger.ONE)){
#             for(BigInteger c : kc){
#                 expect_equal(Double.valueOf(Double.POSITIVE_INFINITY), stopping_time(c.longValue(), 100, true))
#             }
#         }
#     }
# })

# test_that("StoppingTime_KnownCycleLeadIns", {
#     # Test the lead into a cycle by entering two of the cycles. -56;-5, -200;-17
#     expect_equal(Double.valueOf(Double.POSITIVE_INFINITY), stopping_time(-56, 100, true))
#     expect_equal(Double.valueOf(Double.POSITIVE_INFINITY), stopping_time(-200, 100, true))
# })

# test_that("StoppingTime_RegularStoppingTime", {
#     # Test the regular stopping time check.
#     expect_equal(Double.valueOf(1), stopping_time(4))
#     expect_equal(Double.valueOf(3), stopping_time(5))
# })

# test_that("StoppingTime_NegativeMaxTotalStoppingTime", {
#     # Test small max total stopping time: (minimum internal value is one)
#     expect_equal(null, stopping_time(5, -100, true))
# })

# test_that("StoppingTime_ZeroStopMidHail", {
#     # Test the zero stop mid hailing. This wont happen with default params tho.
#     expect_equal(Double.valueOf(-1), stopping_time(3, 2, 3, -9, 100, false))
# })

# test_that("StoppingTime_UnitaryPCausesAlmostImmediateCycles", {
#     # Lastly, while the function wont let you use a P value of 0, 1 and -1 are
#     # still allowed, although they will generate immediate 1 or 2 length cycles
#     # respectively, so confirm the behaviour of each of these stopping times.
#     expect_equal(Double.valueOf(Double.POSITIVE_INFINITY), stopping_time(3, 1, 3, 1, 100, false))
#     expect_equal(Double.valueOf(Double.POSITIVE_INFINITY), stopping_time(3, -1, 3, 1, 100, false))
# })

# test_that("StoppingTime_MultiplesOf576460752303423488Plus27", {
#     # One last one for the fun of it..
#     expect_equal(Double.valueOf(111), stopping_time(27, 1000, true))
#     # # And for a bit more fun, common trajectories on
#     for(int k = 0; k < 5; k++){
#         BigInteger input = BigInteger.valueOf(27).add(BigInteger.valueOf(k).multiply(new BigInteger("576460752303423488")))
#         Double stop = Collatz.stoppingTime(input, Collatz.DEFAULT_P, Collatz.DEFAULT_A, Collatz.DEFAULT_B, 1000, false)
#         expect_equal(Double.valueOf(96), stop)
#     }
# })

test_that("StoppingTime_AssertSaneParameterisation", {
    # Set P and a to 0 to assert on __assert_sane_parameterisation
    expect_error(stopping_time(1, 0, 2, 3, 1000, false), Collatz$SaneParameterErrMsg$P)
    expect_error(stopping_time(1, 0, 0, 3, 1000, false), Collatz$SaneParameterErrMsg$P)
    expect_error(stopping_time(1, 1, 0, 3, 1000, false), Collatz$SaneParameterErrMsg$A)
})
