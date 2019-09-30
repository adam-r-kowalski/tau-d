@nogc @safe pure nothrow:

unittest {
  enum stride = rowMajor([2, 3, 4]);
  static assert(stride == [12, 4, 1]);

  static assert(stride.linearIndex([0, 0, 0]) == 0);
  static assert(stride.linearIndex([0, 0, 1]) == 1);
  static assert(stride.linearIndex([0, 0, 2]) == 2);
  static assert(stride.linearIndex([0, 0, 3]) == 3);

  static assert(stride.linearIndex([0, 1, 0]) == 4);
  static assert(stride.linearIndex([0, 1, 1]) == 5);
  static assert(stride.linearIndex([0, 1, 2]) == 6);
  static assert(stride.linearIndex([0, 1, 3]) == 7);

  static assert(stride.linearIndex([0, 2, 0]) == 8);
  static assert(stride.linearIndex([0, 2, 1]) == 9);
  static assert(stride.linearIndex([0, 2, 2]) == 10);
  static assert(stride.linearIndex([0, 2, 3]) == 11);

  static assert(stride.linearIndex([1, 0, 0]) == 12);
  static assert(stride.linearIndex([1, 0, 1]) == 13);
  static assert(stride.linearIndex([1, 0, 2]) == 14);
  static assert(stride.linearIndex([1, 0, 3]) == 15);

  static assert(stride.linearIndex([1, 1, 0]) == 16);
  static assert(stride.linearIndex([1, 1, 1]) == 17);
  static assert(stride.linearIndex([1, 1, 2]) == 18);
  static assert(stride.linearIndex([1, 1, 3]) == 19);

  static assert(stride.linearIndex([1, 2, 0]) == 20);
  static assert(stride.linearIndex([1, 2, 1]) == 21);
  static assert(stride.linearIndex([1, 2, 2]) == 22);
  static assert(stride.linearIndex([1, 2, 3]) == 23);
}

unittest {
  import std.array : staticArray;

  const stride = rowMajor([2, 3, 4]);
  assert(stride == [12, 4, 1].staticArray);

  assert(stride.linearIndex([0, 0, 0]) == 0);
  assert(stride.linearIndex([0, 0, 1]) == 1);
  assert(stride.linearIndex([0, 0, 2]) == 2);
  assert(stride.linearIndex([0, 0, 3]) == 3);

  assert(stride.linearIndex([0, 1, 0]) == 4);
  assert(stride.linearIndex([0, 1, 1]) == 5);
  assert(stride.linearIndex([0, 1, 2]) == 6);
  assert(stride.linearIndex([0, 1, 3]) == 7);

  assert(stride.linearIndex([0, 2, 0]) == 8);
  assert(stride.linearIndex([0, 2, 1]) == 9);
  assert(stride.linearIndex([0, 2, 2]) == 10);
  assert(stride.linearIndex([0, 2, 3]) == 11);

  assert(stride.linearIndex([1, 0, 0]) == 12);
  assert(stride.linearIndex([1, 0, 1]) == 13);
  assert(stride.linearIndex([1, 0, 2]) == 14);
  assert(stride.linearIndex([1, 0, 3]) == 15);

  assert(stride.linearIndex([1, 1, 0]) == 16);
  assert(stride.linearIndex([1, 1, 1]) == 17);
  assert(stride.linearIndex([1, 1, 2]) == 18);
  assert(stride.linearIndex([1, 1, 3]) == 19);

  assert(stride.linearIndex([1, 2, 0]) == 20);
  assert(stride.linearIndex([1, 2, 1]) == 21);
  assert(stride.linearIndex([1, 2, 2]) == 22);
  assert(stride.linearIndex([1, 2, 3]) == 23);
}

/// row major
size_t[N] rowMajor(size_t N)(auto ref const size_t[N] shape) {
  import std.range : retro;
  import std.algorithm : cumulativeFold, copy;

  size_t[N] stride;
  stride[$ - 1] = 1;
  shape[1 .. $].retro.cumulativeFold!"a * b".copy(stride[0 .. $ - 1].retro);
  return stride;
}

