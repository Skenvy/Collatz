# Contributing
Welcome; If you'd like to contribute, firstly, thanks!
## Get the source
The _quickest_ way to get the source _without_ contributing is;
```
git clone https://github.com/Skenvy/Collatz.git
```
If you want to _contribute_ to the source, you'll need to [fork this repository](https://github.com/Skenvy/Collatz/fork), clone it, and create a development branch. Contributions should be received as pull requests from your development branch on your fork.
## Raise an issue
* [Bug Report](https://github.com/Skenvy/Collatz/issues/new?assignees=&labels=bug&template=bug-report.yaml)
* [Feature Request](https://github.com/Skenvy/Collatz/issues/new?assignees=&labels=enhancement&template=feature-request.yaml)
* [Security Vulnerability](https://github.com/Skenvy/Collatz/issues/new?assignees=&labels=security&template=security-vulnerability.yaml)
## Work on an existing issue
You may work on any existing issue, by forking this repository, creating a development branch, then adding a pull request.

Work on bugs is more likely to be accepted, if it is fixing a specific implementation doing something wrong.

Feature requests can be worked on in any or all languages, although if you are able to implement the new feature in _every_ language then it is much more likely to be approved, as the capacity for a feature to be implemented in every language will be a blocker to it being considered for addition to the set of core functionality expected for the _next_ major version.
Before a feature request will be accepted and have any of its PRs reviewed, the ease with which its introduction into the set of the _next_ major version's functionality affects the difficulty in obtaining that major version for _all_ language implementions will need to be considered.

If your feature request is meta to the language's implementation, it won't need to be evaluated in this way, although will likely fall under higher scrutiny as it would impact the overall health of the repository, depending on how obvious an improvement it makes.

## Scrutiny
Any fix or new feature should include an appropriate set of testing. This can vary stylistically between the implementations, but attempt to match the style already present. An easy comparison, for instance, is the verbosity between the java tests and the python tests. The style is not set in stone so as to be unforgiving, but it should be at least a bit obvious, although there are no linting checks or requirements at the time of writing.

The existing CICD attempts to verify the tests as well as the documentation, but the documentation test should be verified by running the local server provided for in the make recipes, to confirm nothing has altered how it will visually present this, as it is possible to pass the documentation producibility test with changes that would break the visual styling and readability, e.g. misplacing the CSS has happened. Any reviewer for a significant change should also confirm that they also run the documentation server similarly.
## Version bumping
Versions for respective projects updated from external PR's will be updated after the corresponding PR that would otherwise introducing the change that deserves a new release / version.
