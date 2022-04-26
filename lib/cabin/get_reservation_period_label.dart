import 'package:intl/intl.dart';
import 'package:xapptor_business/models/reservation_cabin.dart';

String get_reservation_period_label({
  required int index,
  required bool show_creation_menu,
  required List<ReservationCabin> reservations,
  required DateTime selected_date_1,
  required DateTime selected_date_2,
  required String source_language,
}) {
  String reservation_period_label = "";

  DateTime date_to_use_1 =
      show_creation_menu ? selected_date_1 : reservations[index].date_init;

  DateTime date_to_use_2 =
      show_creation_menu ? selected_date_2 : reservations[index].date_init;

  String month_day_1 =
      DateFormat("MMMMd", source_language).format(date_to_use_1);

  String month_day_2 =
      DateFormat("MMMMd", source_language).format(date_to_use_2);

  String month_1 = DateFormat("MMMM", source_language).format(date_to_use_1);

  String month_2 = DateFormat("MMMM", source_language).format(date_to_use_2);

  if (selected_date_1.month == selected_date_2.month) {
    month_1 = month_1.substring(0, 1).toUpperCase() + month_1.substring(1);

    if (index == -1) {
      reservation_period_label =
          "$month_1 ${selected_date_1.day} - ${selected_date_2.day}, ${DateFormat("yyyy").format(selected_date_1)}.";
    } else {
      reservation_period_label =
          "$month_1 ${reservations[index].date_init.day} - ${reservations[index].date_end.day}, ${DateFormat("yyyy").format(selected_date_1)}.";
    }
  } else {
    int month_day_1_first_letter_index = month_day_1.indexOf(month_1);

    int month_day_2_first_letter_index = month_day_2.indexOf(month_2);

    month_day_1 = month_day_1.substring(0, month_day_1_first_letter_index) +
        month_day_1
            .substring(month_day_1_first_letter_index,
                month_day_1_first_letter_index + 1)
            .toUpperCase() +
        month_day_1.substring(month_day_1_first_letter_index + 1);

    month_day_2 = month_day_2.substring(0, month_day_2_first_letter_index) +
        month_day_2
            .substring(month_day_2_first_letter_index,
                month_day_2_first_letter_index + 1)
            .toUpperCase() +
        month_day_2.substring(month_day_2_first_letter_index + 1);

    reservation_period_label =
        "$month_day_1 - $month_day_2, ${DateFormat("yyyy").format(selected_date_1)}.";
  }
  return reservation_period_label;
}
