#' Collatz
#'
#' Functions related to the Collatz/Syracuse/3N+1 problem.
#'
#' Provides the basic functionality to interact with the Collatz conjecture.
#' The parameterisation uses the same (P,a,b) notation as Conway's generalisations.
#' Besides the function and reverse function, there is also functionality to retrieve
#' the hailstone sequence, the "stopping time"/"total stopping time", or tree-graph.
#' The only restriction placed on parameters is that both P and a can't be 0.
#'
#' @docType package
#' @name collatz
#' @import gmp
NULL

library(gmp)

# An environment for constants related to the Collatz package, primarily for testing purposes.
Collatz <- new.env()

# The four known cycles for the standard parameterisation, as ints.
Collatz$KNOWN.CYCLES <- list(list(1, 4, 2), list(-1, -2), list(-5, -14, -7, -20, -10),
    list(-17, -50, -25, -74, -37, -110, -55, -164, -82, -41, -122, -61, -182, -91, -272, -136, -68, -34))
lockBinding("KNOWN.CYCLES", Collatz)

# The current value up to which the standard parameterisation has been verified.
Collatz$VERIFIED.MAXIMUM <- as.bigz("295147905179352825856")
lockBinding("VERIFIED.MAXIMUM", Collatz)

# The current value down to which the standard parameterisation has been verified.
# TODO: Check the actual lowest bound.
Collatz$VERIFIED.MINIMUM <- -272
lockBinding("VERIFIED.MINIMUM", Collatz)

# Error message constants
Collatz$SaneParameterErrMsg <- list(P="'P' should not be 0 ~ violates modulo being non-zero.", A="'a' should not be 0 ~ violates the reversability.")
lockBinding("SaneParameterErrMsg", Collatz)

# SequenceState for Cycle Control: Descriptive flags to indicate when some
# event occurs in the hailstone sequences or tree graph reversal, when set to
# verbose, or stopping time check.
Collatz$SequenceState <- list()

#' Sane Parameter Check
#'
#' Handles the sanity check for the parameterisation (P,a,b)
#'
#' Required by both the function and reverse function, to assert that they
#' have sane parameters, otherwise will force stop the execution.
#'
#' @param P Modulus used to devide n, iff n is equivalent to (0 mod P).
#' @param a Factor by which to multiply n.
#' @param b Value to add to the scaled value of n.
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
    if (P == 0) stop(Collatz$SaneParameterErrMsg$P)
    if (a == 0) stop(Collatz$SaneParameterErrMsg$A)
}

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
collatzFunction <- function(n, P=2, a=3, b=1){
    assertSaneParameterication(P,a,b)
    if (n%%P == 0) (n/P) else ((a*n)+b)
}

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
reverseFunction <- function(n, P=2, a=3, b=1){
    assertSaneParameterication(P,a,b)
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
