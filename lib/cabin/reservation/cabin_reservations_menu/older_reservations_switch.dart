import 'package:flutter/material.dart';
import 'package:xapptor_business/cabin/reservation/cabin_reservation_text_list.dart';
import 'package:xapptor_business/cabin/reservation/cabin_reservations_menu/cabin_reservations_menu.dart';
import 'package:xapptor_business/cabin/reservation/cabin_reservations_menu/get_current_reservations.dart';

extension StateExtension on CabinReservationsMenuState {
  Widget older_reservations_switch() {
    Widget container = const SizedBox();
    if (user_info["admin"] != null) {
      if (user_info["admin"]) {
        container = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${text_list.get(source_language_index)[51]} ${text_list.get(source_language_index)[25]}",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            Switch(
              value: show_older_reservations,
              onChanged: (new_value) {
                show_older_reservations = new_value;
                get_current_reservations();
              },
              activeThumbColor: widget.topbar_color,
            ),
          ],
        );
      }
    }
    return container;
  }
}
