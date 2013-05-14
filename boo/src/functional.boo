namespace Sparle.Functional

valtype = typeof([])

def Encode(values as list, default as valtype):
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
        yield (run, coord, current)

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
