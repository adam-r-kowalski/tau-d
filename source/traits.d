unittest {
  import std.array : staticArray;
  import std.algorithm : fold;
  import std.stdio : printf;

  static assert(moduleName!fold == "std.algorithm.iteration");
  static assert(moduleName!staticArray == "std.array");
  static assert(moduleName!printf == "core.stdc.stdio");
  static assert(!__traits(compiles, moduleName!int));
  static assert(!__traits(compiles, moduleName!string));
}

/// moduleName
template moduleName(alias T) {
  alias parent(alias T) = __traits(parent, T);
  enum bool isPackage(alias T) = __traits(isPackage, T);

  string trimModuleName(alias T)() {
    static if (isPackage!T)
      return T.stringof[8 .. $];
    else
      return T.stringof[7 .. $];
  }

  static if (__traits(compiles, parent!T))
    static if (__traits(isModule, T) || isPackage!T)
      enum string moduleName = moduleName!(parent!T) ~ "." ~ trimModuleName!T;
    else
      enum string moduleName = moduleName!(parent!T);
  else
    enum string moduleName = trimModuleName!T;
}

/// moduleOf
template moduleOf(alias T) {
  mixin("import " ~ moduleName!T ~ ";");
  mixin("alias moduleOf = " ~ moduleName!T ~ ";");
}

/// isTensor
template isTensor(T, string moduleName = __MODULE__) {
  import std.traits : isArray;

  import meta : adl;

  alias shape = adl!("shape", moduleName);
  static if (is(typeof(T.init.shape)))
    enum bool isTensor = isArray!(typeof(T.init.shape));
  else
    enum bool isTensor = false;
}
