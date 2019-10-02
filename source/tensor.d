@nogc @safe pure nothrow:

import traits : isTensor;

unittest {
  enum a = tensor!(int, 1, 3);
  enum b = tensor!(int, 4, 9, 2, 1);

  static assert(a.shape == [1, 3]);
  static assert(b.shape == [4, 9, 2, 1]);
}

unittest {
  import std.array : staticArray;

  const a = tensor!(int, 3, 2);
  const b = tensor!(int, 7, 3, 5);

  assert(a.shape == [3, 2].staticArray);
  assert(b.shape == [7, 3, 5].staticArray);
}

unittest {
  static assert(isTensor!(typeof(tensor!(int, 4, 5, 7)())));
  static assert(isTensor!(typeof(tensor!(float, 3, 2, 7)())));
  static assert(!isTensor!int);
  static assert(!isTensor!string);
}

/// Tensor
template tensor(T, Dims...) {
  import algorithm : product;
  import layout : rowMajor;

  struct Tensor {
    immutable size_t rank = Dims.length;
    immutable size_t[rank] shape = [Dims];
    immutable size_t length = [Dims].product;
    immutable size_t[rank] stride = rowMajor([Dims]);

    this(T[length] data) {
      this.data = data;
    }

    T opIndex(Indices...)(Indices indices) const if (Indices.length == Dims.length) {
      import layout : linearIndex;

      static foreach (i; 0 .. Indices.length)
        assert(indices[i] >= 0 && indices[i] < Dims[i]);

      return data[linearIndex(stride, [indices])];
    }

    void opIndexAssign(Indices...)(T value, Indices indices)
        if (Indices.length == Dims.length) {
      import layout : linearIndex;

      static foreach (i; 0 .. Indices.length)
        assert(indices[i] >= 0 && indices[i] < Dims[i]);

      data[linearIndex(stride, [indices])] = value;
    }

    Tensor opBinary(string op)(auto ref const Tensor other) const 
        if (op == "+" || op == "-") {
      auto result = Tensor();
      mixin("result.data[] = this.data[] " ~ op ~ " other.data[];");
      return result;
    }

  private:
    T[length] data;
  }

  Tensor tensor() {
    return Tensor();
  }

  Tensor tensor(Ts...)(Ts data) if (Ts.length == Tensor.init.length) {
    return Tensor([data]);
  }
}

unittest {
  enum a = tensor!(int, 1, 3);
  enum b = tensor!(int, 4, 9, 2, 1);

  static assert(a.rank == 2);
  static assert(b.rank == 4);
}

unittest {
  const a = tensor!(int, 3, 2);
  const b = tensor!(int, 7, 3, 5);

  assert(a.rank == 2);
  assert(b.rank == 3);
}

unittest {
  enum a = tensor!(int, 1, 3);
  enum b = tensor!(int, 4, 9, 2, 1);

  static assert(a.length == 1 * 3);
  static assert(b.length == 4 * 9 * 2 * 1);
}

unittest {
  const a = tensor!(int, 3, 2);
  const b = tensor!(int, 7, 3, 5);

  assert(a.length == 3 * 2);
  assert(b.length == 7 * 3 * 5);
}

unittest {
  auto a = tensor!(int, 3, 2);
  assert(a[0, 0] == 0);
  assert(a[0, 1] == 0);
  assert(a[1, 0] == 0);
  assert(a[1, 1] == 0);
  assert(a[2, 0] == 0);
  assert(a[2, 1] == 0);

  a[0, 0] = 0;
  a[0, 1] = 1;
  a[1, 0] = 2;
  a[1, 1] = 3;
  a[2, 0] = 4;
  a[2, 1] = 5;

  assert(a[0, 0] == 0);
  assert(a[0, 1] == 1);
  assert(a[1, 0] == 2);
  assert(a[1, 1] == 3);
  assert(a[2, 0] == 4);
  assert(a[2, 1] == 5);
}

unittest {
  enum a = tensor!(int, 3, 2);
  static assert(a[0, 0] == 0);
  static assert(a[0, 1] == 0);
  static assert(a[1, 0] == 0);
  static assert(a[1, 1] == 0);
  static assert(a[2, 0] == 0);
  static assert(a[2, 1] == 0);
}

unittest {
  enum a = tensor!(int, 3, 2)(1, 2, 3, 4, 5, 6);
  static assert(a[0, 0] == 1);
  static assert(a[0, 1] == 2);
  static assert(a[1, 0] == 3);
  static assert(a[1, 1] == 4);
  static assert(a[2, 0] == 5);
  static assert(a[2, 1] == 6);
}

unittest {
  const a = tensor!(int, 3, 2)(1, 2, 3, 4, 5, 6);
  assert(a[0, 0] == 1);
  assert(a[0, 1] == 2);
  assert(a[1, 0] == 3);
  assert(a[1, 1] == 4);
  assert(a[2, 0] == 5);
  assert(a[2, 1] == 6);
}

unittest {
  enum a = tensor!(int, 3, 2)(1, 2, 3, 4, 5, 6);
  enum b = tensor!(int, 3, 2)(1, 2, 3, 4, 5, 6);
  enum c = tensor!(int, 3, 2)(100, 200, 300, 400, 500, 600);
  assert(a == b);
  assert(a != c);
  assert(b != c);
}

unittest {
  const a = tensor!(int, 3, 2)(1, 2, 3, 4, 5, 6);
  const b = tensor!(int, 3, 2)(1, 2, 3, 4, 5, 6);
  const c = tensor!(int, 3, 2)(100, 200, 300, 400, 500, 600);
  assert(a == b);
  assert(a != c);
  assert(b != c);
}

unittest {
  auto a = tensor!(int, 3, 2)(1, 2, 3, 4, 5, 6);
  const b = tensor!(int, 3, 2)(1, 2, 3, 4, 5, 6);
  assert(a == b);
  a[0, 0] = 100;
  assert(a != b);
}

unittest {
  const a = tensor!(int, 3, 2)(1, 2, 3, 4, 5, 6);
  const b = a + a;
  const c = tensor!(int, 3, 2)(2, 4, 6, 8, 10, 12);
  assert(b == c);
}

unittest {
  const a = tensor!(int, 3, 2)(2, 4, 6, 8, 10, 12);
  const b = tensor!(int, 3, 2)(1, 2, 3, 4, 5, 6);
  const c = a - b;
  assert(c == b);
}
