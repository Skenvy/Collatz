# frozen_string_literal: true

require_relative "utilities"
require_relative "function"

module Collatz # rubocop:disable Style/Documentation
  # Using a module to proctor a namespace for the functions, none of which
  # are instance methods. All are "class" methods, so set this globally;
  # https://github.com/rubocop/ruby-style-guide#modules-vs-classes
  module_function # rubocop:disable Layout/EmptyLinesAroundAccessModifier, Style/AccessModifierDeclarations

  # Provides the appropriate lambda to use to check if iterations on an initial
  # value have reached either the stopping time, or total stopping time.
  # @param [Integer] n The initial value to confirm against a stopping time check.
  # @param [Boolean] total_stop If false, the lambda will confirm that iterations of n
  #     have reached the oriented stopping time to reach a value closer to 0.
  #     If true, the lambda will simply check equality to 1.
  # @return [lambda(Integer)->(Boolean)] The lambda to check for the stopping time.
  private def stopping_time_terminus(n, total_stop)
    if total_stop
      lambda { |x| x == 1 }
    elsif n >= 0
      lambda { |x| (x < n && x.positive?) }
    else
      lambda { |x| (x > n && x.negative?) }
    end
  end

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
end
