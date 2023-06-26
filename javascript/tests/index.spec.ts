/* eslint-env mocha */

import 'mocha';
import { assert } from 'chai';

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

  it('should have a hailstoneSequence property', () => {
    assert.property(defaultExport, 'hailstoneSequence');
  });

  it('should have a stoppingTime property', () => {
    assert.property(defaultExport, 'stoppingTime');
  });
});
