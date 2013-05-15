import NUnit.Framework from "nunit.framework"
import Sparle.SparList

[TestFixture]
class SparListFixture:

    [Test]
    def TestGetValues():
        Assert.AreEqual([1,2,3], SparList([1,2,3]).GetValues(),
                        "Flat Expected Encoding")
        Assert.AreEqual([0,1,1], SparList([0,1,1]).GetValues(),
                        "Sparse Start Expected Encoding")
        Assert.AreEqual([1,0,1], SparList([1,0,1]).GetValues(),
                        "Sparse Mid Expected Encoding")
        Assert.AreEqual([1,1], SparList([1,1,0]).GetValues(),
                        "Sparse End Expected Encoding")
        Assert.AreEqual([5,1,5,1], SparList([5,1,5,1,5], 5).GetValues(),
                        "Sparse All Expected Encoding")

    [Test]
    def TestGetValue():
        Assert.AreEqual(1, SparList([1,2]).GetValue(0),
                        "Flat Expected Get Value")
        Assert.AreEqual(0, SparList([0,1,1]).GetValue(0),
                        "Sparse Start Expected Get Value")
        Assert.AreEqual(0, SparList([1,0,1]).GetValue(1),
                        "Sparse Mid Expected Get Value")
        Assert.AreEqual(0, SparList([1,1,0]).GetValue(2),
                        "Sparse End Expected Get Value")
        Assert.AreEqual(5, SparList([5,1,5,1,5], 5).GetValue(2),
                        "Sparse All Expected Get Value")

    [Test]
    def TestSetValue():
        sparles = SparList([1,2])
        sparles.SetValue(0, 5)
        Assert.AreEqual(5, sparles.GetValue(0),
                        "Flat Set Value")
        sparles = SparList([1,2])
        sparles.SetValue(1, 0)
        Assert.AreEqual(0, sparles.GetValue(1),
                        "Clear Set Value")
        sparles = SparList([1,2,2,1])
        sparles.SetValue(2, 5)
        Assert.AreEqual(5, sparles.GetValue(2),
                        "Replace Set Value")
        sparles = SparList([1,2,2,1])
        sparles.SetValue(1, 0)
        Assert.AreEqual(0, sparles.GetValue(1),
                        "Shorten Set Value")

    [Test]
    def TestSetValueSlice():
        sparles = SparList([1,2,3,4,5])
        sparles.SetValueSlice([6,7,8], 1, 4)
        Assert.AreEqual([1,6,7,8,5], sparles.GetValues(),
                        "Flat Slice Value")
        sparles = SparList([1,2,3,4,5])
        sparles.SetValueSlice([6,0,8], 1, 4)
        Assert.AreEqual([1,6,0,8,5], sparles.GetValues(),
                        "Defaulting Slice Value")
        sparles = SparList([1,2,3,4,5])
        sparles.SetValueSlice([0,0,0], 1, 4)
        Assert.AreEqual([1,0,0,0,5], sparles.GetValues(),
                        "Clearing Slice Value")
        sparles = SparList([1,2,3,4,5])
        sparles.SetValueSlice([0,0,0], 1, -1)
        Assert.AreEqual([1,0,0,0,5], sparles.GetValues(),
                        "Clearing Slice Value")
