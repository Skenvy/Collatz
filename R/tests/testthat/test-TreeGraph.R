# /**
#  * Create a "terminal" graph node with null children and the terminal
#  * condition that indicates it has reached the maximum orbit of the tree.
#  * @param n
#  * @return
#  */
# private static TreeGraphNode wrapTGN_TerminalNode(long n){
#     return new TreeGraphNode(BigInteger.valueOf(n), SequenceState.MAX_STOP_OUT_OF_BOUNDS, null, null)
# })

# /**
#  * Create a "cyclic terminal" graph node with null children and the "cycle termination" condition.
#  * @param n
#  * @return
#  */
# private static TreeGraphNode wrapTGN_CyclicTerminal(long n){
#     return new TreeGraphNode(BigInteger.valueOf(n), SequenceState.CYCLE_LENGTH, null, null)
# })

# /**
#  * Create a "cyclic start" graph node with given children and the "cycle start" condition.
#  * @param n
#  * @param preNDivPNode
#  * @param preANplusBNode
#  * @return
#  */
# private static TreeGraphNode wrapTGN_CyclicStart(long n, TreeGraphNode preNDivPNode, TreeGraphNode preANplusBNode){
#     return new TreeGraphNode(BigInteger.valueOf(n), SequenceState.CYCLE_INIT, preNDivPNode, preANplusBNode)
# })

# /**
#  * Create a graph node with no terminal state, with given children.
#  * @param n
#  * @param preNDivPNode
#  * @param preANplusBNode
#  * @return
#  */
# private static TreeGraphNode wrapTGN_Generic(long n, TreeGraphNode preNDivPNode, TreeGraphNode preANplusBNode){
#     return new TreeGraphNode(BigInteger.valueOf(n), null, preNDivPNode, preANplusBNode)
# })

# test_that("TreeGraph_ZeroTrap", {
#     # ":D" for terminal, "C:" for cyclic end
#     TreeGraphNode expectedRoot
#     # The default zero trap
#     # {0:D}
#     expectedRoot = wrapTGN_TerminalNode(0)
#     expect_equal(new TreeGraph(expectedRoot), wrapTreeGraph(0, 0))
#     # {0:{C:0}}
#     expectedRoot = wrapTGN_CyclicStart(0, wrapTGN_CyclicTerminal(0), null)
#     expect_equal(new TreeGraph(expectedRoot), wrapTreeGraph(0, 1))
#     expect_equal(new TreeGraph(expectedRoot), wrapTreeGraph(0, 2))
# })

# test_that("TreeGraph_RootOfOneYieldsTheOneCycle", {
#     # ":D" for terminal, "C:" for cyclic end
#     TreeGraphNode expectedRoot
#     # The roundings of the 1 cycle.
#     # {1:D}
#     expectedRoot = wrapTGN_TerminalNode(1)
#     expect_equal(new TreeGraph(expectedRoot), wrapTreeGraph(1, 0))
#     # {1:{2:D}}
#     expectedRoot = wrapTGN_Generic(1, wrapTGN_TerminalNode(2), null)
#     expect_equal(new TreeGraph(expectedRoot), wrapTreeGraph(1, 1))
#     # {1:{2:{4:D}}}
#     expectedRoot = wrapTGN_Generic(1, wrapTGN_Generic(2, wrapTGN_TerminalNode(4), null), null)
#     expect_equal(new TreeGraph(expectedRoot), wrapTreeGraph(1, 2))
#     # {1:{2:{4:{C:1,8:D}}}}
#     expectedRoot = wrapTGN_CyclicStart(1, wrapTGN_Generic(2, wrapTGN_Generic(4, wrapTGN_TerminalNode(8), wrapTGN_CyclicTerminal(1)), null), null)
#     expect_equal(new TreeGraph(expectedRoot), wrapTreeGraph(1, 3))
# })

# test_that("TreeGraph_RootOfTwoAndFourYieldTheOneCycle", {
#     # ":D" for terminal, "C:" for cyclic end
#     TreeGraphNode expectedRoot
#     # {2:{4:{1:{C:2},8:{16:D}}}}
#     expectedRoot = wrapTGN_CyclicStart(2, wrapTGN_Generic(4, wrapTGN_Generic(8, wrapTGN_TerminalNode(16), null),
#                                                              wrapTGN_Generic(1, wrapTGN_CyclicTerminal(2), null)), null)
#     expect_equal(new TreeGraph(expectedRoot), wrapTreeGraph(2, 3))
#     # {4:{1:{2:{C:4}},8:{16:{5:D,32:D}}}}
#     expectedRoot = wrapTGN_CyclicStart(4, wrapTGN_Generic(8, wrapTGN_Generic(16, wrapTGN_TerminalNode(32), wrapTGN_TerminalNode(5)), null),
#                                           wrapTGN_Generic(1, wrapTGN_Generic(2, wrapTGN_CyclicTerminal(4), null), null))
#     expect_equal(new TreeGraph(expectedRoot), wrapTreeGraph(4, 3))
# })

