test_that("ReverseFunction_ZeroTrap", {
    # Default (P,a,b) 0 trap [as b is not a multiple of a]
    expect_equal(reverseFunction(0), c(0))
})

test_that("ReverseFunction_OneCycle", {
    # Default (P,a,b) 1 cycle positives
    expect_equal(reverseFunction(1), c(2))
    expect_equal(reverseFunction(4), c(8, 1))
    expect_equal(reverseFunction(2), c(4))
})

test_that("ReverseFunction_NegativeOneCycle", {
    # Default (P,a,b) -1 cycle negatives
    expect_equal(reverseFunction(-1), c(-2))
    expect_equal(reverseFunction(-2), c(-4, -1))
})

test_that("ReverseFunction_WiderModuloSweep", {
    # Test a wider modulo sweep by upping P to 5, a to 2, and b to 3.
    expect_equal(reverseFunction(1, 5, 2, 3), c(5, -1))
    expect_equal(reverseFunction(2, 5, 2, 3), c(10))
    expect_equal(reverseFunction(3, 5, 2, 3), c(15)) # also tests !0
    expect_equal(reverseFunction(4, 5, 2, 3), c(20))
    expect_equal(reverseFunction(5, 5, 2, 3), c(25, 1))
})

test_that("ReverseFunction_NegativeParamterisation", {
    # Test negative P, a and b. %, used in the function, is "floor" in python
    # rather than the more reasonable euclidean, but we only use it's (0 mod P)
    # conjugacy class to determine functionality, so the flooring for negative P
    # doesn't cause any issue.
    expect_equal(reverseFunction(1, -3, -2, -5), c(-3)) # != [-3, -3]
    expect_equal(reverseFunction(2, -3, -2, -5), c(-6))
    expect_equal(reverseFunction(3, -3, -2, -5), c(-9, -4))
})

test_that("ReverseFunction_ZeroReversesOnB", {
    # If b is a multiple of a, but not of Pa, then 0 can have a reverse.
    expect_equal(reverseFunction(0, 17, 2, -6), c(0, 3))
    expect_equal(reverseFunction(0, 17, 2, 102), c(0))
})

test_that("ReverseFunction_AssertSaneParameterisation", {
    # Set P and a to 0 to assert on __assert_sane_parameterisation
    expect_error(reverseFunction(1, 0, 2, 3), Collatz$SaneParameterErrMsg$P)
    expect_error(reverseFunction(1, 0, 0, 3), Collatz$SaneParameterErrMsg$P)
    expect_error(reverseFunction(1, 1, 0, 3), Collatz$SaneParameterErrMsg$A)
})
