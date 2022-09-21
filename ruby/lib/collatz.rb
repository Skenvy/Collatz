# frozen_string_literal: true

require_relative "collatz/version"

# :section: Main
# Provides the basic functionality to interact with the Collatz conjecture. The
# parameterisation uses the same (p,a,b) notation as Conway's generalisations.
# Besides the function and reverse function, there is also functionality to
# retrieve the hailstone sequence, the "stopping time"/"total stopping time", or
# tree-graph.

# The four known cycles for the standard parameterisation.
KNOWN_CYCLES = [
  [1, 4, 2].freeze, [-1, -2].freeze, [-5, -14, -7, -20, -10].freeze,
  [-17, -50, -25, -74, -37, -110, -55, -164, -82, -41, -122, -61, -182, -91, -272, -136, -68, -34].freeze
].freeze
# The current value up to which the standard parameterisation has been verified.
VERIFIED_MAXIMUM = 295147905179352825856
# The current value down to which the standard parameterisation has been verified.
VERIFIED_MINIMUM = -272 # TODO: Check the actual lowest bound.

# Error message constants, to be used as input to the FailedSaneParameterCheck.
module SaneParameterErrMsg
  # Message to print in the FailedSaneParameterCheck if p, the modulus, is zero.
  SANE_PARAMS_P = "'p' should not be 0 ~ violates modulo being non-zero."
  # Message to print in the FailedSaneParameterCheck if a, the multiplicand, is zero.
  SANE_PARAMS_A = "'a' should not be 0 ~ violates the reversability."
end

# Thrown when either p, the modulus, or a, the multiplicand, are zero.
class FailedSaneParameterCheck < StandardError
  # Construct a FailedSaneParameterCheck with a message associated with the provided enum.
  # @param [String] msg One of the SaneParameterErrMsg strings.
  def initialize(msg = "This is a custom exception", exception_type = "FailedSaneParameterCheck")
    @exception_type = exception_type
    super(msg)
  end
end

# SequenceState for Cycle Control: Descriptive flags to indicate when some event occurs in the
# hailstone sequences or tree graph reversal, when set to verbose, or stopping time check.
module SequenceState
  # A Hailstone sequence state that indicates the stopping
  # time, a value less than the initial, has been reached.
  STOPPING_TIME = "STOPPING_TIME"
  # A Hailstone sequence state that indicates the total
  # stopping time, a value of 1, has been reached.
  TOTAL_STOPPING_TIME = "TOTAL_STOPPING_TIME"
  # A Hailstone and TreeGraph sequence state that indicates the
  # first occurence of a value that subsequently forms a cycle.
  CYCLE_INIT = "CYCLE_INIT"
  # A Hailstone and TreeGraph sequence state that indicates the
  # last occurence of a value that has already formed a cycle.
  CYCLE_LENGTH = "CYCLE_LENGTH"
  # A Hailstone and TreeGraph sequence state that indicates the sequence
  # or traversal has executed some imposed 'maximum' amount of times.
  MAX_STOP_OUT_OF_BOUNDS = "MAX_STOP_OUT_OF_BOUNDS"
  # A Hailstone sequence state that indicates the sequence terminated
  # by reaching "0", a special type of "stopping time".
  ZERO_STOP = "ZERO_STOP"
end

# Handles the sanity check for the parameterisation (p,a,b)
# required by both the function and reverse function.
#
# @raise [FailedSaneParameterCheck] If p or a are 0.
#
# @param [Integer] p Modulus used to devide n, iff n is equivalent to (0 mod p)
# @param [Integer] a Factor by which to multiply n.
# @param [Integer] b Value to add to the scaled value of n.
def assert_sane_parameterisation(p, a, _b)
  # Sanity check (p,a,b) ~ p absolutely can't be 0. a "could" be zero
  # theoretically, although would violate the reversability (if ~a is 0 then a
  # value of "b" as the input to the reverse function would have a pre-emptive
  # value of every number not divisible by p). The function doesn't _have_ to
  # be reversable, but we are only interested in dealing with the class of
  # functions that exhibit behaviour consistant with the collatz function. If
  # _every_ input not divisable by p went straight to "b", it would simply
  # cause a cycle consisting of "b" and every b/p^z that is an integer. While
  # p in [-1, 1] could also be a reasonable check, as it makes every value
  # either a 1 or 2 length cycle, it's not strictly an illegal operation.
  # "b" being zero would cause behaviour not consistant with the collatz
  # function, but would not violate the reversability, so no check either.
  # " != 0" is redundant for python assertions.
  raise FailedSaneParameterCheck, SaneParameterErrMsg::SANE_PARAMS_P unless p != 0
  raise FailedSaneParameterCheck, SaneParameterErrMsg::SANE_PARAMS_A unless a != 0
