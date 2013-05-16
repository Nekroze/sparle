namespace Sparle.Functional

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
        output.Add([run, position+offset, value])
        position += run
    return output

def Encode(values as List, default):
    return Encode(values, default, 0)

def Encode(values as List):
    return Encode(values, 0, 0)

def Decode(sparles as List, default):
    if not len(sparles):
        return []

    output = []
    sparle as List = sparles[0]
    pos as int = sparle[1]
    output = [default] * pos if pos > 0

    for run as int, pos as int, value in sparles:
        if pos >= len(output):
            output.Extend([default] * (pos-len(output)))
        output.Extend([value] * run)
    return output

def Decode(values as List):
    return Decode(values, 0)

def GetValue(sparles as List, index as int, default):
    for run as int, pos as int, value as int in sparles:
        if pos > index:
            return default
        elif index >= pos and index < pos + run:
            return value
    return default

def GetValue(sparles as List, index as int):
    return GetValue(sparles, index, 0)

def GetValueLength(sparles as List):
    last as List = sparles[-1]
    lastrun as int = last[0]
    lastpos as int = last[1]
    return lastpos + lastrun

def SetValue(sparles as List, index as int, value, default):
    if value == default:
        DeleteValue(sparles, index)
        return
    if not len(sparles):
        return sparles.Add([1, index, value])

    groupindex = 0
    for run as int, pos as int, value as int in sparles:
        if pos > index:
            return null
        elif index >= pos and index < pos + run:
            break
        groupindex += 1
    start = groupindex
    start = groupindex-1 if groupindex > 0
    end = groupindex
    end = groupindex+1 if groupindex < len(sparles)

    values = Decode(sparles[start:end+1], default)

    sparle as List = sparles[start]
    groupstart as int = sparle[1]
    values[index-groupstart] = value

    newer = sparles[:start] + Encode(values, default, groupstart) + sparles[end:]
    sparles.Clear()
    sparles.Extend(newer)

def SetValue(sparles as List, index as int, value):
    return SetValue(sparles, index, value, 0)

def SetValueSlice(sparles as List, values as List, start as int, stop as int,
                  default):
    length = GetValueLength(sparles)
    if stop == -1:
        stop = length-1
    if start < length:
        sparlevs = Decode(sparles, default)
        sparlevs = sparlevs[:start] + values + sparlevs[stop:]
        sparles.Clear()
        sparles.Extend(Encode(sparlevs, default, 0))
    else:
        sparles.Extend(Encode(values, default, start))

def SetValueSlice(sparles as List, values as List, start as int, stop as int):
    SetValueSlice(sparles, values, start, stop, 0)

def DeleteValue(sparles as List, index as int):
    groupindex = 0
    for run as int, pos as int, value as int in sparles:
        if pos > index:
            break
        elif index >= pos and index < pos + run:
            if run <= 1:
                sparles.RemoveAt(groupindex)
            elif pos == index:
                sparles[groupindex] = [run-1, pos+1, value]
            else:
                sparles[groupindex] = [run-1, pos, value]
            break
        groupindex += 1
