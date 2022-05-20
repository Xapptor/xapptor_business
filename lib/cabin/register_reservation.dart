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
  required ReservationCabin? current_reservation,
  required String reservation_period_label,
  required String selected_cabin,
  required String user_id,
  required Map<String, dynamic> user_info,
  required String website_url,
  required List<String> text_list,
}) async {
  if (current_reservation != null) {
    ReservationCabin reservation = ReservationCabin(
      id: current_reservation.id,
      user_id: user_id,
      date_created: DateTime.now(),
      date_init: selected_date_1,
      date_end: selected_date_2,
      cabin_id: selected_cabin,
      payments: [],
    );
    Map<String, dynamic> reservation_map = reservation.to_json();
    reservation_map.remove("id");
    reservation_map.remove("user_id");
    reservation_map.remove("date_created");
    reservation_map.remove("payments");

    var reservation_snap = await FirebaseFirestore.instance
        .collection("reservations")
        .doc(current_reservation.id)
        .get();

    reservation_snap.reference.update(reservation_map);

    Navigator.of(context).pop();

    callback();

    String email_message =
        "${user_info["firstname"]} ${user_info["lastname"]} ${text_list[1]} (${reservation_id}) ${text_list[5]} ${selected_cabin} ${text_list[6]} ${reservation_period_label} ${website_url}";

    send_email(
      to: "info@collineblanche.com.mx",
      subject: "${text_list[8]} ${text_list[10]} (${current_reservation.id})",
      text: email_message,
    );
    get_current_reservations_callback();
  } else {
    ReservationCabin reservation = ReservationCabin(
      id: "",
      user_id: user_id,
      date_created: DateTime.now(),
      date_init: selected_date_1,
      date_end: selected_date_2,
      cabin_id: selected_cabin,
      payments: [],
    );
    Map<String, dynamic> reservation_map = reservation.to_json();
    reservation_map.remove("id");
    reservation_map["date_created"] = Timestamp.now();
    reservation_map.remove("payments");

    FirebaseFirestore.instance
        .collection("reservations")
        .add(reservation_map)
        .then((value) {
      Navigator.of(context).pop();
      callback();

      String email_message =
          "${user_info["firstname"]} ${user_info["lastname"]} ${text_list[0]} (${value.id}) ${text_list[5]} ${selected_cabin} ${text_list[6]} ${reservation_period_label} ${website_url}";

      send_email(
        to: "info@collineblanche.com.mx",
        subject: "${text_list[8]} ${text_list[9]} (${value.id})",
        text: email_message,
      );
      get_current_reservations_callback();
    });
  }
}
