@nogc @safe pure nothrow:

@trusted unittest {
  enum a = Variant!(string, float)("hello");
  static assert(a.string_ == "hello");
  static assert(a.tag_ == typeof(a).Tag.string_tag);

  enum b = Variant!(string, float)(5.3);
  static assert(b.float_ == 5.3);
  static assert(b.tag_ == typeof(b).Tag.float_tag);
}

@trusted unittest {
  const a = Variant!(string, float)("hello");
  assert(a.string_ == "hello");
  assert(a.tag_ == typeof(a).Tag.string_tag);

  const b = Variant!(string, float)(5.3);
  assert(b.float_ == cast(float) 5.3);
  assert(b.tag_ == typeof(b).Tag.float_tag);
}

@trusted unittest {
  auto a = Variant!(string, float)("hello");
  assert(a.string_ == "hello");
  assert(a.tag_ == typeof(a).Tag.string_tag);

  a = Variant!(string, float)(3.7);
  assert(a.float_ == cast(float) 3.7);
  assert(a.tag_ == typeof(a).Tag.float_tag);

  a = Variant!(string, float)("goodbye");
  assert(a.string_ == "goodbye");
  assert(a.tag_ == typeof(a).Tag.string_tag);
}

@trusted unittest {
  Variant!(string, float) a = "hello";
  assert(a.string_ == "hello");
  assert(a.tag_ == typeof(a).Tag.string_tag);

  a = 3.7;
  assert(a.float_ == cast(float) 3.7);
  assert(a.tag_ == typeof(a).Tag.float_tag);

  a = "goodbye";
  assert(a.string_ == "goodbye");
  assert(a.tag_ == typeof(a).Tag.string_tag);
}

/// Variant
struct Variant(Ts...) {

  /// constructor
  static foreach (T; Ts)
    @trusted this(T t) {
      mixin(T.stringof ~ "_ = t;");
      mixin("tag_ = Tag." ~ T.stringof ~ "_tag;");
    }

  /// assignment
  static foreach (T; Ts)
    @trusted void opAssign(T t) {
      mixin(T.stringof ~ "_ = t;");
      mixin("tag_ = Tag." ~ T.stringof ~ "_tag;");
    }

private:
  union {
    static foreach (T; Ts)
      mixin("T " ~ T.stringof ~ "_;");
  }

  enum Tag {
    string_tag,
    float_tag
  }

  Tag tag_;
}
