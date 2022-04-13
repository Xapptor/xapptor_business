// Cabine Reservation model.

import 'reservation.dart';

class CabinReservation extends Reservation {
  const CabinReservation({
    required String id,
    required String user_id,
    required DateTime date_created,
    required DateTime date_init,
    required DateTime date_end,
    required this.cabin_id,
  }) : super(
          id: id,
          user_id: user_id,
          date_created: date_created,
          date_init: date_init,
          date_end: date_end,
        );

  final String cabin_id;

  factory CabinReservation.from_snapshot(
    String id,
    Map<String, dynamic> snapshot,
  ) {
    Reservation reservation = Reservation.from_snapshot(id, snapshot);
    return CabinReservation(
      id: id,
      user_id: reservation.user_id,
      date_created: reservation.date_created,
      date_init: reservation.date_init,
      date_end: reservation.date_end,
      cabin_id: snapshot['cabin_id'],
    );
  }
}
