@nogc @safe pure nothrow:

/// Tensor is a generalization of a scalar, vector, and matrix
struct Tensor(T, Dims...) {
}

/// Tensor factory
Tensor!(T, Dims) tensor(T, Dims...)() {
  return Tensor!(T, Dims)();
}

unittest {
  import std.array : staticArray;

  enum a = tensor!(int, 2, 3);
  static assert(a.shape == [2, 3].staticArray);
  assert(a.shape == [2, 3].staticArray);

  enum b = tensor!(int, 3, 5, 7);
  static assert(b.shape == [3, 5, 7].staticArray);
  assert(b.shape == [3, 5, 7].staticArray);
}

/// The length of each dimension of the Tensor
size_t[Dims.length] shape(T, Dims...)(ref auto const Tensor!(T, Dims)) {
  return [Dims];
}

unittest {
  static assert(is(ElementType!(Tensor!(int, 2, 3)) == int));
  static assert(is(ElementType!(Tensor!(float, 2, 3)) == float));
}

/// The element type of the Tensor
alias ElementType(T : Tensor!(U, Dims), U, Dims...) = U;

unittest {
  static assert(isTensor!(Tensor!(int, 2, 3)));
}

/**
  A type is considered to be a Tensor if has a shape
  and a element type. It should also be possible to index
  the tensor with the same number of indices as the tensors rank.
**/
template isTensor(T) {
  import std.traits : isStaticArray;

  enum bool isTensor = isStaticArray!(typeof(T.init.shape)) && is(ElementType!T);
}

unittest {
  enum a = tensor!(int, 3, 5);
  static assert(a.rank == 2);
  assert(a.rank == 2);

  enum b = tensor!(int, 3, 5, 7);
  static assert(b.rank == 3);
  assert(b.rank == 3);
}

/// The rank or number of dimensions of a tensor
size_t rank(T)(ref auto const T t) if (isTensor!T) {
  return t.shape.length;
}

unittest {
  enum a = tensor!(int, 3, 2);
  static assert(a.length == 6);
  assert(a.length == 6);
}

/// The length or total number of elements of a tensor
size_t length(T)(ref auto const T t) if (isTensor!T) {
  size_t result = 1;
  foreach (e; t.shape)
    result *= e;
  return result;
}
