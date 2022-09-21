# frozen_string_literal: true

# expect(actual).to be(expected) # passes if actual.equal?(expected)
# expect(actual).to eq(expected) # passes if actual == expected

RSpec.describe Collatz do
  it "has a version number" do
    expect(Collatz::VERSION).not_to be nil
  end

  context "function" do
    it "does something useful" do
      expect(true).to eq(true)
    end

    # testFunction_ZeroTrap
    it "gets trapped on 0" do
      # Default/Any (p,a,b); 0 trap
      expect(function(0)).to eq(0)
    end

    # testFunction_OneCycle
    it "iterates the 1 cycle" do
      # Default/Any (p,a,b); 1 cycle; positives
      expect(function(1)).to eq(4)
      expect(function(4)).to eq(2)
      expect(function(2)).to eq(1)
    end

    # testFunction_NegativeOneCycle
    it "iterates the -1 cycle" do
      # Default/Any (p,a,b); -1 cycle; negatives
      expect(function(-1)).to eq(-2)
      expect(function(-2)).to eq(-1)
    end

    # testFunction_WiderModuloSweep
    it "handles parameterisation" do
      # Test a wider modulo sweep by upping p to 5, a to 2, and b to 3.
      expect(function(1, 5, 2, 3)).to eq(5)
      expect(function(2, 5, 2, 3)).to eq(7)
      expect(function(3, 5, 2, 3)).to eq(9)
      expect(function(4, 5, 2, 3)).to eq(11)
      expect(function(5, 5, 2, 3)).to eq(1)
    end

    # testFunction_NegativeParamterisation
    it "handles negative parameterisation" do
      # Test negative p, a and b. Modulo, used in the function, has ambiguous functionality
      # rather than the more definite euclidean, but we only use it's (0 mod p)
      # conjugacy class to determine functionality, so the flooring for negative p
      # doesn't cause any issue.
      expect(function(1, -3, -2, -5)).to eq(-7)
      expect(function(2, -3, -2, -5)).to eq(-9)
      expect(function(3, -3, -2, -5)).to eq(-1)
    end

    # testFunction_AssertSaneParameterisation
    it "breaks on p or a being 0" do
      # Set p and a to 0 to assert on assertSaneParameterisation
      expect { function(1, 0, 2, 3) }.to raise_error(FailedSaneParameterCheck, SaneParameterErrMsg::SANE_PARAMS_P)
      expect { function(1, 0, 0, 3) }.to raise_error(FailedSaneParameterCheck, SaneParameterErrMsg::SANE_PARAMS_P)
      expect { function(1, 1, 0, 3) }.to raise_error(FailedSaneParameterCheck, SaneParameterErrMsg::SANE_PARAMS_A)
    end
  end

  context "reverse_function" do
    it "does something useful" do
      expect(true).to eq(true)
    end
  end

  context "hailstone_sequence" do
    it "does something useful" do
      expect(true).to eq(true)
    end
  end

  context "stopping_time" do
    it "does something useful" do
      expect(true).to eq(true)
    end
  end

  context "tree_graph" do
    it "does something useful" do
      expect(true).to eq(true)
    end
  end
end
