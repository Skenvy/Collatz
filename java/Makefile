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

run:
	java -cp target/Collatz-1.0-SNAPSHOT.jar org.skenvy.collatz.App
