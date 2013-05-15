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
