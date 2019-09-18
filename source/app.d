import traits;
import tensor;
import meta;

extern (C) int main() {
  import std.typetuple : AliasSeq;

  static foreach (m; AliasSeq!(traits, tensor, meta))
    static foreach (u; __traits(getUnitTests, m))
      u();

  return 0;
}
