import 'package:xapptor_db/xapptor_db.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/wpe_editor.dart';

extension StateExtension on WpeEditorState {
  get_wpe_ref() {
    String? wpe_doc_id = (widget.id != "New") ? widget.id : null;
    return XapptorDB.instance.collection("wpes").doc(wpe_doc_id);
  }
}
