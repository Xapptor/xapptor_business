// ignore_for_file: invalid_use_of_protected_member

import 'package:xapptor_business/cabin/reservation/cabin_reservation_text_list.dart';
import 'package:xapptor_business/cabin/reservation/cabin_reservations_menu/cabin_reservations_menu.dart';
import 'package:xapptor_business/cabin/reservation/cabin_reservations_menu/show_select_date_alert_dialog.dart';
import 'package:xapptor_business/cabin/reservation/get_reservations.dart';

extension StateExtension on CabinReservationsMenuState {
  get_current_reservations() async {
    reservations = await get_reservations(
      user_id: user_id,
      user_info: user_info,
      show_older_reservations: show_older_reservations,
    );

    setState(() {});

    if (show_creation_menu) {
      show_select_date_alert_dialog(text_list.get(source_language_index)[0]);
    }
  }
}
