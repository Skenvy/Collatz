#' Create a "terminal" graph node with NULL children and the terminal
#' condition that indicates it has reached the maximum orbit of the tree.
#' @param n
wrap_TG_TerminalNode <- function(n) {
    ret <- list()
    ret[[as.character(n)]] <- NA
    ret
}

#' Create a "cyclic terminal" graph node with NULL children and the "cycle termination" condition.
#' @param n
wrap_TG_CyclicTerminal <- function(n) {
    ret <- list()
    ret[[Collatz$SequenceState$CYCLE_INIT]] <- n
    ret
}

#' Create a graph node with no terminal state, with given children.
#' @param n
#' @param preNDivPNode
#' @param preANplusBNode
#' @return
wrap_TG_Generic <- function(n, preNDivPNode, preANplusBNode) {
    ret <- list()
    ret[[as.character(n)]] <- list()
    for (i in seq(1, length(preNDivPNode))) {
        ret[[as.character(n)]][[names(preNDivPNode[i])]] <- preNDivPNode[[i]]
    }
    if (!is.null(preANplusBNode)) {
        for (i in seq(1, length(preANplusBNode))) {
            ret[[as.character(n)]][[names(preANplusBNode[i])]] <- preANplusBNode[[i]]
        }
    }
    ret
}

test_that("TreeGraph_ZeroTrap", {
    # ":D" for terminal, "C:" for cyclic end
    # The default zero trap
    # {0:D}
    expected_tree <- wrap_TG_TerminalNode(0)
    expect_equal(tree_graph(0, 0), expected_tree)
    # {0:{C:0}}
    expected_tree <- wrap_TG_Generic(0, wrap_TG_CyclicTerminal(0), NULL)
    expect_equal(tree_graph(0, 1), expected_tree)
    expect_equal(tree_graph(0, 2), expected_tree)
})

test_that("TreeGraph_RootOfOneYieldsTheOneCycle", {
    # ":D" for terminal, "C:" for cyclic end
    # The roundings of the 1 cycle.
    # {1:D}
    expected_tree <- wrap_TG_TerminalNode(1)
    expect_equal(tree_graph(1, 0), expected_tree)
    # {1:{2:D}}
    expected_tree <- wrap_TG_Generic(1, wrap_TG_TerminalNode(2), NULL)
    expect_equal(tree_graph(1, 1), expected_tree)
    # {1:{2:{4:D}}}
    expected_tree <- wrap_TG_Generic(1, wrap_TG_Generic(2, wrap_TG_TerminalNode(4), NULL), NULL)
    expect_equal(tree_graph(1, 2), expected_tree)
    # {1:{2:{4:{C:1,8:D}}}}
    expected_tree <- wrap_TG_Generic(1, wrap_TG_Generic(2, wrap_TG_Generic(4, wrap_TG_TerminalNode(8), wrap_TG_CyclicTerminal(1)), NULL), NULL)
    expect_equal(tree_graph(1, 3), expected_tree)
})

# test_that("TreeGraph_RootOfTwoAndFourYieldTheOneCycle", {
#     # ":D" for terminal, "C:" for cyclic end
#     # {2:{4:{1:{C:2},8:{16:D}}}}
#     expected_tree <- wrap_TG_Generic(2, wrap_TG_Generic(4, wrap_TG_Generic(8, wrap_TG_TerminalNode(16), NULL),
#                                                              wrap_TG_Generic(1, wrap_TG_CyclicTerminal(2), NULL)), NULL)
#     expect_equal(tree_graph(2, 3), expected_tree)
#     # {4:{1:{2:{C:4}},8:{16:{5:D,32:D}}}}
#     expected_tree <- wrap_TG_Generic(4, wrap_TG_Generic(8, wrap_TG_Generic(16, wrap_TG_TerminalNode(32), wrap_TG_TerminalNode(5)), NULL),
#                                           wrap_TG_Generic(1, wrap_TG_Generic(2, wrap_TG_CyclicTerminal(4), NULL), NULL))
#     expect_equal(tree_graph(4, 3), expected_tree)
# })

# test_that("TreeGraph_RootOfMinusOneYieldsTheMinusOneCycle", {
#     # ":D" for terminal, "C:" for cyclic end
#     # The roundings of the -1 cycle
#     # {-1:{-2:D}}
#     expected_tree <- wrap_TG_Generic(-1, wrap_TG_TerminalNode(-2), NULL)
#     expect_equal(tree_graph(-1, 1), expected_tree)
#     # {-1:{-2:{-4:D,C:-1}}}
#     expected_tree <- wrap_TG_Generic(-1, wrap_TG_Generic(-2, wrap_TG_TerminalNode(-4), wrap_TG_CyclicTerminal(-1)), NULL)
#     expect_equal(tree_graph(-1, 2), expected_tree)
# })

