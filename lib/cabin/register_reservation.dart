import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:xapptor_business/models/reservation_cabin.dart';
import 'package:xapptor_logic/send_email.dart';

register_reservation({
  required String? reservation_id,
  required Function callback,
  required Function get_current_reservations_callback,
  required BuildContext context,
  required DateTime selected_date_1,
  required DateTime selected_date_2,
  required ReservationCabin current_reservation,
  required String reservation_period_label,
  required String selected_cabin,
  required String user_id,
  required Map<String, dynamic> user_info,
  required String website_url,
}) async {
  if (reservation_id != null) {
    await FirebaseFirestore.instance
        .collection("reservations")
        .doc(reservation_id)
        .update({
      "user_id": user_id,
      "date_created": Timestamp.now(),
      "date_init": selected_date_1,
      "date_end": selected_date_2,
      "cabin_id": selected_cabin,
    }).then((value) {
      Navigator.of(context).pop();

      callback();

      String email_message = user_info["firstname"] +
          " " +
          user_info["lastname"] +
          " ha actualizado una reservación (${current_reservation.id}) para la cabaña ${selected_cabin} con un periodo de " +
          reservation_period_label +
          " " +
          website_url;

      send_email(
        to: "info@collineblanche.com.mx",
        subject: "Reservación Actualizada (${current_reservation.id})",
        text: email_message,
      );
      get_current_reservations_callback();
    });
  } else {
    await FirebaseFirestore.instance.collection("reservations").add({
      "user_id": user_id,
      "date_created": Timestamp.now(),
      "date_init": selected_date_1,
      "date_end": selected_date_2,
      "cabin_id": selected_cabin,
    }).then((value) {
      Navigator.of(context).pop();
      callback();

      String email_message = user_info["firstname"] +
          " " +
          user_info["lastname"] +
          " ha creado una reservación (${value.id}) para la cabaña ${selected_cabin} con un periodo de " +
          reservation_period_label +
          " " +
          website_url;

      send_email(
        to: "info@collineblanche.com.mx",
        subject: "Nueva Reservación Registrada (${value.id})",
        text: email_message,
      );
      get_current_reservations_callback();
    });
  }
}
