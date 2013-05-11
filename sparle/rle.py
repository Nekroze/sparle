"""An implementation of a PARLE."""
__author__ = 'Taylor "Nekroze" Lawson'
__email__ = 'nekroze@eturnilnetwork.com'
from itertools import groupby
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
