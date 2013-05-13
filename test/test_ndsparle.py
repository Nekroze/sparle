from sparle.ndsparle import nd_sparle


class Test_ndSPARLE(object):

    def test_initialization(self):
        nd = nd_sparle(16, 16)

    def test_get(self):
        nd = nd_sparle(16, 16)

        assert nd[0][0][0] == 0

    def test_set(self):
        nd = nd_sparle(16, 16)

        nd[0][0][0] = 1
        assert nd[0][0][0] == 1
        assert nd[0][1][0] == 0
