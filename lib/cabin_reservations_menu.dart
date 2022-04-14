import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:xapptor_logic/is_portrait.dart';
import 'package:xapptor_translation/language_picker.dart';
import 'package:xapptor_translation/model/text_list.dart';
import 'package:xapptor_translation/translation_stream.dart';
import 'package:xapptor_logic/check_if_dates_are_in_the_same_day.dart';
import 'package:xapptor_ui/widgets/topbar.dart';
import 'cabin_reservation_card.dart';
import 'models/cabin.dart';
import 'models/cabin_reservation.dart';

class CabinReservationsMenu extends StatefulWidget {
  CabinReservationsMenu({
    required this.topbar_color,
  });

  final Color topbar_color;

  @override
  _CabinReservationsMenuState createState() => _CabinReservationsMenuState();
}

class _CabinReservationsMenuState extends State<CabinReservationsMenu> {
  TranslationTextListArray text_list = TranslationTextListArray(
    [
      TranslationTextList(
        source_language: "en",
        text_list: [
          "Enter the initial day of your reservation",
          "Enter the last day of your reservation",
          "Reservation Period",
          "Cabin",
          "Price",
          "Capacity",
          "People",
          "Description",
          "Bed",
          "Bathrooms",
          "Kitchen",
          "Sauna",
          "Livingroom",
          "Chimney",
          "Balcony",
          "Yes",
          "No",
          "Ideal for big families or groups of friends.",
          "Ideal for families or groups of friends.",
          "Ideal for couples.",
          "Confirm",
          "Confirm Reservation",
          "Cancel",
          "Ok",
          "New Reservation",
          "Reservations",
        ],
      ),
      TranslationTextList(
        source_language: "es",
        text_list: [
          "Selecciona el día inicial de tu reservación",
          "Selecciona el último día de tu reservación",
          "Periodo de Reservación",
          "Cabaña",
          "Precio",
          "Capacidad",
          "Personas",
          "Descripción",
          "Camas",
          "Baños",
          "Cocina",
          "Sauna",
          "Sala",
          "Chimenea",
          "Balcón",
          "Si",
          "No",
          "Ideal para familias y grupos de amigos grandes.",
          "Ideal para familias y grupos de amigos.",
          "Ideal para parejas.",
          "Confirmar",
          "Confirmar Reservación",
          "Cancelar",
          "Ok",
          "Nueva Reservación",
          "Reservaciones",
        ],
      ),
    ],
  );

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
  List<CabinReservation> reservations = [];
  int selected_date_index = 0;

  List<Cabin> available_cabins = [];
  String selected_cabin = "";

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

  get_reservations() async {
    var reservations_snap = await FirebaseFirestore.instance
        .collection("reservations")
        .where(
          'date_init',
          isGreaterThanOrEqualTo: DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day - 1,
          ),
        )
        .get();

    if (reservations_snap.docs.length > 0) {
      reservations_snap.docs.forEach((snap) {
        reservations.add(CabinReservation.from_snapshot(snap.id, snap.data()));
        print("Reservation: " + reservations.last.to_json().toString());
      });
    }

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
      DateFormat date_formatter = DateFormat.yMMMMd('en_US');

