from math import inf as infinity
import collatz
from collatz import _ErrMsg, _KNOWN_CYCLES


_REGEX_ERR_P_IS_ZERO = f"^{_ErrMsg.SANE_PARAMS_P.value}$"
_REGEX_ERR_A_IS_ZERO = f"^{_ErrMsg.SANE_PARAMS_A.value}$"


print("""
Demonstrate def stopping_time(initial_value:int, P:int=2, a:int=3, b:int=1,
max_stopping_time:int=1000, total_stopping_time:bool=False)
""")
# Test 0's immediated termination.
print(collatz.stopping_time(0), 0)
# The cycle containing 1 wont yield a cycle termination, as 1 is considered
# the "total stop" that is the special case termination.
print(collatz.stopping_time(1), 0)
# Test the 3 known default parameter's cycles (ignoring [1,4,2])
# If not verbose, then the result will be the cycle plus the final value
# being the start of the cycle. If verbose, then the output will be the
# values not in the cycle, a CC flag, then the cycle and another CC flag.
for c in [kc for kc in _KNOWN_CYCLES if 1 not in kc]:
    print(collatz.stopping_time(c[0], total_stopping_time=True), infinity)
# Test the lead into a cycle by entering two of the cycles. -56;-5, -200;-17
print(collatz.stopping_time(-56, total_stopping_time=True), infinity)
print(collatz.stopping_time(-200, total_stopping_time=True), infinity)
# 1's cycle wont yield a description of it being a "cycle" as far as the
# hailstones are concerned, which is to be expected, so..
print(collatz.stopping_time(4, total_stopping_time=True), 2)
print(collatz.stopping_time(16, total_stopping_time=True), 4)
# Test the regular stopping time check.
print(collatz.stopping_time(4), 1)
print(collatz.stopping_time(5), 3)
# Test small max_total_stopping_time: (minimum internal value is one)
print(collatz.stopping_time(5, max_stopping_time=-100) is None)
# Test the zero stop mid hailing. This wont happen with default params tho.
print(collatz.stopping_time(3, P=2, a=3, b=-9), -1)
# Lastly, while the function wont let you use a P value of 0, 1 and -1 are
# still allowed, although they will generate immediate 1 or 2 length cycles
# respectively, so confirm the behaviour of each of these stopping times.
print(collatz.stopping_time(3, P=1), infinity)
print(collatz.stopping_time(3, P=-1), infinity)
# One last one for the fun of it..
print(collatz.stopping_time(27, total_stopping_time=True), 111)
# And for a bit more fun, common trajectories on
for x in range(5):
    print(collatz.stopping_time(27+576460752303423488*x), 96)
# # Set P and a to 0 to assert on __assert_sane_parameterisation
try:
    collatz.stopping_time(1, P=0, a=2, b=3)
except AssertionError as err:
    print(err, _REGEX_ERR_P_IS_ZERO)
try:
    collatz.stopping_time(1, P=0, a=0, b=3)
except AssertionError as err:
    print(err, _REGEX_ERR_P_IS_ZERO)
try:
    collatz.stopping_time(1, P=1, a=0, b=3)
except AssertionError as err:
    print(err, _REGEX_ERR_A_IS_ZERO)
