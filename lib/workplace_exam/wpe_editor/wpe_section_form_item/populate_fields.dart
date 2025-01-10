// ignore_for_file: invalid_use_of_protected_member

import 'package:xapptor_business/models/condition.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/wpe_section_form.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/wpe_section_form_item/wpe_section_form_item.dart';

extension StateExtension on WpeSectionFormItemState {
  populate_fields() {
    switch (widget.wpe_section_form_type) {
      case WpeSectionFormType.education:
        Condition section = widget.section;
        //print(section.to_json());

        if (section.not_promptly_corrected != null) {
          field_1_input_controller.text = section.promptly_corrected!;

          field_2_input_controller.text = section.not_promptly_corrected!;

          field_3_input_controller.text = section.mitigating_action!;
        }

        selected_date_1 = section.date_corrected;
        break;
    }
  }
}
