import 'package:flutter/material.dart';
import 'package:xapptor_business/cabin/reservation/cabin_reservations_menu/cabin_reservations_menu.dart';
import 'package:xapptor_business/cabin/reservation/cabin_reservations_menu/select_date.dart';

extension StateExtension on CabinReservationsMenuState {
  show_select_date_alert_dialog(String msg) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(msg),
          actions: [
            TextButton(
              child: const Text("Ok"),
              onPressed: () async {
                Navigator.of(context).pop();
                select_date();
              },
            ),
          ],
        );
      },
    );
  }
}
