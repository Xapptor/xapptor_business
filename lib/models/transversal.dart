class Transversal {
  final String responsible;
  final String location;

  Transversal({
    required this.responsible,
    required this.location,
  });

  Transversal.from_snapshot(
    Map<String, dynamic> snapshot,
  )   : responsible = snapshot["responsible"],
        location = snapshot["location"];

  Map<String, dynamic> to_json() {
    return {
      "responsible": responsible,
      "location": location,
    };
  }

  factory Transversal.empty() {
    return Transversal(
      responsible: '',
      location: '',
    );
  }
}
