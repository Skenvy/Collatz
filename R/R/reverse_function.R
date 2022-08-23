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
#' @param n (numeric|bigz|bigq) The value on which
#' to perform the reverse Collatz function
#' @param P (numeric|bigz|bigq) Modulus used to divide
#' n, iff n is equivalent to (0 mod P) Default is 2.
#' @param a (numeric|bigz|bigq) Factor by which to multiply n. Default is 3.
#' @param b (numeric|bigz|bigq) Value to add
#' to the scaled value of n. Default is 1.
#' @returns A vector of either numeric or bigz | bigq type
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
    pre.values <- c(P*n)
    if ((n-b)%%a == 0 && (n-b)%%(P*a) != 0){
        pre.values <- append(pre.values, (n-b)/a)
    }
    pre.values
}
