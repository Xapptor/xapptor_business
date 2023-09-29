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
  required String source_language,
  required Map<String, dynamic> user_info,
  required String website_url,
  required List<String> text_list,
}) async {
  var reservation_for_deletion = get_reservation_from_id(
    id: reservation_id,
    reservations: reservations,
  );

  reservation_for_deletion.payments.forEach((payment_id) async {
    await FirebaseFirestore.instance
        .collection("payments")
        .doc(payment_id)
        .delete();
  });

  String reservation_period_label = get_reservation_period_label(
    date_1: reservation_for_deletion.date_init,
    date_2: reservation_for_deletion.date_end,
    source_language: source_language,
  );

  var reservations_snap = await FirebaseFirestore.instance
      .collection("reservations")
      .doc(reservation_id)
      .delete()
      .then((value) {
    Navigator.of(context).pop();

    String email_message =
        "${user_info["firstname"]} ${user_info["lastname"]} ${text_list[2]} ($reservation_id) ${text_list[5]} ${reservation_for_deletion.cabin_id} ${text_list[6]} $reservation_period_label $website_url";

    send_email(
      to: "info@collineblanche.com.mx",
      subject: "${text_list[8]} ${text_list[11]} ($reservation_id)",
      text: email_message,
    );

    callback();
  });
}
