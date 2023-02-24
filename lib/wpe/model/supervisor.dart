class Supervisor {
  String id;
  List<String> shifts;

  Supervisor({
    required this.id,
    required this.shifts,
  });

  Supervisor.from_snapshot(
    String id,
    Map<String, dynamic> snapshot,
  )   : id = id,
        shifts = snapshot['shifts'];

  Map<String, dynamic> to_json() {
    return {
      'shifts': shifts,
    };
  }
}
