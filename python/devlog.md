# Devlog
The python implementation, being the first implementation worked on in this repo, ended up not being as documented in this devlog as many of the others were; the length and assortment of examples increasing for each subsequent devlog makes this one look pretty sparse and empty in comparison. So I'll come back and retroactively rewrite it. Before begining this, a [python package named `collatz` already existed on pypi](https://pypi.org/project/collatz/0.0.1/), owned by [NGeorgescu](https://github.com/NGeorgescu/collatz). Looping back to this after completing the julia implementation, I'd like to thank [NGeorgescu](https://github.com/NGeorgescu/collatz) for being generous with passing over the project name, so that this can live under the [`collatz`](https://pypi.org/project/collatz) name.
#
This is the [Python](https://www.python.org/) implementation. Python ([CPython source](https://github.com/python/cpython)), known for its [zen](https://peps.python.org/pep-0020/), uses [pip](https://pip.pypa.io/en/stable/getting-started/) to [install packages](https://packaging.python.org/en/latest/tutorials/installing-packages/), usually from those hosted on [pypi](https://pypi.org/). Virtual environments can be managed with [venv](https://docs.python.org/3/library/venv.html). We can follow the [Packaging Python Projects](https://packaging.python.org/en/latest/tutorials/packaging-projects/) for the recommended steps to start setting up (which utilises [some build tools you'll need to install](https://packaging.python.org/en/latest/guides/installing-using-linux-tools/)). Or have a look at the [developer guide](https://devguide.python.org/). Or checkout [python's list of recommended IDE's per feature](https://wiki.python.org/moin/IntegratedDevelopmentEnvironments) (we're using [Python extension for Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=ms-python.python) here). Plenty of other handy docs can be found in [Python Packaging User Guide](https://packaging.python.org/en/latest/)
* [the manifest file](https://packaging.python.org/en/latest/guides/using-manifest-in/) | [`./.pypirc`](https://packaging.python.org/en/latest/specifications/pypirc/) | [README](https://packaging.python.org/en/latest/guides/making-a-pypi-friendly-readme/)
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
Two tools for python documentation (see [PEP 257](https://peps.python.org/pep-0257/) on docstrings) can be [pydoc](https://docs.python.org/3/library/pydoc.html) ([wiki](https://en.wikipedia.org/wiki/Pydoc)), included as part of python's core lib, and [sphinx](https://www.sphinx-doc.org/en/master/) ([readthedocs](https://docs.readthedocs.io/en/stable/intro/getting-started-with-sphinx.html), [wiki](https://en.wikipedia.org/wiki/Sphinx_(documentation_generator)), [pypi](https://pypi.org/project/Sphinx/)). We can run `sphinx-quickstart` in a new `docs` folder to create the basic structure. Part of this includes a `conf.py` that can be configured according to [this](https://www.sphinx-doc.org/en/master/usage/configuration.html). We chose "Y" when asked;
```
You have two options for placing the build directory for Sphinx output.
Either, you use a directory "_build" within the root path, or you separate
"source" and "build" directories within the root path.
> Separate source and build directories (y/n) [n]: y
```
So we need to generate our docs and put then in `docs/source`, adjacent to the `index.rst`, so we can run `sphinx-apidoc -o docs/source src/`. We should then be able to run `sphinx-build docs/source docs/build` or `make html -C docs` to build the html, but we get `ERROR: Unknown directive type "automodule"`. We might need to add some [extensions](https://www.sphinx-doc.org/en/master/usage/extensions/index.html). Well, we need to `sys.path.insert(0, os.path.abspath('../../src'))` from the `conf.py` to locate the module, and use the `sphinx.ext.autodoc` extension, and set the `-W --keep-going -n` flags on `sphinx-build` (meaning "convert warnings into errors, keep going past the first one, and be nitpicky"), and we finally have the workflow yielding an error that lists all the errors in the docstrings in the source.

Now we can look at why there are a bunch of errors, for what I thought was the more common docstring format? [PEP 257 – Docstring Conventions](https://peps.python.org/pep-0257/), [this SO question](https://stackoverflow.com/questions/3898572/what-are-the-most-common-python-docstring-formats), and [this older blog](http://daouzli.com/blog/docstring.html) reveal a few things. Apparently the assumptive default for pythonic docstrings is [reStructuredText](https://www.sphinx-doc.org/en/master/usage/restructuredtext/basics.html), and I've been relying on [Google](https://github.com/google/styleguide)'s [python styleguide](https://google.github.io/styleguide/pyguide.html) for [docstrings](https://google.github.io/styleguide/pyguide.html#38-comments-and-docstrings) (or the [sphinx example](https://www.sphinx-doc.org/en/master/usage/extensions/example_google.html#example-google)). We can use the [`napoleon`](https://sphinxcontrib-napoleon.readthedocs.io/en/latest/) extension to allow us to use google style docstrings. The fix is to use the extension, `"sphinx.ext.napoleon"`, and replace all `Kwargs:` in docstrings with the [section](https://www.sphinx-doc.org/en/master/usage/extensions/napoleon.html#docstring-sections) it expects, `Keyword Args:`. We can also `.gitkeep` the `docs/source/_static` and `docs/source/_templates` to preserve the existence of these folders when running in the workflow, as their lack of existence for not having any file in them causes a warning in the workflow to error even though nothing is actually wrong.

Now we can pick a [sphinx theme](https://www.writethedocs.org/guide/tools/sphinx-themes/). I like both the [Read the Docs Theme](https://github.com/readthedocs/sphinx_rtd_theme) and the [Guzzle Theme](https://github.com/guzzle/guzzle_sphinx_theme). "Read the docs" has the edge of ubiquity, and guzzle includes a warning it might not play nicely with "readthedocs" (I _imagine_ it's refering to deploying a build using guzzle on the read the docs hosting site). It appears that [sphinx-rtd-theme's requires](https://github.com/readthedocs/sphinx_rtd_theme/blob/master/setup.cfg) a `sphinx` version less than 7. The issue on [sphinx-rtd-theme to support sphinx version 7](https://github.com/readthedocs/sphinx_rtd_theme/issues/1463) has a comment that mentions another theme that wasn't listed on the sphinx themese site, [furo](https://github.com/pradyunsg/furo). It might not be "read the docs", but to the credit of the quote in its [Used By](https://github.com/pradyunsg/furo#used-by) section, if it's got traction on `pip`, it must be pretty solid. I guess we'll try `furo`! (Turns out there's more themes [here](https://sphinx-themes.org/#themes)).

The initial appearance of the sphinx docs are pretty bare. If we look at [Furo's recommendations](https://pradyunsg.me/furo/recommendations/), one of them is [MyST](https://myst-parser.readthedocs.io/en/latest/intro.html), which is also recommended by [sphinx](https://www.sphinx-doc.org/en/master/usage/markdown.html). But in the process of trying to add anything else or edit it in anyway, sphinx is quickly becoming one of the more frustrating to work with auto-documentation tools out of this whole project. I don't want to have to learn a whole entire new file format, as debugging even simple issues that crop up requires an understanding of what's going on in the reStructuredText that the `*.rst` files are written in, and besides the effort of already having to locate some tool to extend sphinx with that advertises itself as making it possible to include markdown files, it not only doesn't fully explain how to _actually use it_ but there aren't any easy or consistant answers to find on SO for "how do I get sphinx to _actually_ do **X**", which ends up meaning, for the simple task of rendering the markdown in the `<repo-root>/python/README.md`, I've gone through about 5 or 6 different posts with several answers each suggesting that they managed to get sphinx to finally behave how they expected it to with some magic solution, but _none_ of them have worked here. I've managed to get the raw text of the file to be included, which was itself already an hour of digging around online, and every time it runs the build, myst appears to pop in a little message that doesn't really give any information about why it isn't trying to render the page. So far most of the answers have revolved around using an rst file next to the index rst file to `.. include:: ../../README.md`. At this stage, if I wasn't committed to getting it done with sphinx to have a demonstrable experience of sphinx assisted masochism, and I was actually trying to create documentation with an "easy to use" tool, I'd abandon sphinx and go use a tool that was _actually_ easy to use. That's not to say sphinx can't be powerful, or that there aren't great sites that are apparently written in sphinx.. so why is the barrier to entry high enough that trying to include a markdown file is an Achillies heel, for someone who just wants to auto gen some docs? It appears that copying the entire file and having a duplicate of it exist in here lets it properly render it, but that's a shitty expectation, to have a duplicate? Why can it not see the relative path _outside_ of the source folder. Symlinking, `ln -s ../../README.md README.md`, appears to let it work the same way. I _finally_ found a way to make it work, and it took locating [this SO answer](https://stackoverflow.com/a/69134918/9960809), althought frustraingly, the answer was apparently [in some FAQ on MyST's site](https://myst-parser.readthedocs.io/en/latest/faq/index.html#include-markdown-files-into-an-rst-file) all along, tucked out of site. [This SO answer](https://stackoverflow.com/a/48931594/9960809) gets an honourable mention, but now that we have an answer that allows us to inject the whole contents, _parsed_ of course, into the index, and it's one that _can_ accept paths to files outside of the docs source folder, we can just point to the regular readme and not worry about going via the symlink.
### Empty Orphan
We're now ready to add once again create an empty orphan branch;
1. `git checkout --orphan gh-pages-python`
1. `rm .git/index ; git clean -fdx`
1. `git commit -m "Initial empty orphan" --allow-empty`
1. `git push --set-upstream origin gh-pages-python`
