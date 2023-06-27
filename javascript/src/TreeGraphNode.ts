import { SequenceState } from './utilities';
import { reverseFunction } from './function';

/**
 * Nodes that form a "tree graph", structured as a tree, with their own node's value,
 * as well as references to either possible child node, where a node can only ever have
 * two children, as there are only ever two reverse values. Also records any possible
 * "terminal sequence state", whether that be that the "orbit distance" has been reached,
 * as an "out of bounds" stop, which is the regularly expected terminal state. Other
 * terminal states possible however include the cycle state and cycle length (end) states.
 */
export class TreeGraphNode {
  /** The value of this node in the tree. */
  readonly nodeValue: bigint;

  /** The terminal state; null if not a terminal node, MAX_STOP_OUT_OF_BOUNDS if the maxOrbitDistance
   *  has been reached, CYCLE_LENGTH if the node's value is found to have occured previously, or
   *  CYCLE_INIT, retroactively applied when a CYCLE_LENGTH state node is found. */
  // The only variable of TreeGraphNode to not be "final" as it must be possible to update retroactively.
  terminalSequenceState: SequenceState | null = null;

  /** The "Pre N/P" child of this node that is always
   *  present if this is not a terminal node. */
  readonly preNDivPNode: TreeGraphNode | null;

  /** The "Pre aN+b" child of this node that is present
   *  if it exists and this is not a terminal node. */
  readonly preANplusBNode: TreeGraphNode | null;

  /** A map of previous graph nodes which maps instances of
   *  TreeGraphNode to themselves, to enable cycle detection. */
  private readonly cycleCheck: Map<bigint, TreeGraphNode>;

  static readonly emptyMap = new Map<bigint, TreeGraphNode>();

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
  private constructor(nodeValue: bigint, maxOrbitDistance: number, P: bigint, a: bigint, b: bigint, cycleCheck: Map<bigint, TreeGraphNode>,
    createManually: boolean, terminalSequenceState: SequenceState | null, preNDivPNode: TreeGraphNode | null, preANplusBNode: TreeGraphNode | null) {
    this.nodeValue = nodeValue;
    this.cycleCheck = cycleCheck;
    if (createManually) {
      this.terminalSequenceState = terminalSequenceState;
      this.preNDivPNode = preNDivPNode;
      this.preANplusBNode = preANplusBNode;
    }
    else {
      this.cycleCheck = cycleCheck;
      if (this.cycleCheck.has(this.nodeValue)){
        this.cycleCheck.get(this.nodeValue)!.terminalSequenceState = SequenceState.CYCLE_INIT;
        this.terminalSequenceState = SequenceState.CYCLE_LENGTH;
        this.preNDivPNode = null;
        this.preANplusBNode = null;
      } else if (Math.max(0, maxOrbitDistance) === 0){
        this.terminalSequenceState = SequenceState.MAX_STOP_OUT_OF_BOUNDS;
        this.preNDivPNode = null;
        this.preANplusBNode = null;
      } else {
        this.cycleCheck.set(this.nodeValue, this);
        this.terminalSequenceState = null;
        const reverses = reverseFunction({ n: nodeValue, P: P, a: a, b: b });
        this.preNDivPNode = new TreeGraphNode(reverses[0], maxOrbitDistance-1, P, a, b, this.cycleCheck, false, null, null, null);
        if(reverses.length == 2){
          this.preANplusBNode = new TreeGraphNode(reverses[1], maxOrbitDistance-1, P, a, b, this.cycleCheck, false, null, null, null);
        } else {
          this.preANplusBNode = null;
        }
      }
    }
  }

  static new(nodeValue: bigint, maxOrbitDistance: number, P: bigint, a: bigint, b: bigint): TreeGraphNode {
    return new TreeGraphNode(nodeValue, maxOrbitDistance, P, a, b, new Map<bigint, TreeGraphNode>(), false, null, null, null);
  }

  static newTest(nodeValue: bigint, terminalSequenceState: SequenceState | null, preNDivPNode: TreeGraphNode | null, preANplusBNode: TreeGraphNode | null): TreeGraphNode {
    return new TreeGraphNode(nodeValue, 0, 0n, 0n, 0n, TreeGraphNode.emptyMap, true, terminalSequenceState, preNDivPNode, preANplusBNode);
  }

  // /** The equality between TreeGraphNodes is determined exclusively by the
  //  *  node's value, independent of the child nodes or sequence states that
  //  *  would be relevant to the node's status relative to the tree. */
  // equals(obj: Object): boolean{
  //   if (obj === null) {
  //     return false;
  //   }
  //   if (obj.constructor() !== this.constructor()) {
  //     return false;
  //   }
  //   tgn = Object.assign({}, obj);
  //   return this.nodeValue === tgn.nodeValue;
  // }

  // /** The hashCode of a TreeGraphNode is determined by the
  //  *  node's value, the child nodes and sequence state. */
  // hashCode(): number {
  //     int hash = this.nodeValue.hashCode();
  //     hash = 17 * hash + (this.terminalSequenceState != null ? this.terminalSequenceState.hashCode() : 0);
  //     hash = 17 * hash + (this.preNDivPNode != null ? this.preNDivPNode.hashCode() : 0);
  //     hash = 17 * hash + (this.preANplusBNode != null ? this.preANplusBNode.hashCode() : 0);
  //     return hash;
  // }

  /**
   * A much stricter equality check than the {@code equals(Object obj)} override.
   * This will only confirm an equality if the whole subtree of both nodes, including
   * node values, sequence states, and child nodes, checked recursively, are equal.
   * @param tgn - The TreeGraphNode with which to compare equality.
   * @returns true, if the entire sub-trees are equal.
   */
  subTreeEquals(tgn: TreeGraphNode | null): boolean {
      if (tgn === null) {
        return false;
      }
      if(this.nodeValue !== tgn.nodeValue || this.terminalSequenceState !== tgn.terminalSequenceState){
          return false;
      }
      if(this.preNDivPNode === null && tgn.preNDivPNode !== null){
          return false;
      }
      if(this.preNDivPNode !== null && !this.preNDivPNode.subTreeEquals(tgn.preNDivPNode)){
          return false;
      }
      if(this.preANplusBNode == null && tgn.preANplusBNode != null){
          return false;
      }
      if(this.preANplusBNode != null && !this.preANplusBNode.subTreeEquals(tgn.preANplusBNode)){
          return false;
      }
      return true;
  }
}
