namespace Sparle.SparleTable
import Sparle.SparleList

class SparleTable:
    space as System.Collections.Hashtable

    def constructor():
        space = {}

    def GetSparle(x as long, z as long) as SparleList:
        return space[(x, y)]

    def GetVoxel(x as long, y as long, height as int):
        return GetSparle(x,y).GetValue(height)
