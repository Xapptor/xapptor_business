import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/crud/read/get_wpe_ref.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/crud/read/get_wpes.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/load_wpe.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/wpe_editor.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/show_result_snack_bar.dart';

extension StateExtension on WpeEditorState {
  delete_wpe({
    required int slot_index,
  }) async {
    DocumentReference wpe_doc_ref = get_wpe_ref(
      slot_index: slot_index,
    );

    await wpe_doc_ref.delete().then((value) async {
      wpes.removeAt(slot_index);

      show_result_snack_bar(
        result_snack_bar_type: ResultSnackBarType.deleted,
        slot_index: slot_index,
      );

      wpes = await get_wpes(
        user_id: current_user!.uid,
      );

      load_wpe(
        new_slot_index: wpes.isNotEmpty ? wpes.first.slot_index : 0,
      );
    });
  }
}
