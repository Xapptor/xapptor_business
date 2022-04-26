import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:xapptor_business/cabin/get_available_cabins.dart';
import 'package:xapptor_business/cabin/get_cabin_from_id.dart';
import 'package:xapptor_business/cabin/get_cabins.dart';
import 'package:xapptor_business/cabin/get_payments_by_reservation.dart';
import 'package:xapptor_business/cabin/get_reservation_from_id.dart';
import 'package:xapptor_business/cabin/get_reservation_period_label.dart';
import 'package:xapptor_business/cabin/get_reservations.dart';
import 'package:xapptor_business/cabin/get_total_price_from_reservation.dart';
import 'package:xapptor_business/cabin/register_reservation.dart';
import 'package:xapptor_business/models/cabin.dart';
import 'package:xapptor_business/models/payment.dart';
import 'package:xapptor_business/models/reservation_cabin.dart';
import 'package:xapptor_logic/get_user_info.dart';
import 'package:xapptor_logic/is_portrait.dart';
import 'package:xapptor_logic/send_email.dart';
import 'package:xapptor_translation/language_picker.dart';
import 'package:xapptor_translation/translation_stream.dart';
import 'package:xapptor_ui/widgets/topbar.dart';
import 'cabin_reservation_card.dart';
import 'cabin_reservation_text_list.dart';
import 'register_payment.dart';

class CabinReservationsMenu extends StatefulWidget {
  CabinReservationsMenu({
    required this.topbar_color,
    required this.text_list,
    required this.website_url,
  });

  final Color topbar_color;
  final List<String> text_list;
  final String website_url;

  @override
  _CabinReservationsMenuState createState() => _CabinReservationsMenuState();
}

class _CabinReservationsMenuState extends State<CabinReservationsMenu> {
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

      get_current_cabins();
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

  DateFormat label_date_formatter = DateFormat.yMMMMd('en_US');

  update_selected_cabin(String new_cabin) {
    selected_cabin = new_cabin;
    setState(() {});
  }

  get_current_cabins() async {
    user_id = FirebaseAuth.instance.currentUser!.uid;
    user_info = await get_user_info(user_id);

    cabins = await get_cabins();
    get_current_reservations();
  }

  Map<String, dynamic> user_info = {};
  String user_id = "";

