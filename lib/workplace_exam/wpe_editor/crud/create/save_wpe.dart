import 'package:firebase_storage/firebase_storage.dart';
import 'package:xapptor_business/models/wpe.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/crud/read/get_profile_image_ref.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/wpe_editor.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/crud/create/set_wpe.dart';

extension StateExtension on WpeEditorState {
  save_wpe({
    required Wpe wpe,
    Function? callback,
  }) async {
    if (chosen_image_path.isNotEmpty && chosen_image_bytes != null) {
      Reference profile_image_ref = get_profile_image_ref(
        chosen_image_path: chosen_image_path,
      );

      await profile_image_ref.putData(chosen_image_bytes!).then((snap) async {
        chosen_image_url = await snap.ref.getDownloadURL();
        wpe.before_picture1 = chosen_image_url;

        set_wpe(
          wpe: wpe,
        );
      });
    } else {
      set_wpe(
        wpe: wpe,
      );
    }
    if (callback != null) callback();
  }
}
