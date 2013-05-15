namespace Sparle.Functional

def BisectLeft(values as List, index as int):
    for pos as int, val as int in enumerate(values):
        if not val < index:
            return pos-1
    return len(values)-1

def Group(values as List):
    val = values[0]
    run = 0
    for value in values:
        if value == val:
            run += 1
        else:
            yield [val, run]
            val = value
            run = 1
    yield [val, run]

def Encode(values as List, default as int, offset as int):
    output = []
    position = 0
    for value, run as int in Group(values):
        if value == default:
            position += run
            continue
        output.Add([run, position, value])
        position += run
    return output

def Encode(values as List, default as int):
    return Encode(values, default, 0)

def Decode(sparles as List, default as int):
    if not len(sparles):
        return []
    output = []

    sparle as List = sparles[0]
    pos as int = sparle[1]
    if pos:
        output = [default] * pos
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
    pos as int = sparle[1]
    if pos > index:
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
    value = sparle[2]
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

    newer = sparles[:start] + Encode(values, default, groupstart) + sparles[end:]
    sparles.Clear()
    sparles.Extend(newer)

def SetValueSlice(sparles as List, values as List, default as int,
                  start as int, stop as int):
    if start < GetValueLength(sparles):
        sparlevs = Decode(sparles, default)
        sparlevs = sparlevs[:start] + values + sparlevs[stop:]
        sparles.Clear()
        sparles.Extend(Encode(sparlevs, default, 0))
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
    value = sparle[2]

    if run <= 1:
        return DeleteSPARLE(sparles, index)
    elif pos == index:
        sparles[groupindex] = [run-1, pos+1, value]
    else:
        sparles[groupindex] = [run-1, pos, value]
