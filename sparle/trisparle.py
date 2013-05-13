"""An implementation of a SPARLE array."""
__author__ = 'Taylor "Nekroze" Lawson'
__email__ = 'nekroze@eturnilnetwork.com'
from .array import Array
import itertools


class TriSPARLE(list):
    """An implementation of a 3 dimensional SPARLE Array."""
    def __init__(self, width, depth, default=0, loadstring=None):
        """
        Generate a 3d array filled with SPARLE arrays on the Y or height axis.
        """
        super(TriSPARLE, self).__init__([[Array(default=default)
                                         for _ in xrange(depth)]
                                         for _ in xrange(width)])
        if Values is not None:
            self.load_from_string(loadstring)

    def load_from_string(self, string):
        """Reconstruct a TriSPARLE from a TriSPARLE string representation."""
        for data, sparle in izip(
                (dataz for datax in eval(string) for dataz in datax),
                (selfz for selfx in self for selfz in selfx)):
            sparle.set_rles(data)
