import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:xapptor_business/cabin/delete_reservation.dart';
import 'package:xapptor_business/cabin/get_available_cabins.dart';
import 'package:xapptor_business/cabin/get_cabin_from_id.dart';
import 'package:xapptor_business/cabin/get_cabins.dart';
import 'package:xapptor_business/cabin/get_payments_by_reservation.dart';
import 'package:xapptor_business/cabin/get_reservation_from_id.dart';
import 'package:xapptor_business/cabin/get_reservation_period_label.dart';
import 'package:xapptor_business/cabin/get_reservations.dart';
import 'package:xapptor_business/cabin/get_total_price_from_date_range.dart';
import 'package:xapptor_business/cabin/get_total_price_from_reservation.dart';
import 'package:xapptor_business/cabin/register_reservation.dart';
import 'package:xapptor_business/models/cabin.dart';
import 'package:xapptor_business/models/payment.dart';
import 'package:xapptor_business/models/reservation_cabin.dart';
import 'package:xapptor_business/models/season.dart';
import 'package:xapptor_logic/get_user_info.dart';
import 'package:xapptor_logic/is_portrait.dart';
import 'package:xapptor_translation/language_picker.dart';
import 'package:xapptor_translation/translation_stream.dart';
import 'package:xapptor_ui/widgets/topbar.dart';
import 'cabin_reservation_card.dart';
import 'cabin_reservation_text_list.dart';
import 'register_payment.dart';

class CabinReservationsMenu extends StatefulWidget {
  CabinReservationsMenu({
    required this.topbar_color,
    required this.website_url,
    required this.seasons,
  });

