import 'package:firebase_storage/firebase_storage.dart';
import 'package:xapptor_business/workplace_exam/models/wpe.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/crud/read/get_profile_image_ref.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/wpe_editor.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/crud/create/set_wpe.dart';

extension StateExtension on ResumeEditorState {
  save_resume({
    required Resume resume,
    Function? callback,
  }) async {
    if (chosen_image_path.isNotEmpty && chosen_image_bytes != null) {
      Reference profile_image_ref = get_profile_image_ref(
        chosen_image_path: chosen_image_path,
      );

      await profile_image_ref.putData(chosen_image_bytes!).then((snap) async {
        chosen_image_url = await snap.ref.getDownloadURL();
        resume.image_url = chosen_image_url;

        set_resume(
          new_slot_index: slot_index,
          resume: resume,
        );
      });
    } else {
      set_resume(
        new_slot_index: slot_index,
        resume: resume,
      );
    }
    if (callback != null) callback();
  }
}
