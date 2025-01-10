import 'package:intl/intl.dart';
import 'package:xapptor_business/models/wpe.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/wpe_editor_alert.dart';

get_wpes_labels({
  required Wpe current_wpe,
  required String main_label,
  required String backup_label,
  required WpeEditorAlertType wpe_editor_alert_type,
}) {
  DateFormat date_format = DateFormat('yyyy/MM/dd, hh:mm a');
  List<String> labels = [];

  bool main_wpe_exists = true;

  if (main_wpe_exists) {
    Wpe main_wpe = current_wpe;

    String label = "";

    label = main_label;

    if (main_wpe.created_date == Wpe.empty().created_date) {
      label = main_label;
    } else {
      String main_date_String =
          date_format.format(main_wpe.created_date.toDate());
      label = "$main_label - $main_date_String";
    }

    labels.add(label);
  }
  //int loop_limit = 3;

  // for (int i = 1; i <= loop_limit; i++) {
  //   bool wpe_exists = wpes.any((wpe) => wpe.slot_index == i);

  //   String label = "";

  //   if (wpe_exists) {
  //     var current_wpe = wpes.firstWhere((wpe) => wpe.slot_index == i);
  //     String backup_date_String =
  //         date_format.format(current_wpe.created_date.toDate());

  //     label = "$backup_label ${current_wpe.slot_index} - $backup_date_String";
  //   } else {
  //     label = "$backup_label $i";
  //   }

  //   if (wpe_editor_alert_type == WpeEditorAlertType.save) {
  //     labels.add(label);
  //   } else {
  //     if (wpe_exists) {
  //       labels.add(label);
  //     }
  //   }
  // }
  return labels;
}
