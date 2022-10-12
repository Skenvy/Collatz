# frozen_string_literal: true

require_relative "collatz/version"
require_relative "collatz/constants"
require_relative "collatz/utilities"
require_relative "collatz/function"
require_relative "collatz/hailstone_sequence"
require_relative "collatz/tree_graph"

# Provides the basic functionality to interact with the Collatz conjecture. The
# parameterisation uses the same (p,a,b) notation as Conway's generalisations.
# Besides the function and reverse function, there is also functionality to
# retrieve the hailstone sequence, the "stopping time"/"total stopping time", or
# tree-graph.
module Collatz
  # Using a module to proctor a namespace for the functions, none of which
  # are instance methods. All are "class" methods, so set module_function
  # at the head of each required file which opens this module and has defs.
  # https://github.com/rubocop/ruby-style-guide#modules-vs-classes
  # rubocop:disable Lint/UselessAccessModifier

  module_function # rubocop:disable Style/AccessModifierDeclarations

  # rubocop:enable Lint/UselessAccessModifier
end