end

private :assert_sane_parameterisation

# Returns the output of a single application of a Collatz-esque function.
#
# @raise [FailedSaneParameterCheck] If p or a are 0.
#
# @param [Integer] n The value on which to perform the Collatz-esque function.
# @param [Integer] p Modulus used to devide n, iff n is equivalent to (0 mod p).
# @param [Integer] a Factor by which to multiply n.
# @param [Integer] b Value to add to the scaled value of n.
#
# @return [Integer] The result of the function
def function(n, p: 2, a: 3, b: 1)
  assert_sane_parameterisation(p, a, b)
  (n%p).zero? ? (n/p) : ((a*n)+b)
end

# Returns the output of a single application of a Collatz-esque reverse function. If
# only one value is returned, it is the value that would be divided by p. If two values
# are returned, the first is the value that would be divided by p, and the second value
# is that which would undergo the multiply and add step, regardless of which is larger.
#
# @raise [FailedSaneParameterCheck] If p or a are 0.
#
# @param [Integer] n The value on which to perform the reverse Collatz function.
# @param [Integer] p Modulus used to devide n, iff n is equivalent to (0 mod p).
# @param [Integer] a Factor by which to multiply n.
# @param [Integer] b Value to add to the scaled value of n.
#
# @return [Integer] The values that would return the input if given to the function.
def reverse_function(n, p: 2, a: 3, b: 1)
  assert_sane_parameterisation(p, a, b)
  pre_values = [p*n]
  pre_values += [(n-b)/a] if ((n-b)%a).zero? && !((n-b)%(p*a)).zero?
  pre_values
end

# Provides the appropriate lambda to use to check if iterations on an initial
# value have reached either the stopping time, or total stopping time.
# @param [Integer] n The initial value to confirm against a stopping time check.
# @param [Boolean] total_stop If false, the lambda will confirm that iterations of n
#     have reached the oriented stopping time to reach a value closer to 0.
#     If true, the lambda will simply check equality to 1.
# @return [Method(Integer)->(Boolean)] The lambda to check for the stopping time.
def stopping_time_terminus(n, total_stop)
  raise NotImplementedError, "Will be implemented at, or before, v1.0.0"
end

private :stopping_time_terminus

# Contains the results of computing a hailstone sequence via hailstone_sequence(~).
class HailstoneSequence
  def initialize
    raise NotImplementedError, "Will be implemented at, or before, v1.0.0"
  end
end

# Returns a list of successive values obtained by iterating a Collatz-esque
# function, until either 1 is reached, or the total amount of iterations
# exceeds max_total_stopping_time, unless total_stopping_time is False,
# which will terminate the hailstone at the "stopping time" value, i.e. the
# first value less than the initial value. While the sequence has the
# capability to determine that it has encountered a cycle, the cycle from "1"
# wont be attempted or reported as part of a cycle, regardless of default or
# custom parameterisation, as "1" is considered a "total stop".
#
# @raise [FailedSaneParameterCheck] If p or a are 0.
#
# @param [Integer] initial_value The value to begin the hailstone sequence from.
# @param [Integer] p Modulus used to devide n, iff n is equivalent to (0 mod p).
# @param [Integer] a Factor by which to multiply n.
# @param [Integer] b Value to add to the scaled value of n.
# @param [Integer] max_total_stopping_time Maximum amount of times to iterate the function, if 1 is not reached.
# @param [Boolean] total_stopping_time Whether or not to execute until the "total" stopping time
#     (number of iterations to obtain 1) rather than the regular stopping time (number
#     of iterations to reach a value less than the initial value).
#
# @return [HailstoneSequence] A set of values that form the hailstone sequence.
def hailstone_sequence(initial_value, p: 2, a: 3, b: 1, max_total_stopping_time: 1000, total_stopping_time: true)
  raise NotImplementedError, "Will be implemented at, or before, v1.0.0"
