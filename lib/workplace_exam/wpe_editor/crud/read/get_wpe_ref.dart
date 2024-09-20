import 'package:xapptor_db/xapptor_db.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/wpe_editor.dart';

extension StateExtension on WpeEditorState {
  get_wpe_ref({
    required int slot_index,
  }) {
    String wpe_doc_id =
        "${current_user!.uid}_${text_list.list[source_language_index].source_language}";

    if (slot_index != 0) {
      wpe_doc_id += "_bu_$slot_index";
    }
    return XapptorDB.instance.collection("wpes").doc(wpe_doc_id);
  }
}