unittest {
  enum stride = columnMajor([2, 3, 4]);
  static assert(stride == [1, 2, 6]);

  static assert(stride.linearIndex([0, 0, 0]) == 0);
  static assert(stride.linearIndex([1, 0, 0]) == 1);
  static assert(stride.linearIndex([0, 1, 0]) == 2);
  static assert(stride.linearIndex([1, 1, 0]) == 3);

  static assert(stride.linearIndex([0, 2, 0]) == 4);
  static assert(stride.linearIndex([1, 2, 0]) == 5);
  static assert(stride.linearIndex([0, 0, 1]) == 6);
  static assert(stride.linearIndex([1, 0, 1]) == 7);

  static assert(stride.linearIndex([0, 1, 1]) == 8);
  static assert(stride.linearIndex([1, 1, 1]) == 9);
  static assert(stride.linearIndex([0, 2, 1]) == 10);
  static assert(stride.linearIndex([1, 2, 1]) == 11);

  static assert(stride.linearIndex([0, 0, 2]) == 12);
  static assert(stride.linearIndex([1, 0, 2]) == 13);
  static assert(stride.linearIndex([0, 1, 2]) == 14);
  static assert(stride.linearIndex([1, 1, 2]) == 15);

  static assert(stride.linearIndex([0, 2, 2]) == 16);
  static assert(stride.linearIndex([1, 2, 2]) == 17);
  static assert(stride.linearIndex([0, 0, 3]) == 18);
  static assert(stride.linearIndex([1, 0, 3]) == 19);

  static assert(stride.linearIndex([0, 1, 3]) == 20);
  static assert(stride.linearIndex([1, 1, 3]) == 21);
  static assert(stride.linearIndex([0, 2, 3]) == 22);
  static assert(stride.linearIndex([1, 2, 3]) == 23);
}

unittest {
  import std.array : staticArray;

  const stride = columnMajor([2, 3, 4]);
  assert(stride == [1, 2, 6].staticArray);

  assert(stride.linearIndex([0, 0, 0]) == 0);
  assert(stride.linearIndex([1, 0, 0]) == 1);
  assert(stride.linearIndex([0, 1, 0]) == 2);
  assert(stride.linearIndex([1, 1, 0]) == 3);

  assert(stride.linearIndex([0, 2, 0]) == 4);
  assert(stride.linearIndex([1, 2, 0]) == 5);
  assert(stride.linearIndex([0, 0, 1]) == 6);
  assert(stride.linearIndex([1, 0, 1]) == 7);

  assert(stride.linearIndex([0, 1, 1]) == 8);
  assert(stride.linearIndex([1, 1, 1]) == 9);
  assert(stride.linearIndex([0, 2, 1]) == 10);
  assert(stride.linearIndex([1, 2, 1]) == 11);

  assert(stride.linearIndex([0, 0, 2]) == 12);
  assert(stride.linearIndex([1, 0, 2]) == 13);
  assert(stride.linearIndex([0, 1, 2]) == 14);
  assert(stride.linearIndex([1, 1, 2]) == 15);

  assert(stride.linearIndex([0, 2, 2]) == 16);
  assert(stride.linearIndex([1, 2, 2]) == 17);
  assert(stride.linearIndex([0, 0, 3]) == 18);
  assert(stride.linearIndex([1, 0, 3]) == 19);

  assert(stride.linearIndex([0, 1, 3]) == 20);
  assert(stride.linearIndex([1, 1, 3]) == 21);
  assert(stride.linearIndex([0, 2, 3]) == 22);
  assert(stride.linearIndex([1, 2, 3]) == 23);
}

/// columnMajor
size_t[N] columnMajor(size_t N)(auto ref const size_t[N] shape) {
  import std.range : retro;
  import std.algorithm : cumulativeFold, copy;

  size_t[N] stride;
  stride[0] = 1;
  shape[0 .. $ - 1].cumulativeFold!"a * b".copy(stride[1 .. $]);
  return stride;
}

/// linearIndex
size_t linearIndex(size_t N)(auto ref const size_t[N] stride, auto ref const size_t[N] cartesian_index) {
  import std.algorithm : fold, map;
  import range : zip;

  return stride[].zip(cartesian_index[]).map!"a[0] * a[1]"
    .fold!"a + b"(size_t(0));
}
