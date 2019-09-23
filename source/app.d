import traits, tensor, range, variant;

extern (C) int main() {
  import std.typetuple : AliasSeq;

  static foreach (m; AliasSeq!(traits, tensor, range, variant))
    static foreach (u; __traits(getUnitTests, m))
      u();

  return 0;
}
