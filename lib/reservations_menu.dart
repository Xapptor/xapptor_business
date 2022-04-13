import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:xapptor_logic/is_portrait.dart';
import 'package:xapptor_logic/bool_to_text.dart';
import 'package:xapptor_translation/language_picker.dart';
import 'package:xapptor_translation/model/text_list.dart';
import 'package:xapptor_translation/translation_stream.dart';
import 'package:xapptor_logic/check_if_dates_are_in_the_same_day.dart';
import 'package:xapptor_ui/widgets/topbar.dart';
import 'models/cabin.dart';
import 'models/cabin_reservation.dart';

class ReservationsMenu extends StatefulWidget {
  ReservationsMenu({
    required this.topbar_color,
  });

  final Color topbar_color;

  @override
  _ReservationsMenuState createState() => _ReservationsMenuState();
}

class _ReservationsMenuState extends State<ReservationsMenu> {
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
  String selected_cabin = "1";

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
      });
    }

    show_alert_dialog(text_list.get(source_language_index)[0]);
  }

  show_alert_dialog(String msg) {
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
          show_alert_dialog(text_list.get(source_language_index)[1]);
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
      List<DateTime> reservation_range_dates =
          get_range_of_dates(reservation.date_init, reservation.date_end);

      reservation_range_dates.forEach((range_date) {
        new_reservation_range_dates.forEach((new_range_date) {
          if (check_if_dates_are_in_the_same_day(range_date, new_range_date)) {
            unavailable_cabins.add(reservation.cabin_id);
          }
        });
      });
    });

    available_cabins = cabins;

    cabins.forEach((cabin) {
      unavailable_cabins.forEach((unavailable_cabin) {
        if (cabin.id == unavailable_cabin) {
          available_cabins.removeAt(cabins.indexOf(cabin));
        }
      });
    });

    if (available_cabins.length > 0) {
      available_cabins
          .sort((a, b) => int.parse(a.id).compareTo(int.parse(b.id)));

      selected_cabin = "1";
    }

    setState(() {});

    available_cabins.forEach((available_cabin) {
      print(available_cabin.to_json());
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
                  "reservation_type_id": "I9bRFrM7tT4arAn0E5G8",
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

  @override
  Widget build(BuildContext context) {
    double screen_height = MediaQuery.of(context).size.height;
    double screen_width = MediaQuery.of(context).size.width;
    bool portrait = is_portrait(context);

    String reservation_period_value = "";

    if (selected_date_1.month == selected_date_2.month) {
      String month = DateFormat(
              "MMMM",
              text_list.translation_text_list_array[source_language_index]
                  .source_language)
          .format(selected_date_1);

      month = month.substring(0, 1).toUpperCase() + month.substring(1);

      reservation_period_value =
          "$month ${selected_date_1.day} - ${selected_date_2.day}, ${DateFormat("yyyy").format(selected_date_1)}.";
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

      reservation_period_value =
          "$month_day_1 - $month_day_2, ${DateFormat("yyyy").format(selected_date_1)}.";
    }

    String description = "";

    if (available_cabins.length > 0) {
      if (get_cabin_from_index(selected_cabin).capacity >= 6) {
        description = text_list.get(source_language_index)[17];
      } else if (get_cabin_from_index(selected_cabin).capacity >= 4) {
        description = text_list.get(source_language_index)[18];
      } else if (get_cabin_from_index(selected_cabin).capacity >= 2) {
        description = text_list.get(source_language_index)[19];
      }
    }

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
        child: date_label_1.isEmpty || date_label_2.isEmpty
            ? Container()
            : Container(
                height: screen_height * (portrait ? 0.6 : 0.4),
                width: screen_width * (portrait ? 0.8 : 0.4),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: widget.topbar_color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _select_date();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: widget.topbar_color.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Text(
                              text_list.get(source_language_index)[2],
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.visible,
                              maxLines: 10,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              reservation_period_value,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.visible,
                              maxLines: 10,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    selected_cabin.isNotEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    text_list.get(source_language_index)[3] +
                                        ": ",
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.visible,
                                    maxLines: 10,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  DropdownButton<String>(
                                    items: available_cabins
                                        .map((cabin) => cabin.id)
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (new_value) {
                                      selected_cabin = new_value!;
                                      setState(() {});
                                    },
                                    value: selected_cabin,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    text_list.get(source_language_index)[4] +
                                        ": " +
                                        get_cabin_from_index(selected_cabin)
                                            .low_price
                                            .toString() +
                                        "  MXN",
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.visible,
                                    maxLines: 10,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Text(
                                    text_list.get(source_language_index)[5] +
                                        ": " +
                                        get_cabin_from_index(selected_cabin)
                                            .capacity
                                            .toString() +
                                        " " +
                                        text_list.get(source_language_index)[6],
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.visible,
                                    maxLines: 10,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                text_list.get(source_language_index)[7] +
                                    ": " +
                                    description,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.visible,
                                maxLines: 10,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    text_list.get(source_language_index)[8] +
                                        ": " +
                                        get_cabin_from_index(selected_cabin)
                                            .get_beds_string(),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.visible,
                                    maxLines: 10,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Text(
                                    text_list.get(source_language_index)[9] +
                                        ": " +
                                        get_cabin_from_index(selected_cabin)
                                            .bathrooms
                                            .toString(),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.visible,
                                    maxLines: 10,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    text_list.get(source_language_index)[10] +
                                        ": " +
                                        bool_to_text(
                                          value: get_cabin_from_index(
                                                  selected_cabin)
                                              .kitchen,
                                          true_text: text_list
                                              .get(source_language_index)[15],
                                          false_text: text_list
                                              .get(source_language_index)[16],
                                        ),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.visible,
                                    maxLines: 10,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Text(
                                    text_list.get(source_language_index)[11] +
                                        ": " +
                                        bool_to_text(
                                          value: get_cabin_from_index(
                                                  selected_cabin)
                                              .sauna,
                                          true_text: text_list
                                              .get(source_language_index)[15],
                                          false_text: text_list
                                              .get(source_language_index)[16],
                                        ),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.visible,
                                    maxLines: 10,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    text_list.get(source_language_index)[12] +
                                        ": " +
                                        bool_to_text(
                                          value: get_cabin_from_index(
                                                  selected_cabin)
                                              .livingroom,
                                          true_text: text_list
                                              .get(source_language_index)[15],
                                          false_text: text_list
                                              .get(source_language_index)[16],
                                        ),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.visible,
                                    maxLines: 10,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Text(
                                    text_list.get(source_language_index)[13] +
                                        ": " +
                                        bool_to_text(
                                          value: get_cabin_from_index(
                                                  selected_cabin)
                                              .chimney,
                                          true_text: text_list
                                              .get(source_language_index)[15],
                                          false_text: text_list
                                              .get(source_language_index)[16],
                                        ),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.visible,
                                    maxLines: 10,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Text(
                                    text_list.get(source_language_index)[14] +
                                        ": " +
                                        bool_to_text(
                                          value: get_cabin_from_index(
                                                  selected_cabin)
                                              .balcony,
                                          true_text: text_list
                                              .get(source_language_index)[15],
                                          false_text: text_list
                                              .get(source_language_index)[16],
                                        ),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.visible,
                                    maxLines: 10,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.all(20),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        register_reservation();
                                      },
                                      child: Text(
                                        text_list
                                            .get(source_language_index)[22],
                                      ),
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                          widget.topbar_color,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.all(20),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        register_reservation();
                                      },
                                      child: Text(
                                        text_list
                                            .get(source_language_index)[20],
                                      ),
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                          widget.topbar_color,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : Container(),
                  ],
                ),
              ),
      ),
    );
  }
}
