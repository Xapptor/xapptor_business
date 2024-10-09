class Transversal {
  final String responsible;
  final String location;
  final String userid;

  Transversal({
    required this.responsible,
    required this.location,
    required this.userid,
  });

  Transversal.from_snapshot(
    Map<String, dynamic> snapshot,
  )   : responsible = snapshot["responsible"],
        location = snapshot["location"],
        userid = snapshot["userid"];

  Map<String, dynamic> to_json() {
    return {
      "responsible": responsible,
      "location": location,
      "userid": userid,
    };
  }

  factory Transversal.empty() {
    return Transversal(
      responsible: '',
      location: '',
      userid: '',
    );
  }
}
