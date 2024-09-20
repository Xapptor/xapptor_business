// ignore_for_file: invalid_use_of_protected_member

import 'package:xapptor_business/workplace_exam/models/wpe_section.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/wpe_editor.dart';
import 'package:xapptor_logic/extensions/list.dart';

enum ChangeItemPositionType {
  none,
  move_up,
  move_down,
}

extension StateExtension on WpeEditorState {
  update_section({
    required int item_index,
    required int section_index,
    required dynamic section,
    ChangeItemPositionType change_item_position_type =
        ChangeItemPositionType.none,
    bool update_widget = true,
  }) {
    late List<dynamic> dynamic_sections;

    if (section_index == 0) {
      //dynamic_sections = skill_sections;
    } else if (section_index == 1) {
      //dynamic_sections = employment_sections;
    } else if (section_index == 2) {
      dynamic_sections = condition_sections;
    } else if (section_index == 3) {
      //dynamic_sections = custom_sections;
    }

    dynamic_sections = _update_dynamic(
      dynamic_sections: dynamic_sections,
      item_index: item_index,
      section_index: section_index,
      section: section,
      change_item_position_type: change_item_position_type,
    );

    if (section_index == 0) {
      //skill_sections = dynamic_sections as List<WpeSkill>;
    } else if (section_index == 1) {
      //employment_sections = dynamic_sections as List<WpeCondition>;
    } else if (section_index == 2) {
      condition_sections = dynamic_sections as List<WpeCondition>;
    } else if (section_index == 3) {
      //custom_sections = dynamic_sections as List<WpeCondition>;
    }

    if (update_widget) {
      setState(() {});
    }
  }

  List<dynamic> _update_dynamic({
    required List<dynamic> dynamic_sections,
    required int item_index,
    required int section_index,
    required dynamic section,
    ChangeItemPositionType change_item_position_type =
        ChangeItemPositionType.none,
  }) {
    if (change_item_position_type != ChangeItemPositionType.none) {
      if (change_item_position_type == ChangeItemPositionType.move_up) {
        dynamic_sections.swap(item_index, item_index - 1);
      } else if (change_item_position_type ==
          ChangeItemPositionType.move_down) {
        dynamic_sections.swap(item_index, item_index + 1);
      }
    } else {
      if (item_index < dynamic_sections.length) {
        dynamic_sections[item_index] = section;
      } else {
        dynamic_sections.add(section);
      }
    }
    return dynamic_sections;
  }
}
