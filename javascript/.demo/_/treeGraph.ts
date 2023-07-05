import * as Collatz from '@skenvy/collatz';

/**
 * Create a "terminal" graph node with null children and the terminal
 * condition that indicates it has reached the maximum orbit of the tree.
 */
function wrapTerminalNode(n: bigint): Collatz.TreeGraphNode {
  return Collatz.TreeGraphNode.newTest(n, Collatz.SequenceState.MAX_STOP_OUT_OF_BOUNDS, null, null);
}

/** Create a "cyclic terminal" graph node with null children and the "cycle termination" condition. */
function wrapCyclicTerminal(n: bigint): Collatz.TreeGraphNode {
  return Collatz.TreeGraphNode.newTest(n, Collatz.SequenceState.CYCLE_LENGTH, null, null);
}

/** Create a "cyclic start" graph node with given children and the "cycle start" condition. */
function wrapCyclicStart(n: bigint, preNDivPNode: Collatz.TreeGraphNode, preANplusBNode: Collatz.TreeGraphNode | null): Collatz.TreeGraphNode {
  return Collatz.TreeGraphNode.newTest(n, Collatz.SequenceState.CYCLE_INIT, preNDivPNode, preANplusBNode);
}

/** Create a graph node with no terminal state, with given children. */
function wrapGeneric(n: bigint, preNDivPNode: Collatz.TreeGraphNode, preANplusBNode: Collatz.TreeGraphNode | null): Collatz.TreeGraphNode {
  return Collatz.TreeGraphNode.newTest(n, null, preNDivPNode, preANplusBNode);
}

function assertExpectedTree(actualParams: Collatz.CollatzTreeGraphParameters, expectedRoot: Collatz.TreeGraphNode): void {
  // Because the cycle checking map will be different, we could use the custom sub tree equality check.
  // console.log(Collatz.treeGraph(actualParams).root.subTreeEquals(expectedRoot), true);
  // But it's nicer if we can do it with a deep equals.
  let actual = Collatz.treeGraph(actualParams);
  expectedRoot.copyActualTreesCycleMapIntoTestTree(actual.root);
  console.log(actual.root, expectedRoot);
}

let expectedRoot: Collatz.TreeGraphNode;
let actualParams: Collatz.CollatzTreeGraphParameters;

// 'should ZeroTrap'
// ":D" for terminal, "C:" for cyclic end
// The default zero trap
// {0:D}
expectedRoot = wrapTerminalNode(0n);
actualParams = { initialValue: 0n, maxOrbitDistance: 0 };
assertExpectedTree(actualParams, expectedRoot);
// {0:{C:0}}
expectedRoot = wrapCyclicStart(0n, wrapCyclicTerminal(0n), null);
actualParams = { initialValue: 0n, maxOrbitDistance: 1 };
assertExpectedTree(actualParams, expectedRoot);
actualParams = { initialValue: 0n, maxOrbitDistance: 2 };
assertExpectedTree(actualParams, expectedRoot);

// 'should RootOfOneYieldsTheOneCycle'
// ":D" for terminal, "C:" for cyclic end
// The roundings of the 1 cycle.
// {1:D}
expectedRoot = wrapTerminalNode(1n);
actualParams = { initialValue: 1n, maxOrbitDistance: 0 };
assertExpectedTree(actualParams, expectedRoot);
// {1:{2:D}}
expectedRoot = wrapGeneric(1n, wrapTerminalNode(2n), null);
actualParams = { initialValue: 1n, maxOrbitDistance: 1 };
assertExpectedTree(actualParams, expectedRoot);
// {1:{2:{4:D}}}
expectedRoot = wrapGeneric(1n, wrapGeneric(2n, wrapTerminalNode(4n), null), null);
actualParams = { initialValue: 1n, maxOrbitDistance: 2 };
assertExpectedTree(actualParams, expectedRoot);
// {1:{2:{4:{C:1,8:D}}}}
expectedRoot = wrapCyclicStart(1n, wrapGeneric(2n, wrapGeneric(4n, wrapTerminalNode(8n), wrapCyclicTerminal(1n)), null), null);
actualParams = { initialValue: 1n, maxOrbitDistance: 3 };
assertExpectedTree(actualParams, expectedRoot);

// 'should RootOfTwoAndFourYieldTheOneCycle'
// ":D" for terminal, "C:" for cyclic end
// {2:{4:{1:{C:2},8:{16:D}}}}
expectedRoot = wrapCyclicStart(2n, wrapGeneric(4n, wrapGeneric(8n, wrapTerminalNode(16n), null), wrapGeneric(1n, wrapCyclicTerminal(2n), null)), null);
actualParams = { initialValue: 2n, maxOrbitDistance: 3 };
assertExpectedTree(actualParams, expectedRoot);
// {4:{1:{2:{C:4}},8:{16:{5:D,32:D}}}}
expectedRoot = wrapCyclicStart(4n, wrapGeneric(8n, wrapGeneric(16n, wrapTerminalNode(32n), wrapTerminalNode(5n)), null), wrapGeneric(1n, wrapGeneric(2n, wrapCyclicTerminal(4n), null), null));
actualParams = { initialValue: 4n, maxOrbitDistance: 3 };
assertExpectedTree(actualParams, expectedRoot);

// 'should RootOfMinusOneYieldsTheMinusOneCycle'
// ":D" for terminal, "C:" for cyclic end
// The roundings of the -1 cycle
// {-1:{-2:D}}
expectedRoot = wrapGeneric(-1n, wrapTerminalNode(-2n), null);
actualParams = { initialValue: -1n, maxOrbitDistance: 1 };
assertExpectedTree(actualParams, expectedRoot);
// {-1:{-2:{-4:D,C:-1}}}
expectedRoot = wrapCyclicStart(-1n, wrapGeneric(-2n, wrapTerminalNode(-4n), wrapCyclicTerminal(-1n)), null);
actualParams = { initialValue: -1n, maxOrbitDistance: 2 };
assertExpectedTree(actualParams, expectedRoot);

