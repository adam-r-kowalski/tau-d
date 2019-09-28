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

/// iterate
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

  Iterate iterate(ref const T t) {
    return Iterate(t[]);
  }
}

unittest {
  import std.array : staticArray;

  import variant : match;

  const xs = [1, 5, 3, 2].staticArray;
  auto iterator = xs.iterate.map!"a^^2";
  assert(iterator.next().match!((int x) => x == 1, _ => false));
  assert(iterator.next().match!((int x) => x == 25, _ => false));
  assert(iterator.next().match!((int x) => x == 9, _ => false));
  assert(iterator.next().match!((int x) => x == 4, _ => false));
  assert(iterator.next().match!((int) => false, _ => true));
  assert(iterator.next().match!((int) => false, _ => true));
  assert(iterator.next().match!((int) => false, _ => true));
}

/// map
template map(alias fun, Iterator) {
  import std.functional : unaryFun;

  import optional : Optional, Nothing;
  import variant : match;

  alias f = unaryFun!fun;
  alias T = ElementType!Iterator;
  alias U = typeof(f(T.init));

  struct Map {
    Optional!U next() {
      return iterator.next().match!((T t) => Optional!U(f(t)), (Nothing _) => Optional!U(Nothing()));
    }

  private:
    Iterator iterator;
  }

  Map map(Iterator iterator) {
    return Map(iterator);
  }
}

unittest {
  import std.array : staticArray;

  import variant : match;

  const xs = [1, 5, 3, 2, 4].staticArray;
  auto iterator = xs.iterate.filter!"a % 2 == 0";
  assert(iterator.next().match!((int x) => x == 2, _ => false));
  assert(iterator.next().match!((int x) => x == 4, _ => false));
}

/// filter
template filter(alias pred, Iterator) {
  import std.functional : unaryFun;

  import optional : Optional, Nothing;
  import variant : match;

  alias p = unaryFun!pred;
  alias T = ElementType!Iterator;

  struct Filter {
    Optional!T next() {
      auto n = iterator.next();
      while (!n.match!((T t) => p(t), _ => true))
        n = iterator.next();
      return n;
    }

  private:
    Iterator iterator;
  }

  Filter filter(Iterator iterator) {
    return Filter(iterator);
  }
}
