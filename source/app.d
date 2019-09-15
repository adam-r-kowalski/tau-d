import a;
import traits;

extern (C) int main() {
  import std.typetuple : AliasSeq;

  static foreach (m; AliasSeq!(traits, a))
    static foreach (u; __traits(getUnitTests, m))
      u();

  return 0;
}
