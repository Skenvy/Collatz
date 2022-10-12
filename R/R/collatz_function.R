#' @include utils.R
NULL

#' The Collatz function
#'
#' Returns the output of a single application of a Collatz-esque function.
#'
#' This function will compute and return the result of applying one iteration
#' of a parameterised Collatz-esque function. Although it will operate with
#' integer inputs, for overflow safety, provide a gmp Big Integer ('bigz').
#'
#' @param n (numeric|bigz) The value on which
#' to perform the Collatz-esque function
#' @param P (numeric|bigz): Modulus used to divide
#' n, iff n is equivalent to (0 mod P). Default is 2.
#' @param a (numeric|bigz) Factor by which to multiply n. Default is 3.
#' @param b (numeric|bigz) Value to add
#' to the scaled value of n. Default is 1.
#' @returns a numeric, either in-built or a bigz from the gmp library.
#' @examples
#' # Returns the output of a single application of a Collatz-esque function.
#' # Without `gmp` or parameterisation, we can try something simple like
#' collatz_function(5)
#' collatz_function(16)
#' # If we want change the default parameterisation we can;
#' collatz_function(4, 5, 2, 3)
#' # Or if we only want to change one of them
#' collatz_function(3, a=-2)
#' # All the above work fine, but the function doesn't offer protection against
#' # overflowing integers by default. To venture into the world of arbitrary
#' # integer inputs we can use an `as.bigz` from `gmp`. Compare the two;
#' collatz_function(99999999999999999999)
#' collatz_function(as.bigz("99999999999999999999"))
#' @export
collatz_function <- function(n, P=2, a=3, b=1){
    assert_sane_parameterication(P,a,b)
    # bigq does not have a defined use for %%, so must be int or bigz
    # bigz/bigz returns a bigq even if that bigq has denominator 1
    # so we do a divq, "%/%", instead of div, to just get the bigz.
    if (n%%P == 0) (n%/%P) else ((a*n)+b)
}
