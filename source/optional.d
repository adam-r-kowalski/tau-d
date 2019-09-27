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

unittest {
  alias A = Optional!int;
  static assert(isOptional!A);

  alias B = Optional!bool;
  static assert(isOptional!B);

  static assert(!isOptional!int);
}

/// isOptional
enum bool isOptional(T) = is(T : Variant!(U, Nothing), U);

unittest {
  alias A = Optional!int;
  static assert(is(ElementType!A == int));

  alias B = Optional!bool;
  static assert(is(ElementType!B == bool));
}

alias ElementType(T : Variant!(U, Nothing), U) = U;
