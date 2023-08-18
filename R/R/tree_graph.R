#' @include utils.R
#' @include reverse_function.R
NULL

#' Tree Graph
#'
#' Determine the Tree Graph to some depth by iteratively reversing values.
#'
#' Returns nested dictionaries that model the directed tree graph up to a
#' maximum nesting of max_orbit_distance, with the initial_value as the root.
#' @param initial_value (int) The root value of the directed tree graph.
#' @param max_orbit_distance (int) Maximum amount of times to iterate the
#' reverse function. There is no natural termination to populating the tree
#' graph, equivalent to the termination of hailstone sequences or stopping time
#' attempts, so this is not an optional argument like max_stopping_time or
#' max_total_stopping_time, as it is the intended target of orbits to obtain,
#' rather than a limit to avoid uncapped computation.
#' @param P (numeric|bigz): Modulus used to divide
#' n, iff n is equivalent to (0 mod P). Default is 2.
#' @param a (numeric|bigz) Factor by which to multiply n. Default is 3.
#' @param b (numeric|bigz) Value to add
#' to the scaled value of n. Default is 1.
#' @param cycle_prevention (set[int]) Used to prevent cycles from precipitating
#' by keeping track of all values added across previous nest depths. Only to be
#' used internally by the function recursing. Does not expect input.
#' @returns A set of nested dictionaries.
#' @examples
#' #Compute a tree graph, which takes both a value to initialise the tree from,
#' # and an "orbit distance" for how many layers deep in the tree to compute;
#' tree_graph(16, 3)
#' # It will also stop on finding a cycle;
#' tree_graph(4, 3)
#' # And can be parameterised;
#' tree_graph(1, 1, -3, -2, -5)
#' # If b is a multiple of a, but not of Pa, then 0 can have a reverse;
#' tree_graph(0, 1, 17, 2, -6)
#' # The tree graph can run on `bigz`;
#' tree_graph((27+gmp::as.bigz("576460752303423488")), 3)
#' @export
tree_graph <- function(initial_value, max_orbit_distance, P=2, a=3, b=1, cycle_prevention=list()){
    # Call out the reverse_function before any magic returns to trap bad values.
    throwaway_test <- reverse_function(initial_value,P=P,a=a,b=b)
    # In R, if a numeric is used as the key in a K:V list, it will populate the
    # entire list up to that point as ascending numerics pointing to NULLs.
    # To get around this, we can "as.character(numeric_val)" as it does not
    # do the same backfilling for string keys. Although this yields another
    # problem, that the syntax `list((as.character(some_num))=anything)`
    # complains of `Error: unexpected '=' in "list((as.character(some_num))="`
    # So rather than a syntactically concise one liner, we need a few lines..
    tgraph <- list()
    tgraph[[as.character(initial_value)]] <- NA
    if (max(0, max_orbit_distance) == 0) {
        return(tgraph)
    } else {
        tgraph[[as.character(initial_value)]] <- list()
    }
    cycle_prevention <- append(cycle_prevention, list(initial_value))
    for (branch_value in reverse_function(initial_value, P=P, a=a, b=b)) {
        no_cycle <- TRUE
        for (previous_value in cycle_prevention) {
            if (branch_value == previous_value) {
                tgraph[[as.character(initial_value)]][[Collatz$SequenceState$CYCLE_INIT]] <- branch_value
                no_cycle <- FALSE
                break
            }
        }
        if (no_cycle) {
            tgraph[[as.character(initial_value)]][[as.character(branch_value)]] <- tree_graph(branch_value,
                max_orbit_distance-1, P=P, a=a, b=b, cycle_prevention=cycle_prevention)[[as.character(branch_value)]]
        }
    }
    return(tgraph)
}
