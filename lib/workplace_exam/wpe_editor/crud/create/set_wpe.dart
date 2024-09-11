// ignore_for_file: invalid_use_of_protected_member

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xapptor_business/workplace_exam/models/wpe.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/crud/read/get_wpe_ref.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/wpe_editor.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/show_result_snack_bar.dart';

extension StateExtension on ResumeEditorState {
  set_resume({
    required int new_slot_index,
    required Resume resume,
  }) async {
    resume.slot_index = new_slot_index;
    DocumentReference resume_doc_ref = get_resume_ref(
      slot_index: new_slot_index,
    );

    Map resume_json = resume.to_json();

    if (resume_json['image_url'].isEmpty) {
      resume_json.remove('image_url');
    }

    slot_index = new_slot_index;
    setState(() {});

    await resume_doc_ref
        .set(
      resume_json,
      SetOptions(merge: true),
    )
        .then((value) {
      show_result_snack_bar(
        result_snack_bar_type: ResultSnackBarType.saved,
        slot_index: new_slot_index,
      );
    });
  }
}
