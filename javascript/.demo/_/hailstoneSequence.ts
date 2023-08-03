import * as Collatz from '@skenvy/collatz';

let actual: Collatz.HailstoneSequence;
interface Expected {values: bigint[], terminalCondition: Collatz.SequenceState, terminalStatus: number}
let expected: Expected;

function consoleHailstoneSequence(hail: Collatz.HailstoneSequence, expected: Expected): void {
  console.log(hail.values, expected.values);
  console.log(hail.terminalCondition, expected.terminalCondition);
  console.log(hail.terminalStatus, expected.terminalStatus);
}

// Default (P,a,b); 0 trap [as b is not a multiple of a]
// 'should return the Default (P,a,b); 0 trap'
expected = {
  values: [0n],
  terminalCondition: Collatz.SequenceState.ZERO_STOP,
  terminalStatus: 0
};
actual = Collatz.hailstoneSequence({ initialValue: 0n });
consoleHailstoneSequence(actual, expected);

// Default (P,a,b); 1 cycle; "total stop"
// 'should terminate at a total stop for the cycle containing 1'
// The cycle containing 1 wont yield a cycle termination, as 1 is considered
// the "total stop" that is the special case termination.
expected = {
  values: [1n],
  terminalCondition: Collatz.SequenceState.TOTAL_STOPPING_TIME,
  terminalStatus: 0
};
actual = Collatz.hailstoneSequence({ initialValue: 1n });
consoleHailstoneSequence(actual, expected);
// 1's cycle wont yield a description of it being a "cycle" as far as the
// hailstones are concerned, which is to be expected, so..
expected = {
  values: [4n, 2n, 1n],
  terminalCondition: Collatz.SequenceState.TOTAL_STOPPING_TIME,
  terminalStatus: 2
};
actual = Collatz.hailstoneSequence({ initialValue: 4n });
consoleHailstoneSequence(actual, expected);
// As well as entering the cycle from above
expected = {
  values: [16n, 8n, 4n, 2n, 1n],
  terminalCondition: Collatz.SequenceState.TOTAL_STOPPING_TIME,
  terminalStatus: 4
};
actual = Collatz.hailstoneSequence({ initialValue: 16n });
consoleHailstoneSequence(actual, expected);

// Default (P,a,b); the other known cycles; "are cycles"
// 'should yield a cycle length for the other known cycles'
// Test the 3 known default parameter's cycles (ignoring [1,4,2])
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
    consoleHailstoneSequence(actual, expected);
  }
});

// Default (P,a,b); cycle traps a lead in to the -5 cycle
// 'yields the -5 cycle when hailing from -56'
let sequence: bigint[] = [];
let test_cycle = Collatz.KNOWN_CYCLES[2];
sequence.push(test_cycle[1] * 4n);
sequence.push(test_cycle[1] * 2n);
for (let i = 1; i < test_cycle.length; i += 1) { 
  sequence.push(test_cycle[i]);
}
sequence.push(test_cycle[0]);
sequence.push(test_cycle[1]);
actual = Collatz.hailstoneSequence({ initialValue: -56n });
expected = {
  values: sequence,
  terminalCondition: Collatz.SequenceState.CYCLE_LENGTH,
  terminalStatus: test_cycle.length
};
consoleHailstoneSequence(actual, expected);

// Default (P,a,b); cycle traps a lead in to the -17 cycle
// 'yields the -17 cycle when hailing from -200'
sequence = [];
test_cycle = Collatz.KNOWN_CYCLES[3];
sequence.push(test_cycle[1] * 4n);
sequence.push(test_cycle[1] * 2n);
for (let i = 1; i < test_cycle.length; i += 1) { 
  sequence.push(test_cycle[i]);
}
sequence.push(test_cycle[0]);
sequence.push(test_cycle[1]);
actual = Collatz.hailstoneSequence({ initialValue: -200n });
expected = {
  values: sequence,
  terminalCondition: Collatz.SequenceState.CYCLE_LENGTH,
  terminalStatus: test_cycle.length
};
consoleHailstoneSequence(actual, expected);

