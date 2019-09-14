/// moduleName
template moduleName(alias T) {
  import std.traits : TemplateOf;

  enum isTopLevel(alias E) = !__traits(compiles, __traits(parent, E));
  enum isPackage(alias E) = __traits(isPackage, E);
  enum isModule(alias E) = __traits(isModule, E);
  enum isTemplateInstance(alias E) = __traits(compiles, TemplateArgsOf!E);

  alias parentOf(alias E) = __traits(parent, E);

  string getModule(alias E)() {
    static if (isModule!E)
      static if (isTopLevel!E)
        static if (isPackage!E)
          return E.stringof[8 .. $];
        else
          return E.stringof[7 .. $];
      else
        return moduleName!(parentOf!E) ~ "." ~ E.stringof[7 .. $];
    else static if (isTemplateInstance!E)
      return getModule(TemplateOf!E);
    else
      return getModule!(parentOf!E);
  }

  enum moduleName = getModule!T;
}
