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
  required Function(List<Cabin> available_cabins) callback,
}) {
  List<Cabin> available_cabins = cabins.toList();

  available_cabins.sort((cabin_a, cabin_b) =>
      int.parse(cabin_a.id).compareTo(int.parse(cabin_b.id)));

  List<DateTime> new_reservation_range_dates =
      get_range_of_dates(selected_date_1, selected_date_2);

  List<String> unavailable_cabins = [];

  for (var reservation in reservations) {
    List<DateTime> reservation_range_dates = get_range_of_dates(
      reservation.date_init,
      DateTime(
        reservation.date_end.year,
        reservation.date_end.month,
        reservation.date_end.day - 1,
      ),
    );

    for (var range_date in reservation_range_dates) {
      for (var new_range_date in new_reservation_range_dates) {
        if (check_if_dates_are_in_the_same_day(range_date, new_range_date)) {
          if (ignore_reservation_with_id == null) {
            unavailable_cabins.add(reservation.cabin_id);
          } else {
            if (ignore_reservation_with_id != reservation.id) {
              unavailable_cabins.add(reservation.cabin_id);
            }
          }
        }
      }
    }
  }

  unavailable_cabins = unavailable_cabins.toSet().toList();

  for (var unavailable_cabin in unavailable_cabins) {
    available_cabins.removeWhere((cabin) => cabin.id == unavailable_cabin);
  }

  callback(available_cabins);

  return available_cabins;
}
