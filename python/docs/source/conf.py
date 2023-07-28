# Configuration file for the Sphinx documentation builder.
#
# For the full list of built-in configuration values, see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

# -- Path setup --------------------------------------------------------------

import os, sys
sys.path.insert(0, os.path.abspath('../../src'))

# -- Project information -----------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#project-information

project = 'Collatz'
copyright = '2023, Nathan Levett'
author = 'Nathan Levett'

# -- General configuration ---------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#general-configuration

# https://www.sphinx-doc.org/en/master/usage/extensions/index.html
extensions = [
    "sphinx.ext.autodoc",  # Include documentation from docstrings
    "sphinx.ext.napoleon",  # Support for NumPy and Google style docstrings
    # "sphinx.ext.autosectionlabel",  # Allow reference sections using its title
    # "sphinx.ext.autosummary",  # Generate autodoc summaries
    # "sphinx.ext.coverage",  # Collect doc coverage stats
    # "sphinx.ext.doctest",  # Test snippets in the documentation
    # "sphinx.ext.duration",  # Measure durations of Sphinx processing
    # "sphinx.ext.extlinks",  # Markup to shorten external links
    "sphinx.ext.githubpages",  # Publish HTML docs in GitHub Pages
    # "sphinx.ext.graphviz",  # Add Graphviz graphs
    # "sphinx.ext.ifconfig",  # Include content based on configuration
    # "sphinx.ext.imgconverter",  # A reference image converter using Imagemagick
    # "sphinx.ext.inheritance_diagram",  # Include inheritance diagrams
    # "sphinx.ext.intersphinx",  # Link to other projects’ documentation
    # "sphinx.ext.linkcode",  # Add external links to source code Math support for HTML outputs in Sphinx
    # "sphinx.ext.todo",  # Support for todo items
    "sphinx.ext.viewcode",  # Add links to highlighted source code
    # Non sphinx included extenstions;
    "myst_parser",  # https://myst-parser.readthedocs.io/en/latest/intro.html
]

templates_path = ['_templates']
exclude_patterns = []

# https://www.sphinx-doc.org/en/master/usage/configuration.html#confval-source_suffix
source_suffix = {
    '.rst': 'restructuredtext',
    '.md': 'markdown',
}

# -- Options for HTML output -------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#options-for-html-output

html_theme = 'furo'
html_static_path = ['_static']
html_theme_options = {
    "source_repository": "https://github.com/Skenvy/Collatz/",
    "source_branch": "gh-pages-python",
    "source_directory": "python/",
}
