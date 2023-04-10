/* eslint-env mocha */

import 'mocha';
import { assert } from 'chai';

import * as Collatz from '../src/index';
import defaultExport from '../src/index';

describe('NPM Package', () => {
  it('should be an object', () => {
    assert.isObject(defaultExport);
  });

  it('should have a Function property', () => {
    assert.property(defaultExport, 'Function');
  });
});

describe('Function', () => {
  it('should be a function', () => {
    assert.isFunction(Collatz.Function);
  });

  // Default/Any (P,a,b); 0 trap
  it('should return the Default/Any (P,a,b); 0 trap', () => {
    const expected = 0n;
    const actual = Collatz.Function({ n: 0n });
    assert.equal(actual, expected);
  });

  // Default/Any (P,a,b); 1 cycle; positives
  it('should return the Default/Any (P,a,b); 1 cycle; positives', () => {
    assert.equal(Collatz.Function({ n: 1n }), 4n);
    assert.equal(Collatz.Function({ n: 4n }), 2n);
    assert.equal(Collatz.Function({ n: 2n }), 1n);
  });

  // Default/Any (P,a,b); -1 cycle; negatives
  it('should return the Default/Any (P,a,b); -1 cycle; negatives', () => {
    assert.equal(Collatz.Function({ n: -1n }), -2n);
    assert.equal(Collatz.Function({ n: -2n }), -1n);
  });

  // Test a wider modulo sweep by upping P to 5, a to 2, and b to 3.
  it('should return the Test a wider modulo sweep by upping P to 5, a to 2, and b to 3.', () => {
    assert.equal(Collatz.Function({ n: 1n, P: 5n, a: 2n, b: 3n }), 5n);
    assert.equal(Collatz.Function({ n: 2n, P: 5n, a: 2n, b: 3n }), 7n);
    assert.equal(Collatz.Function({ n: 3n, P: 5n, a: 2n, b: 3n }), 9n);
    assert.equal(Collatz.Function({ n: 4n, P: 5n, a: 2n, b: 3n }), 11n);
    assert.equal(Collatz.Function({ n: 5n, P: 5n, a: 2n, b: 3n }), 1n);
  });

  // Test negative P, a and b. We only use the (0 mod P) conjugacy class to
  // determine functionality, so flooring negative P doesn't cause any issue.
  it('should return the Test negative P, a and b.', () => {
    assert.equal(Collatz.Function({ n: 1n, P: -3n, a: -2n, b: -5n }), -7n);
    assert.equal(Collatz.Function({ n: 2n, P: -3n, a: -2n, b: -5n }), -9n);
    assert.equal(Collatz.Function({ n: 3n, P: -3n, a: -2n, b: -5n }), -1n);
  });

  // Set P and a to 0 to assert on __assert_sane_parameterisation.
  it('should return the assertion error', () => {
    assert.throws(() => { Collatz.Function({ n: 1n, P: 0n, a: 2n, b: 3n }); }, Collatz.FailedSaneParameterCheck, Collatz.SaneParameterErrMsg.SANE_PARAMS_P);
    assert.throws(() => { Collatz.Function({ n: 1n, P: 0n, a: 0n, b: 3n }); }, Collatz.FailedSaneParameterCheck, Collatz.SaneParameterErrMsg.SANE_PARAMS_P);
    assert.throws(() => { Collatz.Function({ n: 1n, P: 1n, a: 0n, b: 3n }); }, Collatz.FailedSaneParameterCheck, Collatz.SaneParameterErrMsg.SANE_PARAMS_A);
  });
});
