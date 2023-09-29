enum Bed {
  king,
  queen,
  double,
  single,
}

extension ParseToString on Bed {
  String toShortString() {
    return toString().split('.').last;
  }
}
