export declare namespace Collatz {
    const _KNOWN_CYCLES: bigint[][];
    const __VERIFIED_MAXIMUM: bigint;
    const __VERIFIED_MINIMUM: bigint;
    enum _ErrMsg {
        SANE_PARAMS_P = "'P' should not be 0 ~ violates modulo being non-zero.",
        SANE_PARAMS_A = "'a' should not be 0 ~ violates the reversability."
    }
    class FailedSaneParameterCheck extends Error {
        constructor(message: _ErrMsg);
    }
    enum _CC {
        STOPPING_TIME = "STOPPING_TIME",
        TOTAL_STOPPING_TIME = "TOTAL_STOPPING_TIME",
        CYCLE_INIT = "CYCLE_INIT",
        CYCLE_LENGTH = "CYCLE_LENGTH",
        MAX_STOP_OUT_OF_BOUNDS = "MAX_STOP_OUT_OF_BOUNDS",
        ZERO_STOP = "ZERO_STOP"
    }
    function __assert_sane_parameterisation(P: bigint, a: bigint, b: bigint): void;
    interface Parameterised {
        n: bigint;
        P?: bigint;
        a?: bigint;
        b?: bigint;
    }
    function Function({ n, P, a, b }: Parameterised): bigint;
}
declare const _default: {
    Collatz: typeof Collatz;
};
export default _default;
//# sourceMappingURL=index.d.ts.map