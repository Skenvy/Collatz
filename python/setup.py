import setuptools


# Get the version
import sys, os
sys.path.append(os.path.join(os.path.dirname(os.path.abspath(__file__)), 'src/'))
from collatz import __version__ as __version__


setuptools.setup(
    version=__version__,
)
