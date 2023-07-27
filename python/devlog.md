# Devlog
The python implementation, being the first implementation worked on in this repo, ended up not being as documented in this devlog as many of the others were; the length and assortment of examples increasing for each subsequent devlog makes this one look pretty sparse and empty in comparison. So I'll come back and retroactively rewrite it. Before begining this, a [python package named `collatz` already existed on pypi](https://pypi.org/project/collatz/0.0.1/), owned by [NGeorgescu](https://github.com/NGeorgescu/collatz). Looping back to this after completing the julia implementation, I'd like to thank [NGeorgescu](https://github.com/NGeorgescu/collatz) for being generous with passing over the project name, so that this can live under the [`collatz`](https://pypi.org/project/collatz) name.
#
This is the [Python](https://www.python.org/) implementation. Python ([CPython source](https://github.com/python/cpython)), known for its [zen](https://peps.python.org/pep-0020/), uses [pip](https://pip.pypa.io/en/stable/getting-started/) to [install packages](https://packaging.python.org/en/latest/tutorials/installing-packages/), usually from those hosted on [pypi](https://pypi.org/). Virtual environments can be managed with [venv](https://docs.python.org/3/library/venv.html). We can follow the [Packaging Python Projects](https://packaging.python.org/en/latest/tutorials/packaging-projects/) for the recommended steps to start setting up (which utilises [some build tools you'll need to install](https://packaging.python.org/en/latest/guides/installing-using-linux-tools/)). Or have a look at the [developer guide](https://devguide.python.org/). Or checkout [python's list of recommended IDE's per feature](https://wiki.python.org/moin/IntegratedDevelopmentEnvironments) (we're using [Python extension for Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=ms-python.python) here). Plenty of other handy docs can be found in [Python Packaging User Guide](https://packaging.python.org/en/latest/)
* [the manifest file](https://packaging.python.org/en/latest/guides/using-manifest-in/) | [`./.pypirc`](https://packaging.python.org/en/latest/specifications/pypirc/)
* [set up testing with pytest](https://docs.pytest.org/en/7.1.x/getting-started.html#get-started)
* [the recommended github actions](https://packaging.python.org/en/latest/guides/publishing-package-distribution-releases-using-github-actions-ci-cd-workflows/) | [pypa on github](https://github.com/pypa) | [`pypa/gh-action-pypi-publish` action](https://github.com/pypa/gh-action-pypi-publish)
* [the actual recommendation on aligning the readme with pypi's expectations for it](https://packaging.python.org/en/latest/guides/making-a-pypi-friendly-readme/)

Our [packaging process](https://packaging.python.org/en/latest/tutorials/packaging-projects/) here is to use [build](https://packaging.python.org/en/latest/key_projects/#build) ([PEP 517](https://peps.python.org/pep-0517/)) to wrap [setuptools](https://packaging.python.org/en/latest/key_projects/#easy-install), to create the [wheel](https://packaging.python.org/en/latest/key_projects/#wheel) that can be published with [twine](https://packaging.python.org/en/latest/key_projects/#twine). There are a number of different ways to get to the same end result of a python package that can be uploaded to pypi, and ours is;
1. `python -m build`
1. [Build](https://pypa-build.readthedocs.io/en/latest/) uses `./.pyproject.toml`
1. `./.pyproject.toml`'s `[build-system]` specifies a `build-backend`
1. Ours is `build-backend = "setuptools.build_meta"` (see [setuptools' build_meta](https://setuptools.pypa.io/en/latest/build_meta.html))
1. [Setuptools](https://setuptools.pypa.io/en/latest/), using [`./.pyproject.toml`](https://setuptools.pypa.io/en/latest/userguide/pyproject_config.html), runs a [./setup.py](https://setuptools.pypa.io/en/latest/userguide/quickstart.html) if present, which also uses [`./setup.cfg`](https://setuptools.pypa.io/en/latest/userguide/declarative_config.html)
    1. Although `./setup.py` is now recommended against, in favour of just `./setup.cfg`, it's the easiest dynamic entry, i.e. to use a `__version__.py` file to specify the version. (Although it looks like something similar can be done in `./setup.cfg` with something like `version = attr: my_package.VERSION`)
1. This creates the source distribution and [wheel](https://wheel.readthedocs.io/en/latest/) ([PEP 427](https://peps.python.org/pep-0427/)).
1. We then can use [twine](https://twine.readthedocs.io/en/latest/) to publish the source.
    1. We _actually_ use a GitHub action to upload the build from a workflow; [pypa/gh-action-pypi-publish](https://github.com/pypa/gh-action-pypi-publish). Twine recipes that do the same thing are in the `./Makefile`, but this is a [`pypa`](https://github.com/pypa) maintained action to make it easier, rather than proctoring the existence of the necessary `./.pypirc` file on the runner.
## `./.pypirc` example
```
[distutils]
index-servers =
    pypi
    testpypi

[pypi]
  username = __token__
  password = <pypi-token>

[testpypi]
  username = __token__
  password = <test-pypi-token>
```
## "Local" version vs primary version used on GH runner.
My `python --version` is `3.8.10` locally, and picking a version you know you're using as the one to run things in in the pipelines can be helpful in minimising the potential for unforeseeable issues, but [this](https://raw.githubusercontent.com/actions/python-versions/main/versions-manifest.json) is a list of python versions the installer action can accept. `3.8.10` doesn't have an ubuntu `22.04` release. The closest version available to the runner is `3.8.12`.
## Linting
We can lint with [pylama](https://github.com/klen/pylama), which wraps multiple other linters. Re can generate pylint rc file with `pylint --generate-rcfile > .pylintrc`. For more details on configuring pylint see [this SO answer](https://stackoverflow.com/a/70110825/9960809) ([pylint docs](https://docs.pylint.org/), [codes](https://docs.pylint.org/features.html) and [pylintrc](https://github.com/pylint-dev/pylint/blob/main/pylintrc)). Configuring pyflakes is annoying. It reports;
```
src/collatz/__init__.py:2:1 W0611 '.parameterised._KNOWN_CYCLES' imported but unused [pyflakes]
src/collatz/__init__.py:3:1 W0611 '.parameterised.__VERIFIED_MAXIMUM' imported but unused [pyflakes]
src/collatz/__init__.py:4:1 W0611 '.parameterised.__VERIFIED_MINIMUM' imported but unused [pyflakes]
src/collatz/__init__.py:5:1 W0611 '.parameterised._ErrMsg' imported but unused [pyflakes]
src/collatz/__init__.py:6:1 W0611 '.parameterised._CC' imported but unused [pyflakes]
```
but neither configuring it in `pylama.ini` with;
```ini
[pylama:src/collatz/__init__.py]
ignore = W0401,W0611
```
Or in a `pyflakes.ini` with;
```ini
[pyflakes]
per-file-ignores =
    # imported but unused
    src/collatz/__init__.py: W0611

```
is dismissing these errors, and any googling for how to ignore specific erros in pyflakes suggest to either swap to flake8, a tool not listed on pylama's supported wraps, or to implement your own patch to ignore. We could "`  # NOWQA`" all the offending lines on the file but the `src/collatz/__init__.py: W0611` is the only complain the pyflakes is having, so we may as well just not run pyflakes, even thought pyflakes seemed to be the only linter to complain about unused imports, it seems a shame to have to get rid of it.
We also seem to not be able to configure pycodestyle to ignore an error code. It seems like only pylint is getting configuration passed to it from pylama. Maybe it would be easiest sto swap to us pylint and flake8 together rather than pylama.
## [Documentation](https://wiki.python.org/moin/DocumentationTools)
Two tools for python documentation can be [pydoc](https://docs.python.org/3/library/pydoc.html) ([wiki](https://en.wikipedia.org/wiki/Pydoc)), included as part of python's core lib, and [sphinx](https://www.sphinx-doc.org/en/master/) ([readthedocs](https://docs.readthedocs.io/en/stable/intro/getting-started-with-sphinx.html), [wiki](https://en.wikipedia.org/wiki/Sphinx_(documentation_generator)), [pypi](https://pypi.org/project/Sphinx/)). We can run `sphinx-quickstart` in a new `docs` folder to create the basic structure. Part of this includes a `conf.py` that can be configured according to [this](https://www.sphinx-doc.org/en/master/usage/configuration.html).