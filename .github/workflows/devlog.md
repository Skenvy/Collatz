# Devlog
## Setting up the initial workflow patterns
_A few of the core reasons in here no longer apply as rigidly, but it's been set up this way for over a year and below is the argument as to why._ For instance, back when this was written, a called workflow couldn't call another workflow, the call depth had a maximum of one. I hear it's now something like a depth of 4, and 20 callables per top call.

Relocated from the README's "Workflow triggers" section, as it's getting long.

It is challenging to find a way to compress these four categories into less than four workflows, although this leads to an issue of how to share the internal processes for each workflow without duplicating code across them, and without having to have a `workflow_call` workflow for each process that gets invoked by each category. The `on.push.paths` field is not inconsequential to access as a field that could be used to `if` a job, so it's best if that category gets it's own workflow, especially being the only one to invoke the CD process. But it utilises the "entire scope CI", which it could access by `workflow_call` on a second workflow dedicated to the CI. The PR trigger is easy to integrate parallel to the push trigger and conditionalise the workflow on it.

The problem comes from trying to simultaneously include _"A push to main that doesn't change the idiomatic release versioning"_ and _"A push to any other branch"_ in the same workflow. If the "branches"/"branches-ignore" fields are removed, and the CI workflow is allowed to run without branch limiting, then a push to main that triggers the CD workflow will also invoke the entire scope testing in the CI workflow, essentially doubling the work done.

One approach is to have three workflows, one for the CD process with the trigger for _"A push to main that changes the idiomatic release versioning"_, one for the "entire scope" CI process triggered by the the _"A push to main that doesn't change the idiomatic release versioning"_ and _"A PR against main"_, and one for the "limited scope" CI process triggered by _"A push to any other branch"_.

An alternative approach would be to set up a way to establish the aboves categories as contexts in which a single workflow would run via each of the above categories having their own workflow that simply invokes a shared workflow via `workflow_call` and passes the context to it via inputs. This is the best way to circumvent the lack (or removal of) the capacity to check the list of changed files in a push's event payload (with which it'd be possible to just keep only two workflows). This also lets us keep the "whole workflow" in a single file and conditionalise it on inputs to the `workflow_call` event provided by a range of triggering workflows. The only downside, besides each language now having 5 workflow files, is that the workflow file itself wouldn't be able to invoke any additional workflows as this would exceed the depth of 2.

