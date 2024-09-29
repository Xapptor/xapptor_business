import 'package:xapptor_business/models/condition.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/wpe_section_form.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/wpe_section_form_item/wpe_section_form_item.dart';

extension StateExtension on WpeSectionFormItemState {
  update_item({
    bool update_widget = true,
  }) async {
    String title = "";
    switch (widget.wpe_section_form_type) {
      case WpeSectionFormType.education:
        title = widget.text_list[8];
        break;
    }

    switch (widget.wpe_section_form_type) {
      case WpeSectionFormType.education:
        widget.update_item(
          item_index: widget.item_index,
          section_index: widget.section_index,
          section: Condition(
            promptly_corrected: field_1_input_controller.text,
            not_promptly_corrected: field_2_input_controller.text,
            mitigating_action: field_3_input_controller.text,
            date_corrected: selected_date_1,
            //date_corrected: selected_date_2,
          ),
          update_widget: update_widget,
        );
        break;
    }
  }
}
