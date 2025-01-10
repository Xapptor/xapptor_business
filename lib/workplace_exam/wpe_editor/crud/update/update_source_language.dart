// ignore_for_file: invalid_use_of_protected_member
import 'package:xapptor_business/workplace_exam/wpe_editor/wpe_editor.dart';

extension StateExtension on WpeEditorState {
  update_source_language({
    required int new_source_language_index,
  }) {
    source_language_index = new_source_language_index;
    setState(() {});
  }
}
