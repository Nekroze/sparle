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
    def __init__(self, default):
        self._default = default
        super(Array, self).__init__()

    def rle_values(self):
        return self[:]

    def get_value(self, index):
        return self.get_rle(index)[2]

    def get_values(self):
        output = list()
        if self[:][0][1]:
            output.append(self._default)
            output *= self[:][0][1]

        for length, pos, value in self[:]:
            if pos >= len(output):
                temp = list([self._default])
                temp *= pos - len(output)
                output.extend(temp)

            temp = list([value])
            temp *= length
            output.extend(temp)
        return output

    def get_rle(self, index):
        if not len(self):
            return self._default
        rles = self.rle_values()

        keys = [r[1] for r in rles]
        groupindex = bisect_left(keys, index)
        if groupindex >= len(self) or rles[groupindex][1] > index:
            return self._default
        return rles[groupindex]

    def set_value(self, index, value):
        if value == self._default:
            return None
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
                      rles[start:end+1]], list())
        groupstart = rles[start][1]
        values[index - groupstart] = value

        encoded = rle.encode(values, offset=groupstart)
        rles[start:end + 1] = encoded

    def set_values(self, values):
        self[:] = []
        groups = groupby(values)
        position = 0
        for value, group in groups:
            if value == self._default:
                continue
            length = len(list(group))
            self.append((length, position, value))
            position += length

    def delete_rle(self, index):
        rles = self.rle_values()

        keys = [r[1] for r in rles]
        group = bisect_left(keys, index)
        if group >= len(rles) or rles[group][1] > index:
            return None
        super(Array, self).__delitem__(group)

    def delete_value(self, index):
        rlev = self.get_rle(index)
        if rlev is None:
            return None

        if rlev[0] <= 1:
            return self.delete_rle(index)
        elif rlev[1] == index:
            rlev[1] += 1
        rlev[0] -= 1
