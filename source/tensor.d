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

  static assert(isTensor!(Tensor!(int, 4, 5, 7)));
  static assert(isTensor!(Tensor!(float, 3, 2, 7)));
  static assert(!isTensor!int);
  static assert(!isTensor!string);
}

/// Tensor
struct Tensor(T, Dims...) {
}

/// tensor
Tensor!(T, Dims) tensor(T, Dims...)() {
  return Tensor!(T, Dims)();
}

/// shape
size_t[Dims.length] shape(T, Dims...)(ref auto const Tensor!(T, Dims)) {
  return [Dims];
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

/// rank
size_t length(T)(ref auto const T t) if (isTensor!T) {
  size_t result = 1;
  foreach (e; t.shape)
    result *= e;
  return result;
}
