# CICD for orthogonal releases from one repository
`./github/workflows/` being a centralised location for any automated, testing, documenting, building, or releasing, coupled with this repo housing multiple orthogonal release targets (ideally one for each language included in it), leads to the obvious design goal of keeping any processes for a single language as clustered as possible, and that each overall process should attempt to maintain a uniformity as to "what it does" in terms of the testing, documenting, building, or releasing.
To achieve clustering for shared relevance to the same release target (per language) each workflow will be named `<language>-*.yaml`.
To achieve prescriptivity over the intended uniformity of each workflow as it pertains to "what it does" for (per that language's release target) each workflow will be named `<language>-<process>.yaml`.

Some restrictions that immediately apply to this, because it relies on [GitHub Actions](https://docs.github.com/en/actions) are related to the `workflow_call` event, and performing operations with the `GITHUB_TOKEN`.
While workflows are designed with the intent of being [modularisable / reusable](https://docs.github.com/en/enterprise-cloud@latest/actions/using-workflows/reusing-workflows#calling-a-reusable-workflow) via the [`workflow_call`](https://docs.github.com/en/enterprise-cloud@latest/actions/using-workflows/events-that-trigger-workflows#workflow_call) event, a workflow that is initiated via a `workflow_call` can not only not initiate another workflow via `workflow_call`, but even more than that cannot include an invocation to initiate another workflow via `workflow_call`, whether it runs or not! (It appears that the check for whether a chained `workflow_call` exists is shallow, and does not even parse the [`jobs.<job_id>.if`](https://docs.github.com/en/enterprise-cloud@latest/actions/using-workflows/workflow-syntax-for-github-actions#jobsjob_idif) to check if that chained invocation will be initiated).
Parallel to this is that any operation performed during an "action", if performed with the [`GITHUB_TOKEN`](https://docs.github.com/en/github-ae@latest/actions/security-guides/automatic-token-authentication) won't "trigger" any other workflows, regardless of if they are set up to only trigger on such an anticipated action, to minimise recursive workflow instantiations. The typical method to circumvent this is to utilise a "Personal Access Token" key to perform actions during a workflow that you do want to trigger another workflow, but this is looser security. All in all, both these issues with `workflow_call` and `GITHUB_TOKEN` make [GitHub Actions](https://docs.github.com/en/actions) feel very much like riding a bike with training wheels that can't be taken off.
# The "per that language's release target" processes
## CI
_Any_ push to _any_ branch, **that changes files relevant to** _some_ release target(s), should invoke a **"CI verification"** on that release.
* The steps within a **"CI verification"** can have either a _limited_ or _entire_ scope.
    * All release targets for the _entire_ scope should be included in the `jobs.<job_id>.strategy.matrix` such as;
        ```
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
## `<language>-test.yaml`
```
Example
```
## `<language>-build.yaml`
```
Example
```
# The meta-processes: `github-<metaprocess>.yaml`
## [`github-context.yaml`](https://github.com/Skenvy/Collatz/blob/main/.github/workflows/github-context.yaml)
## [`github-pages.yaml`](https://github.com/Skenvy/Collatz/blob/main/.github/workflows/github-pages.yaml)
