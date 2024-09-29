import 'package:cloud_firestore/cloud_firestore.dart';

class Condition {
  String? title;
  String? subtitle;
  String? description;
  DateTime? begin;
  DateTime? end;

  Condition({
    this.title,
    this.subtitle,
    this.description,
    this.begin,
    this.end,
  });

  Condition.from_snapshot(
    Map<dynamic, dynamic> snapshot,
  )   : title = snapshot['title'],
        subtitle = snapshot['subtitle'],
        description = snapshot['description'],
        begin = snapshot['begin'] != null
            ? (snapshot['begin'] as Timestamp).toDate()
            : null,
        end = snapshot['end'] != null
            ? (snapshot['end'] as Timestamp).toDate()
            : null;

  Map<String, dynamic> to_json() {
    return {
      'title': title,
      'subtitle': subtitle,
      'description': description,
      'begin': begin,
      'end': end,
    };
  }

  Map<String, dynamic> to_pretty_json() {
    return {
      'title': title,
      'subtitle': subtitle,
      'description': description,
      'begin': begin?.toIso8601String(),
      'end': end?.toIso8601String(),
    };
  }

  Condition.from_json(
    Map<String, dynamic> json,
  )   : title = json['title'],
        subtitle = json['subtitle'],
        description = json['description'],
        begin = json['begin'] != null ? DateTime.parse(json['begin']) : null,
        end = json['end'] != null ? DateTime.parse(json['end']) : null;

  factory Condition.empty() {
    return Condition(
      title: null,
      subtitle: null,
      description: null,
      begin: null,
      end: null,
    );
  }
}
