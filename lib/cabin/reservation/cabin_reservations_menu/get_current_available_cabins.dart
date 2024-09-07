// ignore_for_file: invalid_use_of_protected_member

import 'package:xapptor_business/cabin/cabins/get_available_cabins.dart';
import 'package:xapptor_business/cabin/reservation/cabin_reservations_menu/cabin_reservations_menu.dart';
import 'package:xapptor_business/cabin/reservation/get_reservation_from_id.dart';
import 'package:xapptor_business/models/cabin.dart';

extension StateExtension on CabinReservationsMenuState {
  get_current_available_cabins({
    String? ignore_reservation_with_id,
    required List<Cabin> cabins,
  }) {
    available_cabins = get_available_cabins(
        ignore_reservation_with_id: ignore_reservation_with_id,
        cabins: cabins,
        reservations: reservations,
        selected_cabin: selected_cabin,
        selected_date_1: selected_date_1,
        selected_date_2: selected_date_2,
        callback: (List<Cabin> available_cabins) {
          if (available_cabins.isNotEmpty) {
            if (ignore_reservation_with_id == null) {
              selected_cabin = available_cabins.first.id;
            } else {
              selected_cabin = get_reservation_from_id(
                id: ignore_reservation_with_id,
                reservations: reservations,
              ).cabin_id;
            }
          }
        });
    setState(() {});
  }
}
