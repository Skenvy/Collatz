# CICD for orthogonal releases from one repository
`./github/workflows/` being a centralised location for any automated, testing, documenting, building, or releasing, coupled with this repo housing multiple orthogonal release targets (ideally one for each language included in it), leads to the obvious design goal of keeping any processes for a single language as clustered as possible, and that each overall process should attempt to maintain a uniformity as to "what it does" in terms of the testing, documenting, building, or releasing.
To achieve clustering for shared relevance to the same release target (per language) each workflow will be named `<language>-*.yaml`.
To achieve prescriptivity over the intended uniformity of each workflow as it pertains to "what it does" for (per that language's release target) each workflow will be named `<language>-<process>.yaml`.

Some restrictions that immediately apply to this, because it relies on [GitHub Actions](https://docs.github.com/en/actions) are related to the `workflow_call` event, and performing operations with the `GITHUB_TOKEN`.
While workflows are designed with the intent of being [modularisable / reusable](https://docs.github.com/en/enterprise-cloud@latest/actions/using-workflows/reusing-workflows#calling-a-reusable-workflow) via the [`workflow_call`](https://docs.github.com/en/enterprise-cloud@latest/actions/using-workflows/events-that-trigger-workflows#workflow_call) event, a workflow that is initiated via a `workflow_call` can not only not initiate another workflow via `workflow_call`, but even more than that cannot include an invocation to initiate another workflow via `workflow_call`, whether it runs or not! (It appears that the check for whether a chained `workflow_call` exists is shallow, and does not even parse the [`jobs.<job_id>.if`](https://docs.github.com/en/enterprise-cloud@latest/actions/using-workflows/workflow-syntax-for-github-actions#jobsjob_idif) to check if that chained invocation will be initiated) (the resulting error is `error parsing called workflow "./.github/workflows/some-workflow.yaml@": job "some-job" calls workflow "./.github/workflows/another-workflow.yaml@", but doing so would exceed the limit on called workflow depth of 2`). This is also coupled with the called workflow inheriting the entire "github context" from the callee, so a workflow with triggering actions `[<X>, workflow_call]` called by another workflow triggered by an `<X>` action, will pass the entire `<X>` context. For instance, a comparison can not be used such as `jobs.<job_id>.if: ${{ github.event_name == 'workflow_call' }}`, although the workflow call can bootstrap this condition with inputs.
Parallel to this is that any operation performed during an "action", if performed with the [`GITHUB_TOKEN`](https://docs.github.com/en/github-ae@latest/actions/security-guides/automatic-token-authentication) won't "trigger" any other workflows, regardless of if they are set up to only trigger on such an anticipated action, to minimise recursive workflow instantiations. The typical method to circumvent this is to utilise a "Personal Access Token" key to perform actions during a workflow that you do want to trigger another workflow, but this is looser security. All in all, both these issues with `workflow_call` and `GITHUB_TOKEN` make [GitHub Actions](https://docs.github.com/en/actions) feel very much like riding a bike with training wheels that can't be taken off.
# The "per that language's release target" processes
## CI
_Any_ push to _any_ branch, **that changes files relevant to** _some_ release target(s), should invoke a **"CI verification"** on that release.
* The steps within a **"CI verification"** can have either a _limited_ or _entire_ scope.
    * All release targets for the _entire_ scope should be included in the `jobs.<job_id>.strategy.matrix` such as;
        ```yaml
        jobs:
          <job_id>:
            runs-on: '${{ matrix.os }}'
            strategy:
            matrix:
              version: ['1', '2', '...']
              os: [ubuntu-latest, macOS-latest, windows-latest]
              arch: [x64, '...']
        ```
* The **"CI verification"** for a release **must** include a **full test suite**;
    * Which is equivalent to, or greater than, running a `make test` recipe.
* The **"CI verification"** for a release _may_ include a **documentation test**;
    * That **verifies an optional documentation generation** step in the post-release action will work.
    * Documentation testing can be within a unitary scope, according to how it will be hosted.
* _All_ pushes to, _and_ PRs against, _the **main**_ branch should invoke the **"CI verification"** across the _entire_ scope.
* _Any_ push to _any **non-main**_ branch should invoke the **"CI verification"** across the _limited_ scope.
    * i.e. no need to implement the **"CI verification"** across the _entire_ scope in `jobs.<job_id>.strategy.matrix`.
## CD
_All_ pushes to _the **main**_ branch **that changes files relevant to** _some_ release target(s), **_where those files affect the idiomatic versioning of that release_**, should, pending on the passing of the **"CI verification"**, invoke the **build and release** (**"CD actions"**) on that release target(s).
* The building, releasing, and or distributing process for each "release target" is unique, and the jargon used internally to each language, about its release, may be ambiguous in the absence of the context of that language. For this reason;
* A **release** step within the context of being an action in the CD workflow implies a ["github release"](https://docs.github.com/en/repositories/releasing-projects-on-github/about-releases).
    * The order of actions for a **release** should align with;
        * `{CI verification} => (build?) => release => (distribute?::(documentation?))`
    * A **release** may or may not contain **build artefacts**.
    * A **release** may or may not subsequently need to be "deployed"/"distributed"
## Workflow triggers
```mermaid
flowchart TD
    A1(Any Push) --> |Trigger| B1{Relevant changes?}
    B1 --> |yes| C1{Branch}
    B1 --> |no| D1(Nothing to do)
    C1 --> |not main| E1[Limited Scope CI]
    C1 --> |main| F1[Entire Scope CI]
    F1 -->  G1{Release changes?}
    G1 --> |yes| H1[CD Process]
    G1 --> |no| D1(Nothing to do)
    A2(PR against main) --> |Trigger| B2{Relevant changes?}
    B2 --> |yes| C2[Entire Scope CI]
    B2 --> |no| D2(Nothing to do)
```
We want different processes for the workflows across four essential categories.
1. A push to main that changes the idiomatic release versioning.
    ```yaml
    on:
      push:
        branches:
        - 'main'
        paths:
        - 'some_lang/some_version_files'
    ```
    * Entire Scope CI
    * CD Process
1. A push to main that doesn't change the idiomatic release versioning.
    ```yaml
    on:
      push:
        branches:
        - 'main'
        paths:
        - 'some_lang/**'
        - '!some_lang/some_version_files'
        - '.github/workflows/some_lang-*'
    ```
    * Entire Scope CI
1. A push to any other branch
    ```yaml
    on:
      push:
        branches-ignore:
        - 'main'
        paths:
        - 'some_lang/**'
        - '.github/workflows/some_lang-*'
    ```
    * Limited Scope CI
1. A PR against main
    ```yaml
    on:
      pull_request:
        branches:
        - 'main'
        paths:
        - 'some_lang/**'
        - '.github/workflows/some_lang-*'
    ```
    * Entire Scope CI

It would also be nice to run each of the tests once a month. We're in an AEST+AEDT time zone, and the crons are UTC. It'd be nice to run a test workflow a day, in the morning, say around 9AM for the time it would be in AEST/AEDT. Daylight savings times take effect first Sunday in October and April, so if we are setting the crons to _some day in the month after the 7th_, then April won't be AEDT but October will be. Months `1,2,3,10,11,12` will be AEDT and months `4,5,6,7,8,9` will be AEST. To know what UTC time to set for, we subtract the `11` hours in AEDT, and `10` hours in AEST.
So if we want 9AM tests spread across days, the crons would be something like [`0 22 14 1,2,3,10,11,12 *`](https://crontab.guru/#0_22_14_1,2,3,10,11,12_*) and [`0 23 14 4,5,6,7,8,9 *`](https://crontab.guru/#0_23_14_4,5,6,7,8,9_*) (as an example for the 15th day of the month).
```yaml
on:
  schedule: # 9AM on the 15th
  - cron: 0 22 14 1,2,3,10,11,12 * # AEDT Months
  - cron: 0 23 14 4,5,6,7,8,9 *    # AEST Months
```

## Templates for workflows; `*-test.yaml` and `*-build.yaml`
Can be search+replace'd on
* `<Language>` + `<language>` + `<language-emojis>`
* `<gh-action-setup-language@semver>` + `<language-version>`
* `<make-environment-dependencies>`
* `<version-file>` (appears as `export VERSION_FILE="<language>/<version-file>"`)
* `<version-extracting-command>` (appears as `export VER=$(<version-extracting-command>)`)

The caveat on the lowercase `<language>` is that it is replacing the value in `working-directory: <language>`, so is synonymous with the subfolder that contains that language, and might not always actually be replaced with something in lower case. It's also required that this uses the same capitalisation as the `.github/workflows/<language>-*` files.
## `<language>-test.yaml`
```yaml
name: <Language> <language-emojis> Tests 🦂
on:
  push:
    branches-ignore:
    - 'main'
    paths:
    - '<language>/**'
    - '!<language>/**.md'
    - '!<language>/.vscode/**'
    - '.github/workflows/<language>-*'
  pull_request:
    branches:
    - 'main'
    paths:
    - '<language>/**'
    - '!<language>/**.md'
    - '!<language>/.vscode/**'
    - '.github/workflows/<language>-*'
  schedule: # 9AM on the 15th
  - cron: 0 22 14 1,2,3,10,11,12 * # AEDT Months
  - cron: 0 23 14 4,5,6,7,8,9 *    # AEST Months
  workflow_call:
permissions: {}
defaults:
  run:
    shell: bash
    working-directory: <language>
env:
  development_<language>_version: <language-version>
jobs:
  quick-test:
    name: <Language> <language-emojis> Quick Test 🦂
    if: ${{ github.event_name == 'push' && !(github.event.ref == 'refs/heads/main') }}
    runs-on: ubuntu-latest
    steps:
    - name: 🏁 Checkout
      uses: actions/checkout@b4ffde65f46336ab88eb53be808477a3936bae11 # v4.1.1
    - name: <language-emojis> Set up <Language>
      uses: <gh-action-setup-language@semver>
      with:
        version: ${{ env.development_<language>_version }}
        arch: 'x64'
    - name: 🧱 Install build dependencies
      run: make <make-environment-dependencies>
    - name: 🦂 Test
      run: make test
    - name: 🧹 Lint
      run: make lint
    - name: ⚖ Does the checked source match the built result? 
      run: make verify_built_checkin
  full-test:
    name: <Language> <language-emojis> Full Test 🦂
    if: >- 
      ${{ github.event_name == 'pull_request' || github.event_name == 'workflow_dispatch' ||
      (github.event_name == 'push' && github.event.ref == 'refs/heads/main') }}
    runs-on: '${{ matrix.os }}'
    strategy:
      fail-fast: false
      matrix:
        version: ['1', '2', '3']
        os: [ubuntu-latest] # , macOS-latest, windows-latest # < maybe.
        arch: [x64]
    steps:
    - name: 🏁 Checkout
      uses: actions/checkout@b4ffde65f46336ab88eb53be808477a3936bae11 # v4.1.1
    - name: <language-emojis> Set up <Language> ${{ matrix.version }}
      uses: <gh-action-setup-language@semver>
      with:
        version: ${{ matrix.version }}
        arch: ${{ matrix.arch }}
    # TODO: Maybe another step to install test dependencies
    - name: 🦂 Test
    # TODO: run: or uses: something depending on the languges
    - name: 🧹 Lint
      run: make lint
    - name: ⚖ Does the checked source match the built result? 
      run: make verify_built_checkin
  built-example:
    name: <Language> <language-emojis> Build Example 🦛
    if: >-
      ${{ github.event_name == 'pull_request' || github.event_name == 'workflow_dispatch' ||
      (github.event_name == 'push' && github.event.ref == 'refs/heads/main') }}
    runs-on: ubuntu-latest
    steps:
    - name: 🏁 Checkout
      uses: actions/checkout@b4ffde65f46336ab88eb53be808477a3936bae11 # v4.1.1
    - name: <language-emojis> Set up <Language>
      uses: <gh-action-setup-language@semver>
      with:
        version: ${{ env.development_<language>_version }}
        arch: 'x64'
    - name: 🧱 Install build dependencies
      run: make setup
    - name: 🧱 Build
      run: make build
    - name: 🆙 Upload dists
      uses: actions/upload-artifact@0b2256b8c012f0828dc542b3febcab082c67f72b # v4.3.4
      with:
        name: Package
        path: <language>/some-artefacts/path-to-one-file.pkg
        if-no-files-found: error
        retention-days: 1
  usage-demonstration:
    name: <Language> <language-emojis> Usage Demonstration 🦏
    needs: [built-example]
    if: >-
      ${{ github.event_name == 'pull_request' || github.event_name == 'workflow_dispatch' ||
      (github.event_name == 'push' && github.event.ref == 'refs/heads/main') }}
    runs-on: ubuntu-latest
    defaults:
      run:
        working-directory: <language>/.demo
    steps:
    - name: 🏁 Checkout
      uses: actions/checkout@b4ffde65f46336ab88eb53be808477a3936bae11 # v4.1.1
    - name: <language-emojis> Set up <Language>
      uses: <gh-action-setup-language@semver>
      with:
        version: ${{ env.development_<language>_version }}
        arch: 'x64'
    - name: 🆒 Download dists
      uses: actions/download-artifact@fa0a91b85d4f404e444e00e005971372dc801d16 # v4.1.8
      with:
        name: Package
        path: <language>/.demo
    - name: 🦛 Install this package
      run: make install
    - name: 🦏 Run usage demonstration
      run: make demo
  # # CodeQL step is dependent on https://aka.ms/codeql-docs/language-support
  codeql:
    name: <Language> <language-emojis> CodeQL 🛡👨‍💻🛡
    if: >- 
      ${{ github.event_name == 'pull_request' || github.event_name == 'workflow_dispatch' ||
      (github.event_name == 'push' && github.event.ref == 'refs/heads/main') }}
    permissions:
      actions: read
      contents: read
      security-events: write
    uses: ./.github/workflows/github-codeql.yaml
    with:
      language: '<Language>'
  # Docs step is optional depending on language
  docs:
    name: <Language> <language-emojis> Docs 📄 Quick Test 🦂
    runs-on: ubuntu-latest
    steps:
    - name: 🏁 Checkout
      uses: actions/checkout@b4ffde65f46336ab88eb53be808477a3936bae11 # v4.1.1
    - name: <language-emojis> Set up <Language>
      uses: <gh-action-setup-language@semver>
      with:
        version: ${{ env.development_<language>_version }}
    - name: 🧱 Install build dependencies
      run: make setup
    - name: 📄 Docs
      run: make docs
```
## `<language>-build.yaml`
```yaml
name: <Language> <language-emojis> Test 🦂 Build 🧱 Release 🚰 and Publish 📦
on:
  push:
    branches:
    - 'main'
    paths:
    - '<language>/**'
    - '!<language>/**.md'
    - '!<language>/.vscode/**'
    - '.github/workflows/<language>-*'
  workflow_dispatch:
permissions: {}
defaults:
  run:
    shell: bash
    working-directory: <language>
env:
  development_<language>_version: <language-version>
jobs:
  context:
    name: GitHub 🐱‍👤 Context 📑
    uses: ./.github/workflows/github-context.yaml
  test:
    name: <Language> <language-emojis> Test 🦂
    # Needs these permissions if the test workflow runs a CodeQL step
    # permissions:
    #   actions: read
    #   contents: read
    #   security-events: write
    uses: ./.github/workflows/<language>-test.yaml
  workflow-conditions:
    name: 🛑🛑🛑 Stop builds that didn't change the release version 🛑🛑🛑
    runs-on: ubuntu-latest
    outputs:
      version-file-changed: ${{ steps.version-file-check.outputs.version-file-changed }}
      version-tag-exists: ${{ steps.version-tag-exists.outputs.version-tag-exists }}
    steps:
    - name: 🏁 Checkout
      uses: actions/checkout@b4ffde65f46336ab88eb53be808477a3936bae11 # v4.1.1
      with:
        fetch-depth: 2
    - name: Check if version files changed
      id: version-file-check
      run: |
        export VERSION_FILE="<language>/<version-file>"
        [ "$(git diff HEAD^1.. --name-only | grep -e "^$VERSION_FILE$")" == "$VERSION_FILE" ] && echo "version-file-changed=${{toJSON(true)}}" >> $GITHUB_OUTPUT || echo "version-file-changed=${{toJSON(false)}}" >> $GITHUB_OUTPUT
    - name: Notify on version-file-check
      run: echo "::Notice::version-file-changed is ${{ fromJSON(steps.version-file-check.outputs.version-file-changed) }}"
    - name: Check if version specified in version file has not released.
      id: version-tag-exists
      run: |
        git fetch --tags
        export VER=$(<version-extracting-command>)
        [ -z "$(git tag -l "<language>-v$VER")" ] && echo "version-tag-exists=${{toJSON(false)}}" >> $GITHUB_OUTPUT || echo "version-tag-exists=${{toJSON(true)}}" >> $GITHUB_OUTPUT
    - name: Notify on version-tag-exists
      run: echo "::Notice::version-tag-exists is ${{ fromJSON(steps.version-tag-exists.outputs.version-tag-exists) }}"
  # Now any step that should only run on the version change can use
  # "needs: [workflow-conditions]" Which will yield the condition checks below.
  # We want to "release" automatically if "version-file-changed" is true on push
  # Or manually if workflow_dispatch. BOTH need "version-tag-exists" is false.
  build:
    name: <Language> <language-emojis> Build 🧱
    needs: [test, workflow-conditions]
    if: >-
      ${{ ((fromJSON(needs.workflow-conditions.outputs.version-file-changed) == true && github.event_name == 'push') ||
      github.event_name == 'workflow_dispatch') && fromJSON(needs.workflow-conditions.outputs.version-tag-exists) == false }}
    runs-on: ubuntu-latest
    steps:
    - name: 🏁 Checkout
      uses: actions/checkout@b4ffde65f46336ab88eb53be808477a3936bae11 # v4.1.1
    - name: <language-emojis> Set up <Language>
      uses: <gh-action-setup-language@semver>
      with:
        version: ${{ env.development_<language>_version }}
    - name: 🧱 Install build dependencies
      run: make <make-environment-dependencies>
    # Some step that uses `make build`
    # - name: 🆙 Upload dists
    #   uses: actions/upload-artifact@0b2256b8c012f0828dc542b3febcab082c67f72b # v4.3.4
    #   with:
    #     name: some-artefacts
    #     path: <language>/some-artefacts/
    #     if-no-files-found: error
  release:
    name: <Language> <language-emojis> Release 🚰
    needs: [build]
    permissions:
      contents: write
    runs-on: ubuntu-latest
    steps:
    - name: 🏁 Checkout
      uses: actions/checkout@b4ffde65f46336ab88eb53be808477a3936bae11 # v4.1.1
    # - name: 🆒 Download dists
    #   uses: actions/download-artifact@fa0a91b85d4f404e444e00e005971372dc801d16 # v4.1.8
    #   with:
    #     name: some-artefacts
    #     path: <language>/some-artefacts
    - name: 🚰 Release
      # env:
      #   GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
      run: |
        export VER=$(<version-extracting-command>)
        gh release create <language>-v$VER --generate-notes -t "<Language>: Version $VER"
  publish:
    name: <Language> <language-emojis> Publish 📦
    needs: [release]
    runs-on: ubuntu-latest
    steps:
    # Although the dists are built uses checkout to satisfy refs/tags existence
    # which were created by the release, prior to uploading to pypi.
    - name: 🏁 Checkout
      uses: actions/checkout@b4ffde65f46336ab88eb53be808477a3936bae11 # v4.1.1
    # - name: 🆒 Download dists
    #   uses: actions/download-artifact@fa0a91b85d4f404e444e00e005971372dc801d16 # v4.1.8
    #   with:
    #     name: some-artefacts
    #     path: <language>/some-artefacts
    - name: 📦 Publish
    # TODO: run: or uses: something depending on the languges
  docs:
    name: <Language> <language-emojis> Docs 📄
    needs: [release, publish]
    permissions:
      contents: write
    runs-on: ubuntu-latest
    steps:
    - name: 🏁 Checkout
      uses: actions/checkout@b4ffde65f46336ab88eb53be808477a3936bae11 # v4.1.1
    - name: <language-emojis> Set up <Language>
      uses: <gh-action-setup-language@semver>
      with:
        version: ${{ env.development_<language>_version }}
    # Run the following first to create the empty orphan
    # git checkout --orphan gh-pages-<language>
    # rm .git/index ; git clean -fdx
    # git commit -m "Initial empty orphan" --allow-empty
    # git push --set-upstream origin gh-pages-<language>
    - name: 📄 Docs
      run: |-
        git config --local user.email "actions@github.com"
        git config --local user.name "Github Actions"
        export SHORTSHA=$(git rev-parse --short HEAD)
        git fetch origin gh-pages-<language>:gh-pages-<language>
        git symbolic-ref HEAD refs/heads/gh-pages-<language>
        # What gets copied and where might vary but generally;
        cd .. && mv <language>/<built-docs-path> ../MERGE_TARGET
        git rm -rf . && git clean -fxd && git reset
        shopt -s dotglob && mkdir <language> && mv ../MERGE_TARGET/* <language>/
        # Then back to normal;
        git add .
        git commit -m "Build based on $SHORTSHA" --allow-empty
        git push --set-upstream origin gh-pages-<language>
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
  docs-merge:
    name: GitHub 🐱‍👤 Pages 📄 Merger 🧬
    needs: [docs]
    permissions:
      contents: write
      pages: write
      id-token: write
    uses: ./.github/workflows/github-pages.yaml
    with:
      merge_from: 'gh-pages-<language>'
```
# The meta-processes: `github-<metaprocess>.yaml`
## [`github-context.yaml`](https://github.com/Skenvy/Collatz/blob/main/.github/workflows/github-context.yaml)
Wraps echoing the [github context](https://docs.github.com/en/actions/learn-github-actions/contexts)
## [`github-pages.yaml`](https://github.com/Skenvy/Collatz/blob/main/.github/workflows/github-pages.yaml)
Unambiguously merges from some `gh-pages-*` branch into the `gh-pages` branch, with the assumed expectation that the `gh-pages-*` branch will be a `gh-pages-<language>` branch that only contains anything in a `<language>` subdirectory, and so only merge on top of its own previous merges.
## [`github-codeql.yaml`](https://github.com/Skenvy/Collatz/blob/main/.github/workflows/github-codeql.yaml)
Detects and lists code scanning violations and uploads the SARIF files to populate the security [code scanning](https://github.com/Skenvy/Collatz/security/code-scanning).
