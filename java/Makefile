HUSH=-Dorg.slf4j.simpleLogger.log.org.apache.maven.cli.transfer.Slf4jMavenTransferListener=warn
MVN=mvn clean
MVN_NONINTERACTIVE=mvn -B -U clean
.PHONY: clean docs docs_noninteractive docs_deploy test test_noninteractive build build_noninteractive run deploy_noninteractive_ossrh deploy_noninteractive_github
SHELL:=/bin/bash

clean:
	$(MVN)

docs:
	$(MVN) site:site site:run -P deploy-ossrh

# the clean phase can be included in a single invocation
test:
	$(MVN) test

# package > test in mvn phases, so no need for test to be a prerequisite
build:
	$(MVN) package

# Something like the actual java invocation; (for the default gen'd)
# java -cp target/Collatz-1.0-SNAPSHOT.jar org.skenvy.collatz.App
# would be usable if it could discover the jar by name. Instead use
# https://www.mojohaus.org/exec-maven-plugin/java-mojo.html
# But this will only be relevant when the main class has main(String[] args)
__run:
	$(MVN) compile exec:java -Dexec.mainClass="io.github.skenvy.Collatz"

# The use of maven in GitHub Actions benefits from the batch mode options in
# $(MVN_NONINTERACTIVE) and removing the "downloading" info output via $(HUSH)
docs_noninteractive:
	$(MVN_NONINTERACTIVE) site:site site:stage scm-publish:publish-scm -P deploy-ossrh -Dscmpublish.checkinComment="build based on $(SHORTSHA)" $(HUSH) -Dscmpublish.dryRun=true

docs_deploy:
	$(MVN_NONINTERACTIVE) site:site site:stage scm-publish:publish-scm -P deploy-ossrh -Dscmpublish.checkinComment="build based on $(SHORTSHA)" $(HUSH) -Dpassword=$(PASSWORD)

test_noninteractive:
	$(MVN_NONINTERACTIVE) test $(HUSH)

build_noninteractive:
	$(MVN_NONINTERACTIVE) package $(HUSH)

deploy_noninteractive_ossrh:
	$(MVN_NONINTERACTIVE) deploy -P deploy-ossrh,release,gpg $(HUSH)

deploy_noninteractive_github:
	$(MVN_NONINTERACTIVE) deploy -P deploy-github,release,gpg $(HUSH)
