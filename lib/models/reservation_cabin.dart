// Cabine Reservation model.

import 'reservation.dart';

class ReservationCabin extends Reservation {
  const ReservationCabin({
    required String id,
    required String user_id,
    required DateTime date_created,
    required DateTime date_init,
    required DateTime date_end,
    required this.cabin_id,
    required this.payments,
  }) : super(
          id: id,
          user_id: user_id,
          date_created: date_created,
          date_init: date_init,
          date_end: date_end,
        );

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
