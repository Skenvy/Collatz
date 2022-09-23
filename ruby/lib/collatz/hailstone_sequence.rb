# frozen_string_literal: true

require_relative "utilities"
require_relative "function"

module Collatz # rubocop:disable Style/Documentation
  # Using a module to proctor a namespace for the functions, none of which
  # are instance methods. All are "class" methods, so set this globally;
  # https://github.com/rubocop/ruby-style-guide#modules-vs-classes
  module_function # rubocop:disable Layout/EmptyLinesAroundAccessModifier, Style/AccessModifierDeclarations

  # Contains the results of computing a hailstone sequence via hailstone_sequence(~).
  class HailstoneSequence
    # The set of values that comprise the hailstone sequence.
    @values
    # The terminal condition lambda
    @terminate
    # A terminal condition that reflects the final state of the hailstone sequencing,
    # whether than be that it succeeded at determining the stopping time, the total
    # stopping time, found a cycle, or got stuck on zero (or surpassed the max total). */
    @terminal_condition # SequenceState
    # A status value that has different meanings depending on what the terminal condition
    # was. If the sequence completed either via reaching the stopping or total stopping time,
    # or getting stuck on zero, then this value is the stopping/terminal time. If the sequence
    # got stuck on a cycle, then this value is the cycle length. If the sequencing passes the
    # maximum stopping time then this is the value that was provided as that maximum. */
    @terminal_status

    # Initialise and compute a new Hailstone Sequence.
    # @param [Integer] initial_value The value to begin the hailstone sequence from.
    # @param [Integer] p Modulus used to devide n, iff n is equivalent to (0 mod p).
    # @param [Integer] a Factor by which to multiply n.
    # @param [Integer] b Value to add to the scaled value of n.
    # @param [Integer] max_total_stopping_time Maximum amount of times to iterate the function, if 1 is not reached.
    # @param [Boolean] total_stopping_time Whether or not to execute until the "total" stopping time
    #     (number of iterations to obtain 1) rather than the regular stopping time (number
    #     of iterations to reach a value less than the initial value).
    def initialize(initial_value, p, a, b, max_total_stopping_time, total_stopping_time)
      @terminate = stopping_time_terminus(initial_value, total_stopping_time)
      if initial_value.zero?
        # 0 is always an immediate stop.
        @values = [0]
        @terminal_condition = SequenceState::ZERO_STOP
        @terminal_status = 0
      elsif initial_value == 1
        # 1 is always an immediate stop, with 0 stopping time.
        @values = [1]
        @terminal_condition = SequenceState::TOTAL_STOPPING_TIME
        @terminal_status = 0
      else
        # Otherwise, hail!
        min_max_total_stopping_time = [max_total_stopping_time, 1].max
        pre_values = Array.new(min_max_total_stopping_time+1)
        pre_values[0] = initial_value
        for k in 1..min_max_total_stopping_time do
          next_value = Collatz.function(pre_values[k-1], p: p, a: a, b: b)
          # Check if the next_value hailstone is either the stopping time, total
          # stopping time, the same as the initial value, or stuck at zero.
          if @terminate.call(next_value)
            pre_values[k] = next_value
            if next_value == 1
              @terminal_condition = SequenceState::TOTAL_STOPPING_TIME
            else 
              @terminal_condition = SequenceState::STOPPING_TIME
            end
            @terminal_status = k
            @values = pre_values.slice(0, k+1)
            return
          end
          if pre_values.include? next_value
            pre_values[k] = next_value
            cycle_init = 1
            for j in 1..k do
              if pre_values[k-j] == next_value
                cycle_init = j
                break
              end
            end
            @terminal_condition = SequenceState::CYCLE_LENGTH
            @terminal_status = cycle_init
            @values = pre_values.slice(0, k+1)
            return
          end
          if next_value.zero?
            pre_values[k] = 0
            @terminal_condition = SequenceState::ZERO_STOP
            @terminal_status = -k
            @values = pre_values.slice(0, k+1)
            return
          end
          pre_values[k] = next_value
        end
        @terminal_condition = SequenceState::MAX_STOP_OUT_OF_BOUNDS
        @terminal_status = min_max_total_stopping_time
        @values = pre_values
      end
    end

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

    attr_reader :values, :terminal_condition, :terminal_status
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
    _throwaway = function(initial_value, p: p, a: a, b: b)
    # Return the hailstone sequence.
    HailstoneSequence.new(initial_value, p, a, b, max_total_stopping_time, total_stopping_time)
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
