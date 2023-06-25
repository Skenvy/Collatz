/* eslint-env mocha */

import 'mocha';
import { assert } from 'chai';

import * as Collatz from '../src/index';
import defaultExport from '../src/index';

describe('NPM Package', () => {
  it('should be an object', () => {
    assert.isObject(defaultExport);
  });

  it('should have a collatzFunction property', () => {
    assert.property(defaultExport, 'collatzFunction');
  });

  it('should have a reverseFunction property', () => {
    assert.property(defaultExport, 'reverseFunction');
  });
});

describe('collatzFunction', () => {
  it('should be a function', () => {
    assert.isFunction(Collatz.collatzFunction);
  });

  // Default/Any (P,a,b); 0 trap
  it('should return the Default/Any (P,a,b); 0 trap', () => {
    const expected = 0n;
    const actual = Collatz.collatzFunction({ n: 0n });
    assert.equal(actual, expected);
  });

  // Default/Any (P,a,b); 1 cycle; positives
  it('should return the Default/Any (P,a,b); 1 cycle; positives', () => {
    assert.equal(Collatz.collatzFunction({ n: 1n }), 4n);
    assert.equal(Collatz.collatzFunction({ n: 4n }), 2n);
    assert.equal(Collatz.collatzFunction({ n: 2n }), 1n);
  });

  // Default/Any (P,a,b); -1 cycle; negatives
  it('should return the Default/Any (P,a,b); -1 cycle; negatives', () => {
    assert.equal(Collatz.collatzFunction({ n: -1n }), -2n);
    assert.equal(Collatz.collatzFunction({ n: -2n }), -1n);
  });

  // Test a wider modulo sweep by upping P to 5, a to 2, and b to 3
  it('should return the Test a wider modulo sweep by upping P to 5, a to 2, and b to 3', () => {
    assert.equal(Collatz.collatzFunction({ n: 1n, P: 5n, a: 2n, b: 3n }), 5n);
    assert.equal(Collatz.collatzFunction({ n: 2n, P: 5n, a: 2n, b: 3n }), 7n);
    assert.equal(Collatz.collatzFunction({ n: 3n, P: 5n, a: 2n, b: 3n }), 9n);
    assert.equal(Collatz.collatzFunction({ n: 4n, P: 5n, a: 2n, b: 3n }), 11n);
    assert.equal(Collatz.collatzFunction({ n: 5n, P: 5n, a: 2n, b: 3n }), 1n);
  });

  // Test negative P, a and b. We only use the (0 mod P) conjugacy class to
  // determine functionality, so flooring negative P doesn't cause any issue.
  it('should return the Test negative P, a and b.', () => {
    assert.equal(Collatz.collatzFunction({ n: 1n, P: -3n, a: -2n, b: -5n }), -7n);
    assert.equal(Collatz.collatzFunction({ n: 2n, P: -3n, a: -2n, b: -5n }), -9n);
    assert.equal(Collatz.collatzFunction({ n: 3n, P: -3n, a: -2n, b: -5n }), -1n);
  });

  // Set P and a to 0 to assert on assertSaneParameterisation.
  it('should return the assertion error', () => {
    assert.throws(() => { Collatz.collatzFunction({ n: 1n, P: 0n, a: 2n, b: 3n }); }, Collatz.FailedSaneParameterCheck, Collatz.SaneParameterErrMsg.SANE_PARAMS_P);
    assert.throws(() => { Collatz.collatzFunction({ n: 1n, P: 0n, a: 0n, b: 3n }); }, Collatz.FailedSaneParameterCheck, Collatz.SaneParameterErrMsg.SANE_PARAMS_P);
    assert.throws(() => { Collatz.collatzFunction({ n: 1n, P: 1n, a: 0n, b: 3n }); }, Collatz.FailedSaneParameterCheck, Collatz.SaneParameterErrMsg.SANE_PARAMS_A);
  });
});

