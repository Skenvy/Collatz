# frozen_string_literal: true

module Collatz
  # The four known cycles for the standard parameterisation.
  KNOWN_CYCLES = [
    [1, 4, 2], [-1, -2], [-5, -14, -7, -20, -10],
    [-17, -50, -25, -74, -37, -110, -55, -164, -82, -41, -122, -61, -182, -91, -272, -136, -68, -34]
  ].each(&:freeze).freeze
  # The current value up to which the standard parameterisation has been verified.
  VERIFIED_MAXIMUM = 295147905179352825856
  # The current value down to which the standard parameterisation has been verified.
  VERIFIED_MINIMUM = -272 # TODO: Check the actual lowest bound.
end
