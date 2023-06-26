/* eslint-env mocha */

import 'mocha';
import { assert } from 'chai';

import * as Collatz from '../src/index';

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
