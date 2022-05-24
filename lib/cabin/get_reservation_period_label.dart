import 'package:intl/intl.dart';

String get_reservation_period_label({
  required DateTime date_1,
  required DateTime date_2,
  required String source_language,
}) {
  String reservation_period_label = "";

  String month_1 = DateFormat("MMMM", source_language).format(date_1);
  String month_2 = DateFormat("MMMM", source_language).format(date_2);

  if (date_1.month == date_2.month) {
    month_1 = month_1.substring(0, 1).toUpperCase() + month_1.substring(1);

    reservation_period_label =
        "$month_1 ${date_1.day} - ${date_2.day}, ${DateFormat("yyyy").format(date_1)}.";
  } else {
    String month_day_1 = DateFormat("MMMMd", source_language).format(date_1);
    String month_day_2 = DateFormat("MMMMd", source_language).format(date_2);

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
        "$month_day_1 - $month_day_2, ${DateFormat("yyyy").format(date_2)}.";
  }
  return reservation_period_label;
}
