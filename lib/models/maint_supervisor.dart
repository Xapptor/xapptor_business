class MaintSupervisor {
  late final String name;
  final String user_id;

  MaintSupervisor({
    required this.name,
    required this.user_id,
  });

  factory MaintSupervisor.empty() {
    return MaintSupervisor(
      name: '',
      user_id: '',
    );
  }
}
