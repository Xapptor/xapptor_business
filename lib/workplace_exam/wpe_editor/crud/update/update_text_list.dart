// ignore_for_file: invalid_use_of_protected_member

import 'package:xapptor_business/workplace_exam/wpe_editor/wpe_editor.dart';

extension StateExtension on WpeEditorState {
  update_text_list({
    required int index,
    required String new_text,
    required int list_index,
  }) {
    if (list_index == 0) {
      text_list.get(source_language_index)[index] = new_text;
    } else if (list_index == 1) {
      //skill_text_list.get(source_language_index)[index] = new_text;
    } else if (list_index == 2) {
      //employment_text_list.get(source_language_index)[index] = new_text;
    } else if (list_index == 3) {
      education_text_list.get(source_language_index)[index] = new_text;
    } else if (list_index == 4) {
      picker_text_list.get(source_language_index)[index] = new_text;
    } else if (list_index == 5) {
      sections_by_page_text_list.get(source_language_index)[index] = new_text;
    } else if (list_index == 6) {
      time_text_list.get(source_language_index)[index] = new_text;
    }
    setState(() {});
  }
}
