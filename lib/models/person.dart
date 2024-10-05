class Person {
  final String name;
  final String user_id;

  Person({
    required this.name,
    required this.user_id,
  });

  Person.from_snapshot(
    Map<String, dynamic> snapshot,
  )   : name = snapshot["name"],
        user_id = snapshot["user_id"];

  Map<String, dynamic> to_json() {
    return {
      "name": name,
      "user_id": user_id,
    };
  }

  factory Person.empty() {
    return Person(
      name: '',
      user_id: '',
    );
  }
}