Using GitHub Actions is really just playing a game of deciding which antipatterns are least annoying to deal with, as any minor complexity in a workflow design requires sacrificing the cleanliness of them to antipatterns. For example, to have the fewest files, with the least amount of duplication, we could rely on `workflow_call`, but because it has a maximum depth of "1" call (i.e. a called workflow can't call another), we'll have to end up with a bit of duplicated code, but also will have to plan what files has what strategically so as to make sure we don't ever call deeper than "1". For instance, we can't split any "shared" testing between the full and quick tests into a seperate workflow and call that from either of them, because then the release workflow would have a call depth of 2.

Personally, my most live-with-able antipattern is to give one workflow the capacity to nullify itself if it knows it can anticipate being invoked by another. Which allows us to keep only two workflows, reliant on the path(s) to the file(s) considered as updating the version, and thus triggering a release build. Although, if we rely on a step in a job to manually detect whether or not the build job will run, then it's just as relevant as relying on the `on.push.paths` filter. Rather than utilise this manual check in the test workflow to prevent it running if it assumes the build workflow will call it, why not instead limit the test workflow to not run on main, and remove the `on.push.paths: version-file` filter from the build workflow, and have it use the manual check to let its steps subsequent to calling the test workflow run or not. The _only_ disadvantage, or rather, minor inconvenience to this, is that the CD workflow would end up containing runs for pushes straight to master that didn't update the version, and hence never released, when that workflow is supposed to idiomatically be runs that ended in a release.

While something like the below works, and should work for now, if it comes to a point where it's not possible to predicate the running of the release on a single file, we might need to add a third workflow that would be something like the second block of code below;
```yaml
jobs:
  workflow-conditions:
    name: 🐱‍👤 Workflow Conditionaliser 🐱‍👤 
    runs-on: ubuntu-latest
    outputs:
      version-file-changed: ${{ steps.version-file-check.outputs.version-file-changed }}
    steps:
    - name: 🏁 Checkout
      uses: actions/checkout@93ea575cb5d8a053eaa0ac8fa3b40d7e05a33cc8 # v3.1.0
      with:
        fetch-depth: 2
    - name: Check if version files changed
      id: version-file-check
      run: |
        export VERSION_FILE="python/src/collatz/__version__.py"
        [ "$(git diff HEAD^1.. --name-only | grep -e "^$VERSION_FILE$")" == "$VERSION_FILE" ] && echo "version-file-changed=${{toJSON(true)}}" >> $GITHUB_OUTPUT || echo "version-file-changed=${{toJSON(false)}}" >> $GITHUB_OUTPUT
    - name: Notify of conditions
      run: echo "::Notice::version-file-changed is ${{ fromJSON(steps.version-file-check.outputs.version-file-changed) }}"
  # Now any step that should only run on the version change can use "needs: [workflow-conditions]"
  # Which will yield the condition check "if: ${{ fromJSON(needs.workflow-conditions.outputs.version-file-changed) == true }}"
```
_And the alternative possible third workflow that would enable leaving `on.push.paths`_
```yaml
name: Python 🐍🐍🐍 CD 🦂 Build 🧱 Release 🚰 and Publish 📦
on:
  push:
    branches:
    - 'main'
    paths:
    - 'python/**'
    - '!python/src/collatz/__version__.py'
    - '.github/workflows/python-*'
  workflow_dispatch: # manual, rather than tag triggering
defaults:
  run:
    shell: bash
    working-directory: python
jobs:
  test:
    name: Python 🐍🐍🐍 CI 🦂
    uses: ./.github/workflows/python-test.yaml
```
With the goal being that it simply removes the release triggering file from its paths, and only calls the test workflow.
## Limiting full test matrices to cached versions in some cases.
Recently I got struck by these two [[1](https://github.com/actions/setup-node/issues/77)] [[2](https://github.com/nodejs/build/issues/1993)] issues related to very slow download speeds of versions of node not cached on certain runners causing half hour downloads to cancel themselves and cause workflows to fail. Node 19 took 27 minutes to try and download on `macOS-latest`, before giving up.

To get around this issue, we can have a look at [Supported runners and hardware resources](https://docs.github.com/en/actions/using-github-hosted-runners/about-github-hosted-runners#supported-runners-and-hardware-resources) to see what "runner image" is used per workflow label for [jobs.<job_id>.runs-on](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions#jobsjob_idruns-on) (which has the same table under it here ["Choosing GitHub-hosted runners"](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions#choosing-github-hosted-runners)). We can couple that with the readmes under [runner-images](https://github.com/actions/runner-images/tree/main/images), and look at the installed / cached versions for each hosted runner image we can choose. For example, at the moment the images are;
| YAML workflow label | Runner image | Cached Node Versions |
| :---                | :---         | :---                 |
| `windows-latest`    | [Windows Server 2022](https://github.com/actions/runner-images/blob/dcf2bd287074254863131d7c5e58f6c591a7247e/images/win/Windows2022-Readme.md) | [14.21.3, 16.20.1, 18.16.1](https://github.com/actions/runner-images/blob/dcf2bd287074254863131d7c5e58f6c591a7247e/images/win/Windows2022-Readme.md#nodejs) |
| `ubuntu-latest`     | [Ubuntu 22.04](https://github.com/actions/runner-images/blob/bd6b3eaafbf6e04d169f71890f5640da343c94bc/images/linux/Ubuntu2204-Readme.md) | [14.21.3, 16.20.1, 18.16.1](https://github.com/actions/runner-images/blob/bd6b3eaafbf6e04d169f71890f5640da343c94bc/images/linux/Ubuntu2204-Readme.md#nodejs) |
| `macos-latest`      | [macOS 12 Monterey](https://github.com/actions/runner-images/blob/0a6e640250d4b1406160dabadcf2f832e0ec6393/images/macos/macos-12-Readme.md) | [14.21.3, 16.20.1, 18.16.1](https://github.com/actions/runner-images/blob/0a6e640250d4b1406160dabadcf2f832e0ec6393/images/macos/macos-12-Readme.md#nodejs) |

Without knowing how long it'll be until the "latest" images change, we may as well stop testing Node version 17 and 19 on windows and mac.
