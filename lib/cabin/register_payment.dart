import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:xapptor_business/models/cabin.dart';
import 'package:xapptor_business/models/payment.dart';
import 'package:xapptor_business/models/reservation_cabin.dart';
import 'package:xapptor_logic/is_portrait.dart';
import 'package:xapptor_logic/send_email.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

register_payment(
    {required String reservation_id,
    required BuildContext context,
    required var parent,
    required Function get_reservations_callback,
    required Map<String, dynamic> user_info,
    required List<ReservationCabin> reservations,
    required List<Cabin> cabins,
    required TextEditingController amount_input_controller,
    required List<String> text_list,
    required String website_url,
    required List<Payment> reservation_payments}) async {
  parent.current_reservation =
      reservations.firstWhere((element) => element.id == reservation_id);

  Cabin current_cabin = cabins.firstWhere(
      (element) => element.id == parent.current_reservation!.cabin_id);

  double screen_height = MediaQuery.of(context).size.height;
  double screen_width = MediaQuery.of(context).size.width;
  bool portrait = is_portrait(context);

  String user_id = FirebaseAuth.instance.currentUser!.uid;
  DateFormat label_date_formatter = DateFormat.yMMMMd('en_US');

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(text_list[31]),
        content: Container(
          height: screen_height * 0.3,
          child: Column(
            children: [
              reservation_payments.length > 0
                  ? Container(
                      height: screen_height * 0.2,
                      width: screen_width / 5,
                      child: ListView.builder(
                          itemCount: reservation_payments.length,
                          itemBuilder: (context, index) {
                            return Container(
                              //height: screen_height * 0.1,
                              width: screen_width / 5,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    label_date_formatter.format(
                                            reservation_payments[index].date) +
                                        " - \$" +
                                        reservation_payments[index]
                                            .amount
                                            .toString(),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      await FirebaseFirestore.instance
                                          .collection("payments")
                                          .doc(reservation_payments[index].id)
                                          .delete();

                                      parent.current_reservation!.payments
                                          .removeWhere((element) =>
                                              element ==
                                              reservation_payments[index].id);

                                      await FirebaseFirestore.instance
                                          .collection("reservations")
                                          .doc(parent.current_reservation!.id)
                                          .update({
                                        "payments": parent
                                            .current_reservation!.payments,
                                      });

                                      String email_message = user_info[
                                              "firstname"] +
                                          " " +
                                          user_info["lastname"] +
                                          " ha eliminado el registro de pago (${reservation_payments[index].id}), con un monto de (\$${reservation_payments[index].amount}), para la reservación (${parent.current_reservation!.id}), en la cabaña ${parent.current_reservation!.cabin_id} " +
                                          website_url;

                                      send_email(
                                        to: "info@collineblanche.com.mx",
                                        subject:
                                            "Registro de pago eliminado (${reservation_payments[index].id}), Cabaña: (${parent.current_reservation!.cabin_id})",
                                        text: email_message,
                                      );

                                      Navigator.pop(context);
                                    },
                                    icon: Icon(
                                      FontAwesomeIcons.trashCan,
                                    ),
                                    tooltip: text_list[29],
                                  )
                                ],
                              ),
                            );
                          }),
                    )
                  : Container(),
              reservation_payments.length > 0
                  ? Container(
                      alignment: Alignment.centerRight,
                      child: Text(
                        text_list[33] +
                            " \$" +
                            reservation_payments
                                .map((payment) => payment.amount)
                                .toList()
                                .reduce((a, b) => a + b)
                                .toString() +
                            "/" +
                            current_cabin
                                .get_season_price(
                                    parent.current_reservation!.date_init)
                                .toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : Container(),
              Container(
                child: TextField(
                  controller: amount_input_controller,
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: text_list[32],
                    hintText: text_list[32],
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(text_list[22]),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: Text(text_list[23]),
            onPressed: () {
              Payment new_payment = Payment(
                id: "",
                amount: int.parse(amount_input_controller.text),
                date: DateTime.now(),
                product_id: parent.current_reservation!.cabin_id,
                user_id: user_id,
              );

              FirebaseFirestore.instance
                  .collection("payments")
                  .add(new_payment.to_json())
                  .then((payment) {
                FirebaseFirestore.instance
                    .collection("reservations")
                    .doc(parent.current_reservation!.id)
                    .update({
                  "payments": FieldValue.arrayUnion([payment.id]),
                }).then((reservation) {
                  String email_message = user_info["firstname"] +
                      " " +
                      user_info["lastname"] +
                      " ha creado el registro de pago (${payment.id}), con un monto de (\$${amount_input_controller.text}), para la reservación (${parent.current_reservation!.id}), en la cabaña ${parent.current_reservation!.cabin_id} " +
                      website_url;

                  send_email(
                    to: "info@collineblanche.com.mx",
                    subject:
                        "Registro de pago creado (${payment.id}), Cabaña: (${parent.current_reservation!.cabin_id})",
                    text: email_message,
                  );

                  amount_input_controller.clear();

                  Navigator.pop(context);
                  get_reservations_callback();
                });
              });
            },
          ),
        ],
      );
    },
  );
}
