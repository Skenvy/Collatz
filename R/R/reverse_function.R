#' @include utils.R
NULL

#' The "inverse"/"reverse" Collatz function
#'
#' Calculates the values that would return the input under the Collatz function.
#'
#' Returns the output of a single application of a Collatz-esque reverse
#' function. If only one value is returned, it is the value that would be
#' divided by P. If two values are returned, the first is the value that
#' would be divided by P, and the second value is that which would undergo
#' the multiply and add step, regardless of which is larger.
#' @param n (numeric|bigz) The value on which
#' to perform the reverse Collatz function
#' @param P (numeric|bigz) Modulus used to divide
#' n, iff n is equivalent to (0 mod P) Default is 2.
#' @param a (numeric|bigz) Factor by which to multiply n. Default is 3.
#' @param b (numeric|bigz) Value to add
#' to the scaled value of n. Default is 1.
#' @returns A list of either numeric or bigz type
#' @examples
#' # Calculates the values that would return the input under the Collatz
#' # function. Without `gmp` or parameterisation, we can try something
#' # simple like
#' reverse_function(1)
#' reverse_function(2)
#' reverse_function(4)
#' # If we want change the default parameterisation we can;
#' reverse_function(3, -3, -2, -5)
#' # Or if we only want to change one of them
#' reverse_function(16, a=5)
#' # All the above work fine, but the function doesn't offer protection against
#' # overflowing integers by default. To venture into the world of arbitrary
#' # integer inputs we can use an `as.bigz` from `gmp`. Compare the two;
#' reverse_function(99999999999999999999)
#' reverse_function(gmp::as.bigz("99999999999999999999"))
#' @export
reverse_function <- function(n, P=2, a=3, b=1){
    assert_sane_parameterication(P,a,b)
    # Every input can be reversed as the result of "n/P" division, which yields
    # "Pn"... {f(n) = an + b}~={(f(n) - b)/a = n} ~ if n was such that the
    # muliplication step was taken instead of the division by the modulus, then
    # (f(n) - b)/a) must be an integer that is not in (0 mod P). Because we're
    # not placing restrictions on the parameters yet, although there is a better
    # way of shortcutting this for the default variables, we need to always
    # attempt (f(n) - b)/a)
    pre_values <- list(P*n)
    n_minus_b <- (n-b)
    if (n_minus_b%%a == 0 && n_minus_b%%(P*a) != 0){
        # bigq does not have a defined use for %%, so must be int or bigz
        # bigz/bigz returns a bigq even if that bigq has denominator 1
        # so we do a divq, "%/%", instead of div, to just get the bigz.
        pre_values <- append(pre_values, list(n_minus_b%/%a))
    }
    pre_values
}
