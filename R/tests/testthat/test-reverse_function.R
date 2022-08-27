test_that("reverse_function_ZeroTrap", {
    # Default (P,a,b) 0 trap [as b is not a multiple of a]
    expect_equal(reverse_function(0), list(0))
})

test_that("reverse_function_OneCycle", {
    # Default (P,a,b) 1 cycle positives
    expect_equal(reverse_function(1), list(2))
    expect_equal(reverse_function(4), list(8, 1))
    expect_equal(reverse_function(2), list(4))
})

test_that("reverse_function_NegativeOneCycle", {
    # Default (P,a,b) -1 cycle negatives
    expect_equal(reverse_function(-1), list(-2))
    expect_equal(reverse_function(-2), list(-4, -1))
})

test_that("reverse_function_WiderModuloSweep", {
    # Test a wider modulo sweep by upping P to 5, a to 2, and b to 3.
    expect_equal(reverse_function(1, 5, 2, 3), list(5, -1))
    expect_equal(reverse_function(2, 5, 2, 3), list(10))
    expect_equal(reverse_function(3, 5, 2, 3), list(15)) # also tests !0
    expect_equal(reverse_function(4, 5, 2, 3), list(20))
    expect_equal(reverse_function(5, 5, 2, 3), list(25, 1))
})

test_that("reverse_function_NegativeParamterisation", {
    # Test negative P, a and b. %, used in the function, is "floor" in python
    # rather than the more reasonable euclidean, but we only use it's (0 mod P)
    # conjugacy class to determine functionality, so the flooring for negative P
    # doesn't cause any issue.
    expect_equal(reverse_function(1, -3, -2, -5), list(-3)) # != [-3, -3]
    expect_equal(reverse_function(2, -3, -2, -5), list(-6))
    expect_equal(reverse_function(3, -3, -2, -5), list(-9, -4))
})

test_that("reverse_function_ZeroReversesOnB", {
    # If b is a multiple of a, but not of Pa, then 0 can have a reverse.
    expect_equal(reverse_function(0, 17, 2, -6), list(0, 3))
    expect_equal(reverse_function(0, 17, 2, 102), list(0))
})

test_that("reverse_function_AssertSaneParameterisation", {
    # Set P and a to 0 to assert on __assert_sane_parameterisation
    expect_error(reverse_function(1, 0, 2, 3), Collatz$SaneParameterErrMsg$P)
    expect_error(reverse_function(1, 0, 0, 3), Collatz$SaneParameterErrMsg$P)
    expect_error(reverse_function(1, 1, 0, 3), Collatz$SaneParameterErrMsg$A)
})
