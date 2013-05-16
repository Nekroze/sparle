"""An implementation of a PARLE."""
__author__ = 'Taylor "Nekroze" Lawson'
__email__ = 'nekroze@eturnilnetwork.com'
from itertools import groupby
from bisect import bisect_left, bisect_right


def encode(values, default=0, offset=0,):
    """Run-Length Encode the given values with offset."""
    groups = groupby(values)
    encoded = list()
    position = 0
    for name, group in groups:
        if name == default:
            continue
        length = len(list(group))
        encoded.append((length, position + offset, name))
        position += length
    return encoded


def decode(rles, default):
    """Return all stored values in the RLE's."""
    if not rles:
        return []
    output = list()
    if rles[0][1]:
        output.append(default)
        output *= rles[0][1]

    for length, pos, value in rles:
        if pos > len(output):
            output.extend([default] * (pos-len(output)))
        output.extend([value] * length)
    return output


def get_value(rles, index, default):
    """Return a stored value at the given index."""
    for run, pos, value in rles:
        if pos > index:
            return default
        if pos <= index < pos+run:
            return value
    return default


def get_value_length(rles):
    """Return the length of values defined in the given RLE's."""
    return rles[-1][1] + rles[-1][0]


def get_value_slice(rles, default, start, stop, step):
    """Return a slice of the given parle array."""
    if step is None:
        step = 1
    end = rles[-1][1] + rles[-1][0]-1
    begin = rles[0][1]
    if not len(rles):
        return [default] * (stop-start)
    elif start is None and stop is None:
        return decode(rles, default)[::step]

    if start is None:
        start = 0
    if stop is None:
        stop = get_value_length(rles)

    sliceend = stop
    slicebegin = start
    if end > stop:
        sliceend = stop
    elif begin < start:
        slicebegin = start

    keys = [r[1] for r in rles]
    groupstop = bisect_left(keys, sliceend) - 1
    groupstart = bisect_right(keys, slicebegin) + 1

    startrlev = get_rle(rles, slicebegin)
    stoprlev = get_rle(rles, sliceend)
    midrles = rles[groupstart:groupstop]

    first = [startrlev[2]] * (startrlev[0] - (slicebegin - startrlev[1])) \
        if startrlev else [default] * (rles[groupstart][1] - slicebegin)
    if start < slicebegin:
        first = [default] * (slicebegin-start) + first

    mid = [] if not midrles else decode(midrles, default)

    last = [stoprlev[2]] * (sliceend - stoprlev[1]) \
        if stoprlev else [default] * (sliceend - rles[groupstop][1])
    if stop > sliceend:
        last = last + ([default] * (stop - sliceend))
    return (first + mid + last) if step == 1 else (first + mid + last)[::step]


def set_value_slice(rles, values, default, start, stop):
    """Set a slice of values."""
    length = get_value_length(rles)
    if stop == -1:
        stop = length-1
    if start < length:
        rlevs = decode(rles, default)
        rlevs[start:stop] = values
        rles[:] = encode(rlevs, default)
    else:
        rles.extend(encode(values, default, start))


def set_value(rles, index, value, default):
    """Store the given value at the index position."""
    if value == default:
        return delete_value(rles, index)
    if not len(rles):
        return rles.append((1, index, value))

    groupindex = 0
    for run, pos, value in sparles:
        if pos > index:
            return None
        elif index >= pos and index < pos + run:
            break
        groupindex += 1

    start = group - 1 if group > 0 else group
    end = group + 1 if group < len(rles) else group

    values = sum([length * [item] for length, _, item in
                  rles[start:end+1]], [])
    groupstart = rles[start][1]
    values[index - groupstart] = value

    rles[start:end + 1] = encode(values, default, groupstart)


def set_values(rles, values, default):
    """Erase the Array then encode and store all values."""
    rles[:] = encode(values, default)


def delete_value(sparles, index):
    groupindex = 0
    for run, pos, value in sparles:
        if pos > index:
            break
        elif pos <= index < pos+run:
            if run <= 1:
                del sparles[groupindex]
            elif pos == index:
                sparles[groupindex] = [run-1, pos+1, value]
            else:
                sparles[groupindex] = [run-1, pos, value]
            break
        groupindex += 1
