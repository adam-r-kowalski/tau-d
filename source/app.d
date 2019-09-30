import optional, traits, algorithm, range, tensor, variant, meta, layout;

/// moduleOf
template moduleOf(alias T) {
  static if (__traits(isModule, T))
    alias moduleOf = T;
  else
    alias moduleOf = moduleOf!(__traits(parent, T));
}

extern (C) int main() {
  import std.typetuple : AliasSeq;

  static foreach (m; AliasSeq!(optional, traits, algorithm, range, tensor, variant, meta, layout))
    static foreach (u; __traits(getUnitTests, moduleOf!m))
      u();

  return 0;
}