  get_current_reservations() async {
    reservations = await get_reservations(
      user_id: user_id,
      user_info: user_info,
    );

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
          get_current_available_cabins(cabins: cabins);
        }
      });
    } else {
      cancel_button();
    }
  }

  cancel_button() {
    date_label_1 = "";
    date_label_2 = "";
    show_creation_menu = false;
    current_reservation = null;
    setState(() {});
  }

  delete_button(String reservation_id) async {
    var reservation_for_deletion = get_reservation_from_id(
      id: reservation_id,
      reservations: reservations,
    );

    String current_reservation_period_label = get_reservation_period_label(
      index: reservations.indexOf(reservation_for_deletion),
      show_creation_menu: show_creation_menu,
      reservations: reservations,
      selected_date_1: selected_date_1,
      selected_date_2: selected_date_2,
      source_language: text_list
          .translation_text_list_array[source_language_index].source_language,
    );

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
          widget.website_url;

      send_email(
        to: "info@collineblanche.com.mx",
        subject: "Reservación Eliminada (${reservation_id})",
        text: email_message,
      );

      get_current_reservations();
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

    get_current_available_cabins(
      ignore_reservation_with_id: reservation_id,
      cabins: cabins,
    );
  }

  get_current_available_cabins({
    String? ignore_reservation_with_id,
    required List<Cabin> cabins,
  }) {
    available_cabins = get_available_cabins(
      ignore_reservation_with_id: ignore_reservation_with_id,
      cabins: cabins,
      reservations: reservations,
      selected_cabin: selected_cabin,
      selected_date_1: selected_date_1,
      selected_date_2: selected_date_2,
    );
    setState(() {});
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
                    reservation_id:
                        reservation_id.isEmpty ? null : reservation_id,
                    callback: () {
                      show_creation_menu = false;
                      setState(() {});
                    },
                    get_current_reservations_callback: get_current_reservations,
                    context: context,
                    selected_date_1: selected_date_1,
                    selected_date_2: selected_date_2,
                    current_reservation: current_reservation!,
                    reservation_period_label: reservation_period_label,
                    selected_cabin: selected_cabin,
                    user_id: user_id,
                    user_info: user_info,
                    website_url: widget.website_url,
                  );
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

  TextEditingController amount_input_controller = TextEditingController();

  String reservation_period_label = "";

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
                          if (index == 0) {
                            return Container(
                              margin: const EdgeInsets.all(30),
                              child: Text(
                                text_list.get(source_language_index)[25],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          } else {
                            Cabin current_cabin = get_cabin_from_id(
                              id: reservations[index - 1].cabin_id,
                              cabins: cabins,
                            );

                            int total_price_from_reservation =
                                get_total_price_from_reservation(
                              reservation: reservations[index - 1],
                              cabin_season_price:
                                  current_cabin.get_season_price(
                                      reservations[index - 1].date_init),
                            );

                            return FractionallySizedBox(
                              widthFactor: portrait ? 0.8 : 0.4,
                              child: Container(
                                height: screen_height * (portrait ? 0.35 : 0.3),
                                margin: const EdgeInsets.all(10),
                                child: FutureBuilder<List<Payment>>(
                                  future: get_payments_by_reservation(
                                    reservations[index - 1],
                                  ), // a previously-obtained Future<String> or null
                                  builder: (BuildContext context,
                                      AsyncSnapshot<List<Payment>>
                                          reservation_payments) {
                                    return reservation_payments.hasData
                                        ? CabinReservationCard(
                                            reservation:
                                                reservations[index - 1],
                                            select_date_available: true,
                                            select_date_callback: _select_date,
                                            main_color: widget.topbar_color,
                                            text_list: text_list
                                                .get(source_language_index),
                                            cabin: current_cabin,
                                            reservation_period_label:
                                                get_reservation_period_label(
                                              index: index - 1,
                                              show_creation_menu:
                                                  show_creation_menu,
                                              reservations: reservations,
                                              selected_date_1: selected_date_1,
                                              selected_date_2: selected_date_2,
                                              source_language: text_list
                                                  .translation_text_list_array[
                                                      source_language_index]
                                                  .source_language,
                                            ),
                                            selected_cabin: selected_cabin,
                                            update_selected_cabin:
                                                update_selected_cabin,
                                            register_reservation:
                                                (String reservation_id,
                                                        bool register) =>
                                                    show_edit_alert_dialog(
                                                        reservation_id,
                                                        register),
                                            available_cabins: available_cabins,
                                            cancel_button_callback: () =>
                                                cancel_button(),
                                            delete_button_callback:
                                                (String reservation_id,
                                                        bool register) =>
                                                    show_edit_alert_dialog(
                                                        reservation_id,
                                                        register),
                                            edit_button_callback:
                                                (String reservation_id) =>
                                                    edit_button(reservation_id),
                                            editing_mode: show_creation_menu,
                                            register_payment_callback:
                                                (String reservation_id) =>
                                                    register_payment(
                                              reservation_id: reservation_id,
                                              context: context,
                                              parent: this,
                                              amount_input_controller:
                                                  amount_input_controller,
                                              text_list: text_list
                                                  .get(source_language_index),
                                              get_reservations_callback:
                                                  get_reservations,
                                              reservations: reservations,
                                              user_info: user_info,
                                              website_url: widget.website_url,
                                              cabins: cabins,
                                              reservation_payments:
                                                  reservation_payments.data!,
                                            ),
                                            total_price_from_reservation:
                                                total_price_from_reservation,
                                            reservation_payments_total:
                                                reservation_payments
                                                            .data!.length >
                                                        0
                                                    ? reservation_payments.data!
                                                        .map((payment) =>
                                                            payment.amount)
                                                        .toList()
                                                        .reduce((a, b) => a + b)
                                                    : 0,
                                          )
                                        : CircularProgressIndicator();
                                  },
                                ),
                              ),
                            );
                          }
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
                      cabin: get_cabin_from_id(
                        id: selected_cabin,
                        cabins: available_cabins,
                      ),
                      reservation_period_label: get_reservation_period_label(
                        index: -1,
                        show_creation_menu: show_creation_menu,
                        reservations: reservations,
                        selected_date_1: selected_date_1,
                        selected_date_2: selected_date_2,
                        source_language: text_list
                            .translation_text_list_array[source_language_index]
                            .source_language,
                      ),
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
                      total_price_from_reservation:
                          get_total_price_from_reservation(
                        reservation: current_reservation!,
                        cabin_season_price: get_cabin_from_id(
                          id: selected_cabin,
                          cabins: available_cabins,
                        ).get_season_price(current_reservation!.date_init),
                      ),
                      reservation_payments_total: 0,
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
