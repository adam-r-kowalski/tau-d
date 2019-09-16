/// isShape
template isShape(T, string moduleName = __MODULE__) {
  import std.traits : isNumeric;

  import meta : adl;

  alias area = adl!("area", moduleName);

  enum bool isShape = isNumeric!(typeof(T.init.area));
}
