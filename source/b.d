/// isShape
template isShape(T) {
  import std.traits : isNumeric;

  import traits : moduleOf;

  static if (__traits(compiles, T.init.area))
    enum bool isShape = isNumeric!(typeof(T.init.area));
  else static if (__traits(compiles, moduleOf!T.area))
    enum bool isShape = isNumeric!(typeof(moduleOf!T.area(T.init)));
  else
    enum bool isShape = false;
}

