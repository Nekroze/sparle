namespace Sparle.Functional

def BisectLeft(values as List, index as int):
    for pos as int, val as int in enumerate(values):
        if not val < index:
            return pos-1
    return len(values)-1

def Encode(values as List, default as int, offset as int):
    output = []
    if not len(values):
        return output
    current = default
    run = 0
    coord = 0
    pos = 0
    while pos < len(values):
        while values[pos] == default:
            pos += 1
        if values[pos] != current:
            current = values[pos]
            run = 0
        coord = pos
        while values[pos] == current:
            run += 1
            pos += 1
        output.Add([run, coord+offset, current])
    return output

def Decode(sparles as List, default as int):
    if not len(sparles):
        return []
    output = []

    sparle as List = sparles[0]
    sparlev as int = sparle[1]
    if sparlev:
        output = [default] * sparlev
    else:
        output = []

    for run as int, pos as int, value as int in sparles:
        if pos > len(sparles):
            output.Extend([default] * (pos-len(output)))
        output.Extend([value] * run)
    return output

def GetSPARLEIndex(sparles as List, index as int):
    if not len(sparles):
        return null

    keys = [r[1] for r as List in sparles]
    groupindex = BisectLeft(keys, index)

    if groupindex >= len(sparles):
        groupindex -= 1
    sparle as List = sparles[groupindex]
    sparlev as int = sparle[1]
    if sparlev > index:
        groupindex -= 1
    if groupindex < 0:
        return -1
    return groupindex

def GetSPARLE(sparles as List, index as int) as List:
    groupindex = GetSPARLEIndex(sparles, index)
    if groupindex == -1:
        return null
    else:
        return sparles[groupindex]

def GetValue(sparles as List, index as int, default as int):
    sparle = GetSPARLE(sparles, index)
    run as int = sparle[0]
    pos as int = sparle[1]
    value as int = sparle[2]
    if sparle is null or index < pos or index >= pos + run:
        return default
    else:
        return value

def GetValueLength(sparles as List):
    first as List = sparles[0]
    last as List = sparles[-1]
    lastrun as int = last[0]
    lastpos as int = last[1]
    firstpos as int = first[1]
    return lastpos + lastrun - firstpos

def SetValue(sparles as List, index as int, value as int,
             default as int):
    if value == default:
        return DeleteValue(sparles, index)
    if not len(sparles):
        return sparles.Add([1, index, value])


    keys = [r[1] for r as List in sparles]
    groupindex = BisectLeft(keys, index)

    if groupindex >= len(sparles):
        groupindex -= 1

    sparle as List = sparles[groupindex]
    pos as int = sparle[1]
    if pos > index:
        groupindex -= 1

    start = groupindex
    start = groupindex-1 if groupindex > 0
    end = groupindex
    end = groupindex+1 if groupindex < len(sparles)

    values = Decode(sparles[start:end+1], default)

    sparle = sparles[start]
    groupstart as int = sparle[1]
    values[index-groupstart] = value

    sparles[start:end+1] = Encode(values, default, groupstart)

def SetValueSlice(sparles as List, values as List, default as int,
                  start as int, stop as int):
    if start < GetValueLength(sparles):
        sparlevs = Decode(sparles, default)
        sparlevs[start:stop] = values
        sparles[:] = Encode(sparlevs, default, 0)
    else:
        sparles.Extend(Encode(values, default, start))

def DeleteSPARLE(sparles as List, index as int):
    keys = [r[1] for r as List in sparles]
    groupindex = BisectLeft(keys, index)
    sparle as List = sparles[groupindex]
    pos as int = sparle[1]
    if groupindex >= len(sparles) or pos > index:
        return null
    sparles.RemoveAt(groupindex)

def DeleteValue(sparles as List, index as int):
    groupindex = GetSPARLEIndex(sparles, index)
    if groupindex is null or not len(sparles):
        return null
    sparle as List = sparles[groupindex]
    run as int = sparle[0]
    pos as int = sparle[1]
    value as int = sparle[2]

    if run <= 1:
        return DeleteSPARLE(sparles, index)
    elif pos == index:
        sparles[groupindex] = [run-1, pos+1, value]
    else:
        sparles[groupindex] = [run-1, pos, value]