  final Color topbar_color;
  final String website_url;
  final List<Season> seasons;

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
    DateTime.now().year,
    DateTime.now().month + 3,
    DateTime.now().day,
  );

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
      show_older_reservations: show_older_reservations,
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
        callback: (List<Cabin> available_cabins) {
          if (available_cabins.length > 0) {
            if (ignore_reservation_with_id == null) {
              selected_cabin = available_cabins.first.id;
            } else {
              selected_cabin = get_reservation_from_id(
                id: ignore_reservation_with_id,
                reservations: reservations,
              ).cabin_id;
            }
          }
        });
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
                  reservation_period_label = get_reservation_period_label(
                    index: -1,
                    show_creation_menu: show_creation_menu,
                    reservations: reservations,
                    selected_date_1: selected_date_1,
                    selected_date_2: selected_date_2,
                    source_language:
                        text_list.list[source_language_index].source_language,
                  );

                  register_reservation(
                    reservation_id: reservation_id,
                    callback: () {
                      show_creation_menu = false;
                      setState(() {});
                    },
                    get_current_reservations_callback: get_current_reservations,
                    context: context,
                    selected_date_1: selected_date_1,
                    selected_date_2: selected_date_2,
                    current_reservation: current_reservation,
                    reservation_period_label: reservation_period_label,
                    selected_cabin: selected_cabin,
                    user_id: user_id,
                    user_info: user_info,
                    website_url: widget.website_url,
                    text_list:
                        text_list.get(source_language_index).sublist(37, 49),
                  );
                } else {
                  delete_reservation(
                    reservation_id: reservation_id,
                    reservations: reservations,
                    callback: () {
                      cancel_button();
                      get_current_reservations();
                    },
                    context: context,
                    selected_date_1: selected_date_1,
                    selected_date_2: selected_date_2,
                    source_language:
                        text_list.list[source_language_index].source_language,
                    user_info: user_info,
                    website_url: widget.website_url,
                    text_list:
                        text_list.get(source_language_index).sublist(37, 49),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  bool show_older_reservations = false;

  Widget show_older_reservations_button() {
    Widget container = Container();
    if (user_info["admin"] != null) {
      if (user_info["admin"]) {
        container = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text_list.get(source_language_index)[51] +
                  " " +
                  text_list.get(source_language_index)[25],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            Switch(
              value: show_older_reservations,
              onChanged: (new_value) {
                show_older_reservations = new_value;
                get_current_reservations();
              },
              activeColor: widget.topbar_color,
            ),
          ],
        );
      }
    }
    return container;
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
            ? Column(
                mainAxisAlignment: reservations.length == 0
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.spaceEvenly,
                children: [
                  show_older_reservations_button(),
                  Container(
                    height: screen_height * (portrait ? 0.8 : 0.8),
                    child: reservations.length == 0
                        ? FractionallySizedBox(
                            widthFactor: (portrait ? 0.85 : 1),
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                text_list.get(source_language_index)[26],
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                        : ListView(
                            shrinkWrap: true,
                            children: [
                              SizedBox(height: screen_height / 20),
                              Text(
                                text_list.get(source_language_index)[25],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: ClampingScrollPhysics(),
                                itemCount: reservations.length,
                                itemBuilder: (context, index) {
                                  Cabin current_cabin = get_cabin_from_id(
                                    id: reservations[index].cabin_id,
                                    cabins: cabins,
                                  );

                                  int total_price_from_reservation =
                                      get_total_price_from_reservation(
                                    reservation: reservations[index],
                                    cabin_season_price:
                                        current_cabin.get_season_price(
                                      current_date:
                                          reservations[index].date_init,
                                      seasons: widget.seasons,
                                    ),
                                  );

                                  return FractionallySizedBox(
                                    widthFactor: portrait ? 0.9 : 0.4,
                                    child: Container(
                                      height: screen_height *
                                          (portrait ? 0.5 : 0.45),
                                      margin: const EdgeInsets.all(10),
                                      child: FutureBuilder<List<Payment>>(
                                        future: get_payments_by_reservation(
                                          reservations[index],
                                        ),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<List<Payment>>
                                                reservation_payments) {
                                          if (reservation_payments.hasData) {
                                            return CabinReservationCard(
                                              reservation: reservations[index],
                                              select_date_available: true,
                                              select_date_callback:
                                                  _select_date,
                                              main_color: widget.topbar_color,
                                              text_list: text_list
                                                  .get(source_language_index),
                                              cabin: current_cabin,
                                              reservation_period_label:
                                                  get_reservation_period_label(
                                                index: index,
                                                show_creation_menu:
                                                    show_creation_menu,
                                                reservations: reservations,
                                                selected_date_1:
                                                    selected_date_1,
                                                selected_date_2:
                                                    selected_date_2,
                                                source_language: text_list
                                                    .list[source_language_index]
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
                                              available_cabins:
                                                  available_cabins,
                                              cancel_button_callback: () =>
                                                  cancel_button(),
                                              delete_button_callback:
                                                  (String reservation_id,
                                                          bool register) =>
                                                      show_edit_alert_dialog(
                                                          reservation_id,
                                                          register),
                                              edit_button_callback: (String
                                                      reservation_id) =>
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
                                                    get_current_reservations,
                                                reservations: reservations,
                                                user_info: user_info,
                                                website_url: widget.website_url,
                                                cabins: cabins,
                                                reservation_payments:
                                                    reservation_payments.data!,
                                                source_language: text_list
                                                    .list[source_language_index]
                                                    .source_language,
                                                seasons: widget.seasons,
                                              ),
                                              total_price_from_reservation:
                                                  total_price_from_reservation,
                                              reservation_payments_total:
                                                  reservation_payments
                                                              .data!.length >
                                                          0
                                                      ? reservation_payments
                                                          .data!
                                                          .map((payment) =>
                                                              payment.amount)
                                                          .toList()
                                                          .reduce(
                                                              (a, b) => a + b)
                                                      : 0,
                                              user_info: user_info,
                                              seasons: widget.seasons,
                                            );
                                          } else {
                                            return Container(
                                              child: FractionallySizedBox(
                                                heightFactor: 0.25,
                                                widthFactor: 0.2,
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: screen_height / 20),
                            ],
                          ),
                  ),
                ],
              )
            : date_label_1.isEmpty || date_label_2.isEmpty
                ? Container()
                : Container(
                    height: screen_height * (portrait ? 0.45 : 0.4),
                    width: screen_width * (portrait ? 0.9 : 0.4),
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
                            .list[source_language_index].source_language,
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
                      total_price_from_reservation: current_reservation == null
                          ? get_total_price_from_date_range(
                              cabin_season_price: get_cabin_from_id(
                                id: selected_cabin,
                                cabins: available_cabins,
                              ).get_season_price(
                                current_date: selected_date_1,
                                seasons: widget.seasons,
                              ),
                              date_1: selected_date_1,
                              date_2: selected_date_2,
                            )
                          : get_total_price_from_reservation(
                              reservation: current_reservation!,
                              cabin_season_price: get_cabin_from_id(
                                id: current_reservation!.cabin_id,
                                cabins: available_cabins,
                              ).get_season_price(
                                current_date: current_reservation!.date_init,
                                seasons: widget.seasons,
                              ),
                            ),
                      reservation_payments_total: 0,
                      user_info: user_info,
                      seasons: widget.seasons,
                    ),
                  ),
      ),
      floatingActionButton: !show_creation_menu
          ? FloatingActionButton(
              onPressed: () {
                show_creation_menu = true;
                current_reservation = null;
                setState(() {});
                show_select_date_alert_dialog(
                    text_list.get(source_language_index)[0]);
              },
              child: Icon(
                FontAwesomeIcons.filePen,
              ),
              tooltip: text_list.get(source_language_index)[44] +
                  " " +
                  text_list.get(source_language_index)[24],
            )
          : Container(),
    );
  }
}
