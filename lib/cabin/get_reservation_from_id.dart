import 'package:xapptor_business/models/reservation_cabin.dart';

ReservationCabin get_reservation_from_id({
  required String id,
  required List<ReservationCabin> reservations,
}) {
  return reservations.firstWhere((reservation) => reservation.id == id);
}