describe('reverseFunction', () => {
  it('should be a function', () => {
    assert.isFunction(Collatz.reverseFunction);
  });

  // Default (P,a,b); 0 trap [as b is not a multiple of a]
  it('should return the Default (P,a,b); 0 trap', () => {
    const expected = [0n];
    const actual = Collatz.reverseFunction({ n: 0n });
    assert.deepEqual(actual, expected);
  });

  // Default (P,a,b); 1 cycle; positives
  it('should return the Default (P,a,b); 1 cycle; positives', () => {
    assert.deepEqual(Collatz.reverseFunction({ n: 1n }), [2n]);
    assert.deepEqual(Collatz.reverseFunction({ n: 4n }), [8n, 1n]);
    assert.deepEqual(Collatz.reverseFunction({ n: 2n }), [4n]);
  });

  // Default (P,a,b); -1 cycle; negatives
  it('should return the Default (P,a,b); -1 cycle; negatives', () => {
    assert.deepEqual(Collatz.reverseFunction({ n: -1n }), [-2n]);
    assert.deepEqual(Collatz.reverseFunction({ n: -2n }), [-4n, -1n]);
  });

  // Test a wider modulo sweep by upping P to 5, a to 2, and b to 3
  it('should return the Test a wider modulo sweep by upping P to 5, a to 2, and b to 3', () => {
    assert.deepEqual(Collatz.reverseFunction({ n: 1n, P: 5n, a: 2n, b: 3n }), [5n, -1n]);
    assert.deepEqual(Collatz.reverseFunction({ n: 2n, P: 5n, a: 2n, b: 3n }), [10n]);
    assert.deepEqual(Collatz.reverseFunction({ n: 3n, P: 5n, a: 2n, b: 3n }), [15n]); // also tests !0
    assert.deepEqual(Collatz.reverseFunction({ n: 4n, P: 5n, a: 2n, b: 3n }), [20n]);
    assert.deepEqual(Collatz.reverseFunction({ n: 5n, P: 5n, a: 2n, b: 3n }), [25n, 1n]);
  });

  // Test negative P, a and b. We only use the (0 mod P) conjugacy class to
  // determine functionality, so flooring negative P doesn't cause any issue.
  it('should return the Test negative P, a and b.', () => {
    assert.deepEqual(Collatz.reverseFunction({ n: 1n, P: -3n, a: -2n, b: -5n }), [-3n]); // != [-3, -3]
    assert.deepEqual(Collatz.reverseFunction({ n: 2n, P: -3n, a: -2n, b: -5n }), [-6n]);
    assert.deepEqual(Collatz.reverseFunction({ n: 3n, P: -3n, a: -2n, b: -5n }), [-9n, -4n]);
  });

  // Set P and a to 0 to assert on assertSaneParameterisation
  it('should return the assertion error', () => {
    assert.throws(() => { Collatz.reverseFunction({ n: 1n, P: 0n, a: 2n, b: 3n }); }, Collatz.FailedSaneParameterCheck, Collatz.SaneParameterErrMsg.SANE_PARAMS_P);
    assert.throws(() => { Collatz.reverseFunction({ n: 1n, P: 0n, a: 0n, b: 3n }); }, Collatz.FailedSaneParameterCheck, Collatz.SaneParameterErrMsg.SANE_PARAMS_P);
    assert.throws(() => { Collatz.reverseFunction({ n: 1n, P: 1n, a: 0n, b: 3n }); }, Collatz.FailedSaneParameterCheck, Collatz.SaneParameterErrMsg.SANE_PARAMS_A);
  });

  // If b is a multiple of a, but not of Pa, then 0 can have a reverse.
  it('should return the If b is a multiple of a, but not of Pa, then 0 can have a reverse.', () => {
    assert.deepEqual(Collatz.reverseFunction({ n: 0n, P: 17n, a: 2n, b: -6n }), [0n, 3n]);
    assert.deepEqual(Collatz.reverseFunction({ n: 0n, P: 17n, a: 2n, b: 102n }), [0n]);
  });
});

function assertHailstoneSequence(hail: Collatz.HailstoneSequence, expected: {values: bigint[], terminalCondition: Collatz.SequenceState, terminalStatus: number}): void {
  assert.deepEqual(hail.values, expected.values);
  assert.equal(hail.terminalCondition, expected.terminalCondition);
  assert.equal(hail.terminalStatus, expected.terminalStatus);
}


