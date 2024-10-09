class Supervisor {
  late final String name;
  final String user_id;
  final String department_name;

  Supervisor({
    required this.name,
    required this.user_id,
    required this.department_name,
  });

  factory Supervisor.empty() {
    return Supervisor(
      name: '',
      user_id: '',
      department_name: '',
    );
  }
}
