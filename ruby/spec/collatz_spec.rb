# frozen_string_literal: true

# expect(actual).to equal(expected) # passes if a.equal?(b)
# expect(actual).to eql(expected)   # passes if a.eql?(b)
# expect(actual).to be == expected  # passes if a == b
# expect(actual).to be(expected)    # passes if actual.equal?(expected)
# expect(actual).to eq(expected)    # passes if actual == expected

RSpec.describe Collatz do
  it "has a version number" do
    expect(Collatz::VERSION).not_to be nil
  end

  context "function" do
    # testFunction_ZeroTrap
    it "gets trapped on 0" do
      # Default/Any (p,a,b); 0 trap
      expect(Collatz.function(0)).to eq(0)
    end

    # testFunction_OneCycle
    it "iterates the 1 cycle" do
      # Default/Any (p,a,b); 1 cycle; positives
      expect(Collatz.function(1)).to eq(4)
      expect(Collatz.function(4)).to eq(2)
      expect(Collatz.function(2)).to eq(1)
    end

    # testFunction_NegativeOneCycle
    it "iterates the -1 cycle" do
      # Default/Any (p,a,b); -1 cycle; negatives
      expect(Collatz.function(-1)).to eq(-2)
      expect(Collatz.function(-2)).to eq(-1)
    end

    # testFunction_WiderModuloSweep
    it "handles parameterisation" do
      # Test a wider modulo sweep by upping p to 5, a to 2, and b to 3.
      expect(Collatz.function(1, p: 5, a: 2, b: 3)).to eq(5)
      expect(Collatz.function(2, p: 5, a: 2, b: 3)).to eq(7)
      expect(Collatz.function(3, p: 5, a: 2, b: 3)).to eq(9)
      expect(Collatz.function(4, p: 5, a: 2, b: 3)).to eq(11)
      expect(Collatz.function(5, p: 5, a: 2, b: 3)).to eq(1)
    end

    # testFunction_NegativeParamterisation
    it "handles negative parameterisation" do
      # Test negative p, a and b. Modulo, used in the function, has ambiguous functionality
      # rather than the more definite euclidean, but we only use it's (0 mod p)
      # conjugacy class to determine functionality, so the flooring for negative p
      # doesn't cause any issue.
      expect(Collatz.function(1, p: -3, a: -2, b: -5)).to eq(-7)
      expect(Collatz.function(2, p: -3, a: -2, b: -5)).to eq(-9)
      expect(Collatz.function(3, p: -3, a: -2, b: -5)).to eq(-1)
    end

    # testFunction_AssertSaneParameterisation
    it "breaks on p or a being 0" do
      # Set p and a to 0 to assert on assert_sane_parameterisation
      # rubocop:disable Layout/LineLength
      expect { Collatz.function(1, p: 0, a: 2, b: 3) }.to raise_error(Collatz::FailedSaneParameterCheck, Collatz::SaneParameterErrMsg::SANE_PARAMS_P)
      expect { Collatz.function(1, p: 0, a: 0, b: 3) }.to raise_error(Collatz::FailedSaneParameterCheck, Collatz::SaneParameterErrMsg::SANE_PARAMS_P)
      expect { Collatz.function(1, p: 1, a: 0, b: 3) }.to raise_error(Collatz::FailedSaneParameterCheck, Collatz::SaneParameterErrMsg::SANE_PARAMS_A)
      # rubocop:enable Layout/LineLength
    end
  end

  context "reverse_function" do
    # testReverseFunction_ZeroTrap
    it "gets trapped on 0" do
      # Default (P,a,b); 0 trap [as b is not a multiple of a]
      expect(Collatz.reverse_function(0)).to eq([0])
    end

    # testReverseFunction_OneCycle
    it "reverse iterates the 1 cycle" do
      # Default (P,a,b); 1 cycle; positives
      expect(Collatz.reverse_function(1)).to eq([2])
      expect(Collatz.reverse_function(4)).to eq([8, 1])
      expect(Collatz.reverse_function(2)).to eq([4])
    end

    # testReverseFunction_NegativeOneCycle
    it "reverse iterates the -1 cycle" do
      # Default (P,a,b); -1 cycle; negatives
      expect(Collatz.reverse_function(-1)).to eq([-2])
      expect(Collatz.reverse_function(-2)).to eq([-4, -1])
    end

    # testReverseFunction_WiderModuloSweep
    it "handles parameterisation" do
      # Test a wider modulo sweep by upping P to 5, a to 2, and b to 3.
      expect(Collatz.reverse_function(1, p: 5, a: 2, b: 3)).to eq([5, -1])
      expect(Collatz.reverse_function(2, p: 5, a: 2, b: 3)).to eq([10])
      expect(Collatz.reverse_function(3, p: 5, a: 2, b: 3)).to eq([15]) # also tests !0
      expect(Collatz.reverse_function(4, p: 5, a: 2, b: 3)).to eq([20])
      expect(Collatz.reverse_function(5, p: 5, a: 2, b: 3)).to eq([25, 1])
    end

    # testReverseFunction_NegativeParamterisation
    it "handles negative parameterisation" do
      # We only use the (0 mod P) conjugacy class to determine functionality,
      # so we aren't concerned whether the % modulo is flooring (for negative P)
      # or if it is the more sensible euclidean modulo.
      expect(Collatz.reverse_function(1, p: -3, a: -2, b: -5)).to eq([-3]) # != [-3, -3]
      expect(Collatz.reverse_function(2, p: -3, a: -2, b: -5)).to eq([-6])
      expect(Collatz.reverse_function(3, p: -3, a: -2, b: -5)).to eq([-9, -4])
    end

    # testReverseFunction_ZeroReversesOnB
    it "might be able to reverse zero" do
      # If b is a multiple of a, but not of Pa, then 0 can have a reverse.
      expect(Collatz.reverse_function(0, p: 17, a: 2, b: -6)).to eq([0, 3])
      expect(Collatz.reverse_function(0, p: 17, a: 2, b: 102)).to eq([0])
    end

    # testReverseFunction_AssertSaneParameterisation
    it "breaks on p or a being 0" do
      # Set P and a to 0 to assert on assert_sane_parameterisation
      # rubocop:disable Layout/LineLength
      expect { Collatz.reverse_function(1, p: 0, a: 2, b: 3) }.to raise_error(Collatz::FailedSaneParameterCheck, Collatz::SaneParameterErrMsg::SANE_PARAMS_P)
      expect { Collatz.reverse_function(1, p: 0, a: 0, b: 3) }.to raise_error(Collatz::FailedSaneParameterCheck, Collatz::SaneParameterErrMsg::SANE_PARAMS_P)
      expect { Collatz.reverse_function(1, p: 1, a: 0, b: 3) }.to raise_error(Collatz::FailedSaneParameterCheck, Collatz::SaneParameterErrMsg::SANE_PARAMS_A)
      # rubocop:enable Layout/LineLength
    end
  end

  def assert_hailstone_sequence(hail, values, terminal_condition, terminal_status)
    expect(hail.values).to eq(values)
    expect(hail.terminal_condition).to eq(terminal_condition)
    expect(hail.terminal_status).to eq(terminal_status)
  end

  context "hailstone_sequence" do
    # testHailstoneSequence_ZeroTrap
    it "gets trapped on 0" do
      # Test 0's immediated termination.
      actual = Collatz.hailstone_sequence(0)
      assert_hailstone_sequence(actual, [0], Collatz::SequenceState::ZERO_STOP, 0)
    end

    # testHailstoneSequence_OnesCycleOnlyYieldsATotalStop
    it "yields a total stop from the 1 cycle" do
      # The cycle containing 1 wont yield a cycle termination, as 1 is considered
      # the "total stop" that is the special case termination.
      actual = Collatz.hailstone_sequence(1)
      assert_hailstone_sequence(actual, [1], Collatz::SequenceState::TOTAL_STOPPING_TIME, 0)
      # 1's cycle wont yield a description of it being a "cycle" as far as the
      # hailstones are concerned, which is to be expected, so..
      actual = Collatz.hailstone_sequence(4)
      assert_hailstone_sequence(actual, [4, 2, 1], Collatz::SequenceState::TOTAL_STOPPING_TIME, 2)
      actual = Collatz.hailstone_sequence(16)
      assert_hailstone_sequence(actual, [16, 8, 4, 2, 1], Collatz::SequenceState::TOTAL_STOPPING_TIME, 4)
    end

    # testHailstoneSequence_KnownCycles
    it "detects a cycle for every other known cycle" do
      # Test the 3 known default parameter's cycles (ignoring [1,4,2])
      Collatz::KNOWN_CYCLES.each do |kc|
        unless kc.include? 1
          actual = Collatz.hailstone_sequence(kc[0])
          expected = Array.new(kc.length+1)
          for k in 0..(kc.length-1)
            expected[k] = kc[k]
          end
          expected[kc.length] = kc[0]
          assert_hailstone_sequence(actual, expected, Collatz::SequenceState::CYCLE_LENGTH, kc.length)
        end
      end
    end

    # testHailstoneSequence_Minus56
    it "detects the -5 cycle from an external value" do
      # Test the lead into a cycle by entering two of the cycles; -5
      kc = Collatz::KNOWN_CYCLES[2]
      expected = Array.new(kc.length+3)
      expected[0] = kc[1]*4
      expected[1] = kc[1]*2
      for k in 0..(kc.length-1) do
        expected[2+k] = kc[(k+1)%kc.length]
      end
      expected[kc.length+2] = kc[1]
      actual = Collatz.hailstone_sequence(-56)
      assert_hailstone_sequence(actual, expected, Collatz::SequenceState::CYCLE_LENGTH, kc.length)
    end

    # testHailstoneSequence_Minus200
    it "detects the -17 cycle from an external value" do
      # Test the lead into a cycle by entering two of the cycles; -17
      kc = Collatz::KNOWN_CYCLES[3]
      expected = Array.new(kc.length+3)
      expected[0] = kc[1]*4
      expected[1] = kc[1]*2
      for k in 0..(kc.length-1) do
        expected[2+k] = kc[(k+1)%kc.length]
      end
      expected[kc.length+2] = kc[1]
      actual = Collatz.hailstone_sequence(-200)
      assert_hailstone_sequence(actual, expected, Collatz::SequenceState::CYCLE_LENGTH, kc.length)
    end

    # testHailstoneSequence_RegularStoppingTime
    it "appropriately stops at the stopping time if not a total stop" do
      # Test the regular stopping time check.
      actual = Collatz.hailstone_sequence(4, total_stopping_time: false)
      assert_hailstone_sequence(actual, [4, 2], Collatz::SequenceState::STOPPING_TIME, 1)
      actual = Collatz.hailstone_sequence(5, total_stopping_time: false)
      assert_hailstone_sequence(actual, [5, 16, 8, 4], Collatz::SequenceState::STOPPING_TIME, 3)
    end

    # testHailstoneSequence_NegativeMaxTotalStoppingTime
    it "Quickly exits OoB on a negative max total stopping time" do
      # Test small max total stopping time: (minimum internal value is one)
      actual = Collatz.hailstone_sequence(4, max_total_stopping_time: -100)
      assert_hailstone_sequence(actual, [4, 2], Collatz::SequenceState::MAX_STOP_OUT_OF_BOUNDS, 1)
    end

    # testHailstoneSequence_ZeroStopMidHail
    it "Stops on the 0 trap while hailing" do
      # Test the zero stop mid hailing. This wont happen with default params tho.
      actual = Collatz.hailstone_sequence(3, p: 2, a: 3, b: -9)
      assert_hailstone_sequence(actual, [3, 0], Collatz::SequenceState::ZERO_STOP, -1)
    end

    # testHailstoneSequence_UnitaryPCausesAlmostImmediateCycles
    it "|P| values of 1 cause semi-immediate cycles" do
      # Lastly, while the function wont let you use a P value of 0, 1 and -1 are
      # still allowed, although they will generate immediate 1 or 2 length cycles
      # respectively, so confirm the behaviour of each of these hailstones.
      actual = Collatz.hailstone_sequence(3, p: 1, a: 3, b: 1)
      assert_hailstone_sequence(actual, [3, 3], Collatz::SequenceState::CYCLE_LENGTH, 1)
      actual = Collatz.hailstone_sequence(3, p: -1, a: 3, b: 1)
      assert_hailstone_sequence(actual, [3, -3, 3], Collatz::SequenceState::CYCLE_LENGTH, 2)
    end

    # testHailstoneSequence_AssertSaneParameterisation
    it "breaks on p or a being 0" do
      # Set P and a to 0 to assert on assert_sane_parameterisation
      # rubocop:disable Layout/LineLength
      expect { Collatz.hailstone_sequence(1, p: 0, a: 2, b: 3) }.to raise_error(Collatz::FailedSaneParameterCheck, Collatz::SaneParameterErrMsg::SANE_PARAMS_P)
      expect { Collatz.hailstone_sequence(1, p: 0, a: 0, b: 3) }.to raise_error(Collatz::FailedSaneParameterCheck, Collatz::SaneParameterErrMsg::SANE_PARAMS_P)
      expect { Collatz.hailstone_sequence(1, p: 1, a: 0, b: 3) }.to raise_error(Collatz::FailedSaneParameterCheck, Collatz::SaneParameterErrMsg::SANE_PARAMS_A)
      # rubocop:enable Layout/LineLength
    end
  end

  context "stopping_time" do
    # testStoppingTime_ZeroTrap
    it "gets trapped on 0" do
      # Test 0's immediated termination.
      expect(Collatz.stopping_time(0)).to eq(0)
    end

    # testStoppingTime_OnesCycleOnlyYieldsATotalStop
    it "yields a total stopping time from the 1 cycle" do
      # The cycle containing 1 wont yield a cycle termination, as 1 is considered
      # the "total stop" that is the special case termination.
      expect(Collatz.stopping_time(1)).to eq(0)
      # 1's cycle wont yield a description of it being a "cycle" as far as the
      # hailstones are concerned, which is to be expected, so..
      expect(Collatz.stopping_time(4, max_stopping_time: 100, total_stopping_time: true)).to eq(2)
      expect(Collatz.stopping_time(16, max_stopping_time: 100, total_stopping_time: true)).to eq(4)
    end

    # testStoppingTime_KnownCyclesYieldInfinity
    it "detects a cycle rather than stopping for every other known cycle" do
      # Test the 3 known default parameter's cycles (ignoring [1,4,2])
      Collatz::KNOWN_CYCLES.each do |kc|
        unless kc.include? 1
          kc.each do |c|
            expect(Collatz.stopping_time(c, max_stopping_time: 100, total_stopping_time: true)).to eq(Float::INFINITY)
          end
        end
      end
    end

    # testStoppingTime_KnownCycleLeadIns
    it "detects the -5 and -17 cycles from an external value" do
      # Test the lead into a cycle by entering two of the cycles. -56;-5, -200;-17
      expect(Collatz.stopping_time(-56, max_stopping_time: 100, total_stopping_time: true)).to eq(Float::INFINITY)
      expect(Collatz.stopping_time(-200, max_stopping_time: 100, total_stopping_time: true)).to eq(Float::INFINITY)
    end

    # testStoppingTime_RegularStoppingTime
    it "appropriately stops at the regular stopping time by default" do
      # Test the regular stopping time check.
      expect(Collatz.stopping_time(4)).to eq(1)
      expect(Collatz.stopping_time(5)).to eq(3)
    end

    # testStoppingTime_NegativeMaxTotalStoppingTime
    it "Quickly exits OoB on a negative max stopping time" do
      # Test small max total stopping time: (minimum internal value is one)
      expect(Collatz.stopping_time(5, max_stopping_time: -100, total_stopping_time: true)).to eq(nil)
    end

    # testStoppingTime_ZeroStopMidHail
    it "Stops on the 0 trap while hailing" do
      # Test the zero stop mid hailing. This wont happen with default params tho.
      expect(Collatz.stopping_time(3, p: 2, a: 3, b: -9, max_stopping_time: 100)).to eq(-1)
    end

    # testStoppingTime_UnitaryPCausesAlmostImmediateCycles
    it "|P| values of 1 cause semi-immediate cycles" do
      # Lastly, while the function wont let you use a P value of 0, 1 and -1 are
      # still allowed, although they will generate immediate 1 or 2 length cycles
      # respectively, so confirm the behaviour of each of these stopping times.
      expect(Collatz.stopping_time(3, p: 1, a: 3, b: 1, max_stopping_time: 100)).to eq(Float::INFINITY)
      expect(Collatz.stopping_time(3, p: -1, a: 3, b: 1, max_stopping_time: 100)).to eq(Float::INFINITY)
    end

    # testStoppingTime_MultiplesOf576460752303423488Plus27
    it "Yields a stopping time of 96 for multiples of 576460752303423488 plus 27" do
      # One last one for the fun of it..
      expect(Collatz.stopping_time(27, max_stopping_time: 120, total_stopping_time: true)).to eq(111)
      # # And for a bit more fun, common trajectories on
      for k in 0..5 do
        expect(Collatz.stopping_time(27+(k*576460752303423488), max_stopping_time: 100)).to eq(96)
      end
    end

    # testStoppingTime_AssertSaneParameterisation
    it "breaks on p or a being 0" do
      # Set P and a to 0 to assert on assert_sane_parameterisation
      # rubocop:disable Layout/LineLength
      expect { Collatz.stopping_time(1, p: 0, a: 2, b: 3) }.to raise_error(Collatz::FailedSaneParameterCheck, Collatz::SaneParameterErrMsg::SANE_PARAMS_P)
      expect { Collatz.stopping_time(1, p: 0, a: 0, b: 3) }.to raise_error(Collatz::FailedSaneParameterCheck, Collatz::SaneParameterErrMsg::SANE_PARAMS_P)
      expect { Collatz.stopping_time(1, p: 1, a: 0, b: 3) }.to raise_error(Collatz::FailedSaneParameterCheck, Collatz::SaneParameterErrMsg::SANE_PARAMS_A)
      # rubocop:enable Layout/LineLength
    end
  end

  # The whole set of tests for tree graph and helper defs ignore the following cops
  # rubocop:disable Layout/HashAlignment, Layout/ArgumentAlignment
  # Create a "terminal" graph node with nil children and the terminal
  # condition that indicates it has reached the maximum orbit of the tree.
  # @param [Integer] n
  # @return TreeGraphNode
  def wrap_tgn_terminal_node(n)
    Collatz::TreeGraphNode.new(n, 0, 0, 0, 0, create_raw: true,
      terminal_sequence_state: Collatz::SequenceState::MAX_STOP_OUT_OF_BOUNDS)
  end

  # Create a "cyclic terminal" graph node with nil children and the "cycle termination" condition.
  # @param [Integer] n
  # @return TreeGraphNode
  def wrap_tgn_cyclic_terminal(n)
    Collatz::TreeGraphNode.new(n, 0, 0, 0, 0, create_raw: true,
      terminal_sequence_state: Collatz::SequenceState::CYCLE_LENGTH)
  end

  # Create a "cyclic start" graph node with given children and the "cycle start" condition.
  # @param [Integer] n
  # @param [TreeGraphNode] pre_n_div_p_node
  # @param [TreeGraphNode] pre_an_plus_b_node
  # @return TreeGraphNode
  def wrap_tgn_cyclic_start(n, pre_n_div_p_node, pre_an_plus_b_node)
    Collatz::TreeGraphNode.new(n, 0, 0, 0, 0, create_raw: true,
      terminal_sequence_state: Collatz::SequenceState::CYCLE_INIT,
      pre_n_div_p_node: pre_n_div_p_node,
      pre_an_plus_b_node: pre_an_plus_b_node)
  end

  # Create a graph node with no terminal state, with given children.
  # @param [Integer] n
  # @param [TreeGraphNode] pre_n_div_p_node
  # @param [TreeGraphNode] pre_an_plus_b_node
  # @return TreeGraphNode
  def wrap_tgn_generic(n, pre_n_div_p_node, pre_an_plus_b_node)
    Collatz::TreeGraphNode.new(n, 0, 0, 0, 0, create_raw: true,
      pre_n_div_p_node: pre_n_div_p_node,
      pre_an_plus_b_node: pre_an_plus_b_node)
  end

  # Create the tree graph with a root node
  # @param [TreeGraphNode] expected_root
  # @return TreeGraph
  def wrap_tgn_root(expected_root)
    Collatz::TreeGraph.new(0, 0, 0, 0, 0, create_raw: true, root: expected_root)
  end

  context "tree_graph" do
    # testTreeGraph_ZeroTrap
    it "gets trapped on 0" do
      # ":D" for terminal, "C:" for cyclic end
      # The default zero trap
      # {0:D}
      expected_tree = wrap_tgn_root(wrap_tgn_terminal_node(0))
      expect(Collatz.tree_graph(0, 0)).to eq(expected_tree)
      # {0:{C:0}}
      expected_tree = wrap_tgn_root(wrap_tgn_cyclic_start(0, wrap_tgn_cyclic_terminal(0), nil))
      expect(Collatz.tree_graph(0, 1)).to eq(expected_tree)
      expect(Collatz.tree_graph(0, 2)).to eq(expected_tree)
    end

    # testTreeGraph_RootOfOneYieldsTheOneCycle
    it "exhibits a cycle terminus from within the 1 cycle, starting with 1" do
      # ":D" for terminal, "C:" for cyclic end
      # The roundings of the 1 cycle.
      # {1:D}
      expected_tree = wrap_tgn_root(wrap_tgn_terminal_node(1))
      expect(Collatz.tree_graph(1, 0)).to eq(expected_tree)
      # {1:{2:D}}
      expected_tree = wrap_tgn_root(wrap_tgn_generic(1, wrap_tgn_terminal_node(2), nil))
      expect(Collatz.tree_graph(1, 1)).to eq(expected_tree)
      # {1:{2:{4:D}}}
      expected_tree = wrap_tgn_root(wrap_tgn_generic(1, wrap_tgn_generic(2, wrap_tgn_terminal_node(4), nil), nil))
      expect(Collatz.tree_graph(1, 2)).to eq(expected_tree)
      # {1:{2:{4:{C:1,8:D}}}}
      expected_tree = wrap_tgn_root(wrap_tgn_cyclic_start(1, wrap_tgn_generic(2, wrap_tgn_generic(4,
                      wrap_tgn_terminal_node(8), wrap_tgn_cyclic_terminal(1)), nil), nil))
      expect(Collatz.tree_graph(1, 3)).to eq(expected_tree)
    end

    # testTreeGraph_RootOfTwoAndFourYieldTheOneCycle
    it "exhibits a cycle terminus from within the 1 cycle, starting with 2 and 4" do
      # ":D" for terminal, "C:" for cyclic end
      # {2:{4:{1:{C:2},8:{16:D}}}}
      expected_tree = wrap_tgn_root(wrap_tgn_cyclic_start(2, wrap_tgn_generic(4, wrap_tgn_generic(8,
                      wrap_tgn_terminal_node(16), nil), wrap_tgn_generic(1, wrap_tgn_cyclic_terminal(2), nil)), nil))
      expect(Collatz.tree_graph(2, 3)).to eq(expected_tree)
      # {4:{1:{2:{C:4}},8:{16:{5:D,32:D}}}}
      expected_tree = wrap_tgn_root(wrap_tgn_cyclic_start(4, wrap_tgn_generic(8, wrap_tgn_generic(16,
                      wrap_tgn_terminal_node(32), wrap_tgn_terminal_node(5)), nil), wrap_tgn_generic(1,
                      wrap_tgn_generic(2, wrap_tgn_cyclic_terminal(4), nil), nil)))
      expect(Collatz.tree_graph(4, 3)).to eq(expected_tree)
    end

    # testTreeGraph_RootOfMinusOneYieldsTheMinusOneCycle
    it "exhibits a cycle terminus from within the -1 cycle" do
      # ":D" for terminal, "C:" for cyclic end
      # The roundings of the -1 cycle
      # {-1:{-2:D}}
      expected_tree = wrap_tgn_root(wrap_tgn_generic(-1, wrap_tgn_terminal_node(-2), nil))
      expect(Collatz.tree_graph(-1, 1)).to eq(expected_tree)
      # {-1:{-2:{-4:D,C:-1}}}
      expected_tree = wrap_tgn_root(wrap_tgn_cyclic_start(-1, wrap_tgn_generic(-2,
                      wrap_tgn_terminal_node(-4), wrap_tgn_cyclic_terminal(-1)), nil))
      expect(Collatz.tree_graph(-1, 2)).to eq(expected_tree)
    end

    # testTreeGraph_WiderModuloSweep
    it "appropriately grows a tree for parameterised inputs" do
      # ":D" for terminal, "C:" for cyclic end
      # Test a wider modulo sweep by upping P to 5, a to 2, and b to 3.
      # Orbit distance of 1 ~= {1:{-1:D,5:D}}
      expected_tree = wrap_tgn_root(wrap_tgn_generic(1, wrap_tgn_terminal_node(5), wrap_tgn_terminal_node(-1)))
      expect(Collatz.tree_graph(1, 1, p: 5, a: 2, b: 3)).to eq(expected_tree)
      # Orbit distance of 2 ~= {1:{-1:{-5:D,-2:D},5:{C:1,25:D}}}
      expected_tree = wrap_tgn_root(wrap_tgn_cyclic_start(1, wrap_tgn_generic(5,
                      wrap_tgn_terminal_node(25), wrap_tgn_cyclic_terminal(1)),
                      wrap_tgn_generic(-1, wrap_tgn_terminal_node(-5), wrap_tgn_terminal_node(-2))))
      expect(Collatz.tree_graph(1, 2, p: 5, a: 2, b: 3)).to eq(expected_tree)
      # Orbit distance of 3 ~=  {1:{-1:{-5:{-25:D,-4:D},-2:{-10:D}},5:{C:1,25:{11:D,125:D}}}}
      expected_tree = wrap_tgn_root(wrap_tgn_cyclic_start(1, wrap_tgn_generic(5, wrap_tgn_generic(25,
                      wrap_tgn_terminal_node(125), wrap_tgn_terminal_node(11)), wrap_tgn_cyclic_terminal(1)),
                      wrap_tgn_generic(-1, wrap_tgn_generic(-5, wrap_tgn_terminal_node(-25),
                      wrap_tgn_terminal_node(-4)), wrap_tgn_generic(-2, wrap_tgn_terminal_node(-10), nil))))
      expect(Collatz.tree_graph(1, 3, p: 5, a: 2, b: 3)).to eq(expected_tree)
    end

    # testTreeGraph_NegativeParamterisation
    it "appropriately grows a tree for negative parameterised inputs" do
      # ":D" for terminal, "C:" for cyclic end
      # Test negative P, a and b ~ P=-3, a=-2, b=-5
      # Orbit distance of 1 ~= {1:{-3:D}}
      expected_tree = wrap_tgn_root(wrap_tgn_generic(1, wrap_tgn_terminal_node(-3), nil))
      expect(Collatz.tree_graph(1, 1, p: -3, a: -2, b: -5)).to eq(expected_tree)
      # Orbit distance of 2 ~= {1:{-3:{-1:D,9:D}}}
      expected_tree = wrap_tgn_root(wrap_tgn_generic(1, wrap_tgn_generic(-3,
                      wrap_tgn_terminal_node(9), wrap_tgn_terminal_node(-1)), nil))
      expect(Collatz.tree_graph(1, 2, p: -3, a: -2, b: -5)).to eq(expected_tree)
      # Orbit distance of 3 ~= {1:{-3:{-1:{-2:D,3:D},9:{-27:D,-7:D}}}}
      expected_tree = wrap_tgn_root(wrap_tgn_generic(1, wrap_tgn_generic(-3, wrap_tgn_generic(9,
                      wrap_tgn_terminal_node(-27), wrap_tgn_terminal_node(-7)), wrap_tgn_generic(-1,
                      wrap_tgn_terminal_node(3), wrap_tgn_terminal_node(-2))), nil))
      expect(Collatz.tree_graph(1, 3, p: -3, a: -2, b: -5)).to eq(expected_tree)
    end

    # testTreeGraph_ZeroReversesOnB
    it "might be able to reverse zero" do
      # ":D" for terminal, "C:" for cyclic end
      # If b is a multiple of a, but not of Pa, then 0 can have a reverse.
      # {0:{C:0,3:D}}
      expected_tree = wrap_tgn_root(wrap_tgn_cyclic_start(0, wrap_tgn_cyclic_terminal(0), wrap_tgn_terminal_node(3)))
      expect(Collatz.tree_graph(0, 1, p: 17, a: 2, b: -6)).to eq(expected_tree)
      # {0:{C:0}}
      expected_tree = wrap_tgn_root(wrap_tgn_cyclic_start(0, wrap_tgn_cyclic_terminal(0), nil))
      expect(Collatz.tree_graph(0, 1, p: 17, a: 2, b: 102)).to eq(expected_tree)
    end

    # testTreeGraph_AssertSaneParameterisation
    it "breaks on p or a being 0" do
      # Set p and a to 0 to assert on assert_sane_parameterisation
      # rubocop:disable Layout/LineLength
      expect { Collatz.tree_graph(1, 1, p: 0, a: 2, b: 3) }.to raise_error(Collatz::FailedSaneParameterCheck, Collatz::SaneParameterErrMsg::SANE_PARAMS_P)
      expect { Collatz.tree_graph(1, 1, p: 0, a: 0, b: 3) }.to raise_error(Collatz::FailedSaneParameterCheck, Collatz::SaneParameterErrMsg::SANE_PARAMS_P)
      expect { Collatz.tree_graph(1, 1, p: 1, a: 0, b: 3) }.to raise_error(Collatz::FailedSaneParameterCheck, Collatz::SaneParameterErrMsg::SANE_PARAMS_A)
      # rubocop:enable Layout/LineLength
    end
  end
  # rubocop:enable Layout/HashAlignment, Layout/ArgumentAlignment
end
