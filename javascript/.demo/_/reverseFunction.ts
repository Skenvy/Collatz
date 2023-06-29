import * as Collatz from '@skenvy/collatz';

// Default (P,a,b); 0 trap [as b is not a multiple of a]
// 'should return the Default (P,a,b); 0 trap'
console.log(Collatz.reverseFunction({ n: 0n }), [0n]);

// Default (P,a,b); 1 cycle; positives
// 'should return the Default (P,a,b); 1 cycle; positives'
console.log(Collatz.reverseFunction({ n: 1n }), [2n]);
console.log(Collatz.reverseFunction({ n: 4n }), [8n, 1n]);
console.log(Collatz.reverseFunction({ n: 2n }), [4n]);

// Default (P,a,b); -1 cycle; negatives
// 'should return the Default (P,a,b); -1 cycle; negatives'
console.log(Collatz.reverseFunction({ n: -1n }), [-2n]);
console.log(Collatz.reverseFunction({ n: -2n }), [-4n, -1n]);

// Test a wider modulo sweep by upping P to 5, a to 2, and b to 3
// 'should return the Test a wider modulo sweep by upping P to 5, a to 2, and b to 3'
console.log(Collatz.reverseFunction({ n: 1n, P: 5n, a: 2n, b: 3n }), [5n, -1n]);
console.log(Collatz.reverseFunction({ n: 2n, P: 5n, a: 2n, b: 3n }), [10n]);
console.log(Collatz.reverseFunction({ n: 3n, P: 5n, a: 2n, b: 3n }), [15n]); // also tests !0
console.log(Collatz.reverseFunction({ n: 4n, P: 5n, a: 2n, b: 3n }), [20n]);
console.log(Collatz.reverseFunction({ n: 5n, P: 5n, a: 2n, b: 3n }), [25n, 1n]);

// Test negative P, a and b. We only use the (0 mod P) conjugacy class to
// determine functionality, so flooring negative P doesn't cause any issue.
// 'should return the Test negative P, a and b.'
console.log(Collatz.reverseFunction({ n: 1n, P: -3n, a: -2n, b: -5n }), [-3n]); // != [-3, -3]
console.log(Collatz.reverseFunction({ n: 2n, P: -3n, a: -2n, b: -5n }), [-6n]);
console.log(Collatz.reverseFunction({ n: 3n, P: -3n, a: -2n, b: -5n }), [-9n, -4n]);

// Set P and a to 0 to assert on assertSaneParameterisation
// 'should return the assertion error'
try {
  Collatz.reverseFunction({ n: 1n, P: 0n, a: 2n, b: 3n });
} catch (e) {
  if (e.name == 'FailedSaneParameterCheck') {
    console.log('Caught expected FailedSaneParameterCheck', Collatz.SaneParameterErrMsg.SANE_PARAMS_P);
    console.log(e);
  } else {
    throw e;
  }
}
try {
  Collatz.reverseFunction({ n: 1n, P: 0n, a: 0n, b: 3n });
} catch (e) {
  if (e.name == 'FailedSaneParameterCheck') {
    console.log('Caught expected FailedSaneParameterCheck', Collatz.SaneParameterErrMsg.SANE_PARAMS_P);
    console.log(e);
  } else {
    throw e;
  }
}
try {
  Collatz.reverseFunction({ n: 1n, P: 1n, a: 0n, b: 3n });
} catch (e) {
  if (e.name == 'FailedSaneParameterCheck') {
    console.log('Caught expected FailedSaneParameterCheck', Collatz.SaneParameterErrMsg.SANE_PARAMS_A);
    console.log(e);
  } else {
    throw e;
  }
}

// If b is a multiple of a, but not of Pa, then 0 can have a reverse.
// 'should return the If b is a multiple of a, but not of Pa, then 0 can have a reverse.'
console.log(Collatz.reverseFunction({ n: 0n, P: 17n, a: 2n, b: -6n }), [0n, 3n]);
console.log(Collatz.reverseFunction({ n: 0n, P: 17n, a: 2n, b: 102n }), [0n]);
