# Devlog
The python implementation, being the first implementation worked on in this repo, ended up not being as documented in this devlog as many of the others were; the length and assortment of examples increasing for each subsequent devlog makes this one look pretty sparse and empty in comparison. So I'll come back and retroactively rewrite it. Before begining this, a [python package named `collatz` already existed on pypi](https://pypi.org/project/collatz/0.0.1/), owned by [NGeorgescu](https://github.com/NGeorgescu/collatz). Looping back to this after completing the julia implementation, I'd like to thank [NGeorgescu](https://github.com/NGeorgescu/collatz) for being generous with passing over the project name, so that this can live under the [`collatz`](https://pypi.org/project/collatz) name.
#
This is the [Python](https://www.python.org/) implementation. Python ([CPython source](https://github.com/python/cpython)), known for its [zen](https://peps.python.org/pep-0020/), uses [pip](https://pip.pypa.io/en/stable/getting-started/) to [install packages](https://packaging.python.org/en/latest/tutorials/installing-packages/), usually from those hosted on [pypi](https://pypi.org/). Virtual environments can be managed with [venv](https://docs.python.org/3/library/venv.html). We can follow the [Packaging Python Projects](https://packaging.python.org/en/latest/tutorials/packaging-projects/) for the recommended steps to start setting up (which utilises [some build tools you'll need to install](https://packaging.python.org/en/latest/guides/installing-using-linux-tools/)). Or have a look at the [developer guide](https://devguide.python.org/). Or checkout [python's list of recommended IDE's per feature](https://wiki.python.org/moin/IntegratedDevelopmentEnvironments) (we're using [Python extension for Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=ms-python.python) here). Plenty of other handy docs can be found in [Python Packaging User Guide](https://packaging.python.org/en/latest/)
* [the manifest file](https://packaging.python.org/en/latest/guides/using-manifest-in/) | [`./.pypirc`](https://packaging.python.org/en/latest/specifications/pypirc/)
* [set up testing with pytest](https://docs.pytest.org/en/7.1.x/getting-started.html#get-started)
* [the recommended github actions](https://packaging.python.org/en/latest/guides/publishing-package-distribution-releases-using-github-actions-ci-cd-workflows/) | [pypa on github](https://github.com/pypa) | [`pypa/gh-action-pypi-publish` action](https://github.com/pypa/gh-action-pypi-publish)
* [the actual recommendation on aligning the readme with pypi's expectations for it](https://packaging.python.org/en/latest/guides/making-a-pypi-friendly-readme/)
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
## Linting
We can lint with [pylama](https://github.com/klen/pylama), which wraps multiple other linters. Re can generate pylint rc file with `pylint --generate-rcfile > .pylintrc`. For more details on configuring pylint see [this SO answer](https://stackoverflow.com/a/70110825/9960809). Configuring pyflakes is annoying. It reports;
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
