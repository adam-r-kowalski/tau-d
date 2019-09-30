@nogc @safe pure nothrow:

import std.range : isForwardRange;

unittest {
  static assert([1, 2, 3, 4, 5].product == 120);
}

/// product
template product(Range) if (isForwardRange!Range) {
  import std.range : ElementType;
  import std.algorithm : fold;

  alias E = ElementType!Range;

  E product(ref auto const Range range) {
    return range.fold!"a * b"(E(1));
  }
}
