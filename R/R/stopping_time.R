#' @include utils.R
#' @include hailstone_sequence.R
NULL

#' Stopping Time
#'
#' Determine the stopping time, or "total" stopping time, for an initial value.
#'
#' Returns the stopping time, the amount of iterations required to reach a
#' value less than the initial value, or NaN if max_stopping_time is exceeded.
#' Alternatively, if total_stopping_time is TRUE, then it will instead count
#' the amount of iterations to reach 1. If the sequence does not stop, but
#' instead ends in a cycle, the result will be (Inf). If (P,a,b) are such
#' that it is possible to get stuck on zero, the result will be the negative of
#' what would otherwise be the "total stopping time" to reach 1, where 0 is
#' considered a "total stop" that should not occur as it does form a cycle of
#' length 1.
#' @param initial_value (int): The value for which to find the stopping time.
#' @param P (numeric|bigz): Modulus used to divide
#' n, iff n is equivalent to (0 mod P). Default is 2.
#' @param a (numeric|bigz) Factor by which to multiply n. Default is 3.
#' @param b (numeric|bigz) Value to add
#' to the scaled value of n. Default is 1.
#' @param max_stopping_time (int) Maximum amount of times to iterate the
#' function, if the stopping time is not reached. IF the max_stopping_time
#' is reached, the function will return NaN. Default is 1000.
#' @param total_stopping_time (bool) Whether or not to execute until the "total"
#' stopping time (number of iterations to obtain 1) rather than the regular
#' stopping time (number of iterations to reach a value less than the initial
#' value). Default is FALSE.
#' @returns An integer numeral if stopped, Inf if a cycle, NaN if OOB, else NA.
#' @export

stopping_time <- function(initial_value, P=2, a=3, b=1,
    max_stopping_time=1000, total_stopping_time=FALSE){
    # The information is contained in the verbose form of a hailstone sequence.
    # Although the "max_~_time" for hailstones is name for "total stopping" time
    # and the "max_~_time" for this "stopping time" function is _not_ "total",
    # they are handled the same way, as the default for "total_stopping_time"
    # for hailstones is true, but for this, is false. Thus the naming difference
    sequence <- hailstone_sequence(initial_value, P=P, a=a, b=b, verbose=TRUE,
                                   max_total_stopping_time=max_stopping_time,
                                   total_stopping_time=total_stopping_time)
    # For total/regular/zero stopping time, the value is already the same as
    # that present, for cycles we report infinity instead of the cycle length,
    # and for max stop out of bounds, we report None instead of the max stop cap
    # An extra note here is that while other designs use the enum values as the
    # comparitors in the switch, R is very unhappy with non-literal switch keys.
    return(switch(sequence$terminalCondition,
        "TOTAL_STOPPING_TIME" = sequence$terminalStatus,
        "STOPPING_TIME" = sequence$terminalStatus,
        "CYCLE_LENGTH" = Inf,
        "ZERO_STOP" = sequence$terminalStatus,
        "MAX_STOP_OUT_OF_BOUNDS" = NaN,
        NA
    ))
}
