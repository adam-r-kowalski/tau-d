/// adl
template adl(string fun, string moduleName = __MODULE__) {
  auto adl(T)(ref auto T t) {
    import traits : moduleOf;

    static if (__traits(compiles, mixin("t." ~ fun)))
      return mixin("t." ~ fun);
    else static if (__traits(compiles, mixin("moduleOf!T." ~ fun ~ "(t)")))
      return mixin("moduleOf!T." ~ fun ~ "(t)");
    else {
      mixin("import " ~ moduleName ~ ";");
      static assert(__traits(compiles, mixin(moduleName ~ "." ~ fun ~ "(t)")),
          "adl lookup failed for function " ~ fun ~ " for type " ~ T.stringof
          ~ " in module " ~ moduleName);
      return mixin(moduleName ~ "." ~ fun ~ "(t)");
    }
  }
}

struct AdlWrapper(T, string moduleName = __MODULE__) {
  T obj;
  alias obj this;

  auto opDispatch(string method, Args...)(Args args) {
    return obj.adl!(method, moduleName)(args);
  }
}

AdlWrapper!(T, moduleName) adlWrap(T, string moduleName = __MODULE__)(T obj) {
  return AdlWrapper!(T, moduleName)(obj);
}

version(unittest) {
  struct S {}
  bool empty(S s) { return false; }
  int front(S s) { return 42; }
  void popFront(S s) {}
}

unittest {
  import std.range: take, only;
  import std.algorithm: equal;

  S s;
  assert(s.adlWrap.take(5).equal(only(42, 42, 42, 42, 42)));
}
