// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:xapptor_business/cabin/reservation/cabin_reservation_text_list.dart';
import 'package:xapptor_business/cabin/reservation/cabin_reservations_menu/cabin_reservations_menu.dart';
import 'package:xapptor_business/cabin/reservation/cabin_reservations_menu/get_current_available_cabins.dart';
import 'package:xapptor_business/cabin/reservation/cabin_reservations_menu/show_select_date_alert_dialog.dart';

extension StateExtension on CabinReservationsMenuState {
  Future select_date() async {
    DateTime next_3_months = DateTime(
      DateTime.now().year,
      DateTime.now().month + 3,
      DateTime.now().day,
    );

    DateTime initial_date = DateTime.now();

    if (selected_date_index != 0) {
      initial_date = DateTime(
        selected_date_1.year,
        selected_date_1.month,
        selected_date_1.day + 1,
      );
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial_date,
      firstDate: show_older_reservations
          ? DateTime(
              DateTime.now().year - 2,
              DateTime.now().month,
              DateTime.now().day,
            )
          : initial_date,
      lastDate: next_3_months,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: widget.topbar_color,
              onPrimary: Colors.white,
              onSurface: widget.topbar_color,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: widget.topbar_color,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      switch (selected_date_index) {
        case 0:
          selected_date_1 = picked;
          date_label_1 = label_date_formatter.format(selected_date_1);
          break;
        case 1:
          selected_date_2 = picked;
          date_label_2 = label_date_formatter.format(selected_date_2);
          break;
      }

      selected_date_index == 0 ? selected_date_index++ : selected_date_index = 0;

      if (selected_date_index != 0) {
        show_select_date_alert_dialog(text_list.get(source_language_index)[1]);
      } else {
        get_current_available_cabins(cabins: cabins);
      }
      setState(() {});
    } else {
      cancel_button();
    }
  }
}
