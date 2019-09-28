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

unittest {
  enum a = Optional!int(5);
  enum b = a.map!"a^^2";
  static assert(b.match!((int x) => x == 25, _ => false));
}

unittest {
  enum a = Optional!int(7);
  enum b = a.map!"a^^2";
  static assert(b.match!((int x) => x == 49, _ => false));
}

unittest {
  enum a = Optional!int(Nothing());
  enum b = a.map!"a^^2";
  static assert(b.match!((int) => false, _ => true));
}

/// map 
template map(alias fun, O) if (isOptional!O) {
  import std.functional : unaryFun;

  alias f = unaryFun!fun;
  alias T = ElementType!O;
  alias U = typeof(f(T.init));

  Optional!U map(O optional) {
    // dfmt off
    return optional.match!(
      (T t) => Optional!U(f(t)),
      _ => Optional!U(Nothing())
    );
    // dfmt on
  }
}
