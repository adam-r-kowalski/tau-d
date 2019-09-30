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
  struct Tensor {
    import algorithm : product;

    immutable size_t[Dims.length] shape = [Dims];

    ref T opIndex(Indices...)(Indices _) if (Indices.length == Dims.length) {
      return data[0];
    }

  private:
    T[[Dims].product] data;
  }

  Tensor tensor() {
    return Tensor();
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

/// rank
size_t rank(T)(ref auto const T t) if (isTensor!T) {
  return t.shape.length;
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

/// length
size_t length(T)(ref auto const T t) if (isTensor!T) {
  import algorithm : product;

  return t.shape[].product;
}

unittest {
  enum a = tensor!(int, 3, 2);
  static assert(a[0, 0] == 0);
}
