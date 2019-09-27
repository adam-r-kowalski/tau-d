@nogc @safe pure nothrow:

import variant : Variant, match;

unittest {
  enum a = Optional!int(5);
  static assert(a.match!((int) => true, _ => false));
}

/// Nothing
struct Nothing {
}

/// Optional
alias Optional(T) = Variant!(T, Nothing);
