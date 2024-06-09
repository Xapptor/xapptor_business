import 'package:xapptor_logic/date/get_range_of_dates.dart';

int get_total_price_from_date_range({
  required int cabin_season_price,
  required DateTime date_1,
  required DateTime date_2,
}) {
  List<DateTime> range_of_dates = get_range_of_dates(date_1, date_2);
  return (range_of_dates.length - 1) * cabin_season_price;
}
