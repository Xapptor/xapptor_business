class Supervisor {
  String id;
  List<String> shift_ids;

  Supervisor({
    required this.id,
    required this.shift_ids,
  });

  Supervisor.from_snapshot(
    String id,
    Map snapshot,
  )   : id = id,
        shift_ids = snapshot['shifts'];

  Map<String, dynamic> to_json() {
    return {
      'shifts': shift_ids,
    };
  }
}