// 'should WiderModuloSweep'
// ":D" for terminal, "C:" for cyclic end
// Test a wider modulo sweep by upping P to 5, a to 2, and b to 3.
// Orbit distance of 1 ~= {1:{-1:D,5:D}}
expectedRoot = wrapGeneric(1n, wrapTerminalNode(5n), wrapTerminalNode(-1n));
actualParams = { initialValue: 1n, maxOrbitDistance: 1, P: 5n, a: 2n, b: 3n };
assertExpectedTree(actualParams, expectedRoot);
// Orbit distance of 2 ~= {1:{-1:{-5:D,-2:D},5:{C:1,25:D}}}
expectedRoot = wrapCyclicStart(1n, wrapGeneric(5n, wrapTerminalNode(25n), wrapCyclicTerminal(1n)), wrapGeneric(-1n, wrapTerminalNode(-5n), wrapTerminalNode(-2n)));
actualParams = { initialValue: 1n, maxOrbitDistance: 2, P: 5n, a: 2n, b: 3n };
assertExpectedTree(actualParams, expectedRoot);
// Orbit distance of 3 ~=  {1:{-1:{-5:{-25:D,-4:D},-2:{-10:D}},5:{C:1,25:{11:D,125:D}}}}
expectedRoot = wrapCyclicStart(1n, wrapGeneric(5n, wrapGeneric(25n, wrapTerminalNode(125n), wrapTerminalNode(11n)), wrapCyclicTerminal(1n)), wrapGeneric(-1n, wrapGeneric(-5n, wrapTerminalNode(-25n), wrapTerminalNode(-4n)), wrapGeneric(-2n, wrapTerminalNode(-10n), null)));
actualParams = { initialValue: 1n, maxOrbitDistance: 3, P: 5n, a: 2n, b: 3n };
assertExpectedTree(actualParams, expectedRoot);

// 'should NegativeParamterisation'
// ":D" for terminal, "C:" for cyclic end
// Test negative P, a and b ~ P=-3, a=-2, b=-5
// Orbit distance of 1 ~= {1:{-3:D}}
expectedRoot = wrapGeneric(1n, wrapTerminalNode(-3n), null);
actualParams = { initialValue: 1n, maxOrbitDistance: 1, P: -3n, a: -2n, b: -5n };
assertExpectedTree(actualParams, expectedRoot);
// Orbit distance of 2 ~= {1:{-3:{-1:D,9:D}}}
expectedRoot = wrapGeneric(1n, wrapGeneric(-3n, wrapTerminalNode(9n), wrapTerminalNode(-1n)), null);
actualParams = { initialValue: 1n, maxOrbitDistance: 2, P: -3n, a: -2n, b: -5n };
assertExpectedTree(actualParams, expectedRoot);
// Orbit distance of 3 ~= {1:{-3:{-1:{-2:D,3:D},9:{-27:D,-7:D}}}}
expectedRoot = wrapGeneric(1n, wrapGeneric(-3n, wrapGeneric(9n, wrapTerminalNode(-27n), wrapTerminalNode(-7n)), wrapGeneric(-1n, wrapTerminalNode(3n), wrapTerminalNode(-2n))), null);
actualParams = { initialValue: 1n, maxOrbitDistance: 3, P: -3n, a: -2n, b: -5n };
assertExpectedTree(actualParams, expectedRoot);

// 'should ZeroReversesOnB'
// ":D" for terminal, "C:" for cyclic end
// If b is a multiple of a, but not of Pa, then 0 can have a reverse.
// {0:{C:0,3:D}}
expectedRoot = wrapCyclicStart(0n, wrapCyclicTerminal(0n), wrapTerminalNode(3n));
actualParams = { initialValue: 0n, maxOrbitDistance: 1, P: 17n, a: 2n, b: -6n };
assertExpectedTree(actualParams, expectedRoot);
// {0:{C:0}}
expectedRoot = wrapCyclicStart(0n, wrapCyclicTerminal(0n), null);
actualParams = { initialValue: 0n, maxOrbitDistance: 1, P: 17n, a: 2n, b: 102n };
assertExpectedTree(actualParams, expectedRoot);

// Set P and a to 0 to assert on assertSaneParameterisation
// 'should return the assertion error'
try {
  Collatz.treeGraph({ initialValue: 1n, maxOrbitDistance: 1, P: 0n, a: 2n, b: 3n });
} catch (e) {
  if (e.name == 'FailedSaneParameterCheck') {
    console.log('Caught expected FailedSaneParameterCheck', Collatz.SaneParameterErrMsg.SANE_PARAMS_P);
    console.log(e);
  } else {
    throw e;
  }
}
try {
  Collatz.treeGraph({ initialValue: 1n, maxOrbitDistance: 1, P: 0n, a: 0n, b: 3n });
} catch (e) {
  if (e.name == 'FailedSaneParameterCheck') {
    console.log('Caught expected FailedSaneParameterCheck', Collatz.SaneParameterErrMsg.SANE_PARAMS_P);
    console.log(e);
  } else {
    throw e;
  }
}
try {
  Collatz.treeGraph({ initialValue: 1n, maxOrbitDistance: 1, P: 1n, a: 0n, b: 3n });
} catch (e) {
  if (e.name == 'FailedSaneParameterCheck') {
    console.log('Caught expected FailedSaneParameterCheck', Collatz.SaneParameterErrMsg.SANE_PARAMS_A);
    console.log(e);
  } else {
    throw e;
  }
}
