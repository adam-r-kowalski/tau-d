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
    const U[] data;
    size_t index = 0;

    Optional!U next() {
      return index < data.length ? optional!U(data[index++]) : optional!U();
    }
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

  import optional : Optional, map, match;

  alias f = unaryFun!fun;
  alias T = ElementType!Range;
  alias U = typeof(f(T.init));

  struct Map {
    Range range;

    Optional!U next() {
      return range.next().map!((T t) => f(t));
    }
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
    Range range;

    Optional!T next() {
      auto n = range.next();
      while (!n.match!((T t) => p(t), _ => true))
        n = range.next();
      return n;
    }
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
    U value;

    bool step(T x) {
      value = r(value, x);
      return true;
    }

    bool step(Nothing) {
      return false;
    }
  }

  U fold(Range range, U initial) {
    auto acc = Acc(initial);
    while (range.next().match!(a => acc.step(a))) {
    }
    return acc.value;
  }
}

unittest {
  import optional : match;

  auto range = inclusive_range(3);
  assert(range.next().match!((int x) => x == 0, _ => false));
  assert(range.next().match!((int x) => x == 1, _ => false));
  assert(range.next().match!((int x) => x == 2, _ => false));
  assert(range.next().match!((int x) => x == 3, _ => false));
  assert(range.next().match!((int) => false, _ => true));
}

unittest {
  import optional : match;

  auto range = inclusive_range(3, 6);
  assert(range.next().match!((int x) => x == 3, _ => false));
  assert(range.next().match!((int x) => x == 4, _ => false));
  assert(range.next().match!((int x) => x == 5, _ => false));
  assert(range.next().match!((int x) => x == 6, _ => false));
  assert(range.next().match!((int) => false, _ => true));
}

unittest {
  import optional : match;

  auto range = inclusive_range(0, 6, 2);
  assert(range.next().match!((int x) => x == 0, _ => false));
  assert(range.next().match!((int x) => x == 2, _ => false));
  assert(range.next().match!((int x) => x == 4, _ => false));
  assert(range.next().match!((int x) => x == 6, _ => false));
  assert(range.next().match!((int) => false, _ => true));
}

/// inclusive_range
template inclusive_range(T) {
  import optional : Optional, optional;

  struct InclusiveRange {
    T begin;
    T end;
    T step;

    Optional!T next() {
      if (begin <= end) {
        const result = optional(begin);
        begin += step;
        return result;
      }
      return optional!T();
    }
  }

  InclusiveRange inclusive_range(T end) {
    return InclusiveRange(0, end, 1);
  }

  InclusiveRange inclusive_range(T begin, T end) {
    return InclusiveRange(begin, end, 1);
  }

  InclusiveRange inclusive_range(T begin, T end, T step) {
    return InclusiveRange(begin, end, step);
  }
}

unittest {
  import std.array : staticArray;

  const _ = [1, 2, 3, 4].staticArray;
  assert(_.iterate.sum == 10);
}

/// sum
ElementType!Range sum(Range)(Range range) if (isForwardRange!Range) {
  return range.fold!"a + b"(0);
}

/// Project Euler Problem 1
unittest {
  const expected = 233_168;
  const actual = inclusive_range(999).filter!(a => a % 3 == 0 || a % 5 == 0).sum;
  assert(expected == actual);
}
