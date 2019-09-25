@nogc @safe pure nothrow:

@trusted unittest {
  enum a = Variant!(string, float)("hello");
  static assert(a.data_0 == "hello");
  static assert(a.tag_ == typeof(a).Tag.tag_0);

  enum b = Variant!(string, float)(5.3);
  static assert(b.data_1 == 5.3);
  static assert(b.tag_ == typeof(b).Tag.tag_1);
}

@trusted unittest {
  const a = Variant!(string, float)("hello");
  assert(a.data_0 == "hello");
  assert(a.tag_ == typeof(a).Tag.tag_0);

  const b = Variant!(string, float)(5.3);
  assert(b.data_1 == cast(float) 5.3);
  assert(b.tag_ == typeof(b).Tag.tag_1);
}

@trusted unittest {
  auto a = Variant!(string, float)("hello");
  assert(a.data_0 == "hello");
  assert(a.tag_ == typeof(a).Tag.tag_0);

  a = Variant!(string, float)(3.7);
  assert(a.data_1 == cast(float) 3.7);
  assert(a.tag_ == typeof(a).Tag.tag_1);

  a = Variant!(string, float)("goodbye");
  assert(a.data_0 == "goodbye");
  assert(a.tag_ == typeof(a).Tag.tag_0);
}

@trusted unittest {
  Variant!(string, float) a = "hello";
  assert(a.data_0 == "hello");
  assert(a.tag_ == typeof(a).Tag.tag_0);

  a = 3.7;
  assert(a.data_1 == cast(float) 3.7);
  assert(a.tag_ == typeof(a).Tag.tag_1);

  a = "goodbye";
  assert(a.data_0 == "goodbye");
  assert(a.tag_ == typeof(a).Tag.tag_0);
}

@trusted unittest {
  Variant!(string, float, bool) a = "hello";
  assert(a.data_0 == "hello");
  assert(a.tag_ == typeof(a).Tag.tag_0);

  a = 3.7;
  assert(a.data_1 == cast(float) 3.7);
  assert(a.tag_ == typeof(a).Tag.tag_1);

  a = false;
  assert(a.data_2 == false);
  assert(a.tag_ == typeof(a).Tag.tag_2);

  a = "goodbye";
  assert(a.data_0 == "goodbye");
  assert(a.tag_ == typeof(a).Tag.tag_0);
}

/// Variant
struct Variant(Ts...) {

  /// constructor
  static foreach (i; 0 .. Ts.length)
    @trusted this(Ts[i] _) {
      mixin(generateAssignment!i);
    }

  /// assignment
  static foreach (i; 0 .. Ts.length)
    @trusted void opAssign(Ts[i] _) {
      mixin(generateAssignment!i);
    }

private:
  union {
    static foreach (i; 0 .. Ts.length)
      mixin(generateUnion!i);
  }

  mixin(generateEnum!(Ts.length));

  Tag tag_;
}

unittest {
  enum Variant!(string, bool, float) a = false;
  static assert(a.match!((string _) => 1, (bool _) => 2, (float _) => 3) == 2);

  enum Variant!(string, bool, float) b = "hello";
  static assert(b.match!((string _) => 1, (bool _) => 2, (float _) => 3) == 1);

  enum Variant!(string, bool, float) c = 7.3;
  static assert(c.match!((string _) => 1, (bool _) => 2, (float _) => 3) == 3);
}

version (unittest) {
  int f(string) {
    return 1;
  }

  int f(float) {
    return 2;
  }

  int f(bool) {
    return 3;
  }
}

unittest {
  enum Variant!(string, float, bool) a = "hello";
  static assert(a.match!f == 1);

  enum Variant!(string, float, bool) b = 3.5;
  static assert(b.match!f == 2);

  enum Variant!(string, float, bool) c = false;
  static assert(c.match!f == 3);
}

template match(funs...) {
  template fun(alias T) {
    import std.meta : Filter;

    enum bool callableWith(alias fun) = is(typeof(fun(T.init)));
    alias filtered_funs = Filter!(callableWith, funs);
    static if (filtered_funs.length > 0)
      alias fun = filtered_funs[0];
    else {
      enum string message = () {
        string message = "\npattern matching failed for type " ~ T.stringof;
        message ~= "\n" ~ funs.stringof;
        return message;
      }();
      static assert(0, message);
    }
  }

  @trusted auto match(Ts...)(auto ref const Variant!Ts v) {
    return () { mixin(generateSwitch!(Ts.length)); }();
  }
}

private:

unittest {
  enum expected = "data_0 = _;
tag_ = Tag.tag_0;";

  enum actual = generateAssignment!0;
  static assert(expected == actual);
}

unittest {
  enum expected = "data_1 = _;
tag_ = Tag.tag_1;";

  enum actual = generateAssignment!1;
  static assert(expected == actual);
}

string generateAssignment(size_t N)() {
  enum string result = () {
    enum int n = cast(int) N;
    string result = "data_" ~ n.stringof ~ " = _;\n";
    result ~= "tag_ = Tag.tag_" ~ n.stringof ~ ";";
    return result;
  }();
  return result;
}

unittest {
  enum expected = "Ts[i] data_0;";
  enum actual = generateUnion!0;
  static assert(expected == actual);
}

unittest {
  enum expected = "Ts[i] data_1;";
  enum actual = generateUnion!1;
  static assert(expected == actual);
}

string generateUnion(size_t N)() {
  enum string result = () {
    enum int n = cast(int) N;
    return "Ts[i] data_" ~ n.stringof ~ ";";
  }();
  return result;
}

unittest {
  enum expected = "enum Tag {
  tag_0,
  tag_1,
}";

  enum actual = generateEnum!2;

  static assert(expected == actual);
}

unittest {
  enum expected = "enum Tag {
  tag_0,
  tag_1,
  tag_2,
}";

  enum actual = generateEnum!3;

  static assert(expected == actual);
}

/// generateTag
string generateEnum(size_t N)() {
  enum string tag = () {
    string result;
    result ~= "enum Tag {\n";
    static foreach (i; 0 .. cast(int) N)
      result ~= "  tag_" ~ i.stringof ~ ",\n";
    return result ~ "}";
  }();
  return tag;
}

unittest {
  enum string expected = "final switch (v.tag_) with (typeof(v).Tag) {
case tag_0:
  return fun!(Ts[0])(v.data_0);
case tag_1:
  return fun!(Ts[1])(v.data_1);
case tag_2:
  return fun!(Ts[2])(v.data_2);
}";

  enum string actual = generateSwitch!3;

  static assert(expected == actual);
}

string generateSwitch(size_t n)() {
  enum string result = () {
    string result = "final switch (v.tag_) with (typeof(v).Tag) {\n";
    static foreach (int i; 0 .. n) {
      result ~= "case tag_" ~ i.stringof ~ ":\n";
      result ~= "  return fun!(Ts[" ~ i.stringof ~ "])(v.data_" ~ i.stringof ~ ");\n";
    }
    return result ~ "}";
  }();
  return result;
}
