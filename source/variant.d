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
