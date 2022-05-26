.PHONY: clean docs test test_noninteractive build build_noninteractive run
SHELL:=/bin/bash

clean:
	mvn clean

docs:
	mvn site

# the clean phase can be included in a single invocation
test:
	mvn clean test

test_noninteractive:
	mvn -B -U clean test

# package > test in mvn phases, so no need for test to be a prerequisite
build:
	mvn clean package

build_noninteractive:
	mvn -B -U clean package

# Something like the actual java invocation; (for the default gen'd)
# java -cp target/Collatz-1.0-SNAPSHOT.jar org.skenvy.collatz.App
# would be usable if it could discover the jar by name. Instead use
# https://www.mojohaus.org/exec-maven-plugin/java-mojo.html
run:
	mvn clean compile exec:java -Dexec.mainClass="io.github.skenvy.Collatz"

deploy_noninteractive_ossrh:
	mvn -B -U deploy -P deploy-ossrh,release,gpg

deploy_noninteractive_github:
	mvn -B -U deploy -P deploy-github,release,gpg -X
