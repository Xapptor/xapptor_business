import 'package:cloud_firestore/cloud_firestore.dart';

class Hazard {
  final String id;
  final List<String> burns;
  final List<String> falls;
  final List<String> healths;
  final List<String> hit_or_caughts;
  final List<String> lototos;
  final List<String> work_conditions;

  const Hazard({
    required this.id,
    required this.burns,
    required this.falls,
    required this.healths,
    required this.hit_or_caughts,
    required this.lototos,
    required this.work_conditions,
  });

  Hazard.from_snapshot(DocumentSnapshot snapshot)
      : id = snapshot.id,
        burns = (snapshot['burns'] as List).map((e) => e as String).toList(),
        falls = (snapshot['falls'] as List).map((e) => e as String).toList(),
        healths =
            (snapshot['healths'] as List).map((e) => e as String).toList(),
        hit_or_caughts = (snapshot['hit_or_caughts'] as List)
            .map((e) => e as String)
            .toList(),
        lototos =
            (snapshot['lototos'] as List).map((e) => e as String).toList(),
        work_conditions = (snapshot['work_conditions'] as List)
            .map((e) => e as String)
            .toList();

  Map<String, dynamic> to_json() {
    return {
      "burns": burns,
      "falls": falls,
      "healths": healths,
      "hit_or_caughts": hit_or_caughts,
      "lototos": lototos,
      "work_conditions": work_conditions,
    };
  }
}
