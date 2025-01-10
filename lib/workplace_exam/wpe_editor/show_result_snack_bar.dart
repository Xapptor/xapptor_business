import 'package:xapptor_business/workplace_exam/wpe_editor/wpe_editor.dart';
import 'package:xapptor_ui/utils/show_alert.dart';

enum ResultSnackBarType {
  loaded,
  saved,
  deleted,
}

extension StateExtension on WpeEditorState {
  show_result_snack_bar({
    required ResultSnackBarType result_snack_bar_type,
  }) {
    String message = "";
    String? slot_label = wpe_number.toString();
    int textIndex = 0;

    switch (result_snack_bar_type) {
      case ResultSnackBarType.loaded:
        textIndex = 14;
        break;
      case ResultSnackBarType.saved:
        textIndex = 15;
        break;
      case ResultSnackBarType.deleted:
        textIndex = 16;
        break;
    }
    message =
        "${alert_text_list.get(source_language_index)[textIndex]}: $slot_label";
    show_success_alert(
      context: context,
      message: message,
    );
  }
}
