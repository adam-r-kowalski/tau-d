@nogc @safe pure nothrow:

import std.range : isForwardRange;

unittest {
  import std.range : ElementType;
  import std.array : staticArray;
  import std.typecons : Tuple, tuple;

  const a = [1, 2, 3].staticArray;
  const b = [true, false, true].staticArray;

  auto c = zip(a[], b[]);
  assert(!c.empty);
  assert(c.front == tuple(1, true));
  c.popFront();
  assert(!c.empty);
  assert(c.front == tuple(2, false));
  assert(!c.empty);
  c.popFront();
  assert(c.front == tuple(3, true));
  assert(c.empty);
}

unittest {
  import std.array : staticArray;
  import std.typecons : tuple;

  enum a = [1, 2, 3].staticArray;
  enum b = [true, false, true].staticArray;
  enum c = zip(a[], b[]).staticArray!3;
  static assert(c == [tuple(1, true), tuple(2, false), tuple(3, true)]);
}

unittest {
  import std.array : staticArray;
  import std.algorithm : map, fold;

  const a = [1, 2, 3].staticArray;
  const b = [4, 5, 6].staticArray;
  const c = zip(a[], b[]).map!"a[0] * a[1]"
    .fold!"a + b"(0);
  static assert(c == 32);
}

/// zip
template zip(A, B) if (isForwardRange!A && isForwardRange!B) {
  import std.range : ElementType, empty, front, popFront;
  import std.typecons : Tuple, tuple;

  alias E = Tuple!(ElementType!A, ElementType!B);

  struct Zip {
    bool empty() const {
      return a.empty || b.empty;
    }

    E front() {
      return tuple(a.front, b.front);
    }

    void popFront() {
      a.popFront;
      b.popFront;
    }

  private:
    A a;
    B b;
  }

  Zip zip(A a, B b) {
    return Zip(a, b);
  }
}
