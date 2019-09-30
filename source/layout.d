@nogc @safe pure nothrow:

unittest {
  enum layout = rowMajor([2, 3, 4]);
  static assert(layout.stride == [12, 4, 1]);

  static assert(layout.linearIndex(0, 0, 0) == 0);
  static assert(layout.linearIndex(0, 0, 1) == 1);
  static assert(layout.linearIndex(0, 0, 2) == 2);
  static assert(layout.linearIndex(0, 0, 3) == 3);

  static assert(layout.linearIndex(0, 1, 0) == 4);
  static assert(layout.linearIndex(0, 1, 1) == 5);
  static assert(layout.linearIndex(0, 1, 2) == 6);
  static assert(layout.linearIndex(0, 1, 3) == 7);

  static assert(layout.linearIndex(0, 2, 0) == 8);
  static assert(layout.linearIndex(0, 2, 1) == 9);
  static assert(layout.linearIndex(0, 2, 2) == 10);
  static assert(layout.linearIndex(0, 2, 3) == 11);

  static assert(layout.linearIndex(1, 0, 0) == 12);
  static assert(layout.linearIndex(1, 0, 1) == 13);
  static assert(layout.linearIndex(1, 0, 2) == 14);
  static assert(layout.linearIndex(1, 0, 3) == 15);

  static assert(layout.linearIndex(1, 1, 0) == 16);
  static assert(layout.linearIndex(1, 1, 1) == 17);
  static assert(layout.linearIndex(1, 1, 2) == 18);
  static assert(layout.linearIndex(1, 1, 3) == 19);

  static assert(layout.linearIndex(1, 2, 0) == 20);
  static assert(layout.linearIndex(1, 2, 1) == 21);
  static assert(layout.linearIndex(1, 2, 2) == 22);
  static assert(layout.linearIndex(1, 2, 3) == 23);
}

unittest {
  import std.array : staticArray;

  const layout = rowMajor([2, 3, 4]);
  assert(layout.stride == [12, 4, 1].staticArray);

  assert(layout.linearIndex(0, 0, 0) == 0);
  assert(layout.linearIndex(0, 0, 1) == 1);
  assert(layout.linearIndex(0, 0, 2) == 2);
  assert(layout.linearIndex(0, 0, 3) == 3);

  assert(layout.linearIndex(0, 1, 0) == 4);
  assert(layout.linearIndex(0, 1, 1) == 5);
  assert(layout.linearIndex(0, 1, 2) == 6);
  assert(layout.linearIndex(0, 1, 3) == 7);

  assert(layout.linearIndex(0, 2, 0) == 8);
  assert(layout.linearIndex(0, 2, 1) == 9);
  assert(layout.linearIndex(0, 2, 2) == 10);
  assert(layout.linearIndex(0, 2, 3) == 11);

  assert(layout.linearIndex(1, 0, 0) == 12);
  assert(layout.linearIndex(1, 0, 1) == 13);
  assert(layout.linearIndex(1, 0, 2) == 14);
  assert(layout.linearIndex(1, 0, 3) == 15);

  assert(layout.linearIndex(1, 1, 0) == 16);
  assert(layout.linearIndex(1, 1, 1) == 17);
  assert(layout.linearIndex(1, 1, 2) == 18);
  assert(layout.linearIndex(1, 1, 3) == 19);

  assert(layout.linearIndex(1, 2, 0) == 20);
  assert(layout.linearIndex(1, 2, 1) == 21);
  assert(layout.linearIndex(1, 2, 2) == 22);
  assert(layout.linearIndex(1, 2, 3) == 23);
}

/// row major
template rowMajor(size_t N) {
  struct RowMajor {
    size_t[N] stride;

    size_t linearIndex(Indices...)(Indices indices) const if (Indices.length == N) {
      import std.algorithm : fold, map;
      import range : zip;

      size_t[N] cartesian_index = [indices];
      return stride[].zip(cartesian_index[]).map!"a[0] * a[1]"
        .fold!"a + b"(size_t(0));
    }
  }

  RowMajor rowMajor(auto ref const size_t[N] shape) {
    import std.range : retro;
    import std.algorithm : cumulativeFold, copy;

    size_t[N] stride;
    stride[$ - 1] = 1;
    shape[1 .. $].retro.cumulativeFold!"a * b".copy(stride[0 .. $ - 1].retro);
    return RowMajor(stride);
  }
}
