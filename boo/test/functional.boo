import NUnit.Framework from "nunit.framework"
import Sparle.Functional

[TestFixture]
class FunctionalFixture:

    [Test]
    def EncodeTest():
        Assert.AreEqual("[[2, 0, 1]]", Encode([1,1], 0, 0).ToString(), "String Representation")
        Assert.AreEqual([[2,0,1]], Encode([1,1], 0, 0), "Flat Expected Encoding")
        Assert.AreEqual([[2,1,1]], Encode([0,1,1], 0, 0), "Sparse Start Expected Encoding")
        Assert.AreEqual([[1,0,1],[1,2,1]], Encode([1,0,1], 0, 0), "Sparse Mid Expected Encoding")
        Assert.AreEqual([[2,0,1]], Encode([1,1,0], 0, 0), "Sparse End Expected Encoding")
