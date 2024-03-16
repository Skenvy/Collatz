import { SequenceState } from './utilities.ts';
/**
 * Nodes that form a "tree graph", structured as a tree, with their own node's value,
 * as well as references to either possible child node, where a node can only ever have
 * two children, as there are only ever two reverse values. Also records any possible
 * "terminal sequence state", whether that be that the "orbit distance" has been reached,
 * as an "out of bounds" stop, which is the regularly expected terminal state. Other
 * terminal states possible however include the cycle state and cycle length (end) states.
 */
export declare class TreeGraphNode {
    /** The value of this node in the tree. */
    readonly nodeValue: bigint;
    /** The terminal state; null if not a terminal node, MAX_STOP_OUT_OF_BOUNDS if the maxOrbitDistance
     *  has been reached, CYCLE_LENGTH if the node's value is found to have occured previously, or
     *  CYCLE_INIT, retroactively applied when a CYCLE_LENGTH state node is found. */
    terminalSequenceState: SequenceState | null;
    /** The "Pre N/P" child of this node that is always
     *  present if this is not a terminal node. */
    readonly preNDivPNode: TreeGraphNode | null;
    /** The "Pre aN+b" child of this node that is present
     *  if it exists and this is not a terminal node. */
    readonly preANplusBNode: TreeGraphNode | null;
    /** A map of previous graph nodes which maps instances of
     *  TreeGraphNode to themselves, to enable cycle detection. */
    private cycleCheck;
    static readonly emptyMap: Map<bigint, TreeGraphNode>;
    /**
     * Create an instance of TreeGraphNode which will yield its entire sub-tree of all child nodes.
     * This is used internally by itself and the public constructor to pass the cycle checking map,
     * recursively determining subsequent child nodes.
     * @param nodeValue - The value for which to find the tree graph node reversal.
     * @param maxOrbitDistance - The maximum distance/orbit/branch length to travel.
     * @param P - Modulus used to devide n, iff n is equivalent to (0 mod P).
     * @param a - Factor by which to multiply n.
     * @param b - Value to add to the scaled value of n.
     * @param cycleCheck - Checks if this node's value already occurred.
     * @param createManually - Create an instance of TreeGraphNode by directly passing it the values
     *     required to instantiate, intended to be used in testing by manually creating trees in reverse,
     *     by passing expected child nodes to their parents until the entire expected tree is created.
     * @param terminalSequenceState - The expected sequence state;
     *     null, MAX_STOP_OUT_OF_BOUNDS, CYCLE_INIT or CYCLE_LENGTH.
     * @param preNDivPNode - The expected "Pre N/P" child node.
     * @param preANplusBNode - The expected "Pre aN+b" child node.
     * @returns the tree graph node and its subtree, computed for the parameters provided.
     * @throws FailedSaneParameterCheck
     * Thrown if either P or a are 0.
     */
    private constructor();
    /**
     * Create an instance of TreeGraphNode which will yield its entire sub-tree of all child nodes.
     * @param nodeValue - The value for which to find the tree graph node reversal.
     * @param maxOrbitDistance - The maximum distance/orbit/branch length to travel.
     * @param P - Modulus used to devide n, iff n is equivalent to (0 mod P).
     * @param a - Factor by which to multiply n.
     * @param b - Value to add to the scaled value of n.
     * @returns the tree graph node and its subtree, computed for the parameters provided.
     * @throws FailedSaneParameterCheck
     * Thrown if either P or a are 0.
     */
    static new(nodeValue: bigint, maxOrbitDistance: number, P: bigint, a: bigint, b: bigint): TreeGraphNode;
    /**
     * This is used internally by itself and the public constructor to pass the cycle checking map,
     * recursively determining subsequent child nodes.
     * @param nodeValue - The value for which to find the tree graph node reversal.
     * @param terminalSequenceState - The expected sequence state;
     *     null, MAX_STOP_OUT_OF_BOUNDS, CYCLE_INIT or CYCLE_LENGTH.
     * @param preNDivPNode - The expected "Pre N/P" child node.
     * @param preANplusBNode - The expected "Pre aN+b" child node.
     * @returns the tree graph node and its subtree, where the subtrees are passed in.
     * @throws FailedSaneParameterCheck
     * Thrown if either P or a are 0.
     */
    static newTest(nodeValue: bigint, terminalSequenceState: SequenceState | null, preNDivPNode: TreeGraphNode | null, preANplusBNode: TreeGraphNode | null): TreeGraphNode;
    /**
     * This will only confirm an equality if the whole subtree of both nodes, including
     * node values, sequence states, and child nodes, checked recursively, are equal.
     * It ignores the cycle checking map, which is purely a utility variable.
     * @param tgn - The TreeGraphNode with which to compare equality.
     * @returns true, if the entire sub-trees are equal.
     */
    subTreeEquals(tgn: TreeGraphNode | null): boolean;
    /**
     * Traverse a tree and assign the cycle map manually on all nodes.
     * @param cycleCheck - The map to retroactively assign to all nodes in a test tree.
     */
    copyActualTreesCycleMapIntoTestTree(actualTree: TreeGraphNode): void;
}
declare const _default: {
    TreeGraphNode: typeof TreeGraphNode;
};
export default _default;
//# sourceMappingURL=TreeGraphNode.d.ts.map