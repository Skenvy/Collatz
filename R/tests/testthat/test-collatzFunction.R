test_that("Function_ZeroTrap", {
    # Default/Any (P,a,b); 0 trap
    expect_equal(collatzFunction(0), 0)
})

test_that("Function_OneCycle", {
    # Default/Any (P,a,b); 1 cycle; positives
    expect_equal(collatzFunction(1), 4)
    expect_equal(collatzFunction(4), 2)
    expect_equal(collatzFunction(2), 1)
})

test_that("Function_NegativeOneCycle", {
    # Default/Any (P,a,b); -1 cycle; negatives
    expect_equal(collatzFunction(-1), -2)
    expect_equal(collatzFunction(-2), -1)
})

test_that("Function_WiderModuloSweep", {
    # Test a wider modulo sweep by upping P to 5, a to 2, and b to 3.
    expect_equal(collatzFunction(1, 5, 2, 3), 5)
    expect_equal(collatzFunction(2, 5, 2, 3), 7)
    expect_equal(collatzFunction(3, 5, 2, 3), 9)
    expect_equal(collatzFunction(4, 5, 2, 3), 11)
    expect_equal(collatzFunction(5, 5, 2, 3), 1)
})

test_that("Function_NegativeParamterisation", {
    # Test negative P, a and b. Modulo, used in the function, has ambiguous functionality
    # rather than the more definite euclidean, but we only use it's (0 mod P)
    # conjugacy class to determine functionality, so the flooring for negative P
    # doesn't cause any issue.
    expect_equal(collatzFunction(1, -3, -2, -5), -7)
    expect_equal(collatzFunction(2, -3, -2, -5), -9)
    expect_equal(collatzFunction(3, -3, -2, -5), -1)
})

test_that("Function_AssertSaneParameterisation", {
    # Set P and a to 0 to assert on assertSaneParameterisation
    expect_error(collatzFunction(1, 0, 2, 3), Collatz$SaneParameterErrMsg$P)
    expect_error(collatzFunction(1, 0, 0, 3), Collatz$SaneParameterErrMsg$P)
    expect_error(collatzFunction(1, 1, 0, 3), Collatz$SaneParameterErrMsg$A)
})
