namespace Sparle.SparleMatrix
import Sparle.SparList

class SparleMatrix:
    _sparles as (SparList, 2)

    def constructor(width as int, depth as int, default as int):
        _sparles = matrix(SparList, width, depth)
        for x in range(len(_sparles,0)):
            for y in range(len(_sparles,1)):
                _sparles[x, y] = SparList(default)

    def constructor(width as int, depth as int):
        _sparles = matrix(SparList, width, depth)
        for x in range(len(_sparles,0)):
            for y in range(len(_sparles,1)):
                _sparles[x, y] = SparList(0)

    def GetValues(x as int, y as int):
        return _sparles[x, y].GetValues()

    def GetValue(x as int, y as int, z as int):
        return _sparles[x, y].GetValue(z)

    def GetValueLength(x as int, y as int):
        return _sparles[x, y].GetValueLength()

    def SetValue(x as int, y as int, z as int, value as int):
        return _sparles[x, y].SetValue(z, value)

    def SetValueSlice(x as int, y as int, values as List,
                      start as int, stop as int):
        _sparles[x, y].SetValueSlice(values, start, stop)

    def GetTopValue(x as int, y as int):
        return _sparles[x, y].GetTopValue()

    def GetTopPos(x as int, y as int):
        return _sparles[x, y].GetTopPos()

    def GetBottomValue(x as int, y as int):
        return _sparles[x, y].GetBottomValue()

    def GetBottomPos(x as int, y as int):
        return _sparles[x, y].GetBottomPos()
