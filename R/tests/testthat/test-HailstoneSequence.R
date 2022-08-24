expected_hailstone_sequence <- function(hail, expected_sequence, expected_terminal_condition, expected_terminal_status){
    expect_equal(hail$values, expected_sequence)
    expect_equal(hail$terminalCondition, expected_terminal_condition)
    expect_equal(hail$terminalStatus, expected_terminal_status)
}

test_that("HailstoneSequence_ZeroTrap", {
    # Test 0's immediated termination.
    expected_hailstone_sequence(hailstone_sequence(0), list(0), Collatz$SequenceState$ZERO_STOP, 0)
})

test_that("HailstoneSequence_OnesCycleOnlyYieldsATotalStop", {
    # The cycle containing 1 wont yield a cycle termination, as 1 is considered
    # the "total stop" that is the special case termination.
    expected_hailstone_sequence(hailstone_sequence(1), list(1), Collatz$SequenceState$TOTAL_STOPPING_TIME, 0)
    # 1's cycle wont yield a description of it being a "cycle" as far as the
    # hailstones are concerned, which is to be expected, so..
    expected_hailstone_sequence(hailstone_sequence(4), list(4, 2, 1), Collatz$SequenceState$TOTAL_STOPPING_TIME, 2)
    expected_hailstone_sequence(hailstone_sequence(16), list(16, 8, 4, 2, 1), Collatz$SequenceState$TOTAL_STOPPING_TIME, 4)
})

test_that("HailstoneSequence_KnownCycles", {
    # Test the 3 known default parameter's cycles (ignoring [1,4,2])
    for (kc in Collatz$KNOWN.CYCLES) {
        if (!(1 %in% kc)) {
            expected_hailstone_sequence(hailstone_sequence(kc[[1]]), append(kc, kc[[1]]), Collatz$SequenceState$CYCLE_LENGTH, length(kc))
        }
    }
})

test_that("HailstoneSequence_Minus56", {
    # Test the lead into a cycle by entering two of the cycles -5
    cycle <- Collatz$KNOWN.CYCLES[[3]]
    rotated <- append(cycle[2:length(cycle)], cycle[1:2])
    expected <- append(list(cycle[[2]]*4, cycle[[2]]*2), rotated)
    expected_hailstone_sequence(hailstone_sequence(-56), expected, Collatz$SequenceState$CYCLE_LENGTH, length(cycle))
})

test_that("HailstoneSequence_Minus200", {
    # Test the lead into a cycle by entering two of the cycles -17
    cycle <- Collatz$KNOWN.CYCLES[[4]]
    rotated <- append(cycle[2:length(cycle)], cycle[1:2])
    expected <- append(list(cycle[[2]]*4, cycle[[2]]*2), rotated)
    expected_hailstone_sequence(hailstone_sequence(-200), expected, Collatz$SequenceState$CYCLE_LENGTH, length(cycle))
})

# test_that("HailstoneSequence_RegularStoppingTime", {
#     HailstoneSequence hail
#     # Test the regular stopping time check.
#     hail <- wrapHailstoneSequence(4, 1000, FALSE)
#     expected_hailstone_sequence(hail, list(4, 2), Collatz$SequenceState$STOPPING_TIME, 1)
#     hail <- wrapHailstoneSequence(5, 1000, FALSE)
#     expected_hailstone_sequence(hail, list(5, 16, 8, 4), Collatz$SequenceState$STOPPING_TIME, 3)
# })

# test_that("HailstoneSequence_NegativeMaxTotalStoppingTime", {
#     # Test small max total stopping time: (minimum internal value is one)
#     HailstoneSequence hail <- wrapHailstoneSequence(4, -100, TRUE)
#     expected_hailstone_sequence(hail, list(4, 2), Collatz$SequenceState$MAX_STOP_OUT_OF_BOUNDS, 1)
# }

# test_that("HailstoneSequence_ZeroStopMidHail", {
#     # Test the zero stop mid hailing. This wont happen with default params tho.
#     HailstoneSequence hail <- wrapHailstoneSequence(3, 2, 3, -9, 100, TRUE)
#     expected_hailstone_sequence(hail, list(3, 0), Collatz$SequenceState$ZERO_STOP, -1)
# })

# test_that("HailstoneSequence_UnitaryPCausesAlmostImmediateCycles", {
#     # Lastly, while the function wont let you use a P value of 0, 1 and -1 are
#     # still allowed, although they will generate immediate 1 or 2 length cycles
#     # respectively, so confirm the behaviour of each of these hailstones.
#     hail <- wrapHailstoneSequence(3, 1, 3, 1, 100, TRUE)
#     expected_hailstone_sequence(hail, list(3, 3), Collatz$SequenceState$CYCLE_LENGTH, 1)
#     hail <- wrapHailstoneSequence(3, -1, 3, 1, 100, TRUE)
#     expected_hailstone_sequence(hail, list(3, -3, 3), Collatz$SequenceState$CYCLE_LENGTH, 2)
# })

test_that("HailstoneSequence_AssertSaneParameterisation", {
    # Set P and a to 0 to assert on __assert_sane_parameterisation
    expect_error(hailstone_sequence(1, 0, 2, 3, 1000, TRUE), Collatz$SaneParameterErrMsg$P)
    expect_error(hailstone_sequence(1, 0, 0, 3, 1000, TRUE), Collatz$SaneParameterErrMsg$P)
    expect_error(hailstone_sequence(1, 1, 0, 3, 1000, TRUE), Collatz$SaneParameterErrMsg$A)
})
