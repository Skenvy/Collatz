import collatz
from collatz import _CC, _ErrMsg


_REGEX_ERR_P_IS_ZERO = f"^{_ErrMsg.SANE_PARAMS_P.value}$"
_REGEX_ERR_A_IS_ZERO = f"^{_ErrMsg.SANE_PARAMS_A.value}$"


print("""
Demonstrate def tree_graph(initial_value:int, max_orbit_distance:int, P:int=2,
a:int=3, b:int=1, __cycle_prevention:Optional[Set[int]]=None)
""")
C = _CC.CYCLE_INIT.value  # Shorthand the cycle terminus
D = {}  # Just to colourise the below in the editor..
# The default zero trap
print(collatz.tree_graph(0, 0), {0: D})
print(collatz.tree_graph(0, 1), {0: {C: 0}})
print(collatz.tree_graph(0, 2), {0: {C: 0}})
# The roundings of the 1 cycle.
print(collatz.tree_graph(1, 1), {1: {2: D}})
print(collatz.tree_graph(1, 0), {1: D})
print(collatz.tree_graph(1, 1), {1: {2: D}})
print(collatz.tree_graph(1, 2), {1: {2: {4: D}}})
print(collatz.tree_graph(1, 3), {1: {2: {4: {C: 1, 8: D}}}})
print(collatz.tree_graph(2, 3), {2: {4: {1: {C: 2}, 8: {16: D}}}})
print(collatz.tree_graph(4, 3), {4: {1: {2: {C: 4}}, 8: {16: {5: D, 32: D}}}})
# The roundings of the -1 cycle
print(collatz.tree_graph(-1, 1), {-1: {-2: D}})
print(collatz.tree_graph(-1, 2), {-1: {-2: {-4: D, C: -1}}})
# Test a wider modulo sweep by upping P to 5, a to 2, and b to 3.
tree = lambda x, y: {1: {-1: x, 5: y}}
orb_1 = tree(D, D)
orb_2 = tree({-5: D, -2: D}, {C: 1, 25: D})
tree = lambda x, y, z: {1: {-1: {-5: x, -2: y}, 5: {C: 1, 25: z}}}
orb_3 = tree({-25: D, -4: D}, {-10: D}, {11: D, 125: D})
print(collatz.tree_graph(1, 1, P=5, a=2, b=3), orb_1)
print(collatz.tree_graph(1, 2, P=5, a=2, b=3), orb_2)
print(collatz.tree_graph(1, 3, P=5, a=2, b=3), orb_3)
# Test negative P, a and b.
orb_1 = {1: {-3: D}}
tree = lambda x, y: {1: {-3: {-1: x, 9: y}}}
orb_2 = tree(D, D)
orb_3 = tree({-2: D, 3: D}, {-27: D, -7: D})
print(collatz.tree_graph(1, 1, P=-3, a=-2, b=-5), orb_1)
print(collatz.tree_graph(1, 2, P=-3, a=-2, b=-5), orb_2)
print(collatz.tree_graph(1, 3, P=-3, a=-2, b=-5), orb_3)
# # Set P and a to 0 to assert on __assert_sane_parameterisation
try:
    collatz.tree_graph(1, 1, P=0, a=2, b=3)
except AssertionError as err:
    print(err, _REGEX_ERR_P_IS_ZERO)
try:
    collatz.tree_graph(1, 1, P=0, a=0, b=3)
except AssertionError as err:
    print(err, _REGEX_ERR_P_IS_ZERO)
try:
    collatz.tree_graph(1, 1, P=1, a=0, b=3)
except AssertionError as err:
    print(err, _REGEX_ERR_A_IS_ZERO)
# If b is a multiple of a, but not of Pa, then 0 can have a reverse.
print(collatz.tree_graph(0, 1, P=17, a=2, b=-6), {0: {C: 0, 3: D}})
print(collatz.tree_graph(0, 1, P=17, a=2, b=102), {0: {C: 0}})
