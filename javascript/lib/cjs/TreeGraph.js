"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.TreeGraph = void 0;
exports.treeGraph = treeGraph;
const TreeGraphNode_js_1 = require("./TreeGraphNode.js");
/**
 * Contains the results of computing the Tree Graph via Collatz.treeGraph(~).
 * Contains the root node of a tree of TreeGraphNode's.
 */
class TreeGraph {
    /**
     * Create a new TreeGraph with the root node defined by the inputs.
     * @param nodeValue - The value for which to find the tree graph node reversal.
     * @param maxOrbitDistance - The maximum distance/orbit/branch length to travel.
     * @param P - Modulus used to devide n, iff n is equivalent to (0 mod P).
     * @param a - Factor by which to multiply n.
     * @param b - Value to add to the scaled value of n.
     * @returns A TreeGraph, a tree with branches traversing the inverse function.
     * @throws FailedSaneParameterCheck
     * Thrown if either P or a are 0.
     */
    constructor(nodeValue, maxOrbitDistance, P, a, b) {
        this.root = TreeGraphNode_js_1.TreeGraphNode.new(nodeValue, maxOrbitDistance, P, a, b);
    }
}
exports.TreeGraph = TreeGraph;
/**
 * Returns a directed tree graph of the reverse function values up to a maximum
 * nesting of maxOrbitDistance, with the initialValue as the root.
 * @param parameterisedInputs - Allows non-default (P,a,b); and other options.
 * @returns A TreeGraph, a tree with branches traversing the inverse function.
 * @throws FailedSaneParameterCheck
 * Thrown if either P or a are 0.
 */
function treeGraph({ initialValue, maxOrbitDistance, P = 2n, a = 3n, b = 1n }) {
    return new TreeGraph(initialValue, maxOrbitDistance, P, a, b);
}
