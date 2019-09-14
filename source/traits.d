unittest {
  import std.stdio : printf;
  import std.array : staticArray;

  alias T = moduleName!staticArray;
  T.stringof.printf;
}

/// moduleName
template moduleName(alias T) {
  enum bool isModule(alias M) = __traits(isModule, M);
  alias parentOf(alias M) = __traits(parent, M);
  enum bool isTopLevel(alias M) = !__traits(compiles, parentOf!M);

  template getModule(alias M) if (isModule!M) {
    string getModule()() if (isTopLevel!M) {
      static if (__traits(isPackage, M))
        return M.stringof[8 .. $];
      else
        return M.stringof[7 .. $];
    }

    string getModule()() if (!isTopLevel!M) {
      return moduleName!(parentOf!M) ~ "." ~ M.stringof[7 .. $];
    }
  }

  enum bool isTemplateInstance(alias M) = __traits(compiles, TemplateArgsOf!M);

  string getModule(alias M)() if (isTemplateInstance!M) {
    import std.traits : TemplateOf;

    return getModule!(TemplateOf!M)();
  }

  string getModule(alias M)() if (!isModule!M && !isTemplateInstance!M) {
    return getModule!(parentOf!M)();
  }

  enum moduleName = getModule!T;
}
