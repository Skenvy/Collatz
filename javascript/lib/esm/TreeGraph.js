import { TreeGraphNode } from './TreeGraphNode';
/** Contains the results of computing the Tree Graph via {@code Collatz.treeGraph(~)}.
 *  Contains the root node of a tree of {@code TreeGraphNode}'s.*/
export class TreeGraph {
    /** The root node of the tree of {@code TreeGraphNode}'s. */
    root;
    /**
     * Create a new TreeGraph with the root node defined by the inputs.
     * @param nodeValue - The value for which to find the tree graph node reversal.
     * @param maxOrbitDistance - The maximum distance/orbit/branch length to travel.
     * @param P - Modulus used to devide n, iff n is equivalent to (0 mod P).
     * @param a - Factor by which to multiply n.
     * @param b - Value to add to the scaled value of n.
     * @param createManually - Create a new TreeGraph by directly passing it the
     *     root node. Intended to be used in testing by manually creating trees.
     * @param root - The root node of the tree.
     */
    constructor(nodeValue, maxOrbitDistance, P, a, b, createManually, root) {
        if (createManually && root !== null) {
            this.root = root;
        }
        else {
            this.root = TreeGraphNode.new(nodeValue, maxOrbitDistance, P, a, b);
        }
    }
    static new(nodeValue, maxOrbitDistance, P, a, b) {
        return new TreeGraph(nodeValue, maxOrbitDistance, P, a, b, false, null);
    }
    static newTest(root) {
        return new TreeGraph(0n, 0, 0n, 0n, 0n, true, root);
    }
}
/**
 * Returns a directed tree graph of the reverse function values up to a maximum
 * nesting of maxOrbitDistance, with the initialValue as the root.
 * @param parameterisedInputs - Allows non-default (P,a,b); and other options.
 * @returns A TreeGraph, a tree with branches traversing the inverse function.
 * @throws FailedSaneParameterCheck
 * Thrown if either P or a are 0.
 */
export function treeGraph({ initialValue, maxOrbitDistance, P = 2n, a = 3n, b = 1n }) {
    return TreeGraph.new(initialValue, maxOrbitDistance, P, a, b);
}
