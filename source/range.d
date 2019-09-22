@nogc @safe pure nothrow:

unittest {
  import std.array : staticArray;

  const a = [1, 5, 3, 2].staticArray;
}

