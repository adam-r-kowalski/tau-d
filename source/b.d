/// isShape
template isShape(T, string moduleName = __MODULE__) {
  import std.traits : isNumeric;

  import meta : adl;

  alias area = adl!("area", moduleName);
  static if (__traits(compiles, T.init.area))
    enum bool isShape = isNumeric!(typeof(T.init.area));
  else
    enum bool isShape = false;
}
