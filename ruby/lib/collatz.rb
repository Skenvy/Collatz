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
  # Message to print in the FailedSaneParameterCheck if P, the modulus, is zero.
  SANE_PARAMS_P = "'p' should not be 0 ~ violates modulo being non-zero."
  # Message to print in the FailedSaneParameterCheck if a, the multiplicand, is zero.
  SANE_PARAMS_A = "'a' should not be 0 ~ violates the reversability."
end

# Thrown when either P, the modulus, or a, the multiplicand, are zero.
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
# @raise [FailedSaneParameterCheck] If p or a are 0.
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

# Returns the output of a single application of a Collatz-esque function.
# @raise [FailedSaneParameterCheck] If p or a are 0.
# @param [Integer] n The value on which to perform the Collatz-esque function.
# @param [Integer] P Modulus used to devide n, iff n is equivalent to (0 mod P).
# @param [Integer] a Factor by which to multiply n.
# @param [Integer] b Value to add to the scaled value of n.
# @return [Integer] The result of the function
def function(n, p = 2, a = 3, b = 1)
  assert_sane_parameterisation(p, a, b)
  (n%p).zero? ? (n/p) : ((a*n)+b)
end

# Returns the output of a single application of a Collatz-esque reverse function. If
# only one value is returned, it is the value that would be divided by p. If two values
# are returned, the first is the value that would be divided by p, and the second value
# is that which would undergo the multiply and add step, regardless of which is larger.
# @raise [FailedSaneParameterCheck] If p or a are 0.
# @param [Integer] n The value on which to perform the reverse Collatz function.
# @param [Integer] p Modulus used to devide n, iff n is equivalent to (0 mod p).
# @param [Integer] a Factor by which to multiply n.
# @param [Integer] b Value to add to the scaled value of n.
# @return [Integer] The result of the function
def reverse_function(n, p = 2, a = 3, b = 1)
  assert_sane_parameterisation(p, a, b)
  pre_values = [p*n]
  pre_values += [(n-b)/a] if ((n-b)%a).zero? && !((n-b)%(p*a)).zero?
  pre_values
end
