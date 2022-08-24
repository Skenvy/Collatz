test_that("StoppingTime_ZeroTrap", {
    # Test 0's immediated termination.
    expect_equal(stopping_time(0), 0)
})

test_that("StoppingTime_OnesCycleOnlyYieldsATotalStop", {
    # The cycle containing 1 wont yield a cycle termination, as 1 is considered
    # the "total stop" that is the special case termination.
    expect_equal(stopping_time(1), 0)
    # 1's cycle wont yield a description of it being a "cycle" as far as the
    # hailstones are concerned, which is to be expected, so..
    expect_equal(stopping_time(4, total_stopping_time=TRUE), 2)
    expect_equal(stopping_time(16, total_stopping_time=TRUE), 4)
})

test_that("StoppingTime_KnownCyclesYieldInfinity", {
    # Test the 3 known default parameter's cycles (ignoring [1,4,2])
    for (kc in Collatz$KNOWN.CYCLES) {
        if (!(1 %in% kc)) {
            for(val in kc){
                expect_equal(stopping_time(val, total_stopping_time=TRUE), Inf)
            }
        }
    }
})

test_that("StoppingTime_KnownCycleLeadIns", {
    # Test the lead into a cycle by entering two of the cycles. -56;-5, -200;-17
    expect_equal(stopping_time(-56, total_stopping_time=TRUE), Inf)
    expect_equal(stopping_time(-200, total_stopping_time=TRUE), Inf)
})

test_that("StoppingTime_RegularStoppingTime", {
    # Test the regular stopping time check.
    expect_equal(stopping_time(4), 1)
    expect_equal(stopping_time(5), 3)
})

test_that("StoppingTime_NegativeMaxTotalStoppingTime", {
    # Test small max total stopping time: (minimum internal value is one)
    expect_equal(stopping_time(5, max_stopping_time=-100, total_stopping_time=TRUE), NaN)
})

test_that("StoppingTime_ZeroStopMidHail", {
    # Test the zero stop mid hailing. This wont happen with default params tho.
    expect_equal(stopping_time(3, 2, 3, -9, 100, FALSE), -1)
})

test_that("StoppingTime_UnitaryPCausesAlmostImmediateCycles", {
    # Lastly, while the function wont let you use a P value of 0, 1 and -1 are
    # still allowed, although they will generate immediate 1 or 2 length cycles
    # respectively, so confirm the behaviour of each of these stopping times.
    expect_equal(stopping_time(3, 1, 3, 1, 100, FALSE), Inf)
    expect_equal(stopping_time(3, -1, 3, 1, 100, FALSE), Inf)
})

# test_that("StoppingTime_MultiplesOf576460752303423488Plus27", {
#     # One last one for the fun of it..
#     expect_equal(stopping_time(27, max_stopping_time=1000, total_stopping_time=TRUE), 111)
#     # # And for a bit more fun, common trajectories on
#     for (k in 0:4) {
#         expect_equal(stopping_time(27+(k*gmp::as.bigz("576460752303423488"))), 96)
#     }
# })

test_that("StoppingTime_AssertSaneParameterisation", {
    # Set P and a to 0 to assert on __assert_sane_parameterisation
    expect_error(stopping_time(1, 0, 2, 3, 1000, FALSE), Collatz$SaneParameterErrMsg$P)
    expect_error(stopping_time(1, 0, 0, 3, 1000, FALSE), Collatz$SaneParameterErrMsg$P)
    expect_error(stopping_time(1, 1, 0, 3, 1000, FALSE), Collatz$SaneParameterErrMsg$A)
})
