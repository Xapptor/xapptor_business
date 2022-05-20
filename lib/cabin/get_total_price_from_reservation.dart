import 'package:xapptor_business/cabin/get_total_price_from_date_range.dart';
import 'package:xapptor_business/models/reservation_cabin.dart';

int get_total_price_from_reservation({
  required ReservationCabin reservation,
  required int cabin_season_price,
}) {
  return get_total_price_from_date_range(
    cabin_season_price: cabin_season_price,
    date_1: reservation.date_init,
    date_2: reservation.date_end,
  );
}
