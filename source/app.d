import traits;
import tensor;

extern (C) int main() {
  import std.typetuple : AliasSeq;

  static foreach (m; AliasSeq!(traits, tensor))
    static foreach (u; __traits(getUnitTests, m))
      u();

  return 0;
}
