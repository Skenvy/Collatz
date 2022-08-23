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
#' @param n (numeric|bigz|bigq) The value on which
#' to perform the Collatz-esque function
#' @param P (numeric|bigz|bigq): Modulus used to divide
#' n, iff n is equivalent to (0 mod P). Default is 2.
#' @param a (numeric|bigz|bigq) Factor by which to multiply n. Default is 3.
#' @param b (numeric|bigz|bigq) Value to add
#' to the scaled value of n. Default is 1.
#' @returns a numeric, either in-built or a bigz | bigq from the gmp library.
#' If either n or P are bigz, then the result of n/P will be a bigq
#' although it's denominator(~) will return 1.
#' @export
collatz_function <- function(n, P=2, a=3, b=1){
    assert_sane_parameterication(P,a,b)
    if (n%%P == 0) (n/P) else ((a*n)+b)
}