describe('hailstoneSequence', () => {
  it('should be a function', () => {
    assert.isFunction(Collatz.hailstoneSequence);
  });

  // Default (P,a,b); 0 trap [as b is not a multiple of a]
  it('should return the Default (P,a,b); 0 trap', () => {
    const expected = {
      values: [0n],
      terminalCondition: Collatz.SequenceState.ZERO_STOP,
      terminalStatus: 0
    };
    const actual = Collatz.hailstoneSequence({ initialValue: 0n });
    assertHailstoneSequence(actual, expected);
  });

  // Default (P,a,b); 1 cycle; "total stop"
  it('should terminate at a total stop for the cycle containing 1', () => {
    // The cycle containing 1 wont yield a cycle termination, as 1 is considered
    // the "total stop" that is the special case termination.
    let expected = {
      values: [1n],
      terminalCondition: Collatz.SequenceState.TOTAL_STOPPING_TIME,
      terminalStatus: 0
    };
    let actual = Collatz.hailstoneSequence({ initialValue: 1n });
    assertHailstoneSequence(actual, expected);
    // 1's cycle wont yield a description of it being a "cycle" as far as the
    // hailstones are concerned, which is to be expected, so..
    expected = {
      values: [4n, 2n, 1n],
      terminalCondition: Collatz.SequenceState.TOTAL_STOPPING_TIME,
      terminalStatus: 2
    };
    actual = Collatz.hailstoneSequence({ initialValue: 4n });
    assertHailstoneSequence(actual, expected);
    // As well as entering the cycle from above
    expected = {
      values: [16n, 8n, 4n, 2n, 1n],
      terminalCondition: Collatz.SequenceState.TOTAL_STOPPING_TIME,
      terminalStatus: 4
    };
    actual = Collatz.hailstoneSequence({ initialValue: 16n });
    assertHailstoneSequence(actual, expected);
  });

  // Default (P,a,b); the other known cycles; "are cycles"
  it('should yield a cycle length for the other known cycles', () => {
    // Test the 3 known default parameter's cycles (ignoring [1,4,2])
    let actual: Collatz.HailstoneSequence;
    let expected: {values: bigint[], terminalCondition: Collatz.SequenceState, terminalStatus: number};
    Collatz.KNOWN_CYCLES.forEach( (kc) => {
      if (!kc.includes(1n)) {
        expected = {
          values: [],
          terminalCondition: Collatz.SequenceState.CYCLE_LENGTH,
          terminalStatus: kc.length
        };
        actual = Collatz.hailstoneSequence({ initialValue: kc[0] });
        kc.forEach ( (v) => {
          expected.values.push(v);
        });
        expected.values.push(kc[0]);
        assertHailstoneSequence(actual, expected);
      }
    });
  });

  it('Minus56', () => {
  // // Test the lead into a cycle by entering two of the cycles; -5
  // BigInteger[] seq = Collatz.KNOWN_CYCLES[2].clone();
  // ArrayList<BigInteger> _seq = new ArrayList<BigInteger>();
  // _seq.add(seq[1].multiply(BigInteger.valueOf(4)));
  // _seq.add(seq[1].multiply(BigInteger.valueOf(2)));
  // List<BigInteger> _rotInnerSeq = Arrays.asList(seq);
  // Collections.rotate(_rotInnerSeq, -1);
  // _seq.addAll(_rotInnerSeq);
  // _seq.add(seq[0]); // The rotate also acts on seq, so we add [0] instead of [1]
  // long[] expected = wrapBigIntArr(_seq.toArray(BigInteger[]::new));
  // const actual = Collatz.hailstoneSequence({ initialValue: -56n });
  // assertHailstoneSequence(hail, expected, Collatz.SequenceState.CYCLE_LENGTH, seq.length);
  });

  it('Minus200', () => {
  // // Test the lead into a cycle by entering two of the cycles; -17
  // BigInteger[] seq = Collatz.KNOWN_CYCLES[3].clone();
  // ArrayList<BigInteger> _seq = new ArrayList<BigInteger>();
  // _seq.add(seq[1].multiply(BigInteger.valueOf(4)));
  // _seq.add(seq[1].multiply(BigInteger.valueOf(2)));
  // List<BigInteger> _rotInnerSeq = Arrays.asList(seq);
  // Collections.rotate(_rotInnerSeq, -1);
  // _seq.addAll(_rotInnerSeq);
  // _seq.add(seq[0]); // The rotate also acts on seq, so we add [0] instead of [1]
  // long[] expected = wrapBigIntArr(_seq.toArray(BigInteger[]::new));
  // const actual = Collatz.hailstoneSequence({ initialValue: -200n });
  // assertHailstoneSequence(hail, expected, Collatz.SequenceState.CYCLE_LENGTH, seq.length);
  });

  it('RegularStoppingTime', () => {
  // HailstoneSequence hail;
  // // Test the regular stopping time check.
  // const actual = Collatz.hailstoneSequence({ initialValue: 4, maxTotalStoppingTime: 1000, totalStoppingTime: false });
  // assertHailstoneSequence(hail, new long[]{4, 2}, Collatz.SequenceState.STOPPING_TIME, 1);
  // const actual = Collatz.hailstoneSequence({ initialValue: 5, maxTotalStoppingTime: 1000, totalStoppingTime: false });
  // assertHailstoneSequence(hail, new long[]{5, 16, 8, 4}, Collatz.SequenceState.STOPPING_TIME, 3);
  });

  it('NegativeMaxTotalStoppingTime', () => {
  // // Test small max total stopping time: (minimum internal value is one)
  // const actual = Collatz.hailstoneSequence({ initialValue: 4, maxTotalStoppingTime: -100, totalStoppingTime: true });
  // assertHailstoneSequence(hail, new long[]{4, 2}, Collatz.SequenceState.MAX_STOP_OUT_OF_BOUNDS, 1);
  });

  it('ZeroStopMidHail', () => {
  // // Test the zero stop mid hailing. This wont happen with default params tho.
  // const actual = Collatz.hailstoneSequence({ initialValue: 3, P: 2, a: 3, b: -9, maxTotalStoppingTime: 100, totalStoppingTime: true });
  // assertHailstoneSequence(hail, new long[]{3, 0}, Collatz.SequenceState.ZERO_STOP, -1);
  });

  it('UnitaryPCausesAlmostImmediateCycles', () => {
  // HailstoneSequence hail;
  // // Lastly, while the function wont let you use a P value of 0, 1 and -1 are
  // // still allowed, although they will generate immediate 1 or 2 length cycles
  // // respectively, so confirm the behaviour of each of these hailstones.
  // const actual = Collatz.hailstoneSequence({ initialValue: 3, P: 1, a: 3, b: 1, maxTotalStoppingTime: 100, totalStoppingTime: true });
  // assertHailstoneSequence(hail, new long[]{3, 3}, Collatz.SequenceState.CYCLE_LENGTH, 1);
  // const actual = Collatz.hailstoneSequence({ initialValue: 3, P: -1, a: 3, b: 1, maxTotalStoppingTime: 100, totalStoppingTime: true });
  // assertHailstoneSequence(hail, new long[]{3, -3, 3}, Collatz.SequenceState.CYCLE_LENGTH, 2);
  });

  // Set P and a to 0 to assert on assertSaneParameterisation
  it('should return the assertion error', () => {
    assert.throws(() => { Collatz.hailstoneSequence({ initialValue: 1n, P: 0n, a: 2n, b: 3n }); }, Collatz.FailedSaneParameterCheck, Collatz.SaneParameterErrMsg.SANE_PARAMS_P);
    assert.throws(() => { Collatz.hailstoneSequence({ initialValue: 1n, P: 0n, a: 0n, b: 3n }); }, Collatz.FailedSaneParameterCheck, Collatz.SaneParameterErrMsg.SANE_PARAMS_P);
    assert.throws(() => { Collatz.hailstoneSequence({ initialValue: 1n, P: 1n, a: 0n, b: 3n }); }, Collatz.FailedSaneParameterCheck, Collatz.SaneParameterErrMsg.SANE_PARAMS_A);
  });
});