      setState(() {
        switch (selected_date_index) {
          case 0:
            selected_date_1 = picked;
            date_label_1 = date_formatter.format(selected_date_1);
            break;
          case 1:
            selected_date_2 = picked;
            date_label_2 = date_formatter.format(selected_date_2);
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
    }
  }

  List<Cabin> check_available_cabins() {
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
            unavailable_cabins.add(reservation.cabin_id);
          }
        });
      });
    });

    unavailable_cabins = unavailable_cabins.toSet().toList();

    available_cabins = cabins.toList();

    print(unavailable_cabins);

    cabins.forEach((cabin) {
      unavailable_cabins.forEach((unavailable_cabin) {
        if (cabin.id == unavailable_cabin) {
          int unavailable_cabin_index = cabins.indexOf(cabin);

          print("unavailable_cabin_index: " +
              available_cabins[unavailable_cabin_index].id);

          available_cabins.removeAt(unavailable_cabin_index);
        }
      });
    });

    if (available_cabins.length > 0) {
      available_cabins
          .sort((a, b) => int.parse(a.id).compareTo(int.parse(b.id)));

      selected_cabin = available_cabins.first.id;
    }

    setState(() {});

    available_cabins.forEach((available_cabin) {
      print(available_cabin.id);
    });

    return available_cabins;
  }

  List<DateTime> get_range_of_dates(DateTime date_1, DateTime date_2) {
    int dates_difference_in_days =
        selected_date_2.difference(selected_date_1).inDays;

    List<DateTime> range_of_dates = [];

    for (var i = 0; i <= dates_difference_in_days; i++) {
      range_of_dates.add(
        DateTime(
          selected_date_1.year,
          selected_date_1.month,
          selected_date_1.day + i,
        ),
      );
    }
    return range_of_dates;
  }

  Cabin get_cabin_from_index(String selected_text) {
    return available_cabins.firstWhere((cabin) => cabin.id == selected_text);
  }

  register_reservation() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(text_list.get(source_language_index)[21]),
          actions: <Widget>[
            TextButton(
              child: Text(text_list.get(source_language_index)[22]),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(text_list.get(source_language_index)[23]),
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection("reservations")
                    .doc()
                    .set({
                  "user_id": FirebaseAuth.instance.currentUser!.uid,
                  "date_created": Timestamp.now(),
                  "date_init": selected_date_1,
                  "date_end": selected_date_2,
                  "cabin_id": selected_cabin,
                }).then((value) {
                  Navigator.of(context).pop();
                  show_creation_menu = false;
                  setState(() {});
                });
              },
            ),
          ],
        );
      },
    );
  }

  String get_reservation_period_label(int index) {
    String reservation_period_label = "";

    if (selected_date_1.month == selected_date_2.month) {
      String month = DateFormat(
              "MMMM",
              text_list.translation_text_list_array[source_language_index]
                  .source_language)
          .format(selected_date_1);

      month = month.substring(0, 1).toUpperCase() + month.substring(1);

      if (index == -1) {
        reservation_period_label =
            "$month ${selected_date_1.day} - ${selected_date_2.day}, ${DateFormat("yyyy").format(selected_date_1)}.";
      } else {
        reservation_period_label =
            "$month ${reservations[index].date_init.day} - ${reservations[index].date_end.day}, ${DateFormat("yyyy").format(selected_date_1)}.";
      }
    } else {
      String month_day_1 = DateFormat(
              "MMMMd",
              text_list.translation_text_list_array[source_language_index]
                  .source_language)
          .format(selected_date_1);

      String month_day_2 = DateFormat(
              "MMMMd",
              text_list.translation_text_list_array[source_language_index]
                  .source_language)
          .format(selected_date_2);

      String month_1 = DateFormat(
              "MMMM",
              text_list.translation_text_list_array[source_language_index]
                  .source_language)
          .format(selected_date_1);

      String month_2 = DateFormat(
              "MMMM",
              text_list.translation_text_list_array[source_language_index]
                  .source_language)
          .format(selected_date_2);

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
                width: screen_width * (portrait ? 0.8 : 0.4),
                child: ListView.builder(
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
                        : Container(
                            height: screen_height * (portrait ? 0.3 : 0.2),
                            child: CabinReservationCard(
                              reservation: reservations[index - 1],
                              select_date_available: true,
                              select_date_callback: _select_date,
                              main_color: widget.topbar_color,
                              text_list: text_list.get(source_language_index),
                              cabin: cabins.firstWhere((cabin) =>
                                  cabin.id == reservations[index - 1].cabin_id),
                              reservation_period_label:
                                  get_reservation_period_label(index - 1),
                              selected_cabin: selected_cabin,
                              update_selected_cabin: update_selected_cabin,
                              register_reservation: register_reservation,
                              available_cabins: available_cabins,
                              cancel_button_callback: () {},
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
                      reservation: null,
                      select_date_available: true,
                      select_date_callback: _select_date,
                      main_color: widget.topbar_color,
                      text_list: text_list.get(source_language_index),
                      cabin: get_cabin_from_index(selected_cabin),
                      reservation_period_label:
                          get_reservation_period_label(-1),
                      selected_cabin: selected_cabin,
                      update_selected_cabin: update_selected_cabin,
                      register_reservation: register_reservation,
                      available_cabins: available_cabins,
                      cancel_button_callback: () {
                        show_creation_menu = false;
                        setState(() {});
                      },
                    ),
                  ),
      ),
      floatingActionButton: FloatingActionButton(
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
      ),
    );
  }
}