// Default (P,a,b); stops at the "non-total" stopping time if total stopping time is false.
// 'should halt at the regular stopping time, if total stopping time is false'
// Test the regular stopping time check.
expected = {
  values: [4n, 2n],
  terminalCondition: Collatz.SequenceState.STOPPING_TIME,
  terminalStatus: 1
};
actual = Collatz.hailstoneSequence({ initialValue: 4n, maxTotalStoppingTime: 1000, totalStoppingTime: false });
consoleHailstoneSequence(actual, expected);
expected = {
  values: [5n, 16n, 8n, 4n],
  terminalCondition: Collatz.SequenceState.STOPPING_TIME,
  terminalStatus: 3
};
actual = Collatz.hailstoneSequence({ initialValue: 5n, maxTotalStoppingTime: 1000, totalStoppingTime: false });
consoleHailstoneSequence(actual, expected);

// 'should yield a maximum stopping time "out of bounds" result for a negative stopping time'
// Test small max total stopping time: (minimum internal value is one)
expected = {
  values: [4n, 2n],
  terminalCondition: Collatz.SequenceState.MAX_STOP_OUT_OF_BOUNDS,
  terminalStatus: 1
};
actual = Collatz.hailstoneSequence({ initialValue: 4n, maxTotalStoppingTime: -100, totalStoppingTime: true });
consoleHailstoneSequence(actual, expected);

// 'should hard stop on 0 if the parameters allow it to land on zero'
// Test the zero stop mid hailing. This wont happen with default params tho.
expected = {
  values: [3n, 0n],
  terminalCondition: Collatz.SequenceState.ZERO_STOP,
  terminalStatus: -1
};
actual = Collatz.hailstoneSequence({ initialValue: 3n, P: 2n, a: 3n, b: -9n, maxTotalStoppingTime: 100, totalStoppingTime: true });
consoleHailstoneSequence(actual, expected);

// 'should exhibit a cycle of length 1 or at most 2, if P is 1 or -1'
// Lastly, while the function wont let you use a P value of 0, 1 and -1 are
// still allowed, although they will generate immediate 1 or 2 length cycles
// respectively, so confirm the behaviour of each of these hailstones.
expected = {
  values: [3n, 3n],
  terminalCondition: Collatz.SequenceState.CYCLE_LENGTH,
  terminalStatus: 1
};
actual = Collatz.hailstoneSequence({ initialValue: 3n, P: 1n, a: 3n, b: 1n, maxTotalStoppingTime: 100, totalStoppingTime: true });
consoleHailstoneSequence(actual, expected);
expected = {
  values: [3n, -3n, 3n],
  terminalCondition: Collatz.SequenceState.CYCLE_LENGTH,
  terminalStatus: 2
};
actual = Collatz.hailstoneSequence({ initialValue: 3n, P: -1n, a: 3n, b: 1n, maxTotalStoppingTime: 100, totalStoppingTime: true });
consoleHailstoneSequence(actual, expected);

// Set P and a to 0 to assert on assertSaneParameterisation
// 'should return the assertion error'
try {
  Collatz.hailstoneSequence({ initialValue: 1n, P: 0n, a: 2n, b: 3n });
} catch (e) {
  if (e.name == 'FailedSaneParameterCheck') {
    console.log('Caught expected FailedSaneParameterCheck', Collatz.SaneParameterErrMsg.SANE_PARAMS_P);
    console.log(e);
  } else {
    throw e;
  }
}
try {
  Collatz.hailstoneSequence({ initialValue: 1n, P: 0n, a: 0n, b: 3n });
} catch (e) {
  if (e.name == 'FailedSaneParameterCheck') {
    console.log('Caught expected FailedSaneParameterCheck', Collatz.SaneParameterErrMsg.SANE_PARAMS_P);
    console.log(e);
  } else {
    throw e;
  }
}
try {
  Collatz.hailstoneSequence({ initialValue: 1n, P: 1n, a: 0n, b: 3n });
} catch (e) {
  if (e.name == 'FailedSaneParameterCheck') {
    console.log('Caught expected FailedSaneParameterCheck', Collatz.SaneParameterErrMsg.SANE_PARAMS_A);
    console.log(e);
  } else {
    throw e;
  }
}
