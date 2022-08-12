#' The four known cycles for the standard parameterisation.
#' As a "list of lists", you can iterate over them as
#' for (KC in KNOWN.CYCLES[[1]]) with an inner for (val in KC)
KNOWN.CYCLES <- list(c(list(c(1, 4, 2)), list(c(-1, -2)), list(c(-5, -14, -7, -20, -10)),
    list(c(-17, -50, -25, -74, -37, -110, -55, -164, -82, -41, -122, -61, -182, -91, -272, -136, -68, -34))))
lockBinding("KNOWN.CYCLES", globalenv())

# for (KC in KNOWN.CYCLES[[1]]){
#     print(KC)
#     for (val in KC){
#         print(val)
#     }
# }

# too large to add until implementing arb ints
# VERIFIED.MAXIMUM <- 295147905179352825856
# lockBinding("VERIFIED.MAXIMUM", globalenv())

VERIFIED.MINIMUM <- -272
lockBinding("VERIFIED.MINIMUM", globalenv())

SaneParameterErrMsg <- list(P="'P' should not be 0 ~ violates modulo being non-zero.", A="'a' should not be 0 ~ violates the reversability.")
lockBinding("SaneParameterErrMsg", globalenv())

SequenceState <- list()

#' Handles the sanity check for the parameterisation (P,a,b) required by both
#' the function and reverse function. Returns an error of type;
#'  FailedSaneParameterCheck(SANE_PARAMS_P)
#'  FailedSaneParameterCheck(SANE_PARAMS_A)
#' Has arguments;
#'  - P: Modulus used to devide n, iff n is equivalent to (0 mod P).
#'  - a: Factor by which to multiply n.
#'  - b: Value to add to the scaled value of n.
assertSaneParameterication <- function(P, a, b) {
	# Sanity check (P,a,b) ~ P absolutely can't be 0. a "could" be zero
	# theoretically, although would violate the reversability (if ~a is 0 then a
	# value of "b" as the input to the reverse function would have a pre-emptive
	# value of every number not divisible by P). The function doesn't _have_ to
	# be reversable, but we are only interested in dealing with the class of
	# functions that exhibit behaviour consistant with the collatz function. If
	# _every_ input not divisable by P went straight to "b", it would simply
	# cause a cycle consisting of "b" and every b/P^z that is an integer. While
	# P in [-1, 1] could also be a reasonable check, as it makes every value
	# either a 1 or 2 length cycle, it's not strictly an illegal operation.
	# "b" being zero would cause behaviour not consistant with the collatz
	# function, but would not violate the reversability, so no check either.
	# " != 0" is redundant for python assertions.
	if (P == 0) stop(SaneParameterErrMsg$P)
	if (a == 0) stop(SaneParameterErrMsg$A)
}

#' Returns the output of a single application of a Collatz-esque function.
#' Args:
#'     n (int): The value on which to perform the Collatz-esque function
#' Kwargs:
#'     P (int): Modulus used to devide n, iff n is equivalent to (0 mod P).
#'         Default is 2.
#'     a (int): Factor by which to multiply n. Default is 3.
#'     b (int): Value to add to the scaled value of n. Default is 1.
Function <- function(n, P=2, a=3, b=1){
    assertSaneParameterication(P,a,b)
    if (n%%P == 0) (n/P) else ((a*n)+b)
}

#' Returns the output of a single application of a Collatz-esque reverse
#' function.
#' Args:
#'     n (int): The value on which to perform the reverse Collatz function
#' Kwargs:
#'     P (int): Modulus used to devide n, iff n is equivalent to (0 mod P)
#'         Default is 2.
#'     a (int): Factor by which to multiply n. Default is 3.
#'     b (int): Value to add to the scaled value of n. Default is 1.
reverseFunction <- function(n, P=2, a=3, b=1){
    assertSaneParameterication(P,a,b)
    # Every input can be reversed as the result of "n/P" division, which yields
    # "Pn"... {f(n) = an + b}≡{(f(n) - b)/a = n} ~ if n was such that the
    # muliplication step was taken instead of the division by the modulus, then
    # (f(n) - b)/a) must be an integer that is not in (0 mod P). Because we're
    # not placing restrictions on the parameters yet, although there is a better
    # way of shortcutting this for the default variables, we need to always
    # attempt (f(n) - b)/a)
    pre.values = c(P*n)
    if ((n-b)%%a == 0 && (n-b)%%(P*a) != 0){
        pre.values = append(pre.values, (n-b)/a)
    }
    pre.values
}

Function(17)
reverseFunction(4)
