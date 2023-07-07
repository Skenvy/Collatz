HUSH=-Dorg.slf4j.simpleLogger.log.org.apache.maven.cli.transfer.Slf4jMavenTransferListener=warn
MVN=mvn clean
MVN_NONINTERACTIVE=mvn -B -U clean
DOCS_PUBLISH_GOALS=jxr:jxr site:site site:stage scm-publish:publish-scm -P deploy-ossrh -Dscmpublish.checkinComment=
.PHONY: clean docs test lint build __run
SHELL:=/bin/bash

clean:
	$(MVN)

# http://localhost:8080
# http://localhost:8080/apidocs/io/github/skenvy/package-summary.html
# http://localhost:8080/checkstyle.html
docs:
	$(MVN) jxr:jxr site:site site:run -P deploy-ossrh

# the clean phase can be included in a single invocation
test:
	$(MVN) test

# First check for, and fail on, default of errors. If there aren't
# any errors, then check without failing for warnings.
# https://maven.apache.org/plugins/maven-checkstyle-plugin/check-mojo.html
# Something that prints the style violations line by line is desired for CI,
# but, when there are thousands of errors, running `mvn checkstyle:checkstyle`
# and opening and reading the html it generates is better locally.
lint:
	$(MVN) checkstyle:check
	$(MVN) checkstyle:check -Dcheckstyle.violationSeverity="warning" -Dcheckstyle.failOnViolation=false

# package > test in mvn phases, so no need for test to be a prerequisite
build:
	$(MVN) package

# Something like the actual java invocation; (for the default gen'd)
# java -cp target/Collatz-1.0-SNAPSHOT.jar org.skenvy.collatz.App
# would be usable if it could discover the jar by name. Instead use
# https://www.mojohaus.org/exec-maven-plugin/java-mojo.html
# But this will only be relevant when the main class has main(String[] args)
# If this is ever relevant, add back the jar main class path and exec plugin. See;
# https://github.com/Skenvy/Collatz/commit/82ddc95508911f5e278b090be9bfde1200748ba9
__run:
	$(MVN) compile exec:java -Dexec.mainClass="io.github.skenvy.Collatz"

# The use of maven in GitHub Actions benefits from the batch mode options in
# $(MVN_NONINTERACTIVE) and removing the "downloading" info output via $(HUSH)
.PHONY: docs_noninteractive
docs_noninteractive:
	$(MVN_NONINTERACTIVE) $(DOCS_PUBLISH_GOALS)"build based on $(SHORTSHA)" $(HUSH) -Dscmpublish.dryRun=true

.PHONY: docs_deploy
docs_deploy:
	$(MVN_NONINTERACTIVE) $(DOCS_PUBLISH_GOALS)"build based on $(SHORTSHA)" $(HUSH) -Dpassword=$(PASSWORD)

.PHONY: test_noninteractive
test_noninteractive:
	$(MVN_NONINTERACTIVE) test $(HUSH)

.PHONY: lint_noninteractive
lint_noninteractive:
	$(MVN_NONINTERACTIVE) checkstyle:check $(HUSH)
	$(MVN_NONINTERACTIVE) checkstyle:check -Dcheckstyle.violationSeverity="warning" -Dcheckstyle.failOnViolation=false $(HUSH)

.PHONY: build_noninteractive
build_noninteractive:
	$(MVN_NONINTERACTIVE) package $(HUSH)

.PHONY: deploy_noninteractive_ossrh
deploy_noninteractive_ossrh:
	$(MVN_NONINTERACTIVE) deploy -P deploy-ossrh,release,gpg $(HUSH)

.PHONY: deploy_noninteractive_github
deploy_noninteractive_github:
	$(MVN_NONINTERACTIVE) deploy -P deploy-github,release,gpg $(HUSH)
