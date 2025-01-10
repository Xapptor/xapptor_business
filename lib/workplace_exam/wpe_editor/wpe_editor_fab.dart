// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:xapptor_business/models/wpe.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/generate_wpe.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/validate_wpe.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/wpe_editor_alert.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/wpe_editor.dart';
//import 'package:xapptor_business/workplace_exam/wpe_visualizer/download_wpe_pdf.dart';

extension StateExtension on WpeEditorState {
  wpe_editor_fab() {
    String language_code =
        text_list.list[source_language_index].source_language;
    List alert_text_array = alert_text_list.get(source_language_index);

    String save_label = alert_text_array[18];
    String delete_label = alert_text_array[19];
    String download_label = alert_text_array[20];
    String menu_label = alert_text_array[21];
    String close_label = alert_text_array[22];

    return ExpandableFab(
      key: expandable_fab_key,
      distance: 200,
      duration: const Duration(milliseconds: 150),
      overlayStyle: const ExpandableFabOverlayStyle(
        blur: 5,
      ),
      openButtonBuilder: FloatingActionButtonBuilder(
        size: 20,
        builder: (context, on_pressed, progress) {
          return FloatingActionButton(
            heroTag: null,
            onPressed: on_pressed,
            tooltip: menu_label,
            child: const Icon(
              Icons.menu,
              color: Colors.white,
            ),
          );
        },
      ),
      closeButtonBuilder: FloatingActionButtonBuilder(
        size: 20,
        builder: (context, onPressed, progress) {
          return FloatingActionButton(
            heroTag: null,
            onPressed: onPressed,
            tooltip: close_label,
            child: const Icon(
              Icons.close,
              color: Colors.white,
            ),
          );
        },
      ),
      children: [
        // SAVE
        FloatingActionButton.extended(
          heroTag: null,
          onPressed: () {
            current_wpe = generate_wpe();
            wpe_id = current_wpe.id;
            //Validar WPE
            if (validate_wpe(current_wpe)) {
              wpe_editor_alert(
                wpe: current_wpe,
                wpe_editor_alert_type: WpeEditorAlertType.save,
              );
            }
          },
          backgroundColor: Colors.orange,
          tooltip: save_label,
          label: Row(
            children: [
              Text(
                save_label,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                FontAwesomeIcons.cloudArrowUp,
                color: Colors.white,
                size: 20,
              ),
            ],
          ),
        ),

        // DELETE

        FloatingActionButton.extended(
          heroTag: null,
          onPressed: () {
            Wpe wpe = generate_wpe();

            wpe_editor_alert(
              wpe: wpe,
              wpe_editor_alert_type: WpeEditorAlertType.delete,
            );
          },
          backgroundColor: Colors.red,
          tooltip: delete_label,
          label: Row(
            children: [
              Text(
                delete_label,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                FontAwesomeIcons.trash,
                color: Colors.white,
                size: 20,
              ),
            ],
          ),
        ),

        // DOWNLOAD

        FloatingActionButton.extended(
          heroTag: null,
          onPressed: () {
            // Wpe wpe = generate_wpe();
            // wpe.id = "${wpe.user_id}_$language_code";

            //String wpe_link = "${widget.base_url}/wpes/${wpe.id}";

            // var encoder = const JsonEncoder.withIndent('  ');
            // String pretty_json = encoder.convert(wpe.to_json_2());
            // print(pretty_json);

            // download_wpe_pdf(
            //   wpe: wpe,
            //   text_bottom_margin_for_section:
            //       widget.text_bottom_margin_for_section,
            //   wpe_link: wpe_link,
            //   context: context,
            //   language_code: language_code,
            // );
          },
          backgroundColor: Colors.lightBlue,
          tooltip: download_label,
          label: Row(
            children: [
              Text(
                download_label,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                FontAwesomeIcons.fileArrowDown,
                color: Colors.white,
                size: 20,
              ),
            ],
          ),
        ),
      ].reversed.toList(),
    );
  }
}
