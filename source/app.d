import a;

extern (C) int main() {
  static foreach (u; __traits(getUnitTests, a))
    u();

  return 0;
}