end

# Returns the stopping time, the amount of iterations required to reach a
# value less than the initial value, or nil if max_stopping_time is exceeded.
# Alternatively, if total_stopping_time is True, then it will instead count
# the amount of iterations to reach 1. If the sequence does not stop, but
# instead ends in a cycle, the result will be infinity.
# If (p,a,b) are such that it is possible to get stuck on zero, the result
# will be the negative of what would otherwise be the "total stopping time"
# to reach 1, where 0 is considered a "total stop" that should not occur as
# it does form a cycle of length 1.
#
# @raise [FailedSaneParameterCheck] If p or a are 0.
#
# @param [Integer] initial_value The value for which to find the stopping time.
# @param [Integer] p Modulus used to devide n, iff n is equivalent to (0 mod p).
# @param [Integer] a Factor by which to multiply n.
# @param [Integer] b Value to add to the scaled value of n.
# @param [Integer] max_stopping_time Maximum amount of times to iterate the function, if
#     the stopping time is not reached. IF the max_stopping_time is reached,
#     the function will return nil.
# @param [Boolean] total_stopping_time Whether or not to execute until the "total" stopping
#     time (number of iterations to obtain 1) rather than the regular stopping
#     time (number of iterations to reach a value less than the initial value).
#
# @return [Integer] The stopping time, or, in a special case, infinity, nil or a negative.
def stopping_time(initial_value, p: 2, a: 3, b: 1, max_stopping_time: 1000, total_stopping_time: false)
  raise NotImplementedError, "Will be implemented at, or before, v1.0.0"
end

# Nodes that form a "tree graph", structured as a tree, with their own node's value,
# as well as references to either possible child node, where a node can only ever have
# two children, as there are only ever two reverse values. Also records any possible
# "terminal sequence state", whether that be that the "orbit distance" has been reached,
# as an "out of bounds" stop, which is the regularly expected terminal state. Other
# terminal states possible however include the cycle state and cycle length (end) states.
class TreeGraphNode
  def initialize
    raise NotImplementedError, "Will be implemented at, or before, v1.0.0"
  end
end

# Contains the results of computing the Tree Graph via tree_graph(~).
# Contains the root node of a tree of TreeGraphNode's.
class TreeGraph
  def initialize
    raise NotImplementedError, "Will be implemented at, or before, v1.0.0"
  end
end

# Returns a directed tree graph of the reverse function values up to a maximum
# nesting of max_orbit_distance, with the initial_value as the root.
#
# @raise [FailedSaneParameterCheck] If p or a are 0.
#
# @param [Integer] initial_value The root value of the directed tree graph.
# @param [Integer] max_orbit_distance Maximum amount of times to iterate the reverse
#     function. There is no natural termination to populating the tree graph, equivalent
#     to the termination of hailstone sequences or stopping time attempts, so this is not
#     an optional argument like max_stopping_time / max_total_stopping_time, as it is the intended
#     target of orbits to obtain, rather than a limit to avoid uncapped computation.
# @param [Integer] p Modulus used to devide n, iff n is equivalent to (0 mod p).
# @param [Integer] a Factor by which to multiply n.
# @param [Integer] b Value to add to the scaled value of n.
#
# @return [TreeGraph] The branches of the tree graph as determined by the reverse function.
def tree_graph(initial_value, max_orbit_distance, p: 2, a: 3, b: 1, __cycle_prevention: nil)
  raise NotImplementedError, "Will be implemented at, or before, v1.0.0"
end
