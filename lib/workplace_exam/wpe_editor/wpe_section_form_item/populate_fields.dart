// ignore_for_file: invalid_use_of_protected_member

import 'package:xapptor_business/workplace_exam/models/wpe_section.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/wpe_section_form.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/wpe_section_form_item/wpe_section_form_item.dart';

extension StateExtension on WpeSectionFormItemState {
  populate_fields() {
    switch (widget.wpe_section_form_type) {
      case WpeSectionFormType.education:
        WpeCondition section = widget.section;

        if (section.subtitle != null) {
          int coma_index_1 = section.subtitle!.indexOf(", ");
          int coma_index_2 = section.subtitle!.lastIndexOf(", ");

          field_1_input_controller.text =
              section.subtitle!.substring(0, coma_index_1);

          field_2_input_controller.text =
              section.subtitle!.substring(coma_index_1 + 2, coma_index_2);

          field_3_input_controller.text =
              section.subtitle!.substring(coma_index_2 + 2);
        }

        selected_date_1 = section.begin;
        selected_date_2 = section.end;
        break;
    }
  }
}
