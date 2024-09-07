// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:xapptor_business/cabin/reservation/cabin_reservation_text_list.dart';
import 'package:xapptor_business/cabin/reservation/cabin_reservations_menu/cabin_reservations_menu.dart';
import 'package:xapptor_business/cabin/reservation/cabin_reservations_menu/show_select_date_alert_dialog.dart';

extension StateExtension on CabinReservationsMenuState {
  FloatingActionButton? get_floating_action_button() {
    return !show_creation_menu
        ? FloatingActionButton(
            onPressed: () {
              show_creation_menu = true;
              current_reservation = null;
              setState(() {});
              show_select_date_alert_dialog(text_list.get(source_language_index)[0]);
            },
            tooltip: "${text_list.get(source_language_index)[44]} ${text_list.get(source_language_index)[24]}",
            child: const Icon(
              FontAwesomeIcons.filePen,
            ),
          )
        : null;
  }
}
