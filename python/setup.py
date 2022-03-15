import setuptools
# Because this is run via "build" and not "setup with args" it needs 'here'
# added to the path manually to be able to find 'src'
import sys, os
sys.path.append(os.path.join(os.path.dirname(os.path.abspath(__file__)), '.'))
from src.collatz import __version__


setuptools.setup(
    version=__version__,
)
