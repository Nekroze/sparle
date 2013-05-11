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

    def test_get_rle(self):
        arr = Array(data)

        assert arr.get_rle(0) == expected[0]
        assert arr.get_rle(1) == expected[1]
        assert arr.get_rle(2) == expected[1]
        assert arr.get_rle(3) == expected[2]
        assert arr.get_rle(4) is None

    def test_set_value(self):
        arr = Array()

        arr.set_value(5, 1)
        assert arr[5] == 1

    def test_set_value_default(self):
        arr = Array(data)

        arr.set_value(0, 0)
        assert arr.rle_values() == expected[1:]

    def test_delete_rle(self):
        arr = Array(data)

        assert arr[0] == data[0]
        arr.delete_rle(0)
        assert arr[0] == 0

        assert arr[1] == data[1]
        arr.delete_rle(1)
        assert arr[1] == 0
        assert arr[2] == 0

    def test_delete_value(self):
        arr = Array(data)

        assert arr[0] == data[0]
        arr.delete_value(0)
        assert arr[0] == 0

        assert arr[1] == data[1]
        arr.delete_value(1)
        assert arr[1] == 0
        assert arr[2] == data[2]

    def test_contains(self):
        arr = Array(data)

        assert data[2] in arr
        assert "a" not in arr

    def test_get_slice(self):
        arr = Array(data)

        assert arr[1:-1] == data[1:-1]

    def test_set_slice(self):
        arr = Array(data)

        #arr[1:-1] = [2, 2]
        #assert arr[:] == [data[0], 2, 2, data[-1]]
