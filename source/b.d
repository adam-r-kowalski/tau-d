/// isShape
template isShape(T, string moduleName = __MODULE__) {
  import std.traits : isNumeric;

  import traits : moduleOf;

  static if (__traits(compiles, T.init.area))
    enum bool isShape = isNumeric!(typeof(T.init.area));
  else static if (__traits(compiles, moduleOf!T.area)) {
    alias area = moduleOf!T.area;
    enum bool isShape = isNumeric!(typeof(T.init.area));
  }
  else {
    mixin("import " ~ moduleName ~ ";");
    mixin("alias area = " ~ moduleName ~ ".area;");

    static if (__traits(compiles, T.init.area))
      enum bool isShape = isNumeric!(typeof(T.init.area));
    else
      enum bool isShape = false;
  }
}
