import 'package:flutter/material.dart';
import 'package:xapptor_business/cabin/reservation/cabin_reservations_menu/cabin_reservations_menu.dart';
import 'package:xapptor_translation/language_picker.dart';
import 'package:xapptor_ui/values/ui.dart';
import 'package:xapptor_ui/widgets/top_and_bottom/topbar.dart';

extension StateExtension on CabinReservationsMenuState {
  AppBar get_topbar() {
    return TopBar(
      context: context,
      background_color: widget.topbar_color,
      has_back_button: true,
      actions: [
        SizedBox(
          width: 150,
          child: LanguagePicker(
            translation_stream_list: translation_stream_list,
            language_picker_items_text_color: widget.topbar_color,
            source_language_index: source_language_index,
            update_source_language: update_source_language,
          ),
        ),
        const SizedBox(width: sized_box_space),
      ],
      custom_leading: null,
      logo_path: "assets/images/logo_white.png",
    );
  }
}
