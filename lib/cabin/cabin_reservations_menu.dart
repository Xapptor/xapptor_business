import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:xapptor_business/models/cabin.dart';
import 'package:xapptor_business/models/payment.dart';
import 'package:xapptor_business/models/reservation_cabin.dart';
import 'package:xapptor_logic/get_user_info.dart';
import 'package:xapptor_logic/is_portrait.dart';
import 'package:xapptor_logic/get_range_of_dates.dart';
import 'package:xapptor_logic/send_email.dart';
import 'package:xapptor_translation/language_picker.dart';
import 'package:xapptor_translation/translation_stream.dart';
import 'package:xapptor_logic/check_if_dates_are_in_the_same_day.dart';
import 'package:xapptor_ui/widgets/topbar.dart';
import 'cabin_reservation_card.dart';
import 'cabin_reservation_text_list.dart';

class CabinReservationsMenu extends StatefulWidget {
  CabinReservationsMenu({
    required this.topbar_color,
  });

  final Color topbar_color;

  @override
  _CabinReservationsMenuState createState() => _CabinReservationsMenuState();
}

class _CabinReservationsMenuState extends State<CabinReservationsMenu> {
  String website_url = "https://collineblanche.com.mx/home";

  bool show_creation_menu = false;

  late TranslationStream translation_stream;
  List<TranslationStream> translation_stream_list = [];

  int current_page = 1;
  int source_language_index = 1;

  update_source_language({
    required int new_source_language_index,
  }) {
    source_language_index = new_source_language_index;
    setState(() {});
  }

  update_text_list({
    required int index,
    required String new_text,
    required int list_index,
  }) {
    text_list.get(source_language_index)[index] = new_text;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    initializeDateFormatting();

    if (FirebaseAuth.instance.currentUser == null) {
      Navigator.pop(context);
    } else {
      translation_stream = TranslationStream(
        translation_text_list_array: text_list,
        update_text_list_function: update_text_list,
        list_index: 4,
        source_language_index: source_language_index,
      );

      translation_stream_list = [
        translation_stream,
      ];
      get_cabins();
    }
  }

  static DateTime next_3_months = DateTime(
      DateTime.now().year, DateTime.now().month + 3, DateTime.now().day);

  DateTime selected_date_1 = DateTime.now();
  DateTime selected_date_2 = DateTime.now();
  String date_label_1 = "";
  String date_label_2 = "";

  List<Cabin> cabins = [];
  List<ReservationCabin> reservations = [];
  int selected_date_index = 0;

  List<Cabin> available_cabins = [];
  String selected_cabin = "";
  ReservationCabin? current_reservation;
  Cabin? current_cabin;

  DateFormat label_date_formatter = DateFormat.yMMMMd('en_US');

  update_selected_cabin(String new_cabin) {
    selected_cabin = new_cabin;
    setState(() {});
  }

  get_cabins() async {
    var cabins_snap =
        await FirebaseFirestore.instance.collection("cabins").get();

    cabins_snap.docs.forEach((snap) {
      cabins.add(
          Cabin.from_snapshot(snap.id, snap.data() as Map<String, dynamic>));
    });

    get_reservations();
  }

  Map<String, dynamic> user_info = {};
  String user_id = "";

  get_reservations() async {
    reservations.clear();

    user_id = FirebaseAuth.instance.currentUser!.uid;
    user_info = await get_user_info(user_id);

    bool get_all_reservations = false;

    if (user_info["admin"] != null) {
      if (user_info["admin"]) {
        get_all_reservations = true;
      }
    }

    QuerySnapshot<Map<String, dynamic>> reservations_snap;

    if (get_all_reservations) {
      reservations_snap = await FirebaseFirestore.instance
          .collection("reservations")
          .where(
            "date_init",
            isGreaterThanOrEqualTo: DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day - 1,
            ),
          )
          .get();
    } else {
      reservations_snap = await FirebaseFirestore.instance
          .collection("reservations")
          .where(
            "user_id",
            isEqualTo: user_id,
          )
          .get();
    }

