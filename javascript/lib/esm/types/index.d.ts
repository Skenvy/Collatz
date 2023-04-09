export declare const _KNOWN_CYCLES: bigint[][];
export declare const __VERIFIED_MAXIMUM: bigint;
export declare const __VERIFIED_MINIMUM: bigint;
export declare enum _ErrMsg {
    SANE_PARAMS_P = "'P' should not be 0 ~ violates modulo being non-zero.",
    SANE_PARAMS_A = "'a' should not be 0 ~ violates the reversability."
}
export declare class FailedSaneParameterCheck extends Error {
    constructor(message: _ErrMsg);
}
export declare enum _CC {
    STOPPING_TIME = "STOPPING_TIME",
    TOTAL_STOPPING_TIME = "TOTAL_STOPPING_TIME",
    CYCLE_INIT = "CYCLE_INIT",
    CYCLE_LENGTH = "CYCLE_LENGTH",
    MAX_STOP_OUT_OF_BOUNDS = "MAX_STOP_OUT_OF_BOUNDS",
    ZERO_STOP = "ZERO_STOP"
}
export declare function __assert_sane_parameterisation(P: bigint, a: bigint, b: bigint): void;
export interface Parameterised {
    n: bigint;
    P?: bigint;
    a?: bigint;
    b?: bigint;
}
export declare function Function({ n, P, a, b }: Parameterised): bigint;
declare const _default: {
    Function: typeof Function;
};
export default _default;
//# sourceMappingURL=index.d.ts.map