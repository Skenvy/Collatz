# frozen_string_literal: true

# expect(actual).to be(expected) # passes if actual.equal?(expected)
# expect(actual).to eq(expected) # passes if actual == expected

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
      # Set p and a to 0 to assert on assertSaneParameterisation
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
    it "testHailstoneSequence_ZeroTrap" do
      # Test 0's immediated termination.
      assert_hailstone_sequence(Collatz.hailstone_sequence(0), [0], Collatz::SequenceState::ZERO_STOP, 0)
    end

    it "testHailstoneSequence_OnesCycleOnlyYieldsATotalStop" do
      # The cycle containing 1 wont yield a cycle termination, as 1 is considered
      # the "total stop" that is the special case termination.
      assert_hailstone_sequence(Collatz.hailstone_sequence(1), [1], Collatz::SequenceState::TOTAL_STOPPING_TIME, 0)
      # 1's cycle wont yield a description of it being a "cycle" as far as the
      # hailstones are concerned, which is to be expected, so..
      assert_hailstone_sequence(Collatz.hailstone_sequence(4), [4, 2, 1], Collatz::SequenceState::TOTAL_STOPPING_TIME, 2)
      assert_hailstone_sequence(Collatz.hailstone_sequence(16), [16, 8, 4, 2, 1], Collatz::SequenceState::TOTAL_STOPPING_TIME, 4)
    end

    it "testHailstoneSequence_KnownCycles" do
      # Test the 3 known default parameter's cycles (ignoring [1,4,2])
      Collatz::KNOWN_CYCLES.each do |kc|
        unless kc.include? 1
          hail = Collatz.hailstone_sequence(kc[0])
          expected = Array.new(kc.length+1)
          for k in 0..(kc.length-1)
            expected[k] = kc[k]
          end
          expected[kc.length] = kc[0]
          assert_hailstone_sequence(hail, expected, Collatz::SequenceState::CYCLE_LENGTH, kc.length)
        end
      end
    end

    it "testHailstoneSequence_Minus56" do
      # Test the lead into a cycle by entering two of the cycles; -5
      kc = Collatz::KNOWN_CYCLES[2]
      expected = Array.new(kc.length+3)
      expected[0] = kc[1]*4
      expected[1] = kc[1]*2
      for k in 0..(kc.length-1) do
        expected[2+k] = kc[(k+1)%kc.length]
      end
      expected[kc.length+2] = kc[1]
      hail = Collatz.hailstone_sequence(-56)
      assert_hailstone_sequence(hail, expected, Collatz::SequenceState::CYCLE_LENGTH, kc.length)
    end

    it "testHailstoneSequence_Minus200" do
      # Test the lead into a cycle by entering two of the cycles; -17
      kc = Collatz::KNOWN_CYCLES[3]
      expected = Array.new(kc.length+3)
      expected[0] = kc[1]*4
      expected[1] = kc[1]*2
      for k in 0..(kc.length-1) do
        expected[2+k] = kc[(k+1)%kc.length]
      end
      expected[kc.length+2] = kc[1]
      hail = Collatz.hailstone_sequence(-200)
      assert_hailstone_sequence(hail, expected, Collatz::SequenceState::CYCLE_LENGTH, kc.length)
    end

    it "testHailstoneSequence_RegularStoppingTime" do
      # Test the regular stopping time check.
      assert_hailstone_sequence(Collatz.hailstone_sequence(4, total_stopping_time: false), [4, 2], Collatz::SequenceState::STOPPING_TIME, 1)
      assert_hailstone_sequence(Collatz.hailstone_sequence(5, total_stopping_time: false), [5, 16, 8, 4], Collatz::SequenceState::STOPPING_TIME, 3)
    end

    it "testHailstoneSequence_NegativeMaxTotalStoppingTime" do
      # Test small max total stopping time: (minimum internal value is one)
      assert_hailstone_sequence(Collatz.hailstone_sequence(4, max_total_stopping_time: -100), [4, 2], Collatz::SequenceState::MAX_STOP_OUT_OF_BOUNDS, 1)
    end

    it "testHailstoneSequence_ZeroStopMidHail" do
      # Test the zero stop mid hailing. This wont happen with default params tho.
      assert_hailstone_sequence(Collatz.hailstone_sequence(3, p: 2, a: 3, b: -9), [3, 0], Collatz::SequenceState::ZERO_STOP, -1)
    end

    it "testHailstoneSequence_UnitaryPCausesAlmostImmediateCycles" do
      # Lastly, while the function wont let you use a P value of 0, 1 and -1 are
      # still allowed, although they will generate immediate 1 or 2 length cycles
      # respectively, so confirm the behaviour of each of these hailstones.
      assert_hailstone_sequence(Collatz.hailstone_sequence(3, p: 1, a: 3, b: 1), [3, 3], Collatz::SequenceState::CYCLE_LENGTH, 1)
      assert_hailstone_sequence(Collatz.hailstone_sequence(3, p: -1, a: 3, b: 1), [3, -3, 3], Collatz::SequenceState::CYCLE_LENGTH, 2)
    end

    it "testHailstoneSequence_AssertSaneParameterisation" do
      # Set P and a to 0 to assert on assert_sane_parameterisation
      # rubocop:disable Layout/LineLength
      expect { Collatz.hailstone_sequence(1, p: 0, a: 2, b: 3) }.to raise_error(Collatz::FailedSaneParameterCheck, Collatz::SaneParameterErrMsg::SANE_PARAMS_P)
      expect { Collatz.hailstone_sequence(1, p: 0, a: 0, b: 3) }.to raise_error(Collatz::FailedSaneParameterCheck, Collatz::SaneParameterErrMsg::SANE_PARAMS_P)
      expect { Collatz.hailstone_sequence(1, p: 1, a: 0, b: 3) }.to raise_error(Collatz::FailedSaneParameterCheck, Collatz::SaneParameterErrMsg::SANE_PARAMS_A)
      # rubocop:enable Layout/LineLength
    end
  end

  context "stopping_time" do
    # test_name
    it "is not implemented" do
      expect { Collatz.stopping_time(0) }.to raise_error(NotImplementedError, "Will be implemented at, or before, v1.0.0") # rubocop:disable Layout/LineLength
    end
  end

  context "tree_graph" do
    # test_name
    it "is not implemented" do
      expect { Collatz.tree_graph(0, 1) }.to raise_error(NotImplementedError, "Will be implemented at, or before, v1.0.0") # rubocop:disable Layout/LineLength
    end
  end
end
