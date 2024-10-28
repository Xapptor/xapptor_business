// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:xapptor_business/models/wpe.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/crud/delete/delete_wpe.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/crud/read/get_wpe_ref.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/crud/read/get_wpes_labels.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/load_wpe.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/wpe_editor.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/crud/create/save_wpe.dart';

enum WpeEditorAlertType {
  save,
  load,
  delete,
}

extension StateExtension on WpeEditorState {
  wpe_editor_alert({
    required Wpe wpe,
    required WpeEditorAlertType wpe_editor_alert_type,
  }) {
    _main_alert(
      wpe: wpe,
      wpe_editor_alert_type: wpe_editor_alert_type,
    );
  }

  _asking_for_deletion_alert() {
    String no_label = alert_text_list.get(source_language_index)[5];
    String yes_label = alert_text_list.get(source_language_index)[6];

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text(
                alert_text_list.get(source_language_index)[2],
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    no_label,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    delete_wpe();
                  },
                  child: Text(
                    yes_label,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  _main_alert({
    required Wpe wpe,
    required WpeEditorAlertType wpe_editor_alert_type,
  }) async {
    String main_label = alert_text_list.get(source_language_index)[9];
    String backup_label = alert_text_list.get(source_language_index)[8];

    //Todo borrar
    print('llamado en wpe_editor_alert.dart');
    wpes = await get_wpe_ref();

    List<String> wpes_labels = get_wpes_labels(
      wpes: wpes,
      main_label: main_label,
      backup_label: backup_label,
      wpe_editor_alert_type: wpe_editor_alert_type,
    );

    // if (wpes_labels.isNotEmpty) {
    //   slot_value = wpes_labels[slot_index];
    // }

    // set_slot_index() {
    //   if (slot_value.contains(backup_label)) {
    //     slot_index = wpes_labels.indexOf(slot_value);
    //   } else if (slot_value.contains(main_label)) {
    //     slot_index = 0;
    //   }
    // }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text(
                alert_text_list.get(source_language_index)[wpes_labels.isEmpty
                    ? 9
                    : wpe_editor_alert_type == WpeEditorAlertType.save
                        ? 3
                        : wpe_editor_alert_type == WpeEditorAlertType.delete
                            ? 1
                            : 0],
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
              content: wpes_labels.isEmpty
                  ? Text(
                      alert_text_list.get(source_language_index)[10],
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    )
                  : null,
              actions: [
                if (wpes_labels.isNotEmpty)
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      alert_text_list.get(source_language_index)[7],
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    if (expandable_fab_key.currentState!.isOpen) {
                      expandable_fab_key.currentState!.toggle();
                    }

                    if (wpes_labels.isNotEmpty) {
                      switch (wpe_editor_alert_type) {
                        case WpeEditorAlertType.save:
                          save_wpe(
                            wpe: wpe,
                          );
                          break;
                        case WpeEditorAlertType.load:
                          print('TRES');
                          load_wpe();
                          break;
                        case WpeEditorAlertType.delete:
                          _asking_for_deletion_alert();
                          break;
                      }
                    }
                  },
                  child: Text(
                    alert_text_list.get(source_language_index)[wpes_labels
                            .isEmpty
                        ? 12
                        : wpe_editor_alert_type == WpeEditorAlertType.delete
                            ? 19
                            : wpe_editor_alert_type == WpeEditorAlertType.save
                                ? 18
                                : 17],
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
