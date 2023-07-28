import collatz
from collatz import _ErrMsg


_REGEX_ERR_P_IS_ZERO = f"^{_ErrMsg.SANE_PARAMS_P.value}$"
_REGEX_ERR_A_IS_ZERO = f"^{_ErrMsg.SANE_PARAMS_A.value}$"


print("""
Demonstrate def function(n:int, P:int=2, a:int=3, b:int=1):
""")
# Default/Any (P,a,b); 0 trap
print(collatz.function(0), 0)
# Default/Any (P,a,b); 1 cycle; positives
print(collatz.function(1), 4)
print(collatz.function(4), 2)
print(collatz.function(2), 1)
# Default/Any (P,a,b); -1 cycle; negatives
print(collatz.function(-1), -2)
print(collatz.function(-2), -1)
# Test a wider modulo sweep by upping P to 5, a to 2, and b to 3.
print(collatz.function(1, P=5, a=2, b=3), 5)
print(collatz.function(2, P=5, a=2, b=3), 7)
print(collatz.function(3, P=5, a=2, b=3), 9)
print(collatz.function(4, P=5, a=2, b=3), 11)
print(collatz.function(5, P=5, a=2, b=3), 1)
# Test negative P, a and b. %, used in the function, is "floor" in python
# rather than the more reasonable euclidean, but we only use it's (0 mod P)
# conjugacy class to determine functionality, so the flooring for negative P
# doesn't cause any issue.
print(collatz.function(1, P=-3, a=-2, b=-5), -7)
print(collatz.function(2, P=-3, a=-2, b=-5), -9)
print(collatz.function(3, P=-3, a=-2, b=-5), -1)
# # Set P and a to 0 to assert on __assert_sane_parameterisation
try:
    collatz.function(1, P=0, a=2, b=3)
except AssertionError as err:
    print(err, _REGEX_ERR_P_IS_ZERO)
try:
    collatz.function(1, P=0, a=0, b=3)
except AssertionError as err:
    print(err, _REGEX_ERR_P_IS_ZERO)
try:
    collatz.function(1, P=1, a=0, b=3)
except AssertionError as err:
    print(err, _REGEX_ERR_A_IS_ZERO)
