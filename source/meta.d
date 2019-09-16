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
          "adl lookup failed for function " ~ fun ~ " in module " ~ moduleName);
      return mixin(moduleName ~ "." ~ fun ~ "(t)");
    }
  }
}
