"""An implementation of a PARLE."""
__author__ = 'Taylor "Nekroze" Lawson'
__email__ = 'nekroze@eturnilnetwork.com'
from itertools import groupby
from bisect import bisect_left
try:
    from blist import blist as list
except ImportError:
    pass


def encode(values, offset=0):
    """Run-Length Encode the given values with offset."""
    groups = groupby(values)
    encoded = list()
    position = 0
    for name, group in groups:
        length = len(list(group))
        encoded.append((length, position + offset, name))
        position += length
    return encoded


def get_value(rles, index, default):
    """Return a stored value at the given index."""
    rlev = get_rle(rles, index)
    return default if not rlev else rlev[2]


def get_values(rles, default):
    """Return all stored values in the Array instance."""
    output = list()
    if rles[0][1]:
        output.append(default)
        output *= rles[0][1]

    for length, pos, value in rles:
        if pos >= len(output):
            temp = list([default])
            temp *= pos - len(output)
            output.extend(temp)

        temp = list([value])
        temp *= length
        output.extend(temp)
    return output


def get_rle(rles, index):
    """Get the RLE field that contains the given index else None."""
    groupindex = get_rle_index(rles, index)
    return None if groupindex is None else rles[groupindex]


def get_rle_index(rles, index):
    """Get the index of the RLE field that contians the given index."""
    if not len(rles):
        return None
    keys = [r[1] for r in rles]
    groupindex = bisect_left(keys, index)
    if groupindex >= len(rles):
        return None
    if rles[groupindex][1] > index:
        groupindex -= 1
    if groupindex < 0:
        return None
    return groupindex


def set_value(rles, index, value, default):
    """Store the given value at the index position."""
    if value == default:
        return delete_value(rles, index)
    if not len(rles):
        return rles.append((1, index, value))

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

    rles[start:end + 1] = encode(values, offset=groupstart)


def set_values(rles, values, default):
    """Erase the Array then encode and store all values."""
    del rles[:]
    groups = groupby(values)
    position = 0
    for value, group in groups:
        if value == default:
            continue
        length = len(list(group))
        rles.append((length, position, value))
        position += length


def delete_rle(rles, index):
    """Delete the RLE field that contains the given index."""
    keys = [r[1] for r in rles]
    group = bisect_left(keys, index)
    if group >= len(rles) or rles[group][1] > index:
        return None
    del rles[group]


def delete_value(rles, index):
    """Delete the single value at the given index."""
    groupindex = get_rle_index(rles, index)
    if groupindex is None or not rles:
        return None
    rlev = rles[groupindex]

    if rlev[0] <= 1:
        return delete_rle(rles, index)
    elif rlev[1] == index:
        rles[groupindex] = (rlev[0]-1, rlev[1]+1, rlev[2])
    else:
        rles[groupindex] = (rlev[0]-1, rlev[1], rlev[2])
