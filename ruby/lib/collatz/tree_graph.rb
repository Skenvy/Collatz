# frozen_string_literal: true

require_relative "utilities"
require_relative "function"

module Collatz # rubocop:disable Style/Documentation
  # Using a module to proctor a namespace for the functions, none of which
  # are instance methods. All are "class" methods, so set this globally;
  # https://github.com/rubocop/ruby-style-guide#modules-vs-classes
  module_function # rubocop:disable Layout/EmptyLinesAroundAccessModifier, Style/AccessModifierDeclarations

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
end
