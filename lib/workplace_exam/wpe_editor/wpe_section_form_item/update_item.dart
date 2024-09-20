import 'package:flutter/material.dart';
import 'package:xapptor_business/workplace_exam/models/wpe_section.dart';
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
          section: WpeCondition(
            title: widget.item_index == 0 ? title : null,
            subtitle:
                "${field_1_input_controller.text}, ${field_2_input_controller.text}, ${field_3_input_controller.text}",
            begin: selected_date_1,
            end: selected_date_2,
          ),
          update_widget: update_widget,
        );
        break;
    }
  }
}
