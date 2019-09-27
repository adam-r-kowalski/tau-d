import traits, tensor, range, variant, optional;

extern (C) int main() {
  import std.typetuple : AliasSeq;

  static foreach (m; AliasSeq!(traits, tensor, range, variant, optional))
    static foreach (u; __traits(getUnitTests, m))
      u();

  return 0;
}
