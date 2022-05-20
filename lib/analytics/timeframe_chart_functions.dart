import 'package:intl/intl.dart';

enum TimeFrame {
  day,
  week,
  month,
  year,
  beginning,
}

double get_max_x({
  required TimeFrame timeframe,
  required int first_year,
}) {
  switch (timeframe) {
    case TimeFrame.day:
      return 24;
    case TimeFrame.week:
      return 7;
    case TimeFrame.month:
      return 30;
    case TimeFrame.year:
      return 12;
    case TimeFrame.beginning:
      return first_year.toDouble();
  }
}

DateTime get_timeframe_date({
  required TimeFrame timeframe,
  required int first_year,
}) {
  DateTime date_now = DateTime.now();
  switch (timeframe) {
    case TimeFrame.day:
      return DateTime(
        date_now.year,
        date_now.month,
        date_now.day,
        date_now.hour - 24,
      );
    case TimeFrame.week:
      return DateTime(
        date_now.year,
        date_now.month,
        date_now.day - 7,
      );
    case TimeFrame.month:
      return DateTime(
        date_now.year,
        date_now.month,
        date_now.day - 30,
      );
    case TimeFrame.year:
      return DateTime(
        date_now.year,
        date_now.month - 12,
      );

    case TimeFrame.beginning:
      return DateTime(
        date_now.year - first_year,
      );
  }
}

List<String> get_bottom_labels({
  required double max_x,
  required TimeFrame timeframe,
}) {
  DateTime date_now = DateTime.now();
  List<String> bottom_labels = [];

  for (var i = 0; i < max_x; i++) {
    DateTime current_date = date_now;
    String current_label = "";

    switch (timeframe) {
      case TimeFrame.day:
        current_date = DateTime(
          date_now.year,
          date_now.month,
          date_now.day,
          date_now.hour - i,
        );
        current_label = DateFormat("h a").format(current_date);
        break;
      case TimeFrame.week:
        current_date = DateTime(
          date_now.year,
          date_now.month,
          date_now.day - i,
        );
        current_label = DateFormat("d").format(current_date);
        break;
      case TimeFrame.month:
        current_date = DateTime(
          date_now.year,
          date_now.month,
          date_now.day - i,
        );
        current_label = DateFormat("d").format(current_date);
        break;
      case TimeFrame.year:
        current_date = DateTime(
          date_now.year,
          date_now.month - i,
        );
        current_label = DateFormat("MMM").format(current_date);
        break;
      case TimeFrame.beginning:
        current_date = DateTime(
          date_now.year - i,
        );
        current_label = DateFormat("y").format(current_date);
        break;
    }

    bottom_labels.add(current_label);
  }
  bottom_labels = bottom_labels.reversed.toList();
  return bottom_labels;
}

int last_day_of_month(DateTime month) {
  var beginning_next_month = (month.month < 12)
      ? DateTime(month.year, month.month + 1, 1)
      : DateTime(month.year + 1, 1, 1);
  return beginning_next_month.subtract(Duration(days: 1)).day;
}
