import NUnit.Framework from "nunit.framework"
import Sparle.SparleMatrix

[TestFixture]
class SparleMatrixFixture:

    [Test]
    def TestSetValue():
        sparles = SparleMatrix(16,16)
        sparles.SetValue(0,0,0,5)
        Assert.AreEqual(5, sparles.GetValue(0,0,0),
                        "Flat Set Value")
        Assert.AreEqual(0, sparles.GetValue(0,0,1),
                        "Flat Unique Set Value")
