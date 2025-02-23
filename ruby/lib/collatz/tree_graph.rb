# frozen_string_literal: true

require_relative "utilities"
require_relative "function"

module Collatz # rubocop:disable Style/Documentation
  # Nodes that form a "tree graph", structured as a tree, with their own node's value,
  # as well as references to either possible child node, where a node can only ever have
  # two children, as there are only ever two reverse values. Also records any possible
  # "terminal sequence state", whether that be that the "orbit distance" has been reached,
  # as an "out of bounds" stop, which is the regularly expected terminal state. Other
  # terminal states possible however include the cycle state and cycle length (end) states.
  class TreeGraphNode
    # The value of this node in the tree.
    attr_reader :node_value

    # The terminal SequenceState; nil if not a terminal node, MAX_STOP_OUT_OF_BOUNDS if the max_orbit_distance
    # has been reached, CYCLE_LENGTH if the node's value is found to have occured previously, or
    # CYCLE_INIT, retroactively applied when a CYCLE_LENGTH state node is found.
    attr_accessor :terminal_sequence_state

    # The "Pre N/P" TreeGraphNode child of this node that
    # is always present if this is not a terminal node.
    attr_reader :pre_n_div_p_node

    # The "Pre aN+b" TreeGraphNode child of this node that is
    # present if it exists and this is not a terminal node.
    attr_reader :pre_an_plus_b_node

    # Create an instance of TreeGraphNode which will yield its entire sub-tree of all child nodes.
    #
    # @raise FailedSaneParameterCheck If p or a are 0.
    #
    # @param +Integer+ *node_value:* The value for which to find the tree graph node reversal.
    #
    # @param +Integer+ *max_orbit_distance:* The maximum distance/orbit/branch length to travel.
    #
    # @param +Integer+ *p:* Modulus used to divide n, iff n is equivalent to (0 mod p).
    #
    # @param +Integer+ *a:* Factor by which to multiply n.
    #
    # @param +Integer+ *b:* Value to add to the scaled value of n.
    #
    # @param +Hash<Integer>+ *cycle_check:* A hash used to keep track of already graphed values
    #
    # @param +Boolean+ *create_raw:* Used to instruct the initialiser method to take 1:1 inputs, used in testing.
    #
    # @param SequenceState *terminal_sequence_state:*
    #
    # @param TreeGraphNode *pre_n_div_p_node:*
    #
    # @param TreeGraphNode *pre_an_plus_b_node:*
    #
    # @return [TreeGraphNode] A computed tree graph node
    def initialize(node_value, max_orbit_distance, p, a, b, cycle_check: nil, create_raw: false,
                   terminal_sequence_state: nil, pre_n_div_p_node: nil, pre_an_plus_b_node: nil)
      @node_value = node_value
      if create_raw
        @terminal_sequence_state = terminal_sequence_state
        @pre_n_div_p_node = pre_n_div_p_node
        @pre_an_plus_b_node = pre_an_plus_b_node
        return
      end
      # Handle cycle prevention for recursive calls
      if cycle_check.nil?
        cycle_check = { @node_value => self }
      elsif !cycle_check[@node_value].nil?
        # The value already exists in the cycle so this is a cyclic terminal
        cycle_check[@node_value].terminal_sequence_state = SequenceState::CYCLE_INIT
        @terminal_sequence_state = SequenceState::CYCLE_LENGTH
        @pre_n_div_p_node = nil
        @pre_an_plus_b_node = nil
        return
      else
        cycle_check[@node_value] = self
      end
      if [0, max_orbit_distance].max.zero?
        @terminal_sequence_state = SequenceState::MAX_STOP_OUT_OF_BOUNDS
        @pre_n_div_p_node = nil
        @pre_an_plus_b_node = nil
      else
        reverses = Collatz.reverse_function(node_value, p: p, a: a, b: b)
        @pre_n_div_p_node = TreeGraphNode.new(reverses[0], max_orbit_distance-1, p, a, b, cycle_check: cycle_check)
        if reverses.length == 2
          @pre_an_plus_b_node = TreeGraphNode.new(reverses[1], max_orbit_distance-1, p, a, b, cycle_check: cycle_check)
        else
          @pre_an_plus_b_node = nil
        end
      end
    end

    # This will only confirm an equality if the whole subtree of both nodes, including
    # node values, sequence states, and child nodes, checked recursively, are equal.
    #
    # @param TreeGraphNode *tgn:* The TreeGraphNode with which to compare equality.
    #
    # @return +Boolean+ true, if the entire sub-trees are equal.
    def sub_tree_equals(tgn)
      return false if self.node_value != tgn.node_value
      return false if self.terminal_sequence_state != tgn.terminal_sequence_state
      return false if self.pre_n_div_p_node.nil? && !tgn.pre_n_div_p_node.nil?
      return false if !self.pre_n_div_p_node.nil? && !self.pre_n_div_p_node.sub_tree_equals(tgn.pre_n_div_p_node)
      return false if self.pre_an_plus_b_node.nil? && !tgn.pre_an_plus_b_node.nil?
      return false if !self.pre_an_plus_b_node.nil? && !self.pre_an_plus_b_node.sub_tree_equals(tgn.pre_an_plus_b_node)
      true
    end
  end

  # Contains the results of computing the Tree Graph via tree_graph(~).
  # Contains the root node of a tree of TreeGraphNode's.
  class TreeGraph
    # The root node of the tree of TreeGraphNode's.
    attr_reader :root

    # Create a new TreeGraph with the root node defined by the inputs.
    #
    # @raise FailedSaneParameterCheck If p or a are 0.
    #
    # @param +Integer+ *node_value:* The value for which to find the tree graph node reversal.
    #
    # @param +Integer+ *max_orbit_distance:* The maximum distance/orbit/branch length to travel.
    #
    # @param +Integer+ *p:* Modulus used to divide n, iff n is equivalent to (0 mod p).
    #
    # @param +Integer+ *a:* Factor by which to multiply n.
    #
    # @param +Integer+ *b:* Value to add to the scaled value of n.
    #
    # @param +Boolean+ *create_raw:* Used to instruct the initialiser method to take 1:1 inputs, used in testing.
    #
    # @param TreeGraphNode *root:* A node that will be set to the root of this tree
    #
    # @return [TreeGraph] A tree graph, with a computed root node.
    def initialize(node_value, max_orbit_distance, p, a, b, create_raw: false, root: nil)
      if create_raw && !root.nil?
        @root = root
      else
        @root = TreeGraphNode.new(node_value, max_orbit_distance, p, a, b)
      end
    end

    # The equality between TreeGraph's is determined by the equality check on
    # subtrees. A subtree check will be done on both TreeGraph's root nodes.
    #
    # @param TreeGraph
    #
    # @return +Boolean+ true, if both are TreeGraph, with the entire root's sub-trees being equal.
    def ==(other)
      # Generic checks
      return false if other.nil?
      return false unless other.is_a?(self.class)
      # Actual check
      self.root.sub_tree_equals(other.root)
    end
  end

  # Returns a directed tree graph of the reverse function values up to a maximum
  # nesting of max_orbit_distance, with the initial_value as the root.
  #
  # @raise FailedSaneParameterCheck If p or a are 0.
  #
  # @param +Integer+ *initial_value:* The root value of the directed tree graph.
  #
  # @param +Integer+ *max_orbit_distance:* Maximum amount of times to iterate the reverse
  # function. There is no natural termination to populating the tree graph, equivalent
  # to the termination of hailstone sequences or stopping time attempts, so this is not
  # an optional argument like max_stopping_time / max_total_stopping_time, as it is the
  # intended target of orbits to obtain, rather than a limit to avoid uncapped computation.
  #
  # @param +Integer+ *p:* Modulus used to divide n, iff n is equivalent to (0 mod p).
  #
  # @param +Integer+ *a:* Factor by which to multiply n.
  #
  # @param +Integer+ *b:* Value to add to the scaled value of n.
  #
  # @return TreeGraph The branches of the tree graph as determined by the reverse function.
  module_function def tree_graph(initial_value, max_orbit_distance, p: 2, a: 3, b: 1)
    # Prior to starting the tree graph, which has some magic case handling, call
    # the reverse_function to trigger any assert_sane_parameterisation flags.
    _throwaway = reverse_function(initial_value, p: p, a: a, b: b)
    TreeGraph.new(initial_value, max_orbit_distance, p, a, b)
  end
end
