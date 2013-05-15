import NUnit.Framework from "nunit.framework"
import Sparle.Functional

[TestFixture]
class FunctionalFixture:

    [Test]
    def EncodeTest():
        assert Encode(List(range(5)), 0, 0) == range(5)
