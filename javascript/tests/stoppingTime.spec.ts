/* eslint-env mocha */

import 'mocha';
import { assert } from 'chai';

import * as Collatz from '../src/index';

describe('stoppingTime', () => {
  it('should be a function', () => {
    assert.isFunction(Collatz.stoppingTime);
  });

  // Default (P,a,b); 0 trap [as b is not a multiple of a]
  it('should return the Default (P,a,b); 0 trap', () => {
    // // Test 0's immediated termination.
    assert.equal(Collatz.stoppingTime({ initialValue: 0n }), 0);
  });

  // Default (P,a,b); 1 cycle; "total stop"
  it('should terminate at a total stopping time for the cycle containing 1', () => {
    // The cycle containing 1 wont yield a cycle termination, as 1 is considered
    // the "total stop" that is the special case termination.
    assert.equal(Collatz.stoppingTime({ initialValue: 1n }), 0);
    // 1's cycle wont yield a description of it being a "cycle" as far as the
    // hailstones are concerned, which is to be expected, so..
    assert.equal(Collatz.stoppingTime({ initialValue: 4n, totalStoppingTime: true }), 2);
    assert.equal(Collatz.stoppingTime({ initialValue: 16n, totalStoppingTime: true }), 4);
  });

  // Default (P,a,b); the other known cycles; "are cycles"
  it('should yield infinity for the other known cycles', () => {
    // Test the 3 known default parameter's cycles (ignoring [1,4,2])
    Collatz.KNOWN_CYCLES.forEach( (kc) => {
      if (!kc.includes(1n)) {
        kc.forEach( (v) => {
          assert.equal(Collatz.stoppingTime({ initialValue: v, totalStoppingTime: true }), Infinity);
        });
      }
    });
  });

  // Default (P,a,b); cycle traps a lead in to the -5 cycle and -17 cycle
  it('yields infinity when seeking the total stopping time of values that lead into cycles', () => {
    // Test the lead into a cycle by entering two of the cycles. -56;-5, -200;-17
    assert.equal(Collatz.stoppingTime({ initialValue: -56n, totalStoppingTime: true }), Infinity);
    assert.equal(Collatz.stoppingTime({ initialValue: -200n, totalStoppingTime: true }), Infinity);
  });

  // Default (P,a,b); stops at the "non-total" stopping time if total stopping time is false.
  it('should halt at the regular stopping time', () => {
      // Test the regular stopping time check.
      assert.equal(Collatz.stoppingTime({ initialValue: 4n }), 1);
      assert.equal(Collatz.stoppingTime({ initialValue: 5n }), 3);
  });

  it('should yield a maximum stopping time "out of bounds" result for a negative stopping time', () => {
    // Test small max total stopping time: (minimum internal value is one)
    assert.equal(Collatz.stoppingTime({ initialValue: 5n, maxStoppingTime: -100 }), null);
  });

  it('should ZeroStopMidHail', () => {
    // Test the zero stop mid hailing. This wont happen with default params tho.
    assert.equal(Collatz.stoppingTime({ initialValue: 3n, P: 2n, a: 3n, b: -9n }), -1);
  });

  it('should exhibit a cycle of length 1 or at most 2, if P is 1 or -1', () => {
    // Lastly, while the function wont let you use a P value of 0, 1 and -1 are
    // still allowed, although they will generate immediate 1 or 2 length cycles
    // respectively, so confirm the behaviour of each of these stopping times.
    assert.equal(Collatz.stoppingTime({ initialValue: 3n, P: 1n, a: 3n, b: 1n }), Infinity);
    assert.equal(Collatz.stoppingTime({ initialValue: 3n, P: -1n, a: 3n, b: 1n }), Infinity);
  });

  it('should have a stopping time of 96 for values that are multiples of 576460752303423488, plus 27', () => {
    // One last one for the fun of it..
    assert.equal(Collatz.stoppingTime({ initialValue: 27n, totalStoppingTime: true }), 111);
    // # And for a bit more fun, common trajectories on
    for (let k = 0n; k < 5; k += 1n) {
      assert.equal(Collatz.stoppingTime({ initialValue: (27n + k * 576460752303423488n) }), 96);
    }
  });

  // Set P and a to 0 to assert on assertSaneParameterisation
  it('should return the assertion error', () => {
    assert.throws(() => { Collatz.stoppingTime({ initialValue: 1n, P: 0n, a: 2n, b: 3n }); }, Collatz.FailedSaneParameterCheck, Collatz.SaneParameterErrMsg.SANE_PARAMS_P);
    assert.throws(() => { Collatz.stoppingTime({ initialValue: 1n, P: 0n, a: 0n, b: 3n }); }, Collatz.FailedSaneParameterCheck, Collatz.SaneParameterErrMsg.SANE_PARAMS_P);
    assert.throws(() => { Collatz.stoppingTime({ initialValue: 1n, P: 1n, a: 0n, b: 3n }); }, Collatz.FailedSaneParameterCheck, Collatz.SaneParameterErrMsg.SANE_PARAMS_A);
  });
});
