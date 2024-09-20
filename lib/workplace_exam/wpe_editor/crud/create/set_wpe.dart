// ignore_for_file: invalid_use_of_protected_member

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xapptor_business/models/wpe.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/crud/read/get_wpe_ref.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/wpe_editor.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/show_result_snack_bar.dart';

extension StateExtension on WpeEditorState {
  set_wpe({
    required int new_slot_index,
    required Wpe wpe,
  }) async {
    wpe.slot_index = new_slot_index;
    DocumentReference wpe_doc_ref = get_wpe_ref(
      slot_index: new_slot_index,
    );

    Map wpe_json = wpe.to_json();

    // if (wpe_json['before_picture1'].isEmpty) {
    //   wpe_json.remove('before_picture1');
    // }

    slot_index = new_slot_index;
    setState(() {});

    await wpe_doc_ref
        .set(
      wpe_json,
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
