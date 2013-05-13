"""An implementation of a N dimensional SPARLE array."""
__author__ = 'Taylor "Nekroze" Lawson'
__email__ = 'nekroze@eturnilnetwork.com'
from .array import Array
try:
    import numpy as np
except ImportError:
    import numpypy as np


dsparle = np.dtype(Array)


def nd_sparle(width, depth, default=0, loadstring=None):
    """
    Generate an N dimensional array filled with SPARLE arrays on the Y or
    height axis.
    """
    sparle = np.empty((width, depth), dtype=dsparle)
    for (posx, posy), _ in np.ndenumerate(sparle):
        sparle[posx][posy] = Array(default=default)
    if loadstring:
        load_from_string(sparle, loadstring)
    return sparle


def load_from_string(sparle, string):
    """Reconstruct an ndSPARLE from a string representation."""
    data = eval(string)
    for (posx, posy), array in np.ndenumerate(sparle):
        array.set_rles(data[posx][posy])
