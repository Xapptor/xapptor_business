import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:xapptor_logic/is_portrait.dart';
import 'package:xapptor_translation/language_picker.dart';
import 'package:xapptor_translation/model/text_list.dart';
import 'package:xapptor_translation/translation_stream.dart';
import 'package:xapptor_ui/widgets/topbar.dart';

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
          "About Us",
          "Cabines",
          "Contact",
          "Login",
          "Register",
        ],
      ),
      TranslationTextList(
        source_language: "es",
        text_list: [
          "Sobre Nosotros",
          "Cabañas",
          "Contacto",
          "Inicio de Sesión",
          "Registrar",
        ],
      ),
    ],
  );

  late TranslationStream translation_stream_buy;
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

    translation_stream_buy = TranslationStream(
      translation_text_list_array: text_list,
      update_text_list_function: update_text_list,
      list_index: 4,
      source_language_index: source_language_index,
    );

    translation_stream_list = [
      translation_stream_buy,
    ];

    Timer(Duration(milliseconds: 600), () {
      _select_date();
    });
  }

  static DateTime next_3_months = DateTime(
      DateTime.now().year, DateTime.now().month + 3, DateTime.now().day);

  DateTime selected_date = DateTime.now();
  String birthday_label = "";

  bool verify_if_date_is_available(DateTime date) {
    if (date.day == 31) {
      return true;
    } else {
      return false;
    }
  }

  Future<Null> _select_date() async {
    final DateTime? picked = (await showDatePicker(
        context: context,
        initialDate: selected_date,
        firstDate: selected_date,
        lastDate: next_3_months,
        selectableDayPredicate: (DateTime date) {
          return verify_if_date_is_available(date);
        }));
    if (picked != null)
      setState(() {
        selected_date = picked;

        DateFormat date_formatter = DateFormat.yMMMMd('en_US');
        String date_now_formatted = date_formatter.format(selected_date);
        birthday_label = date_now_formatted;
      });
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
      body: SingleChildScrollView(
        child: Container(),
      ),
    );
  }
}
