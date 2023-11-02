# [Collatz](https://github.com/Skenvy/Collatz): [Python](https://github.com/Skenvy/Collatz/tree/main/python) 🐍🐍🐍
Functions related to [the Collatz/Syracuse/3N+1 problem](https://en.wikipedia.org/wiki/Collatz_conjecture), implemented in [Python](https://www.python.org/).
## Getting Started
[To install the latest from pypi](https://pypi.org/project/collatz/);
```sh
pip install collatz
```
## Usage
Provides the basic functionality to interact with the Collatz conjecture.
The parameterisation uses the same `(P,a,b)` notation as Conway's generalisations.
Besides the function and reverse function, there is also functionality to retrieve the hailstone sequence, the "stopping time"/"total stopping time", or tree-graph. 
The only restriction placed on parameters is that both `P` and `a` can't be `0`.
### collatz.function(~)
`(n:int, P:int=2, a:int=3, b:int=1)`
```python
>>> import collatz
>>> # The default "Collatz function"
>>> collatz.function(5)
16
>>> # Alternatively, you can parameterise the function.
>>> collatz.function(5, P=7, a=5, b=17)
42
```
### collatz.reverse_function(~)
`(n:int, P:int=2, a:int=3, b:int=1)`
```python
>>> import collatz
>>> # Get the list of values that return the input.
>>> collatz.reverse_function(4)
[1, 8]
>>> # Alternatively, you can parameterise the reverse_function.
>>> collatz.reverse_function(5, P=5, a=2, b=3)
[1, 25]
```
### collatz.hailstone_sequence(~)
`(initial_value:int, P:int=2,  a:int=3, b:int=1, max_total_stopping_time:int=1000, total_stopping_time:bool=True, verbose:bool=True)`
```python
>>> import collatz
>>> # Get the sequence of values forming the hailstone from an initial value
>>> collatz.hailstone_sequence(10)
[10, 5, 16, 8, 4, 2, 1, ['TOTAL_STOPPING_TIME', 6]]
>>> # Determines if it's in a cycle
>>> collatz.hailstone_sequence(-56)
[-56, -28, 'CYCLE_INIT', [-14, -7, -20, -10, -5], ['CYCLE_LENGTH', 5]]
>>> # The verbose messages can be muted, although this might leave a sense of ambiguity for larger lists.
>>> collatz.hailstone_sequence(-200, verbose=False)
[-200, -100, -50, -25, -74, -37, -110, -55, -164, -82, -41, -122, -61, -182, -91, -272, -136, -68, -34, -17, -50]
>>> # Although hailstones typically go to the "total stop" of 1, they can be set to terminate on the regular stop
>>> collatz.hailstone_sequence(5, total_stopping_time=False)
[5, 16, 8, 4, ['STOPPING_TIME', 3]]
```
### collatz.stopping_time(~)
`(initial_value:int, P:int=2, a:int=3, b:int=1, max_stopping_time:int=1000, total_stopping_time:bool=False)`
```python
>>> import collatz
>>> # Reports the stopping time, the amount of iterations of the function to reach a value lower than the initial value.
>>> collatz.stopping_time(5)
3
>>> # Can be used to find the "total stopping time" as well, the amount of iterations to reach "1"
>>> collatz.stopping_time(5, total_stopping_time=True)
5
>>> # Although most cylces have a stopping time, by targetting the total stopping time, you can see if a value leads into a cycle by the 'inf' return
>>> collatz.stopping_time(-17, total_stopping_time=True)
inf
>>> # Some cycles are small enough that starting on the lowest absolute value will still identify a cycle.
>>> collatz.stopping_time(-1)
inf
>>> # If it overruns maximum stopping time, returns nothing.
>>> collatz.stopping_time(5, max_stopping_time=-1)
>>> # <None>
```
### collatz.tree_graph(~)
`(initial_value:int, max_orbit_distance:int, P:int=2, a:int=3, b:int=1)`
```python
>>> import collatz
>>> # See the tree graph built by a reverse function traversal, to the depth specified by max_orbit_distance.
>>> collatz.tree_graph(1, 3)
{1: {2: {4: {'CYCLE_INIT': 1, 8: {}}}}}
>>> collatz.tree_graph(1, 12)
{1: {2: {4: {'CYCLE_INIT': 1, 8: {16: {5: {10: {3: {6: {12: {24: {48: {96: {}}}}}}, 20: {40: {13: {26: {52: {17: {}, 104: {}}}}, 80: {160: {53: {106: {}}, 320: {640: {}}}}}}}}, 32: {64: {21: {42: {84: {168: {336: {672: {}}}}}}, 128: {256: {85: {170: {340: {113: {}, 680: {}}}}, 512: {1024: {341: {682: {}}, 2048: {4096: {}}}}}}}}}}}}}}
>>> # Can also be parameterised;
>>> collatz.tree_graph(1, 2, P=5, a=2, b=3)
{1: {-1: {-5: {}, -2: {}}, 5: {'CYCLE_INIT': 1, 25: {}}}}
```
## [Sphinx+MyST generated docs](https://skenvy.github.io/Collatz/python/)
## Developing
### The first time setup
```
git clone https://github.com/Skenvy/Collatz.git && cd Collatz/python && make venv
```
### Iterative development
* `make build` will test and build the wheel and force reinstall it into the local venv, to test the built distribution
## [Open Source Insights](https://deps.dev/pypi/collatz)
