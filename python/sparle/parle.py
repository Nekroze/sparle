"""An implementation of a PARLE."""
__author__ = 'Taylor "Nekroze" Lawson'
__email__ = 'nekroze@eturnilnetwork.com'
from itertools import groupby


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
    for run, pos, value in rles:
        if pos > index:
            return None
        elif index >= pos and index < pos + run:
            break
        groupindex += 1

    start = groupindex - 1 if groupindex > 0 else groupindex
    end = groupindex + 1 if groupindex < len(rles) else groupindex

    values = sum([length * [item] for length, _, item in
                  rles[start:end+1]], [])
    groupstart = rles[start][1]
    values[index - groupstart] = value

    rles[start:end + 1] = encode(values, default, groupstart)


def set_values(rles, values, default):
    """Erase the Array then encode and store all values."""
    rles[:] = encode(values, default)


def delete_value(sparles, index):
    """Delete the single value at the given index."""
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
