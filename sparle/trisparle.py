"""An implementation of a SPARLE array."""
__author__ = 'Taylor "Nekroze" Lawson'
__email__ = 'nekroze@eturnilnetwork.com'
from .array import Array


class TriSPARLE(list):
    """An implementation of a 3 dimensional SPARLE Array."""
    def __init__(self, width, depth, default=0):
        """
        Generate a 3d array filled with SPARLE arrays on the Y or height axis.
        """
        super(TriSPARLE, self).__init__([[Array(default=default)
                                         for _ in xrange(depth)]
                                         for _ in xrange(width)])
