namespace Sparle.Functional

valtype = typeof(0)
postype = typeof(1L)

def BisectLeft(values as list, index as postype):
    for pos, val in enumerate(values):
        elif not val < index:
            return pos-1
    return len(values)-1

def Encode(values as list, default as valtype, offset as postype = 0):
    if not len(values):
        return []
    current = default
    run = 0
    coord = 0
    pos = 0
    while pos < len(values):
        while values[pos] == default:
            pos += 1
        if val != current:
            current = values[pos]
            run = 0
        coord = pos
        while values[pos] == curent:
            run += 1
            pos += 1
        yield [run, coord+offset, current]

def Decode(sparles as list, default as valtype):
    if not len(sparles):
        return []
    output = []

    if sparles[0][1]:
        output = [default] * sparles[0][1]
    else:
        output = []

    for run, pos, value in sparles:
        if pos > len(sparles)
            output.Extend([default] * (pos-len(output)))
        output.extend([value] * run)
    return output

def GetSPARLEIndex(sparles as list, index as postype):
    if not len(sparles):
        return null

    keys = [r[1] for r in sparles]
    groupindex = BisectLeft(keys, index)

    if groupindex >= len(sparles):
        groupindex -= 1
    if sparles[groupindex][1] > index:
        groupindex -= 1
    if groupindex < 0:
        return null
    return groupindex

def GetSPARLE(sparles as list, index as postype) as valtype:
    groupindex = GetSPARLEIndex(sparles, index)
    return null if groupindex is None else sparles[groupindex]

def GetValue(sparles as list, index as postype, default as valtype):
    sparle = GetSPARLE(sparles, index)
    if sparle is null or index < sparle[1] or index >= sparle[1] + sparle[0]:
        return default
    else:
        return rlev[2]

def GetValueLength(sparles as list):
    return sparles[-1][1] + sparles[-1][0]-1

def SetValue(sparles as list, index as postype, value as valtype,
             default as valtype):
    if value == default:
        return delete_value(sparles, index)
    if not len(sparles):
        return sparles.append([1, index, value])


    keys = [r[1] for r in sparles]
    groupindex = BisectLeft(keys, index)

    if groupindex >= len(sparles):
        groupindex -= 1
    if sparles[groupindex][1] > index:
        groupindex -= 1

    start = groupindex-1 if groupindex > 0 else groupindex
    end = groupindex+1 if groupindex < len(sparles) else groupindex

    values = Decode(sparles[start:end+1], default)

    groupstart = sparles[start][1]
    values[index-groupstart] = value

    sparles[start:end+1] = encode(values, default, groupstart)

def SetValueSlice(sparles as list, values as list, default as valtype,
                  start as postype, stop as postype):
    if start < GetValueLength(sparles):
        sparlevs = Decode(sparles, default)
        sparlevs[start:stop] = values
        sparles[:] = Encode(sparlevs, default)
    else:
        sparles.Extend(Encode(values, default, start))

def DeleteSPARLE(sparles as list, index as postype):
    keys = [r[1] for r in sparles]
    groupindex = BisectLeft(keys, index)
    if groupindex >= len(sparles) or sparles[groupindex][1] > index:
        return null
    def sparles[groupindex]

def DeleteValue(sparles as list, index as postype):
    groupindex = GetSPARLEIndex(sparles, index)
    if groupindex is null or not len(sparles):
        return null
    sparle = sparles[groupindex]

    if sparle[0] <= 1:
        return DeleteSPARLE(sparles, index)
    elif sparle[1] == index:
        sparles[groupindex] = [sparle[0]-1, sparle[1]+1, sparle[2]]
    else:
        sparles[groupindex] = [sparle[0]-1, sparle[1], sparle[2]]
