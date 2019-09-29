@nogc @safe pure nothrow:

/// Nothing
struct Nothing {
}

unittest {
  enum a = optional(5);
  static assert(a.match!((int) => true, _ => false));
}

/// Optional2
template Optional(T) {
  import variant : Variant;

  struct Optional {
  private:
    Variant!(T, Nothing) data;
  }
}

/// optional
template optional(T) {
  import variant : Variant;

  Optional!T optional(T value) {
    return Optional!T(Variant!(T, Nothing)(value));
  }

  Optional!T optional() {
    return Optional!T(Variant!(T, Nothing)(Nothing()));
  }
}

/// match
template match(funs...) {
  import variant : match;

  auto match(T)(Optional!T optional) {
    return optional.data.match!funs;
  }
}

unittest {
  alias A = Optional!int;
  static assert(isOptional!A);

  alias B = Optional!bool;
  static assert(isOptional!B);

  static assert(!isOptional!int);
}

/// isOptional
enum bool isOptional(T) = is(ElementType!T);

unittest {
  alias A = Optional!int;
  static assert(is(ElementType!A == int));

  alias B = Optional!bool;
  static assert(is(ElementType!B == bool));
}

alias ElementType(T : Optional!U, U) = U;

unittest {
  enum a = optional(5);
  enum b = a.map!"a^^2";
  static assert(b.match!((int x) => x == 25, _ => false));
}

unittest {
  enum a = optional(7);
  enum b = a.map!"a^^2";
  static assert(b.match!((int x) => x == 49, _ => false));
}

unittest {
  enum a = optional!int();
  enum b = a.map!"a^^2";
  static assert(b.match!((int) => false, _ => true));
}

/// map 
template map(alias fun, O) if (isOptional!O) {
  import std.functional : unaryFun;

  alias f = unaryFun!fun;
  alias T = ElementType!O;
  alias U = typeof(f(T.init));

  Optional!U map(O o) {
    return o.match!((T t) => optional(f(t)), _ => optional!U());
  }
}
