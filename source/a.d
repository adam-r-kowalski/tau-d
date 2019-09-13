unittest {
  import b : isShape;

  assert(Square(5).area == 25);
  assert(isShape!Square);
}

/// Square
struct Square {
  int length; /// length
  int area; /// area 

  /// constructor
  this(int length) {
    this.length = length;
    area = length ^^ 2;
  }
}

unittest {
  import b : isShape;

  assert(Triangle(3, 5).area == 7.5);
  assert(isShape!Triangle);
}

/// Triangle
struct Triangle {
  int base; /// base
  int height; /// height

  /// area
  @property float area() {
    return base * height / 2.0;
  }
}

unittest {
  import b : isShape;

  assert(Circle(8).area == 5);
  static assert(isShape!Circle);
}

/// Circle
struct Circle {
  int radius; /// area
}

/// area
int area(Circle) {
  return 5;
}

unittest {
  import b : isShape;

  static assert(!isShape!int);
  static assert(!isShape!float);
  static assert(!isShape!char);
  static assert(!isShape!bool);
  static assert(!isShape!(int[3]));
}
