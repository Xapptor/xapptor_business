class Person {
  final String person;
  final String person_userid;

  Person({
    required this.person,
    required this.person_userid,
  });

  Person.from_snapshot(
    Map<String, dynamic> snapshot,
  )   : person = snapshot["person"],
        person_userid = snapshot["person_userid"];

  Map<String, dynamic> to_json() {
    return {
      "person": person,
      "person_userid": person_userid,
    };
  }

  factory Person.empty() {
    return Person(
      person: '',
      person_userid: '',
    );
  }
}
