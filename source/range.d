@nogc @safe pure nothrow:

unittest {
  import std.array : staticArray;

  const _ = [1, 2, 3, 4].staticArray;
  static assert(isForwardRange!(typeof(_.iterate)));
  static assert(!isForwardRange!int);
}

/// isForwardRange
template isForwardRange(T) {
  import optional : isOptional;

  static if (is(typeof(T.init.next())))
    enum bool isForwardRange = isOptional!(typeof(T.init.next()));
  else
    enum bool isForwardRange = false;
}

unittest {
  import std.array : staticArray;

  const _ = [1, 2, 3, 4].staticArray;
  static assert(is(ElementType!(typeof(_.iterate)) == int));
}

/// ElementType
template ElementType(T) if (isForwardRange!T) {
  import optional : E = ElementType;

  alias ElementType = E!(typeof(T.init.next()));
}

unittest {
  import std.array : staticArray;

  import optional : match;

  const xs = [1, 5, 3, 2].staticArray;
  auto range = xs.iterate;
  assert(range.next().match!((int x) => x == 1, _ => false));
  assert(range.next().match!((int x) => x == 5, _ => false));
  assert(range.next().match!((int x) => x == 3, _ => false));
  assert(range.next().match!((int x) => x == 2, _ => false));
  assert(range.next().match!((int) => false, _ => true));
  assert(range.next().match!((int) => false, _ => true));
  assert(range.next().match!((int) => false, _ => true));
}

/// iterate
template iterate(T : U[n], U, size_t n) {
  import optional : Optional, optional;

  struct Iterate {
    Optional!U next() {
      return index < data.length ? optional!U(data[index++]) : optional!U();
    }

  private:
    const U[] data;
    size_t index = 0;
  }

  Iterate iterate(ref const T t) {
    return Iterate(t[]);
  }
}

unittest {
  import std.array : staticArray;

  import optional : match;

  const xs = [1, 5, 3, 2].staticArray;
  auto range = xs.iterate.map!"a^^2";
  assert(range.next().match!((int x) => x == 1, _ => false));
  assert(range.next().match!((int x) => x == 25, _ => false));
  assert(range.next().match!((int x) => x == 9, _ => false));
  assert(range.next().match!((int x) => x == 4, _ => false));
  assert(range.next().match!((int) => false, _ => true));
  assert(range.next().match!((int) => false, _ => true));
  assert(range.next().match!((int) => false, _ => true));
}

/// map
template map(alias fun, Range) if (isForwardRange!Range) {
  import std.functional : unaryFun;

  import optional : Optional, map;
  import variant : match;

  alias f = unaryFun!fun;
  alias T = ElementType!Range;
  alias U = typeof(f(T.init));

  struct Map {
    Optional!U next() {
      return range.next().map!((T t) => f(t));
    }

  private:
    Range range;
  }

  Map map(Range range) {
    return Map(range);
  }
}

unittest {
  import std.array : staticArray;

  import optional : match;

  const xs = [1, 5, 3, 2, 4].staticArray;
  auto range = xs.iterate.filter!"a % 2 == 0";
  assert(range.next().match!((int x) => x == 2, _ => false));
  assert(range.next().match!((int x) => x == 4, _ => false));
  assert(range.next().match!((int) => false, _ => true));
  assert(range.next().match!((int) => false, _ => true));
  assert(range.next().match!((int) => false, _ => true));
}

/// filter
template filter(alias pred, Range) if (isForwardRange!Range) {
  import std.functional : unaryFun;

  import optional : Optional, Nothing, match;

  alias p = unaryFun!pred;
  alias T = ElementType!Range;

  struct Filter {
    Optional!T next() {
      auto n = range.next();
      while (!n.match!((T t) => p(t), _ => true))
        n = range.next();
      return n;
    }

  private:
    Range range;
  }

  Filter filter(Range range) {
    return Filter(range);
  }
}

unittest {
  import std.array : staticArray;

  const xs = [1, 5, 3, 2, 4].staticArray;
  assert(xs.iterate.fold!"a + b"(0) == 15);
}

/// fold
template fold(alias reducer, Range, U) if (isForwardRange!Range) {
  import std.functional : binaryFun;

  import optional : Optional, Nothing, match;

  alias r = binaryFun!reducer;
  alias T = ElementType!Range;

  struct Acc {
    bool step(T x) {
      value = r(value, x);
      return true;
    }

    bool step(Nothing) {
      return false;
    }

    U value;
  }

  U fold(Range range, U initial) {
    auto acc = Acc(initial);
    while (range.next().match!(a => acc.step(a))) {
    }
    return acc.value;
  }
}
