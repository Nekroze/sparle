namespace Sparle.SparleList

class SparleList:
    _sparles as List
    _default as object

    def constructor(values as List, default):
        _sparles = Sparle.Functional.Encode(values, default)
        _default = default

    def constructor(default as object):
        _sparles = List()
        _default = default

    def constructor(values as List):
        _sparles = Sparle.Functional.Encode(values, 0)
        _default = 0

    def constructor():
        _sparles = List()
        _default = 0

    def GetValues():
        return Sparle.Functional.Decode(_sparles, _default)

    def GetValue(index as int):
        return Sparle.Functional.GetValue(_sparles, index, _default)

    def GetValueLength():
        return Sparle.Functional.GetValueLength(_sparles)

    def SetValue(index as int, value):
        return Sparle.Functional.SetValue(_sparles, index, value, _default)

    def SetValueSlice(values as List, start as int, stop as int):
        Sparle.Functional.SetValueSlice(_sparles, values, start, stop, _default)

    def GetTopValue():
        sparle as List = _sparles[-1]
        return sparle[2]

    def GetTopPos():
        sparle as List = _sparles[-1]
        run as int = sparle[0]
        pos as int = sparle[1]
        return pos+run

    def GetBottomValue():
        sparle as List = _sparles[0]
        return sparle[2]

    def GetBottomPos():
        sparle as List = _sparles[0]
        pos as int = sparle[1]
        return pos
