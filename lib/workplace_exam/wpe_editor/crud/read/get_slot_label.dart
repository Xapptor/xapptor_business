import 'package:xapptor_business/workplace_exam/wpe_editor/wpe_editor.dart';

extension StateExtension on WpeEditorState {
  String get_slot_label({
    required int slot_index,
  }) {
    return slot_index == 0
        ? alert_text_list.get(source_language_index)[9]
        : "${alert_text_list.get(source_language_index)[8]} $slot_index";
  }
}
