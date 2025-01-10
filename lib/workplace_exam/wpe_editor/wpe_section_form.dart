import 'package:flutter/material.dart';
import 'package:xapptor_business/models/condition.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/wpe_section_form_item/wpe_section_form_item.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/crud/update/update_section.dart';
import 'package:xapptor_ui/values/ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum WpeSectionFormType {
  education,
}

class WpeSectionForm extends StatefulWidget {
  final WpeSectionFormType wpe_section_form_type;
  final List<String> text_list;
  final List<String> time_text_list;

  final Color text_color;
  final String language_code;
  final int section_index;

  final Function({
    required int item_index,
    required int section_index,
    required dynamic section,
    ChangeItemPositionType change_item_position_type,
    bool update_widget,
  }) update_section;

  final Function({
    required int item_index,
    required int section_index,
  }) remove_item;

  final Function({
    required int item_index,
    required int section_index,
  }) clone_item;

  final List<dynamic> section_list;

  const WpeSectionForm({
    super.key,
    required this.wpe_section_form_type,
    required this.text_list,
    required this.time_text_list,
    required this.text_color,
    required this.language_code,
    required this.section_index,
    required this.update_section,
    required this.remove_item,
    required this.clone_item,
    required this.section_list,
  });

  @override
  State<WpeSectionForm> createState() => _WpeSectionFormState();
}

class _WpeSectionFormState extends State<WpeSectionForm> {
  TextEditingController promptly_input_controller = TextEditingController();
  TextEditingController not_promptly_input_controller = TextEditingController();
  TextEditingController mitigation_input_controller = TextEditingController();

  DateTime? selected_date_1;
  int selected_date_index = 0;

  remove_item({
    required int item_index,
    required int section_index,
  }) {
    widget.remove_item(
      item_index: item_index,
      section_index: section_index,
    );
  }

  clone_item({
    required int item_index,
    required int section_index,
  }) {
    widget.clone_item(
      item_index: item_index,
      section_index: section_index,
    );
  }

  @override
  void initState() {
    super.initState();
  }

  _add_item() {
    widget.update_section(
      item_index: widget.section_list.length,
      section_index: widget.section_index,
      section: Condition.empty(),
      update_widget: true,
    );
  }

  show_snack_bar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: SelectableText(
          widget.text_list[10],
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String title = "";

    switch (widget.wpe_section_form_type) {
      case WpeSectionFormType.education:
        title = widget.text_list[8];
        break;
    }

    return Column(
      children: [
        SizedBox(
          height: sized_box_space * 2,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              onPressed: () {
                if (widget.section_list.isNotEmpty) {
                  Condition last_section = widget.section_list.last;
                  if (last_section.promptly_corrected != null ||
                      last_section.not_promptly_corrected != null ||
                      last_section.mitigating_action != null) {
                    _add_item();
                  } else {
                    show_snack_bar();
                  }
                } else {
                  _add_item();
                }
              },
              icon: const Icon(
                FontAwesomeIcons.squarePlus,
              ),
              color: Colors.blue,
            ),
          ],
        ),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: widget.section_list.length,
          itemBuilder: (context, index) {
            bool show_up_arrow = true;
            bool show_down_arrow = true;

            if (index == 0) {
              show_up_arrow = false;
            }

            if (index == widget.section_list.length - 1) {
              show_down_arrow = false;
            }

            if (widget.section_list.length == 1) {
              show_up_arrow = false;
              show_down_arrow = false;
            }
            return WpeSectionFormItem(
              wpe_section_form_type: widget.wpe_section_form_type,
              text_list: widget.text_list.sublist(0, 10) +
                  widget.text_list.sublist(11),
              time_text_list: widget.time_text_list,
              text_color: widget.text_color,
              language_code: widget.language_code,
              item_index: index,
              section_index: widget.section_index,
              update_item: widget.update_section,
              remove_item: remove_item,
              clone_item: clone_item,
              section: widget.section_list[index],
              show_up_arrow: show_up_arrow,
              show_down_arrow: show_down_arrow,
            );
          },
        ),
      ],
    );
  }
}
