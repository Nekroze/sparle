"""An implementation of a SPARLE array."""
__author__ = 'Taylor "Nekroze" Lawson'
__email__ = 'nekroze@eturnilnetwork.com'
from . import parle
try:
    from blist import blist as list
except ImportError:
    pass


class Array(object):
    """
    This is a reimplementation of a python list that utilizes Sparse Positional
    Aware Run-Length Encoding. This class can be used completely transparently.

    Behind the scenes the dynamic Array will use Run-Length Encoding to
    compress repitition of values into a single entry. The Array can also
    not store any entries of a specific value that is given as the default.
    This default will be returned when retreiving an unset index.

    By combining these the Array can space at the slight cost of performance
    especially when storing an array of highly repeating values that may have a
    single more common value. A good example of this might be a voxel
    representation of space, Much of the space may be the same values in a row
    or empty space that can be represented by the default value.
    """
    def __init__(self, values=None, default=0):
        """Encode the given values and set the default value."""
        self.sparle = list()
        self._default = default
        if values:
            parle.set_values(self.sparle, values, self._default)

    def rle_values(self):
        """Return a full slice of the underlying RLE list."""
        return self.sparle

    def get_bottom(self):
        """Return the first stored value."""
        return self.sparle[0][2]

    def get_top(self):
        """Return the first stored value."""
        return self.sparle[-1][2]

    def __getitem__(self, index):
        """Return a stored value at the given index."""
        if isinstance(index, slice):
            return [parle.get_value(self.sparle, pos, self._default)
                    for pos in xrange(*index.indices(len(self)))]
        return parle.get_value(self.sparle, index, self._default)

    def get_values(self):
        """Return all stored values in the Array instance."""
        return parle.get_values(self.sparle, self._default)

    def __setitem__(self, index, value):
        """Store the given value at the index position."""
        if isinstance(index, slice):
            for pos, val in zip(xrange(*index.indices(len(self))), value):
                print pos, val
                parle.set_value(self.sparle, pos, val, self._default)
            return None
        else:
            return parle.set_value(self.sparle, index, value, self._default)

    def set_values(self, values):
        """Erase the Array then encode and store all values."""
        return parle.set_values(self.sparle, values, self._default)

    def __delitem__(self, index):
        """Delete the single value at the given index."""
        return parle.delete_value(self.sparle, index)

    def __len__(self):
        """Return the length of defined values."""
        return self.sparle[-1][1] + self.sparle[-1][0] - self.sparle[0][1]

    def __contains__(self, value):
        """Return True if the Array contains the given value."""
        return value in [r[2] for r in self.sparle]

    def __iter__(self):
        """Iterate over each value and its index."""
        return (((relv[2], relv[1] + pos)
                 for pos in xrange(relv[0])) for relv in self.sparle)

    def __reversed__(self):
        """Iterate in reverse over each value and its index."""
        return (((relv[2], relv[1] + relv[0] - pos)
                 for pos in xrange(relv[0])) for relv in self.sparle[::-1])
