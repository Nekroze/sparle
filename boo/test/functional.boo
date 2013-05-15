import NUnit.Framework from "nunit.framework"
import Sparle.Functional

[TestFixture]
class FunctionalFixture:

    [Test]
    def TestEncode():
        Assert.AreEqual([[2,0,1]], Encode([1,1]),
                        "Flat Expected Encoding")
        Assert.AreEqual([[2,1,1]], Encode([0,1,1]),
                        "Sparse Start Expected Encoding")
        Assert.AreEqual([[1,0,1],[1,2,1]], Encode([1,0,1]),
                        "Sparse Mid Expected Encoding")
        Assert.AreEqual([[2,0,1]], Encode([1,1,0]),
                        "Sparse End Expected Encoding")
        Assert.AreEqual([[1,1,1],[1,3,1]], Encode([5,1,5,1,5], 5),
                        "Sparse All Expected Encoding")
        Assert.AreEqual([[1,6,1],[1,8,1]], Encode([0,1,0,1,0], 0, 5),
                        "Sparse Offset Expected Encoding")

    [Test]
    def TestDecode():
        Assert.AreEqual([1,1], Decode(Encode([1,1])),
                        "Flat Expected Decoding")
        Assert.AreEqual([0,1,1], Decode(Encode([0,1,1])),
                        "Sparse Start Expected Decoding")
        Assert.AreEqual([1,0,1], Decode(Encode([1,0,1])),
                        "Sparse Mid Expected Decoding")
        Assert.AreEqual([1,1], Decode(Encode([1,1,0])),
                        "Sparse End Expected Decoding")
        Assert.AreEqual([5,1,5,1], Decode(Encode([5,1,5,1,5], 5), 5),
                        "Sparse All Expected Decoding")
        Assert.AreEqual([0,0,0,0,0,0,1,0,1], Decode(Encode([0,1,0,1,0], 0, 5)),
                        "Sparse Offset Expected Decoding")

    [Test]
    def TestGetValue():
        Assert.AreEqual(1, GetValue(Encode([1,2]), 0),
                        "Flat Expected Get Value")
        Assert.AreEqual(0, GetValue(Encode([0,1,1]), 0),
                        "Sparse Start Expected Get Value")
        Assert.AreEqual(0, GetValue(Encode([1,0,1]), 1),
                        "Sparse Mid Expected Get Value")
        Assert.AreEqual(0, GetValue(Encode([1,1,0]), 2),
                        "Sparse End Expected Get Value")
        Assert.AreEqual(5, GetValue(Encode([5,1,5,1,5], 5), 2, 5),
                        "Sparse All Expected Get Value")
        Assert.AreEqual(1, GetValue(Encode([0,1,0,1,0], 0, 5), 6),
                        "Sparse Offset Expected Get Value")

    [Test]
    def TestSetValue():
        sparles = Encode([1,2])
        SetValue(sparles, 0, 5)
        Assert.AreEqual(5, GetValue(sparles, 0),
                        "Flat Set Value")
        sparles = Encode([1,2])
        SetValue(sparles, 1, 0, 0)
        Assert.AreEqual(0, GetValue(sparles, 1),
                        "Clear Set Value")
        sparles = Encode([1,2,2,1])
        SetValue(sparles, 2, 5)
        Assert.AreEqual(5, GetValue(sparles, 2),
                        "Replace Set Value")
        sparles = Encode([1,2,2,1])
        SetValue(sparles, 1, 0)
        Assert.AreEqual(0, GetValue(sparles, 1),
                        "Shorten Set Value")

    [Test]
    def TestSetValueSlice():
        sparles = Encode([1,2,3,4,5])
        SetValueSlice(sparles, [6,7,8], 0, 1, 4)
        Assert.AreEqual([1,6,7,8,5], Decode(sparles, 0),
                        "Flat Slice Value")
        sparles = Encode([1,2,3,4,5])
        SetValueSlice(sparles, [6,0,8], 0, 1, 4)
        Assert.AreEqual([1,6,0,8,5], Decode(sparles, 0),
                        "Defaulting Slice Value")
        sparles = Encode([1,2,3,4,5])
        SetValueSlice(sparles, [0,0,0], 0, 1, 4)
        Assert.AreEqual([1,0,0,0,5], Decode(sparles, 0),
                        "Clearing Slice Value")
        sparles = Encode([1,2,3,4,5])
        SetValueSlice(sparles, [0,0,0], 0, 1, -1)
        Assert.AreEqual([1,0,0,0,5], Decode(sparles, 0),
                        "Clearing Slice Value")
