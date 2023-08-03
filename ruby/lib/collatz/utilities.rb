# frozen_string_literal: true

module Collatz
  # Error message constants, to be used as input to the FailedSaneParameterCheck.
  module SaneParameterErrMsg
    # Message to print in the FailedSaneParameterCheck if p, the modulus, is zero.
    SANE_PARAMS_P = "'p' should not be 0 ~ violates modulo being non-zero."
    # Message to print in the FailedSaneParameterCheck if a, the multiplicand, is zero.
    SANE_PARAMS_A = "'a' should not be 0 ~ violates the reversability."
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

  # Thrown when either p, the modulus, or a, the multiplicand, are zero.
  class FailedSaneParameterCheck < StandardError
    # Construct a FailedSaneParameterCheck with a message associated with the provided enum.
    # @param [String] msg One of the SaneParameterErrMsg strings.
    def initialize(msg = "This is a custom exception", exception_type = "FailedSaneParameterCheck")
      @exception_type = exception_type
      super(msg)
    end
  end
end
