import collatz
from collatz import _ErrMsg


_REGEX_ERR_P_IS_ZERO = f"^{_ErrMsg.SANE_PARAMS_P.value}$"
_REGEX_ERR_A_IS_ZERO = f"^{_ErrMsg.SANE_PARAMS_A.value}$"


print("""
Demonstrate reverse_function(n:int, P:int=2, a:int=3, b:int=1):
""")
# Default (P,a,b); 0 trap [as b is not a multiple of a]
print(collatz.reverse_function(0), [0])
# Default (P,a,b); 1 cycle; positives
print(collatz.reverse_function(1), [2])
print(collatz.reverse_function(4), [1, 8])
print(collatz.reverse_function(2), [4])
# Default (P,a,b); -1 cycle; negatives
print(collatz.reverse_function(-1), [-2])
print(collatz.reverse_function(-2), [-4, -1])
# Test a wider modulo sweep by upping P to 5, a to 2, and b to 3.
print(collatz.reverse_function(1, P=5, a=2, b=3), [-1, 5])
print(collatz.reverse_function(2, P=5, a=2, b=3), [10])
print(collatz.reverse_function(3, P=5, a=2, b=3), [15])  # also tests !0
print(collatz.reverse_function(4, P=5, a=2, b=3), [20])
print(collatz.reverse_function(5, P=5, a=2, b=3), [1, 25])
# Test negative P, a and b. %, used in the function, is "floor" in python
# rather than the more reasonable euclidean, but we only use it's (0 mod P)
# conjugacy class to determine functionality, so the flooring for negative P
# doesn't cause any issue.
print(collatz.reverse_function(1, P=-3, a=-2, b=-5), [-3])  # != [-3, -3]
print(collatz.reverse_function(2, P=-3, a=-2, b=-5), [-6])
print(collatz.reverse_function(3, P=-3, a=-2, b=-5), [-9, -4])
# # Set P and a to 0 to assert on __assert_sane_parameterisation
try:
    collatz.reverse_function(1, P=0, a=2, b=3)
except AssertionError as err:
    print(err, _REGEX_ERR_P_IS_ZERO)
try:
    collatz.reverse_function(1, P=0, a=0, b=3)
except AssertionError as err:
    print(err, _REGEX_ERR_P_IS_ZERO)
try:
    collatz.reverse_function(1, P=1, a=0, b=3)
except AssertionError as err:
    print(err, _REGEX_ERR_A_IS_ZERO)
# If b is a multiple of a, but not of Pa, then 0 can have a reverse.
print(collatz.reverse_function(0, P=17, a=2, b=-6), [0, 3])
print(collatz.reverse_function(0, P=17, a=2, b=102), [0])
