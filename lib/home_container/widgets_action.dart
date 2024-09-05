import 'package:flutter/material.dart';
import 'package:xapptor_business/home_container/home_container.dart';
import 'package:xapptor_router/app_screens.dart';
import 'package:xapptor_translation/language_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

extension StateExtension on HomeContainerState {
  List<Widget> widgets_action(bool portrait) {
    return [
      if (widget.has_language_picker && widget.translation_stream_list != null && widget.update_source_language != null)
        SizedBox(
          width: 150,
          child: LanguagePicker(
            translation_stream_list: widget.translation_stream_list!,
            language_picker_items_text_color: widget.topbar_color,
            update_source_language: widget.update_source_language!,
          ),
        ),
      if (!portrait && widget.tooltip_list.isNotEmpty)
        Row(
          children: [
                Tooltip(
                  message: widget.text_list_menu[0],
                  child: TextButton(
                    onPressed: () {
                      open_screen("home/account");
                    },
                    child: const Icon(
                      FontAwesomeIcons.user,
                      color: Colors.white,
                    ),
                  ),
                ),
              ] +
              widget.tooltip_list,
        ),
      if (widget.tile_list.isNotEmpty)
        IconButton(
          icon: const Icon(
            Icons.menu,
            color: Colors.white,
          ),
          onPressed: () {
            scaffold_key.currentState!.openEndDrawer();
          },
        ),
    ];
  }
}
