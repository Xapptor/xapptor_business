import 'package:flutter/material.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/crud/delete/remove_item.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/crud/update/clone_item.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/wpe_editor.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/wpe_section_form.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/crud/update/update_section.dart';
import 'package:xapptor_ui/values/ui.dart';

extension StateExtension on WpeEditorState {
  wpe_sections() => Column(
        children: [
          WpeSectionForm(
            wpe_section_form_type: WpeSectionFormType.education,
            text_list: text_list.get(source_language_index).sublist(7, 18) +
                education_text_list.get(source_language_index),
            time_text_list: time_text_list.get(source_language_index),
            text_color: widget.color_topbar,
            language_code:
                text_list.list[source_language_index].source_language,
            section_index: 2,
            update_section: update_section,
            remove_item: remove_item,
            clone_item: clone_item,
            section_list: condition_sections,
          ),
          SizedBox(
            height: sized_box_space * 2,
          ),
        ],
      );
}
