# [Collatz](https://github.com/Skenvy/Collatz): [Java](https://github.com/Skenvy/Collatz/tree/main/java)
Functions related to [the Collatz/Syracuse/3N+1 problem](https://en.wikipedia.org/wiki/Collatz_conjecture), implemented in Java
## Getting Started
The package can be found at either [mvnrepository](https://mvnrepository.com/artifact/io.github.skenvy/collatz) or the [sonatype package index](https://search.maven.org/artifact/io.github.skenvy/collatz), alternatively it can be seen on the [sonatype release page here](https://s01.oss.sonatype.org/content/repositories/releases/io/github/skenvy/collatz/).
## Usage
Provides the basic functionality to interact with the Collatz conjecture.
The parameterisation uses the same `(P,a,b)` notation as Conway's generalisations.
Besides the function and reverse function, there is also functionality to retrieve the hailstone sequence, the "stopping time"/"total stopping time", or tree-graph. 
The only restriction placed on parameters is that both `P` and `a` can't be `0`.
