from sparle.array import Array


data = [5, 1, 1, 2]
expected = [(1, 0, 5), (2, 1, 1), (1, 3, 2)]


class Test_SPARLE_Array(object):

    def test_initialization(self):
        arr = Array()

    def test_set_values(self):
        arr = Array(data)

        assert arr.rle_values() == expected

    def test_get_values(self):
        arr = Array(data)

        assert arr.get_values() == expected

    def test_get_values(self):
        arr = Array(data)

        assert arr[0] == data[0]
        assert arr[1] == data[1]
        assert arr[2] == data[2]
        assert arr[3] == data[3]
        assert arr[4] == 0

    def test_set_value(self):
        arr = Array()

        arr[5] = 1
        assert arr[5] == 1

    def test_set_value_default(self):
        arr = Array(data)

        arr[0] = 0
        assert arr.rle_values() == expected[1:]

    def test_delete_value(self):
        arr = Array(data)

        assert arr[0] == data[0]
        del arr[0]
        assert arr[0] == 0

        assert arr[1] == data[1]
        del arr[1]
        assert arr[1] == 0
        assert arr[2] == data[2]

    def test_contains(self):
        arr = Array(data)

        assert data[2] in arr
        assert "a" not in arr

    def test_slice(self):
        arr = Array(data)

        assert arr[1:-1] == data[1:-1]
        assert arr[1:] == data[1:]
        assert arr[:2] == data[:2]

        arr[1:-1] = [2, 2]
        assert arr.sparle == [expected[0], (3, 1, 2)]
        assert arr[0] == 5
        assert arr[1] == 2
        assert arr[2] == 2
        assert arr[3] == 2
        assert arr[:] == [data[0], 2, 2, data[-1]]

    def test_slice_sparce(self):
        arr = Array(data)
        expecteddata = data + ([0]*6) + [100]

        assert arr[:10] == data + ([0]*6)

        arr[10:11] = [100]
        assert arr.sparle == expected + [(1, 10, 100)]
        assert arr.get_values() == expecteddata
        assert arr[:] == expecteddata

        del arr[0]
        assert len(arr) == len(expecteddata)
        assert arr.get_values() == [0] + expecteddata[1:]
        assert arr[:] == [0] + expecteddata[1:]
