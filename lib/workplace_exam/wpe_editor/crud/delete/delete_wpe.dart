import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/crud/read/get_wpe_ref.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/crud/read/get_wpes.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/load_wpe.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/wpe_editor.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/show_result_snack_bar.dart';

extension StateExtension on ResumeEditorState {
  delete_resume({
    required int slot_index,
  }) async {
    DocumentReference resume_doc_ref = get_resume_ref(
      slot_index: slot_index,
    );

    await resume_doc_ref.delete().then((value) async {
      resumes.removeAt(slot_index);

      show_result_snack_bar(
        result_snack_bar_type: ResultSnackBarType.deleted,
        slot_index: slot_index,
      );

      resumes = await get_resumes(
        user_id: current_user!.uid,
      );

      load_resume(
        new_slot_index: resumes.isNotEmpty ? resumes.first.slot_index : 0,
      );
    });
  }
}
