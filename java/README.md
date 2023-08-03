# [Collatz](https://github.com/Skenvy/Collatz): [Java](https://github.com/Skenvy/Collatz/tree/main/java) ☕🦆🌞
Functions related to [the Collatz/Syracuse/3N+1 problem](https://en.wikipedia.org/wiki/Collatz_conjecture), implemented in [Java](https://www.java.com/) ([OpenJDK](https://openjdk.org/)).
## Getting Started
[To install the latest from Maven Central](https://repo1.maven.org/maven2/io/github/skenvy/collatz/) ([sonatype.org source mirror](https://s01.oss.sonatype.org/content/repositories/releases/io/github/skenvy/collatz/)) (also see [mvnrepository](https://mvnrepository.com/artifact/io.github.skenvy/collatz) or the [sonatype package index](https://search.maven.org/artifact/io.github.skenvy/collatz));
### Add to the pom `<dependencies>`
```xml
<dependency>
  <groupId>io.github.skenvy</groupId>
  <artifactId>collatz</artifactId>
</dependency>
```
### Or in gradle
```
implementation 'io.github.skenvy:collatz'
```
## Usage
Provides the basic functionality to interact with the Collatz conjecture.
The parameterisation uses the same `(P,a,b)` notation as Conway's generalisations.
Besides the function and reverse function, there is also functionality to retrieve the hailstone sequence, the "stopping time"/"total stopping time", or tree-graph. 
The only restriction placed on parameters is that both `P` and `a` can't be `0`.
## [Maven-Site generated docs](https://skenvy.github.io/Collatz/java)
## [JavaDoc generated docs](https://skenvy.github.io/Collatz/java/apidocs/io/github/skenvy/package-summary.html)
## [Checkstyle generated docs](https://skenvy.github.io/Collatz/java/checkstyle.html)
## Developing
### The first time setup
_There is no one time setup required as each maven command will dynamically fetch its dependencies._
### Iterative development
* `make test` will do nothing magical, but is helpful
* `make lint` will evaluate the [Checkstyle rules](https://github.com/Skenvy/Collatz/blob/main/java/checkstyle.xml).
* `make docs` will create the site and then run it on [localhost](http://localhost:8080) with [javadoc here](http://localhost:8080/apidocs/io/github/skenvy/package-summary.html), and the [Checkstyle report here](http://localhost:8080/checkstyle.html).
## [Open Source Insights](https://deps.dev/maven/io.github.skenvy%3Acollatz)
