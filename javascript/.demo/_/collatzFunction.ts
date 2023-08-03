import * as Collatz from '@skenvy/collatz';

// Default/Any (P,a,b); 0 trap
// 'should return the Default/Any (P,a,b); 0 trap'
console.log(Collatz.collatzFunction({ n: 0n }), 0n);

// Default/Any (P,a,b); 1 cycle; positives
// 'should return the Default/Any (P,a,b); 1 cycle; positives'
console.log(Collatz.collatzFunction({ n: 1n }), 4n);
console.log(Collatz.collatzFunction({ n: 4n }), 2n);
console.log(Collatz.collatzFunction({ n: 2n }), 1n);

// Default/Any (P,a,b); -1 cycle; negatives
// 'should return the Default/Any (P,a,b); -1 cycle; negatives'
console.log(Collatz.collatzFunction({ n: -1n }), -2n);
console.log(Collatz.collatzFunction({ n: -2n }), -1n);

// Test a wider modulo sweep by upping P to 5, a to 2, and b to 3
// 'should return the Test a wider modulo sweep by upping P to 5, a to 2, and b to 3'
console.log(Collatz.collatzFunction({ n: 1n, P: 5n, a: 2n, b: 3n }), 5n);
console.log(Collatz.collatzFunction({ n: 2n, P: 5n, a: 2n, b: 3n }), 7n);
console.log(Collatz.collatzFunction({ n: 3n, P: 5n, a: 2n, b: 3n }), 9n);
console.log(Collatz.collatzFunction({ n: 4n, P: 5n, a: 2n, b: 3n }), 11n);
console.log(Collatz.collatzFunction({ n: 5n, P: 5n, a: 2n, b: 3n }), 1n);

// Test negative P, a and b. We only use the (0 mod P) conjugacy class to
// determine functionality, so flooring negative P doesn't cause any issue.
// 'should return the Test negative P, a and b.'
console.log(Collatz.collatzFunction({ n: 1n, P: -3n, a: -2n, b: -5n }), -7n);
console.log(Collatz.collatzFunction({ n: 2n, P: -3n, a: -2n, b: -5n }), -9n);
console.log(Collatz.collatzFunction({ n: 3n, P: -3n, a: -2n, b: -5n }), -1n);

// Set P and a to 0 to assert on assertSaneParameterisation.
// 'should return the assertion error'
try {
  Collatz.collatzFunction({ n: 1n, P: 0n, a: 2n, b: 3n });
} catch (e) {
  if (e.name == 'FailedSaneParameterCheck') {
    console.log('Caught expected FailedSaneParameterCheck', Collatz.SaneParameterErrMsg.SANE_PARAMS_P);
    console.log(e);
  } else {
    throw e;
  }
}
try {
  Collatz.collatzFunction({ n: 1n, P: 0n, a: 0n, b: 3n });
} catch (e) {
  if (e.name == 'FailedSaneParameterCheck') {
    console.log('Caught expected FailedSaneParameterCheck', Collatz.SaneParameterErrMsg.SANE_PARAMS_P);
    console.log(e);
  } else {
    throw e;
  }
}
try {
  Collatz.collatzFunction({ n: 1n, P: 1n, a: 0n, b: 3n });
} catch (e) {
  if (e.name == 'FailedSaneParameterCheck') {
    console.log('Caught expected FailedSaneParameterCheck', Collatz.SaneParameterErrMsg.SANE_PARAMS_A);
    console.log(e);
  } else {
    throw e;
  }
}
