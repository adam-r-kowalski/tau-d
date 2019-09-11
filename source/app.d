import tensor;

extern (C) void main() {
  static foreach (u; __traits(getUnitTests, __traits(parent, tensor)))
    u();
}
