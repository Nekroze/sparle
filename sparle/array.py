"""An implementation of a SPARLE array."""
__author__ = 'Taylor "Nekroze" Lawson'
__email__ = 'nekroze@eturnilnetwork.com'
from itertools import groupby
from bisect import bisect_left
from . import rle
try:
    from blist import blist as list
except ImportError:
    pass


class Array(list):
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
        super(Array, self).__init__()
        self._default = default
        if values:
            self.set_values(values)

    def rle_values(self):
        """Return a full slice of the underlying RLE list."""
        return list(self)

    def get_bottom(self):
        """Return the first stored value."""
        return self.rle_values()[0][2]

    def get_top(self):
        """Return the first stored value."""
        return self.rle_values()[-1][2]

    def get_value(self, index):
        """Return a stored value at the given index."""
        rlev = self.get_rle(index)
        return self._default if not rlev else rlev[2]
    __getitem__ = get_value

    def get_values(self):
        """Return all stored values in the Array instance."""
        output = list()
        if self.rle_values()[0][1]:
            output.append(self._default)
            output *= self.rle_values()[0][1]

        for length, pos, value in self.rle_values():
            if pos >= len(output):
                temp = list([self._default])
                temp *= pos - len(output)
                output.extend(temp)

            temp = list([value])
            temp *= length
            output.extend(temp)
        return output

    def get_rle(self, index):
        """Get the RLE field that contains the given index else None."""
        groupindex = self.get_rle_index(index)
        return None if groupindex is None else self.rle_values()[groupindex]

    def get_rle_index(self, index):
        """Get the index of the RLE field that contians the given index."""
        if not len(self):
            return None
        rles = self.rle_values()

        keys = [r[1] for r in rles]
        groupindex = bisect_left(keys, index)
        if groupindex >= len(self):
            return None
        if rles[groupindex][1] > index:
            groupindex -= 1
        if groupindex < 0:
            return None
        return groupindex

    def set_value(self, index, value):
        """Store the given value at the index position."""
        if value == self._default:
            return self.delete_value(index)
        if not len(self):
            return self.append((1, index, value))
        rles = self.rle_values()

        keys = [r[1] for r in rles]
        group = bisect_left(keys, index)
        if group >= len(rles):
            group -= 1
        if rles[group][1] > index:
            group -= 1

        start = group - 1 if group > 0 else group
        end = group + 1 if group < len(rles) else group

        values = sum([length * [item] for length, _, item in
                      rles[start:end+1]], [])
        groupstart = rles[start][1]
        values[index - groupstart] = value

        encoded = rle.encode(values, offset=groupstart)
        rles[start:end + 1] = encoded

    def set_values(self, values):
        """Erase the Array then encode and store all values."""
        del self[:]
        groups = groupby(values)
        position = 0
        for value, group in groups:
            if value == self._default:
                continue
            length = len(list(group))
            self.append((length, position, value))
            position += length
    __setitem__ = set_value

    def delete_rle(self, index):
        """Delete the RLE field that contains the given index."""
        rles = self.rle_values()

        keys = [r[1] for r in rles]
        group = bisect_left(keys, index)
        if group >= len(rles) or rles[group][1] > index:
            return None
        super(Array, self).__delitem__(group)

    def delete_value(self, index):
        """Delete the single value at the given index."""
        groupindex = self.get_rle_index(index)
        if groupindex is None or not self:
            return None
        rlev = super(Array, self).__getitem__(groupindex)

        if rlev[0] <= 1:
            return self.delete_rle(index)
        elif rlev[1] == index:
            super(Array, self).__setitem__(groupindex,
                                           (rlev[0]-1, rlev[1]+1, rlev[2]))
        else:
            super(Array, self).__setitem__(groupindex,
                                           (rlev[0]-1, rlev[1], rlev[2]))
    __delitem__ = delete_value

    def __contains__(self, value):
        """Return True if the Array contains the given value."""
        return value in [r[2] for r in self.rle_values()]

    def __getslice__(self, start, stop):
        """Return a slice of decoded values between start and stop."""
        return self.get_values()[start:stop]

    def __setslice__(self, start, stop, sequence):
        """Set a slice of decoded values between start and stop."""
        for pos, value in zip(xrange(start, stop), sequence):
            self.set_value(pos, value)
