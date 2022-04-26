import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:xapptor_business/cabin/get_reservation_from_id.dart';
import 'package:xapptor_business/cabin/get_reservation_period_label.dart';
import 'package:xapptor_business/models/reservation_cabin.dart';
import 'package:xapptor_logic/send_email.dart';

delete_reservation({
  required String reservation_id,
  required List<ReservationCabin> reservations,
  required Function callback,
  required BuildContext context,
  required DateTime selected_date_1,
  required DateTime selected_date_2,
  required String source_language,
  required Map<String, dynamic> user_info,
  required String website_url,
}) async {
  var reservation_for_deletion = get_reservation_from_id(
    id: reservation_id,
    reservations: reservations,
  );

  String current_reservation_period_label = get_reservation_period_label(
    index: reservations.indexOf(reservation_for_deletion),
    show_creation_menu: false,
    reservations: reservations,
    selected_date_1: selected_date_1,
    selected_date_2: selected_date_2,
    source_language: source_language,
  );

  var reservations_snap = await FirebaseFirestore.instance
      .collection("reservations")
      .doc(reservation_id)
      .delete()
      .then((value) {
    Navigator.of(context).pop();

    String email_message = user_info["firstname"] +
        " " +
        user_info["lastname"] +
        " ha eliminado una reservación (${reservation_id}) para la cabaña ${reservation_for_deletion.cabin_id} con un periodo de " +
        current_reservation_period_label +
        " " +
        website_url;

    send_email(
      to: "info@collineblanche.com.mx",
      subject: "Reservación Eliminada (${reservation_id})",
      text: email_message,
    );

    callback();
  });
}
