import 'package:cloud_firestore/cloud_firestore.dart';

class Reservation {
  final String id;
  final String user_id;
  final DateTime date_created;
  final DateTime date_init;
  final DateTime date_end;

  const Reservation({
    required this.id,
    required this.user_id,
    required this.date_created,
    required this.date_init,
    required this.date_end,
  });

  Reservation.from_snapshot(
    this.id,
    Map<String, dynamic> snapshot,
  )   : user_id = snapshot['user_id'],
        date_created = (snapshot['date_created'] as Timestamp).toDate(),
        date_init = (snapshot['date_init'] as Timestamp).toDate(),
        date_end = (snapshot['date_end'] as Timestamp).toDate();

  Map<String, dynamic> to_json() {
    return {
      'id': id,
      'user_id': user_id,
      'date_created': date_created,
      'date_init': date_init,
      'date_end': date_end,
    };
  }
}
