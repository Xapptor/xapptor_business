import 'package:xapptor_business/models/reservation_cabin.dart';
import 'package:xapptor_logic/get_range_of_dates.dart';

int get_total_price_from_reservation({
  required ReservationCabin reservation,
  required int cabin_season_price,
}) {
  List<DateTime> range_of_dates =
      get_range_of_dates(reservation.date_init, reservation.date_end);

  return (range_of_dates.length - 1) * cabin_season_price;
}
