import 'package:cloud_firestore/cloud_firestore.dart';

class Condition {
  DateTime? date_corrected;
  String? promptly_corrected;
  String? not_promptly_corrected;
  String? mitigating_action;

  Condition({
    required this.date_corrected,
    required this.promptly_corrected,
    required this.not_promptly_corrected,
    required this.mitigating_action,
  });

  Condition.from_snapshot(
    Map<dynamic, dynamic> snapshot,
  )   : date_corrected = snapshot['date_corrected'] != null
            ? (snapshot['date_corrected'] as Timestamp).toDate()
            : null,
        promptly_corrected = snapshot["promptly_corrected"],
        not_promptly_corrected = snapshot["not_promptly_corrected"],
        mitigating_action = snapshot["mitigating_action"];

  Map<String, dynamic> to_json() => {
        "date_corrected": date_corrected,
        "promptly_corrected": promptly_corrected,
        "not_promptly_corrected": not_promptly_corrected,
        "mitigating_action": mitigating_action,
      };

  factory Condition.empty() {
    return Condition(
      date_corrected: null,
      promptly_corrected: null,
      not_promptly_corrected: null,
      mitigating_action: null,
    );
  }
}
