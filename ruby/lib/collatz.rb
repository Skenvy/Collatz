# frozen_string_literal: true

require_relative "collatz/version"

# :section: Main
# Provides the basic functionality to interact with the Collatz conjecture. The
# parameterisation uses the same (P,a,b) notation as Conway's generalisations.
# Besides the function and reverse function, there is also functionality to
# retrieve the hailstone sequence, the "stopping time"/"total stopping time", or
# tree-graph.

# The four known cycles for the standard parameterisation.
KNOWN_CYCLES = [
  [1, 4, 2].freeze, [-1, -2].freeze, [-5, -14, -7, -20, -10].freeze,
  [-17, -50, -25, -74, -37, -110, -55, -164, -82, -41, -122, -61, -182, -91, -272, -136, -68, -34].freeze
].freeze
KNOWN_CYCLES.freeze
# The current value up to which the standard parameterisation has been verified.
VERIFIED_MAXIMUM = 295147905179352825856
# The current value down to which the standard parameterisation has been verified.
VERIFIED_MINIMUM = -272  # TODO: Check the actual lowest bound.
