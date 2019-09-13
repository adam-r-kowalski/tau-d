/// isShape
template isShape(T) {
  import std.traits : isNumeric;

  static if (__traits(compiles, T.init.area))
    enum bool isShape = isNumeric!(typeof(T.init.area));
  else static if (__traits(compiles, ModuleOf!T.area))
    enum bool isShape = isNumeric!(typeof(ModuleOf!T.area(T.init)));
  else
    enum bool isShape = false;
}

/// ModuleOf
template ModuleOf(alias T) {
  import std.traits : moduleName;

  mixin("import " ~ moduleName!T ~ ";");
  mixin("alias ModuleOf = " ~ moduleName!T ~ ";");
}
