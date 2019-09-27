@nogc @safe pure nothrow:

unittest {
  import std.array : staticArray;

  import variant : match;

  const xs = [1, 5, 3, 2].staticArray;
  auto iterator = xs.iterate;
  assert(iterator.next().match!((int x) => x == 1, _ => false));
  assert(iterator.next().match!((int x) => x == 5, _ => false));
  assert(iterator.next().match!((int x) => x == 3, _ => false));
  assert(iterator.next().match!((int x) => x == 2, _ => false));
  assert(iterator.next().match!((int) => false, _ => true));
  assert(iterator.next().match!((int) => false, _ => true));
  assert(iterator.next().match!((int) => false, _ => true));
}

/// Iterate
template iterate(T : U[n], U, size_t n) {
  import optional : Optional, Nothing;

  struct Iterate {
    Optional!U next() {
      return index < data.length ? Optional!U(data[index++]) : Optional!U(Nothing());
    }

  private:
    const U[] data;
    size_t index = 0;
  }

  Iterate iterate(const ref T t) {
    return Iterate(t[]);
  }
}
