.PHONY: clean docs test build
SHELL:=/bin/bash

clean:
	mvn clean

docs:
	mvn site

# the clean phase can be included in a single invocation
test:
	mvn clean test

# package > test in mvn phases, so no need for test to be a prerequisite
build:
	mvn clean package

# Something like the actual java invocation; (for the default gen'd)
# java -cp target/Collatz-1.0-SNAPSHOT.jar org.skenvy.collatz.App
# would be usable if it could discover the jar by name. Instead use
# https://www.mojohaus.org/exec-maven-plugin/java-mojo.html
run:
	mvn clean compile exec:java -Dexec.mainClass="io.github.skenvy.Collatz"