# test_that("TreeGraph_RootOfMinusOneYieldsTheMinusOneCycle", {
#     # ":D" for terminal, "C:" for cyclic end
#     TreeGraphNode expectedRoot
#     # The roundings of the -1 cycle
#     # {-1:{-2:D}}
#     expectedRoot = wrapTGN_Generic(-1, wrapTGN_TerminalNode(-2), null)
#     expect_equal(new TreeGraph(expectedRoot), wrapTreeGraph(-1, 1))
#     # {-1:{-2:{-4:D,C:-1}}}
#     expectedRoot = wrapTGN_CyclicStart(-1, wrapTGN_Generic(-2, wrapTGN_TerminalNode(-4), wrapTGN_CyclicTerminal(-1)), null)
#     expect_equal(new TreeGraph(expectedRoot), wrapTreeGraph(-1, 2))
# })

# test_that("TreeGraph_WiderModuloSweep", {
#     # ":D" for terminal, "C:" for cyclic end
#     TreeGraphNode expectedRoot
#     # Test a wider modulo sweep by upping P to 5, a to 2, and b to 3.
#     # Orbit distance of 1 ~= {1:{-1:D,5:D}}
#     expectedRoot = wrapTGN_Generic(1, wrapTGN_TerminalNode(5), wrapTGN_TerminalNode(-1))
#     expect_equal(new TreeGraph(expectedRoot), wrapTreeGraph(1, 1, 5, 2, 3))
#     # Orbit distance of 2 ~= {1:{-1:{-5:D,-2:D},5:{C:1,25:D}}}
#     expectedRoot = wrapTGN_CyclicStart(1, wrapTGN_Generic(5, wrapTGN_TerminalNode(25), wrapTGN_CyclicTerminal(1)),
#                                           wrapTGN_Generic(-1, wrapTGN_TerminalNode(-5), wrapTGN_TerminalNode(-2)))
#     expect_equal(new TreeGraph(expectedRoot), wrapTreeGraph(1, 2, 5, 2, 3))
#     # Orbit distance of 3 ~=  {1:{-1:{-5:{-25:D,-4:D},-2:{-10:D}},5:{C:1,25:{11:D,125:D}}}}
#     expectedRoot = wrapTGN_CyclicStart(1, wrapTGN_Generic(5, wrapTGN_Generic(25, wrapTGN_TerminalNode(125), wrapTGN_TerminalNode(11)), wrapTGN_CyclicTerminal(1)),
#                                           wrapTGN_Generic(-1, wrapTGN_Generic(-5, wrapTGN_TerminalNode(-25), wrapTGN_TerminalNode(-4)), wrapTGN_Generic(-2, wrapTGN_TerminalNode(-10), null)))
#     expect_equal(new TreeGraph(expectedRoot), wrapTreeGraph(1, 3, 5, 2, 3))
# })

# test_that("TreeGraph_NegativeParamterisation", {
#     # ":D" for terminal, "C:" for cyclic end
#     TreeGraphNode expectedRoot
#     # Test negative P, a and b ~ P=-3, a=-2, b=-5
#     # Orbit distance of 1 ~= {1:{-3:D}}
#     expectedRoot = wrapTGN_Generic(1, wrapTGN_TerminalNode(-3), null)
#     expect_equal(new TreeGraph(expectedRoot), wrapTreeGraph(1, 1, -3, -2, -5))
#     # Orbit distance of 2 ~= {1:{-3:{-1:D,9:D}}}
#     expectedRoot = wrapTGN_Generic(1, wrapTGN_Generic(-3, wrapTGN_TerminalNode(9), wrapTGN_TerminalNode(-1)), null)
#     expect_equal(new TreeGraph(expectedRoot), wrapTreeGraph(1, 2, -3, -2, -5))
#     # Orbit distance of 3 ~= {1:{-3:{-1:{-2:D,3:D},9:{-27:D,-7:D}}}}
#     expectedRoot = wrapTGN_Generic(1, wrapTGN_Generic(-3, wrapTGN_Generic(9, wrapTGN_TerminalNode(-27), wrapTGN_TerminalNode(-7)),
#                                                           wrapTGN_Generic(-1, wrapTGN_TerminalNode(3), wrapTGN_TerminalNode(-2))), null)
#     expect_equal(new TreeGraph(expectedRoot), wrapTreeGraph(1, 3, -3, -2, -5))
# })

# test_that("TreeGraph_ZeroReversesOnB", {
#     # ":D" for terminal, "C:" for cyclic end
#     TreeGraphNode expectedRoot
#     # If b is a multiple of a, but not of Pa, then 0 can have a reverse.
#     # {0:{C:0,3:D}}
#     expectedRoot = wrapTGN_CyclicStart(0, wrapTGN_CyclicTerminal(0), wrapTGN_TerminalNode(3))
#     expect_equal(new TreeGraph(expectedRoot), wrapTreeGraph(0, 1, 17, 2, -6))
#     # {0:{C:0}}
#     expectedRoot = wrapTGN_CyclicStart(0, wrapTGN_CyclicTerminal(0), null)
#     expect_equal(new TreeGraph(expectedRoot), wrapTreeGraph(0, 1, 17, 2, 102))
# })

test_that("TreeGraph_AssertSaneParameterisation", {
    # Set P and a to 0 to assert on __assert_sane_parameterisation
    expect_error(tree_graph(1, 1, 0, 2, 3), Collatz$SaneParameterErrMsg$P)
    expect_error(tree_graph(1, 1, 0, 0, 3), Collatz$SaneParameterErrMsg$P)
    expect_error(tree_graph(1, 1, 1, 0, 3), Collatz$SaneParameterErrMsg$A)
})
