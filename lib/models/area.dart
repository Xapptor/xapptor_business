class Area {
  final String area;
  final String department;

  Area({
    required this.area,
    required this.department,
  });

  Area.from_snapshot(
    Map<String, dynamic> snapshot,
  )   : area = snapshot["area"],
        department = snapshot["department"];

  Map<String, dynamic> to_json() {
    return {
      "area": area,
      "department": department,
    };
  }

  factory Area.empty() {
    return Area(
      area: '',
      department: '',
    );
  }
}
