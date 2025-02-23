# frozen_string_literal: true

require_relative "utilities"

module Collatz # rubocop:disable Style/Documentation
  module_function # rubocop:disable Style/AccessModifierDeclarations

  # Handles the sanity check for the parameterisation (p,a,b)
  # required by both the function and reverse function.
  #
  # @raise FailedSaneParameterCheck If p or a are 0.
  #
  # @param +Integer+ p Modulus used to divide n, iff n is equivalent to (0 mod p)
  #
  # @param +Integer+ a Factor by which to multiply n.
  #
  # @param +Integer+ b Value to add to the scaled value of n.
  private def assert_sane_parameterisation(p, a, _b) # :nodoc:
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
    raise FailedSaneParameterCheck, SaneParameterErrMsg::SANE_PARAMS_P if p.zero?
    raise FailedSaneParameterCheck, SaneParameterErrMsg::SANE_PARAMS_A if a.zero?
  end

  # Returns the output of a single application of a Collatz-esque function.
  #
  # @raise FailedSaneParameterCheck If p or a are 0.
  #
  # @param +Integer+ *n:* The value on which to perform the Collatz-esque function.
  #
  # @param +Integer+ *p:* Modulus used to divide n, iff n is equivalent to (0 mod p).
  #
  # @param +Integer+ *a:* Factor by which to multiply n.
  #
  # @param +Integer+ *b:* Value to add to the scaled value of n.
  #
  # @return +Integer+ The result of the function
  def function(n, p: 2, a: 3, b: 1)
    assert_sane_parameterisation(p, a, b)
    (n%p).zero? ? (n/p) : ((a*n)+b)
  end

  # Returns the output of a single application of a Collatz-esque reverse function. If
  # only one value is returned, it is the value that would be divided by p. If two values
  # are returned, the first is the value that would be divided by p, and the second value
  # is that which would undergo the multiply and add step, regardless of which is larger.
  #
  # @raise FailedSaneParameterCheck If p or a are 0.
  #
  # @param +Integer+ *n:* The value on which to perform the reverse Collatz function.
  #
  # @param +Integer+ *p:* Modulus used to divide n, iff n is equivalent to (0 mod p).
  #
  # @param +Integer+ *a:* Factor by which to multiply n.
  #
  # @param +Integer+ *b:* Value to add to the scaled value of n.
  #
  # @return +List<Integer>+ The values that would return the input if given to the function.
  def reverse_function(n, p: 2, a: 3, b: 1)
    assert_sane_parameterisation(p, a, b)
    if ((n-b)%a).zero? && ((n-b)%(p*a)).nonzero?
      [p*n, (n-b)/a]
    else
      [p*n]
    end
  end
end