# test_that("TreeGraph_WiderModuloSweep", {
#     # ":D" for terminal, "C:" for cyclic end
#     # Test a wider modulo sweep by upping P to 5, a to 2, and b to 3.
#     # Orbit distance of 1 ~= {1:{-1:D,5:D}}
#     expected_tree <- wrap_TG_Generic(1, wrap_TG_TerminalNode(5), wrap_TG_TerminalNode(-1))
#     expect_equal(tree_graph(1, 1, 5, 2, 3), expected_tree)
#     # Orbit distance of 2 ~= {1:{-1:{-5:D,-2:D},5:{C:1,25:D}}}
#     expected_tree <- wrap_TG_Generic(1, wrap_TG_Generic(5, wrap_TG_TerminalNode(25), wrap_TG_CyclicTerminal(1)),
#                                           wrap_TG_Generic(-1, wrap_TG_TerminalNode(-5), wrap_TG_TerminalNode(-2)))
#     expect_equal(tree_graph(1, 2, 5, 2, 3), expected_tree)
#     # Orbit distance of 3 ~=  {1:{-1:{-5:{-25:D,-4:D},-2:{-10:D}},5:{C:1,25:{11:D,125:D}}}}
#     expected_tree <- wrap_TG_Generic(1, wrap_TG_Generic(5, wrap_TG_Generic(25, wrap_TG_TerminalNode(125), wrap_TG_TerminalNode(11)), wrap_TG_CyclicTerminal(1)),
#                                           wrap_TG_Generic(-1, wrap_TG_Generic(-5, wrap_TG_TerminalNode(-25), wrap_TG_TerminalNode(-4)), wrap_TG_Generic(-2, wrap_TG_TerminalNode(-10), NULL)))
#     expect_equal(tree_graph(1, 3, 5, 2, 3), expected_tree)
# })

# test_that("TreeGraph_NegativeParamterisation", {
#     # ":D" for terminal, "C:" for cyclic end
#     # Test negative P, a and b ~ P=-3, a=-2, b=-5
#     # Orbit distance of 1 ~= {1:{-3:D}}
#     expected_tree <- wrap_TG_Generic(1, wrap_TG_TerminalNode(-3), NULL)
#     expect_equal(tree_graph(1, 1, -3, -2, -5), expected_tree)
#     # Orbit distance of 2 ~= {1:{-3:{-1:D,9:D}}}
#     expected_tree <- wrap_TG_Generic(1, wrap_TG_Generic(-3, wrap_TG_TerminalNode(9), wrap_TG_TerminalNode(-1)), NULL)
#     expect_equal(tree_graph(1, 2, -3, -2, -5), expected_tree)
#     # Orbit distance of 3 ~= {1:{-3:{-1:{-2:D,3:D},9:{-27:D,-7:D}}}}
#     expected_tree <- wrap_TG_Generic(1, wrap_TG_Generic(-3, wrap_TG_Generic(9, wrap_TG_TerminalNode(-27), wrap_TG_TerminalNode(-7)),
#                                                           wrap_TG_Generic(-1, wrap_TG_TerminalNode(3), wrap_TG_TerminalNode(-2))), NULL)
#     expect_equal(tree_graph(1, 3, -3, -2, -5), expected_tree)
# })

# test_that("TreeGraph_ZeroReversesOnB", {
#     # ":D" for terminal, "C:" for cyclic end
#     # If b is a multiple of a, but not of Pa, then 0 can have a reverse.
#     # {0:{C:0,3:D}}
#     expected_tree <- wrap_TG_Generic(0, wrap_TG_CyclicTerminal(0), wrap_TG_TerminalNode(3))
#     expect_equal(tree_graph(0, 1, 17, 2, -6), expected_tree)
#     # {0:{C:0}}
#     expected_tree <- wrap_TG_Generic(0, wrap_TG_CyclicTerminal(0), NULL)
#     expect_equal(tree_graph(0, 1, 17, 2, 102), expected_tree)
# })

test_that("TreeGraph_AssertSaneParameterisation", {
    # Set P and a to 0 to assert on __assert_sane_parameterisation
    expect_error(tree_graph(1, 1, 0, 2, 3), Collatz$SaneParameterErrMsg$P)
    expect_error(tree_graph(1, 1, 0, 0, 3), Collatz$SaneParameterErrMsg$P)
    expect_error(tree_graph(1, 1, 1, 0, 3), Collatz$SaneParameterErrMsg$A)
})
