"""An implementation of a N dimensional SPARLE array."""
__author__ = 'Taylor "Nekroze" Lawson'
__email__ = 'nekroze@eturnilnetwork.com'
from .array import Array
import numpy as np


DTSPARLE = np.dtype(Array)


def nd_sparle(width, depth, default=0, loadstring=None):
    """
    Generate an N dimensional array filled with SPARLE arrays on the Y or
    height axis.
    """
    sparle = np.empty((width, depth), dtype=DTSPARLE)
    for (posx, posy), _ in np.ndenumerate(sparle):
        sparle[posx][posy] = Array(default=default)
    if loadstring:
        load_from_string(sparle, loadstring)
    return sparle


def save_to_string(ndsparle):
    """Return a loadable string representing the given N dimensional SPARLE."""
    return str(ndsparle.tolist)


def load_from_string(ndsparle, string):
    """Reconstruct an ndSPARLE from a string representation."""
    data = eval(string)
    for (posx, posy), array in np.ndenumerate(ndsparle):
        array.set_rles(data[posx][posy])
