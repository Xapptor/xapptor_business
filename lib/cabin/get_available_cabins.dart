import 'package:xapptor_business/cabin/get_reservation_from_id.dart';
import 'package:xapptor_business/models/cabin.dart';
import 'package:xapptor_business/models/reservation_cabin.dart';
import 'package:xapptor_logic/check_if_dates_are_in_the_same_day.dart';
import 'package:xapptor_logic/get_range_of_dates.dart';

List<Cabin> get_available_cabins({
  String? ignore_reservation_with_id,
  required List<Cabin> cabins,
  required List<ReservationCabin> reservations,
  required DateTime selected_date_1,
  required DateTime selected_date_2,
  required String selected_cabin,
}) {
  List<Cabin> available_cabins = cabins.toList();

  available_cabins.sort((cabin_a, cabin_b) =>
      int.parse(cabin_a.id).compareTo(int.parse(cabin_b.id)));

  List<DateTime> new_reservation_range_dates =
      get_range_of_dates(selected_date_1, selected_date_2);

  List<String> unavailable_cabins = [];

  reservations.forEach((reservation) {
    List<DateTime> reservation_range_dates = get_range_of_dates(
      reservation.date_init,
      DateTime(
        reservation.date_end.year,
        reservation.date_end.month,
        reservation.date_end.day - 1,
      ),
    );

    reservation_range_dates.forEach((range_date) {
      new_reservation_range_dates.forEach((new_range_date) {
        if (check_if_dates_are_in_the_same_day(range_date, new_range_date)) {
          if (ignore_reservation_with_id == null) {
            unavailable_cabins.add(reservation.cabin_id);
          } else {
            if (ignore_reservation_with_id != reservation.id) {
              unavailable_cabins.add(reservation.cabin_id);
            }
          }
        }
      });
    });
  });

  unavailable_cabins = unavailable_cabins.toSet().toList();

  unavailable_cabins.forEach((unavailable_cabin) {
    available_cabins.removeWhere((cabin) => cabin.id == unavailable_cabin);
  });

  if (available_cabins.length > 0) {
    if (ignore_reservation_with_id == null) {
      selected_cabin = available_cabins.first.id;
    } else {
      selected_cabin = get_reservation_from_id(
        id: ignore_reservation_with_id,
        reservations: reservations,
      ).cabin_id;
    }
  }
  return available_cabins;
}
