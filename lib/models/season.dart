class Season {
  SeasonType type;
  DateTime begin;
  DateTime end;

  Season({
    required this.type,
    required this.begin,
    required this.end,
  });
}

enum SeasonType {
  low,
  high,
}