    if (reservations_snap.docs.length > 0) {
      reservations_snap.docs.forEach((snap) {
        reservations.add(ReservationCabin.from_snapshot(snap.id, snap.data()));
      });
    }

    var reservations_copy = reservations.toList();

    reservations.forEach((reservation) {
      DateTime comparison_date = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day - 1,
      );
      if (reservation.date_init.isBefore(comparison_date)) {
        reservations_copy.remove(reservation);
      }
    });

    reservations = reservations_copy.toList();

    setState(() {});

    if (show_creation_menu) {
      show_select_date_alert_dialog(text_list.get(source_language_index)[0]);
    }
  }

  show_select_date_alert_dialog(String msg) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(msg),
          actions: <Widget>[
            TextButton(
              child: Text("Ok"),
              onPressed: () async {
                Navigator.of(context).pop();
                _select_date();
              },
            ),
          ],
        );
      },
    );
  }

  Future<Null> _select_date() async {
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
      firstDate: initial_date,
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
                primary: widget.topbar_color,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
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

        selected_date_index == 0
            ? selected_date_index++
            : selected_date_index = 0;

        if (selected_date_index != 0) {
          show_select_date_alert_dialog(
              text_list.get(source_language_index)[1]);
        } else {
          check_available_cabins();
        }
      });
    } else {
      cancel_button();
    }
  }

  List<Cabin> check_available_cabins({String? ignore_reservation_with_id}) {
    available_cabins = cabins.toList();

    available_cabins.sort((cabin_a, cabin_b) =>
        int.parse(cabin_a.id).compareTo(int.parse(cabin_b.id)));

    List<DateTime> new_reservation_range_dates =
        get_range_of_dates(selected_date_1, selected_date_2);

    List<String> unavailable_cabins = [];

    reservations.forEach((reservation) {
      List<DateTime> reservation_range_dates = get_range_of_dates(
        reservation.date_init,
        DateTime(
          reservation.date_end.year,
          reservation.date_end.month,
          reservation.date_end.day - 1,
        ),
      );

      reservation_range_dates.forEach((range_date) {
        new_reservation_range_dates.forEach((new_range_date) {
          if (check_if_dates_are_in_the_same_day(range_date, new_range_date)) {
            if (ignore_reservation_with_id == null) {
              unavailable_cabins.add(reservation.cabin_id);
            } else {
              if (ignore_reservation_with_id != reservation.id) {
                unavailable_cabins.add(reservation.cabin_id);
              }
            }
          }
        });
      });
    });

    unavailable_cabins = unavailable_cabins.toSet().toList();

    unavailable_cabins.forEach((unavailable_cabin) {
      available_cabins.removeWhere((cabin) => cabin.id == unavailable_cabin);
    });

    if (available_cabins.length > 0) {
      if (ignore_reservation_with_id == null) {
        selected_cabin = available_cabins.first.id;
      } else {
        selected_cabin =
            get_reservation_from_id(ignore_reservation_with_id).cabin_id;
      }
    }

    setState(() {});

    return available_cabins;
  }

  Cabin get_cabin_from_id(String id) {
    return available_cabins.firstWhere((cabin) => cabin.id == id);
  }

  ReservationCabin get_reservation_from_id(String id) {
    return reservations.firstWhere((reservation) => reservation.id == id);
  }

  cancel_button() {
    date_label_1 = "";
    date_label_2 = "";
    show_creation_menu = false;
    current_reservation = null;
    setState(() {});
  }

  delete_button(String reservation_id) async {
    var reservation_for_deletion = get_reservation_from_id(reservation_id);

    String current_reservation_period_label = get_reservation_period_label(
        reservations.indexOf(reservation_for_deletion));

    var reservations_snap = await FirebaseFirestore.instance
        .collection("reservations")
        .doc(reservation_id)
        .delete()
        .then((value) {
      Navigator.of(context).pop();
      cancel_button();

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

      get_reservations();
    });
  }

  edit_button(String reservation_id) async {
    show_creation_menu = true;
    current_reservation =
        reservations.firstWhere((element) => element.id == reservation_id);

    selected_date_1 = current_reservation!.date_init;
    date_label_1 = label_date_formatter.format(selected_date_1);

    selected_date_2 = current_reservation!.date_end;
    date_label_2 = label_date_formatter.format(selected_date_1);

    check_available_cabins(ignore_reservation_with_id: reservation_id);
  }

  show_edit_alert_dialog(String reservation_id, bool register) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(text_list.get(source_language_index)[register ? 21 : 27]),
          actions: <Widget>[
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
                  register_reservation(
                      reservation_id.isEmpty ? null : reservation_id);
                } else {
                  delete_button(reservation_id);
                }
              },
            ),
          ],
        );
      },
    );
  }

  register_reservation(String? reservation_id) async {
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
        show_creation_menu = false;
        setState(() {});

        String email_message = user_info["firstname"] +
            " " +
            user_info["lastname"] +
            " ha actualizado una reservación (${current_reservation!.id}) para la cabaña ${selected_cabin} con un periodo de " +
            reservation_period_label +
            " " +
            website_url;

        send_email(
          to: "info@collineblanche.com.mx",
          subject: "Reservación Actualizada (${current_reservation!.id})",
          text: email_message,
        );
        get_reservations();
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
        show_creation_menu = false;
        setState(() {});

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
        get_reservations();
      });
    }
  }

  TextEditingController amount_input_controller = TextEditingController();

  Future<Payment> get_payment_by_id(String payment_id) async {
    var payment_snap = await FirebaseFirestore.instance
        .collection("payments")
        .doc(payment_id)
        .get();
    return Payment.from_snapshot(
        payment_snap.id, payment_snap.data() as Map<String, dynamic>);
  }

  Future<List<Payment>> get_payments_by_reservation(
      ReservationCabin reservation) async {
    List<Payment> reservation_payments = [];

    reservation.payments.forEach((payment_id) async {
      Payment current_payment = await get_payment_by_id(payment_id);
      reservation_payments.add(current_payment);
    });
    return reservation_payments;
  }

  register_payment(String reservation_id) async {
    current_reservation =
        reservations.firstWhere((element) => element.id == reservation_id);

    current_cabin = cabins
        .firstWhere((element) => element.id == current_reservation!.cabin_id);

    double screen_height = MediaQuery.of(context).size.height;
    double screen_width = MediaQuery.of(context).size.width;
    bool portrait = is_portrait(context);

    get_payments_by_reservation(current_reservation!)
        .then((reservation_payments) {
      Timer(Duration(milliseconds: 300), () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(text_list.get(source_language_index)[31]),
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
                                                  reservation_payments[index]
                                                      .date) +
                                              " - \$" +
                                              reservation_payments[index]
                                                  .amount
                                                  .toString(),
                                        ),
                                        IconButton(
                                          onPressed: () async {
                                            await FirebaseFirestore.instance
                                                .collection("payments")
                                                .doc(reservation_payments[index]
                                                    .id)
                                                .delete();

                                            current_reservation!.payments
                                                .removeWhere((element) =>
                                                    element ==
                                                    reservation_payments[index]
                                                        .id);

                                            await FirebaseFirestore.instance
                                                .collection("reservations")
                                                .doc(current_reservation!.id)
                                                .update({
                                              "payments":
                                                  current_reservation!.payments,
                                            });

                                            Navigator.pop(context);
                                          },
                                          icon: Icon(
                                            FontAwesomeIcons.trashCan,
                                          ),
                                          tooltip: text_list
                                              .get(source_language_index)[29],
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
                              text_list.get(source_language_index)[33] +
                                  " \$" +
                                  reservation_payments
                                      .map((payment) => payment.amount)
                                      .toList()
                                      .reduce((a, b) => a + b)
                                      .toString() +
                                  "/" +
                                  current_cabin!
                                      .get_season_price(
                                          current_reservation!.date_init)
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
                          labelText: text_list.get(source_language_index)[32],
                          hintText: text_list.get(source_language_index)[32],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(text_list.get(source_language_index)[22]),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: Text(text_list.get(source_language_index)[23]),
                  onPressed: () {
                    Payment new_payment = Payment(
                      id: "",
                      amount: int.parse(amount_input_controller.text),
                      date: DateTime.now(),
                      product_id: current_reservation!.cabin_id,
                      user_id: user_id,
                    );

                    FirebaseFirestore.instance
                        .collection("payments")
                        .add(new_payment.to_json())
                        .then((payment) {
                      FirebaseFirestore.instance
                          .collection("reservations")
                          .doc(current_reservation!.id)
                          .update({
                        "payments": FieldValue.arrayUnion([payment.id]),
                      }).then((payment) {
                        amount_input_controller.clear();
                        Navigator.pop(context);
                        get_reservations();
                      });
                    });
                  },
                ),
              ],
            );
          },
        );
      });
    });
  }

  String reservation_period_label = "";

  String get_reservation_period_label(int index) {
    reservation_period_label = "";

    DateTime date_to_use_1 =
        show_creation_menu ? selected_date_1 : reservations[index].date_init;

    DateTime date_to_use_2 =
        show_creation_menu ? selected_date_2 : reservations[index].date_init;

    String month_day_1 = DateFormat(
            "MMMMd",
            text_list.translation_text_list_array[source_language_index]
                .source_language)
        .format(date_to_use_1);

    String month_day_2 = DateFormat(
            "MMMMd",
            text_list.translation_text_list_array[source_language_index]
                .source_language)
        .format(date_to_use_2);

    String month_1 = DateFormat(
            "MMMM",
            text_list.translation_text_list_array[source_language_index]
                .source_language)
        .format(date_to_use_1);

    String month_2 = DateFormat(
            "MMMM",
            text_list.translation_text_list_array[source_language_index]
                .source_language)
        .format(date_to_use_2);

    if (selected_date_1.month == selected_date_2.month) {
      month_1 = month_1.substring(0, 1).toUpperCase() + month_1.substring(1);

      if (index == -1) {
        reservation_period_label =
            "$month_1 ${selected_date_1.day} - ${selected_date_2.day}, ${DateFormat("yyyy").format(selected_date_1)}.";
      } else {
        reservation_period_label =
            "$month_1 ${reservations[index].date_init.day} - ${reservations[index].date_end.day}, ${DateFormat("yyyy").format(selected_date_1)}.";
      }
    } else {
      int month_day_1_first_letter_index = month_day_1.indexOf(month_1);

      int month_day_2_first_letter_index = month_day_2.indexOf(month_2);

      month_day_1 = month_day_1.substring(0, month_day_1_first_letter_index) +
          month_day_1
              .substring(month_day_1_first_letter_index,
                  month_day_1_first_letter_index + 1)
              .toUpperCase() +
          month_day_1.substring(month_day_1_first_letter_index + 1);

      month_day_2 = month_day_2.substring(0, month_day_2_first_letter_index) +
          month_day_2
              .substring(month_day_2_first_letter_index,
                  month_day_2_first_letter_index + 1)
              .toUpperCase() +
          month_day_2.substring(month_day_2_first_letter_index + 1);

      reservation_period_label =
          "$month_day_1 - $month_day_2, ${DateFormat("yyyy").format(selected_date_1)}.";
    }
    return reservation_period_label;
  }

  @override
  Widget build(BuildContext context) {
    double screen_height = MediaQuery.of(context).size.height;
    double screen_width = MediaQuery.of(context).size.width;
    bool portrait = is_portrait(context);

    return Scaffold(
      appBar: TopBar(
        background_color: widget.topbar_color,
        has_back_button: true,
        actions: [
          Container(
            width: 150,
            child: LanguagePicker(
              translation_stream_list: translation_stream_list,
              language_picker_items_text_color: widget.topbar_color,
              source_language_index: source_language_index,
              update_source_language: update_source_language,
            ),
          ),
          const SizedBox(
            width: 16,
          ),
        ],
        custom_leading: null,
        logo_path: "assets/images/logo_white.png",
      ),
      body: Container(
        alignment: Alignment.center,
        child: !show_creation_menu
            ? Container(
                child: reservations.length == 0
                    ? Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.all(30),
                        child: Text(
                          text_list.get(source_language_index)[26],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: reservations.length + 1,
                        itemBuilder: (context, index) {
                          return index == 0
                              ? Container(
                                  margin: const EdgeInsets.all(30),
                                  child: Text(
                                    text_list.get(source_language_index)[25],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              : FractionallySizedBox(
                                  widthFactor: portrait ? 0.8 : 0.4,
                                  child: Container(
                                    height:
                                        screen_height * (portrait ? 0.35 : 0.3),
                                    margin: const EdgeInsets.all(10),
                                    child: CabinReservationCard(
                                      reservation: reservations[index - 1],
                                      select_date_available: true,
                                      select_date_callback: _select_date,
                                      main_color: widget.topbar_color,
                                      text_list:
                                          text_list.get(source_language_index),
                                      cabin: cabins.firstWhere((cabin) =>
                                          cabin.id ==
                                          reservations[index - 1].cabin_id),
                                      reservation_period_label:
                                          get_reservation_period_label(
                                              index - 1),
                                      selected_cabin: selected_cabin,
                                      update_selected_cabin:
                                          update_selected_cabin,
                                      register_reservation:
                                          (String reservation_id,
                                                  bool register) =>
                                              show_edit_alert_dialog(
                                                  reservation_id, register),
                                      available_cabins: available_cabins,
                                      cancel_button_callback: () =>
                                          cancel_button(),
                                      delete_button_callback:
                                          (String reservation_id,
                                                  bool register) =>
                                              show_edit_alert_dialog(
                                                  reservation_id, register),
                                      edit_button_callback:
                                          (String reservation_id) =>
                                              edit_button(reservation_id),
                                      editing_mode: show_creation_menu,
                                      register_payment_callback:
                                          (String reservation_id) =>
                                              register_payment(reservation_id),
                                    ),
                                  ),
                                );
                        },
                      ),
              )
            : date_label_1.isEmpty || date_label_2.isEmpty
                ? Container()
                : Container(
                    height: screen_height * (portrait ? 0.6 : 0.4),
                    width: screen_width * (portrait ? 0.8 : 0.4),
                    child: CabinReservationCard(
                      reservation: current_reservation,
                      select_date_available: true,
                      select_date_callback: _select_date,
                      main_color: widget.topbar_color,
                      text_list: text_list.get(source_language_index),
                      cabin: get_cabin_from_id(selected_cabin),
                      reservation_period_label:
                          get_reservation_period_label(-1),
                      selected_cabin: selected_cabin,
                      update_selected_cabin: update_selected_cabin,
                      register_reservation:
                          (String reservation_id, bool register) =>
                              show_edit_alert_dialog(reservation_id, register),
                      available_cabins: available_cabins,
                      cancel_button_callback: () => cancel_button(),
                      delete_button_callback:
                          (String reservation_id, bool register) =>
                              show_edit_alert_dialog(reservation_id, register),
                      edit_button_callback: (String reservation_id) {},
                      editing_mode: show_creation_menu,
                      register_payment_callback: (String reservation_id) {},
                    ),
                  ),
      ),
      floatingActionButton: !show_creation_menu
          ? FloatingActionButton(
              onPressed: () {
                show_creation_menu = true;
                setState(() {});
                show_select_date_alert_dialog(
                    text_list.get(source_language_index)[0]);
              },
              child: Icon(
                FontAwesomeIcons.filePen,
              ),
              tooltip: text_list.get(source_language_index)[24],
            )
          : Container(),
    );
  }
}
