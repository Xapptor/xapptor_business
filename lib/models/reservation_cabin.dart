// Cabine Reservation model.

import 'reservation.dart';

class ReservationCabin extends Reservation {
  const ReservationCabin({
    required super.id,
    required super.user_id,
    required super.date_created,
    required super.date_init,
    required super.date_end,
    required this.cabin_id,
    required this.payments,
  });

  final String cabin_id;
  final List<String> payments;

  factory ReservationCabin.from_snapshot(
    String id,
    Map<String, dynamic> snapshot,
  ) {
    Reservation reservation = Reservation.from_snapshot(id, snapshot);
    return ReservationCabin(
      id: id,
      user_id: reservation.user_id,
      date_created: reservation.date_created,
      date_init: reservation.date_init,
      date_end: reservation.date_end,
      cabin_id: snapshot['cabin_id'],
      payments: List<String>.from(snapshot['payments'] ?? []),
    );
  }

  @override
  Map<String, dynamic> to_json() {
    return {
      'id': id,
      'user_id': user_id,
      'date_created': date_created,
      'date_init': date_init,
      'date_end': date_end,
      'cabin_id': cabin_id,
      'payments': payments,
    };
  }
}
