// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:xapptor_business/cabin/reservation/cabin_reservation_text_list.dart';
import 'package:xapptor_business/cabin/reservation/cabin_reservations_menu/cabin_reservations_menu.dart';
import 'package:xapptor_business/cabin/reservation/cabin_reservations_menu/get_current_reservations.dart';
import 'package:xapptor_business/cabin/reservation/delete_reservation.dart';
import 'package:xapptor_business/cabin/reservation/get_reservation_period_label.dart';
import 'package:xapptor_business/cabin/reservation/register_reservation.dart';

extension StateExtension on CabinReservationsMenuState {
  show_edit_alert_dialog(String reservation_id, bool register) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(text_list.get(source_language_index)[register ? 21 : 27]),
          actions: [
            TextButton(
              child: Text(text_list.get(source_language_index)[22]),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(text_list.get(source_language_index)[23]),
              onPressed: () {
                if (register) {
                  reservation_period_label = get_reservation_period_label(
                    date_1: selected_date_1,
                    date_2: selected_date_2,
                    source_language: text_list.list[source_language_index].source_language,
                  );

                  register_reservation(
                    reservation_id: reservation_id,
                    callback: () {
                      show_creation_menu = false;
                      setState(() {});
                    },
                    get_current_reservations_callback: get_current_reservations,
                    context: context,
                    selected_date_1: selected_date_1,
                    selected_date_2: selected_date_2,
                    current_reservation: current_reservation,
                    reservation_period_label: reservation_period_label,
                    selected_cabin: selected_cabin,
                    user_id: user_id,
                    user_info: user_info,
                    website_url: widget.website_url,
                    text_list: text_list.get(source_language_index).sublist(37, 49),
                  );
                } else {
                  delete_reservation(
                    reservation_id: reservation_id,
                    reservations: reservations,
                    callback: () {
                      cancel_button();
                      get_current_reservations();
                    },
                    context: context,
                    source_language: text_list.list[source_language_index].source_language,
                    user_info: user_info,
                    website_url: widget.website_url,
                    text_list: text_list.get(source_language_index).sublist(37, 49),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
