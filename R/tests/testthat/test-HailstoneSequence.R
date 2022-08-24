expected_hailstone_sequence <- function(hail, expected_sequence, expected_terminal_condition, expected_terminal_status){
    expect_equal(hail$values, expected_sequence)
    expect_equal(hail$terminalCondition, expected_terminal_condition)
    expect_equal(hail$terminalStatus, expected_terminal_status)
}

test_that("HailstoneSequence_ZeroTrap", {
    # Test 0's immediated termination.
    expected_hailstone_sequence(hailstone_sequence(0), list(0), Collatz$SequenceState$ZERO_STOP, 0)
})

# test_that("HailstoneSequence_OnesCycleOnlyYieldsATotalStop", {
#     HailstoneSequence hail;
#     # The cycle containing 1 wont yield a cycle termination, as 1 is considered
#     # the "total stop" that is the special case termination.
#     hail <- wrapHailstoneSequence(1);
#     expected_hailstone_sequence(hail, new long[]{1}, Collatz.SequenceState.TOTAL_STOPPING_TIME, 0);
#     # 1's cycle wont yield a description of it being a "cycle" as far as the
#     # hailstones are concerned, which is to be expected, so..
#     hail <- wrapHailstoneSequence(4);
#     expected_hailstone_sequence(hail, new long[]{4, 2, 1}, Collatz.SequenceState.TOTAL_STOPPING_TIME, 2);
#     hail <- wrapHailstoneSequence(16);
#     expected_hailstone_sequence(hail, new long[]{16, 8, 4, 2, 1}, Collatz.SequenceState.TOTAL_STOPPING_TIME, 4);
# })

# test_that("HailstoneSequence_KnownCycles", {
#     HailstoneSequence hail;
#     # Test the 3 known default parameter's cycles (ignoring [1,4,2])
#     for(BigInteger[] kc : Collatz.KNOWN_CYCLES){
#         if(!Arrays.asList(kc).contains(BigInteger.ONE)){
#             hail <- Collatz.hailstoneSequence(kc[0], 1000);
#             BigInteger[] expected <- new BigInteger[kc.length+1];
#             for(int k <- 0; k < kc.length; k++){
#                 expected[k] <- kc[k];
#             }
#             expected[kc.length] <- kc[0];
#             expected_hailstone_sequence(hail, wrapBigIntArr(expected), Collatz.SequenceState.CYCLE_LENGTH, kc.length);
#         }
#     }
# })

# test_that("HailstoneSequence_Minus56", {
#     # Test the lead into a cycle by entering two of the cycles; -5
#     BigInteger[] seq <- Collatz.KNOWN_CYCLES[2].clone();
#     ArrayList<BigInteger> _seq <- new ArrayList<BigInteger>();
#     _seq.add(seq[1].multiply(BigInteger.valueOf(4)));
#     _seq.add(seq[1].multiply(BigInteger.valueOf(2)));
#     List<BigInteger> _rotInnerSeq <- Arrays.asList(seq);
#     Collections.rotate(_rotInnerSeq, -1);
#     _seq.addAll(_rotInnerSeq);
#     _seq.add(seq[0]); # The rotate also acts on seq, so we add [0] instead of [1]
#     long[] expected <- wrapBigIntArr(_seq.toArray(BigInteger[]::new));
#     HailstoneSequence hail <- wrapHailstoneSequence(-56);
#     expected_hailstone_sequence(hail, expected, Collatz.SequenceState.CYCLE_LENGTH, seq.length);
# })

# test_that("HailstoneSequence_Minus200", {
#     # Test the lead into a cycle by entering two of the cycles; -17
#     BigInteger[] seq <- Collatz.KNOWN_CYCLES[3].clone();
#     ArrayList<BigInteger> _seq <- new ArrayList<BigInteger>();
#     _seq.add(seq[1].multiply(BigInteger.valueOf(4)));
#     _seq.add(seq[1].multiply(BigInteger.valueOf(2)));
#     List<BigInteger> _rotInnerSeq <- Arrays.asList(seq);
#     Collections.rotate(_rotInnerSeq, -1);
#     _seq.addAll(_rotInnerSeq);
#     _seq.add(seq[0]); # The rotate also acts on seq, so we add [0] instead of [1]
#     long[] expected <- wrapBigIntArr(_seq.toArray(BigInteger[]::new));
#     HailstoneSequence hail <- wrapHailstoneSequence(-200);
#     expected_hailstone_sequence(hail, expected, Collatz.SequenceState.CYCLE_LENGTH, seq.length);
# })

# test_that("HailstoneSequence_RegularStoppingTime", {
#     HailstoneSequence hail;
#     # Test the regular stopping time check.
#     hail <- wrapHailstoneSequence(4, 1000, false);
#     expected_hailstone_sequence(hail, new long[]{4, 2}, Collatz.SequenceState.STOPPING_TIME, 1);
#     hail <- wrapHailstoneSequence(5, 1000, false);
#     expected_hailstone_sequence(hail, new long[]{5, 16, 8, 4}, Collatz.SequenceState.STOPPING_TIME, 3);
# })

# test_that("HailstoneSequence_NegativeMaxTotalStoppingTime", {
#     # Test small max total stopping time: (minimum internal value is one)
#     HailstoneSequence hail <- wrapHailstoneSequence(4, -100, true);
#     expected_hailstone_sequence(hail, new long[]{4, 2}, Collatz.SequenceState.MAX_STOP_OUT_OF_BOUNDS, 1);
# }

# test_that("HailstoneSequence_ZeroStopMidHail", {
#     # Test the zero stop mid hailing. This wont happen with default params tho.
#     HailstoneSequence hail <- wrapHailstoneSequence(3, 2, 3, -9, 100, true);
#     expected_hailstone_sequence(hail, new long[]{3, 0}, Collatz.SequenceState.ZERO_STOP, -1);
# })

# test_that("HailstoneSequence_UnitaryPCausesAlmostImmediateCycles", {
#     HailstoneSequence hail;
#     # Lastly, while the function wont let you use a P value of 0, 1 and -1 are
#     # still allowed, although they will generate immediate 1 or 2 length cycles
#     # respectively, so confirm the behaviour of each of these hailstones.
#     hail <- wrapHailstoneSequence(3, 1, 3, 1, 100, true);
#     expected_hailstone_sequence(hail, new long[]{3, 3}, Collatz.SequenceState.CYCLE_LENGTH, 1);
#     hail <- wrapHailstoneSequence(3, -1, 3, 1, 100, true);
#     expected_hailstone_sequence(hail, new long[]{3, -3, 3}, Collatz.SequenceState.CYCLE_LENGTH, 2);
# })

# test_that("HailstoneSequence_AssertSaneParameterisation", {
#     # Set P and a to 0 to assert on __assert_sane_parameterisation
#     expect_error(HailstoneSequence(1, 0, 2, 3, 1000, true), Collatz$SaneParameterErrMsg$P)
#     expect_error(HailstoneSequence(1, 0, 0, 3, 1000, true), Collatz$SaneParameterErrMsg$P)
#     expect_error(HailstoneSequence(1, 1, 0, 3, 1000, true), Collatz$SaneParameterErrMsg$A)
# })
