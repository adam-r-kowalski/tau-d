import b : isShape;
import c : Rectangle;

unittest {
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
  import std.math : approxEqual;

  static assert(approxEqual(Circle(8).area, 201.0619298297));
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
  static assert(!isShape!int);
  static assert(!isShape!float);
  static assert(!isShape!char);
  static assert(!isShape!bool);
  static assert(!isShape!(int[3]));
}

unittest {
  static assert(Rectangle(5, 10).area == 50);
  static assert(isShape!Rectangle);
}

/// area
int area()(ref auto const Rectangle r) {
  return r.width * r.height;
}

unittest {
  import std.math : approxEqual;

  import meta : adl;

  alias area = adl!"area";

  static assert(Square(10).area == 100);
  static assert(Triangle(5, 10).area == 25);
  static assert(approxEqual(Circle(5).area, 78.5398163397));
  static assert(Rectangle(5, 10).area == 50);
}
