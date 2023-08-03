import collatz
from collatz import _CC, _ErrMsg, _KNOWN_CYCLES


_REGEX_ERR_P_IS_ZERO = f"^{_ErrMsg.SANE_PARAMS_P.value}$"
_REGEX_ERR_A_IS_ZERO = f"^{_ErrMsg.SANE_PARAMS_A.value}$"


print("""
Demonstrate def hailstone_sequence(initial_value:int, P:int=2,
a:int=3, b:int=1, max_total_stopping_time:int=1000,
total_stopping_time:bool=True, verbose:bool=True)
""")
# Test 0's immediated termination.
print(collatz.hailstone_sequence(0), [[_CC.ZERO_STOP.value, 0]])
print(collatz.hailstone_sequence(0, verbose=False), [0])
# The cycle containing 1 wont yield a cycle termination, as 1 is considered
# the "total stop" that is the special case termination.
print(collatz.hailstone_sequence(1), [[_CC.TOTAL_STOPPING_TIME.value, 0]])
print(collatz.hailstone_sequence(1, verbose=False), [1])
# Test the 3 known default parameter's cycles (ignoring [1,4,2])
# If not verbose, then the result will be the cycle plus the final value
# being the start of the cycle. If verbose, then the output will be the
# values not in the cycle, a CC flag, then the cycle and another CC flag.
for kc in [kc for kc in _KNOWN_CYCLES if 1 not in kc]:
    print(collatz.hailstone_sequence(kc[0], verbose=False), kc + [kc[0]])
    print(collatz.hailstone_sequence(kc[0]), [
        _CC.CYCLE_INIT.value, kc, [_CC.CYCLE_LENGTH.value, len(kc)]])
# Test the lead into a cycle by entering two of the cycles.
seq = [kc for kc in _KNOWN_CYCLES if -5 in kc][0]
seq = [seq[1]*4, seq[1]*2] + seq[1:] + [seq[0]]
print(collatz.hailstone_sequence(-56, verbose=False), seq + [seq[2]])
print(collatz.hailstone_sequence(-56), seq[:2] + [
    _CC.CYCLE_INIT.value, seq[2:], [_CC.CYCLE_LENGTH.value, len(seq[2:])]])
seq = [kc for kc in _KNOWN_CYCLES if -17 in kc][0]
seq = [seq[1]*4, seq[1]*2] + seq[1:] + [seq[0]]
print(collatz.hailstone_sequence(-200, verbose=False), seq + [seq[2]])
print(collatz.hailstone_sequence(-200), seq[:2] + [
    _CC.CYCLE_INIT.value, seq[2:], [_CC.CYCLE_LENGTH.value, len(seq[2:])]])
# 1's cycle wont yield a description of it being a "cycle" as far as the
# hailstones are concerned, which is to be expected, so..
print(collatz.hailstone_sequence(4, verbose=False), [4, 2, 1])
print(collatz.hailstone_sequence(4), [
    4, 2, 1, [_CC.TOTAL_STOPPING_TIME.value, 2]])
print(collatz.hailstone_sequence(16, verbose=False), [16, 8, 4, 2, 1])
print(collatz.hailstone_sequence(16), [
    16, 8, 4, 2, 1, [_CC.TOTAL_STOPPING_TIME.value, 4]])
# Test the regular stopping time check.
print(collatz.hailstone_sequence(4, total_stopping_time=False), [
    4, 2, [_CC.STOPPING_TIME.value, 1]])
print(collatz.hailstone_sequence(5, total_stopping_time=False), [
    5, 16, 8, 4, [_CC.STOPPING_TIME.value, 3]])
# Test small max_total_stopping_time: (minimum internal value is one)
print(collatz.hailstone_sequence(4, max_total_stopping_time=-100), [
    4, 2, [_CC.MAX_STOP_OOB.value, 1]])
# Test the zero stop mid hailing. This wont happen with default params tho.
print(collatz.hailstone_sequence(3, P=2, a=3, b=-9), [
    3, 0, [_CC.ZERO_STOP.value, -1]])
# Lastly, while the function wont let you use a P value of 0, 1 and -1 are
# still allowed, although they will generate immediate 1 or 2 length cycles
# respectively, so confirm the behaviour of each of these hailstones.
print(collatz.hailstone_sequence(3, P=1, verbose=False), [3, 3])
print(collatz.hailstone_sequence(3, P=-1, verbose=False), [3, -3, 3])
# # Set P and a to 0 to assert on __assert_sane_parameterisation
try:
    collatz.hailstone_sequence(1, P=0, a=2, b=3)
except AssertionError as err:
    print(err, _REGEX_ERR_P_IS_ZERO)
try:
    collatz.hailstone_sequence(1, P=0, a=0, b=3)
except AssertionError as err:
    print(err, _REGEX_ERR_P_IS_ZERO)
try:
    collatz.hailstone_sequence(1, P=1, a=0, b=3)
except AssertionError as err:
    print(err, _REGEX_ERR_A_IS_ZERO)
