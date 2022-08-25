#' @include utils.R
#' @include collatz_function.R
NULL

#' Hailstone Sequencer
#'
#' Calculates the values of a hailstone sequence, from an initial value.
#'
#' Returns a list of successive values obtained by iterating a Collatz-esque
#' function, until either 1 is reached, or the total amount of iterations
#' exceeds max_total_stopping_time, unless total_stopping_time is FALSE, which
#' will terminate the hailstone at the "stopping time" value, i.e. the first
#' value less than the initial value. While the sequence has the capability to
#' determine that it has encountered a cycle, the cycle from "1" wont be
#' attempted or reported as part of a cycle, regardless of default or custom
#' parameterisation, as "1" is considered a "total stop".
#'
#' @param initial_value (numeric|bigz)
#' The value to begin the hailstone sequence from.
#' @param P (numeric|bigz): Modulus used to divide
#' n, iff n is equivalent to (0 mod P). Default is 2.
#' @param a (numeric|bigz) Factor by which to multiply n. Default is 3.
#' @param b (numeric|bigz) Value to add
#' to the scaled value of n. Default is 1.
#' @param max_total_stopping_time (int) Maximum amount of times to iterate the
#' function, if 1 is not reached. Default is 1000.
#' @param total_stopping_time (bool) Whether or not to execute until the "total"
#' stopping time (number of iterations to obtain 1) rather than the regular
#' stopping time (number of iterations to reach a value less than the initial
#' value). Default is TRUE.
#' @param verbose (bool) If set to verbose, the hailstone sequence will include
#' control string sequences to provide information about how the
#' sequence terminated, whether by reaching a stopping time or entering
#' a cycle. Default is TRUE.
#' @returns A keyed list consisting of a $values list of numeric | bigz
#' along with a $terminalCondition and $terminalStatus
#' @export
hailstone_sequence <- function(initial_value, P=2, a=3, b=1,
    max_total_stopping_time=1000, total_stopping_time=TRUE, verbose=TRUE){
    # Call out the collatz_function before any magic returns to trap bad values.
    throwaway_test <- collatz_function(initial_value,P=P,a=a,b=b)
    # 0 is always an immediate stop.
    if (initial_value == 0){
        if (verbose) {
            return(list(values=list(0), terminalCondition=Collatz$SequenceState$ZERO_STOP, terminalStatus=0))
        } else {
            return(list(0))
        }
    }
    # 1 is always an immediate stop, with 0 stopping time.
    if (initial_value == 1){
        if (verbose) {
            return(list(values=list(1), terminalCondition=Collatz$SequenceState$TOTAL_STOPPING_TIME, terminalStatus=0))
        } else {
            return(list(1))
        }
    }
    terminate <- stopping_time_terminus(initial_value, total_stopping_time)
    # Start the hailstone sequence.
    max_max_total_stopping_time <- max(max_total_stopping_time, 1)
    hailstone <- list(values=vector(mode="list", length=max_max_total_stopping_time), terminalCondition=NA, terminalStatus=NA)
    hailstone$values[[1]] <- initial_value
    for (k in 1:max_max_total_stopping_time){
        next_val <- collatz_function(hailstone$values[[k]],P=P,a=a,b=b)
        # Check if the next_val hailstone is either the stopping time, total
        # stopping time, the same as the initial value, or stuck at zero.
        if (terminate(next_val)) {
            hailstone$values[[k+1]] <- next_val
            hailstone$values <- hailstone$values[1:(k+1)]
            if (verbose) {
                if (next_val == 1) {
                    hailstone$terminalCondition <- Collatz$SequenceState$TOTAL_STOPPING_TIME
                } else {
                    hailstone$terminalCondition <- Collatz$SequenceState$STOPPING_TIME
                }
                hailstone$terminalStatus <- k
                return(hailstone)
            } else {
                return(hailstone$values)
            }
        }
        # Here is normally where cyclic <- function(x){x %in% hailstone$values}
        # would be used to determine presence of a new value in previous values
        # but R's in-built tests for set membership all behave differently to
        # other languages when the input itself is a vector, which bigz raw is!
        # e.g. see how meaningless this is: `gmp::numerator(5) %in% list(5)`
        # So we need to always do to the inverse loop traversal and compare,
        # as the compare on list elements against bigz | bigq _does_ work!
        # >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        cycle_init <- -1
        for (j in 0:(k-1)) {
            if (hailstone$values[[k-j]] == next_val) {
                cycle_init <- j+1
                break
            }
        }
        if (cycle_init > 0) {
            hailstone$values[[k+1]] <- next_val
            hailstone$values <- hailstone$values[1:(k+1)]
            if (verbose) {
                hailstone$terminalCondition <- Collatz$SequenceState$CYCLE_LENGTH
                hailstone$terminalStatus <- cycle_init
                return(hailstone)
            } else {
                return(hailstone$values)
            }
        }
        # <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
        if (next_val == 0) {
            hailstone$values[[k+1]] <- 0
            hailstone$values <- hailstone$values[1:(k+1)]
            if (verbose) {
                hailstone$terminalCondition <- Collatz$SequenceState$ZERO_STOP
                hailstone$terminalStatus <- -k
                return(hailstone)
            } else {
                return(hailstone$values)
            }
        }
        hailstone$values[[k+1]] <- next_val
    }
    if (verbose) {
        hailstone$terminalCondition <- Collatz$SequenceState$MAX_STOP_OUT_OF_BOUNDS
        hailstone$terminalStatus <- max_max_total_stopping_time
        return(hailstone)
    } else {
        return(hailstone$values)
    }
}
