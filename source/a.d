unittest {
  import b : isShape;

  static assert(Square(5).area == 25);
  static assert(isShape!Square);
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

  static assert(Triangle(3, 5).area == 7.5);
  static assert(isShape!Triangle);
}

/// Triangle
struct Triangle {
  int base; /// base
  int height; /// height

  /// area
  @property float area() const {
    return base * height / 2.0;
  }
}

unittest {
  import std.math : abs;

  import b : isShape;

  static assert(abs(Circle(8).area - 201.0619298297) < 0.0000001);
  static assert(isShape!Circle);
}

/// Circle
struct Circle {
  int radius; /// area
}

/// area
float area()(ref const auto Circle c) {
  import std.math : PI;

  return PI * c.radius ^^ 2;
}

unittest {
  import b : isShape;

  static assert(!isShape!int);
  static assert(!isShape!float);
  static assert(!isShape!char);
  static assert(!isShape!bool);
  static assert(!isShape!(int[3]));
}
