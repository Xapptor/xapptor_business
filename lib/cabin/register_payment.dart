import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:xapptor_business/cabin/get_reservation_period_label.dart';
import 'package:xapptor_business/models/cabin.dart';
import 'package:xapptor_business/models/payment.dart';
import 'package:xapptor_business/models/reservation_cabin.dart';
import 'package:xapptor_business/models/season.dart';
import 'package:xapptor_logic/date/get_range_of_dates.dart';
import 'package:xapptor_ui/widgets/is_portrait.dart';
import 'package:xapptor_logic/send_email.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

register_payment({
  required String reservation_id,
  required BuildContext context,
  required var parent,
  required Function get_reservations_callback,
  required Map<String, dynamic> user_info,
  required List<ReservationCabin> reservations,
  required List<Cabin> cabins,
  required TextEditingController amount_input_controller,
  required List<String> text_list,
  required String website_url,
  required List<Payment> reservation_payments,
  required String source_language,
  required List<Season> seasons,
  required bool show_older_reservations,
}) async {
  parent.current_reservation = reservations.firstWhere((element) => element.id == reservation_id);

  Cabin current_cabin = cabins.firstWhere((element) => element.id == parent.current_reservation!.cabin_id);

  double screen_height = MediaQuery.of(context).size.height;
  double screen_width = MediaQuery.of(context).size.width;
  bool portrait = is_portrait(context);

  String user_id = FirebaseAuth.instance.currentUser!.uid;
  DateFormat label_date_formatter = DateFormat.yMMMMd('en_US');

  String reservation_period_label = get_reservation_period_label(
    date_1: parent.current_reservation.date_init,
    date_2: parent.current_reservation.date_end,
    source_language: source_language,
  );

  List<DateTime> current_range_of_dates =
      get_range_of_dates(parent.current_reservation.date_init, parent.current_reservation.date_end);

  int total_to_pay = current_cabin.get_season_price(
          date_1: parent.current_reservation!.date_init,
          date_2: parent.current_reservation!.date_end,
          seasons: seasons) *
      (current_range_of_dates.length - 1);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(text_list[31]),
        content: SizedBox(
          height: screen_height * 0.38,
          width: screen_width * (portrait ? 0.8 : 0.3),
          child: ListView.builder(
            itemCount: reservation_payments.length + 1,
            itemBuilder: (context, index) {
              if (index < reservation_payments.length) {
                return Container(
                  margin: const EdgeInsets.only(top: 6),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 10,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SelectableText(
                              "ID: (${reservation_payments[index].id})",
                              maxLines: 2,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SelectableText(
                              "${label_date_formatter.format(reservation_payments[index].date)} - \$${reservation_payments[index].amount}",
                              maxLines: 2,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: IconButton(
                          onPressed: () async {
                            await FirebaseFirestore.instance
                                .collection("payments")
                                .doc(reservation_payments[index].id)
                                .delete();

                            parent.current_reservation!.payments
                                .removeWhere((element) => element == reservation_payments[index].id);

                            await FirebaseFirestore.instance
                                .collection("reservations")
                                .doc(parent.current_reservation!.id)
                                .update({
                              "payments": parent.current_reservation!.payments,
                            });

                            String email_message =
                                "${user_info["firstname"]} ${user_info["lastname"]} ${text_list[37 + 4]} (${reservation_payments[index].id}), ${text_list[24]} ($reservation_id), ${text_list[37 + 13]} \$${reservation_payments[index].amount} ${text_list[37 + 5]} ${parent.current_reservation!.cabin_id} ${text_list[37 + 6]} $reservation_period_label $website_url";

                            send_email(
                              to: "info@collineblanche.com.mx",
                              subject:
                                  "${text_list[37 + 12]} ${text_list[37 + 11]} (${reservation_payments[index].id}), ${text_list[24]} ($reservation_id)",
                              text: email_message,
                            );

                            if (context.mounted) Navigator.pop(context);
                            get_reservations_callback();
                          },
                          icon: const Icon(
                            FontAwesomeIcons.trashCan,
                          ),
                          tooltip: text_list[29],
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Column(
                  children: [
                    reservation_payments.isNotEmpty
                        ? Container(
                            alignment: Alignment.centerRight,
                            margin: const EdgeInsets.only(top: 10),
                            child: Text(
                              "${text_list[33]} \$${reservation_payments.map((payment) => payment.amount).toList().reduce((a, b) => a + b)}/$total_to_pay",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : Container(),
                    TextField(
                      controller: amount_input_controller,
                      autofocus: true,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: text_list[32],
                        hintText: text_list[32],
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
        actions: [
          TextButton(
            child: Text(text_list[22]),
            onPressed: () {
              amount_input_controller.clear();
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: Text(text_list[23]),
            onPressed: () {
              if (amount_input_controller.text.isNotEmpty) {
                if (int.tryParse(amount_input_controller.text) != null) {
                  if (int.parse(amount_input_controller.text) < total_to_pay * 2) {
                    Payment new_payment = Payment(
                      id: "",
                      amount: int.parse(amount_input_controller.text),
                      date: show_older_reservations ? parent.current_reservation!.date_init : DateTime.now(),
                      product_id: parent.current_reservation!.cabin_id,
                      user_id: user_id,
                    );

                    FirebaseFirestore.instance.collection("payments").add(new_payment.to_json()).then((payment) {
                      FirebaseFirestore.instance.collection("reservations").doc(parent.current_reservation!.id).update({
                        "payments": FieldValue.arrayUnion([payment.id]),
                      }).then((reservation) {
                        String email_message =
                            "${user_info["firstname"]} ${user_info["lastname"]} ${text_list[37 + 3]} (${payment.id}), ${text_list[24]} ($reservation_id), ${text_list[37 + 13]} \$${amount_input_controller.text} ${text_list[37 + 5]} ${parent.current_reservation!.cabin_id} ${text_list[37 + 6]} $reservation_period_label $website_url";

                        send_email(
                          to: "info@collineblanche.com.mx",
                          subject:
                              "${text_list[37 + 12]} ${text_list[37 + 9]} (${payment.id}), ${text_list[24]} ($reservation_id)",
                          text: email_message,
                        );

                        amount_input_controller.clear();

                        Navigator.pop(context);
                        get_reservations_callback();
                      });
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: SelectableText(
                          "The amount is too large",
                        ),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                }
              }
            },
          ),
        ],
      );
    },
  );
}
