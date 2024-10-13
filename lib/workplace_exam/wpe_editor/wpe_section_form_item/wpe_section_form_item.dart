import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/wpe_section_form.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/wpe_section_form_item/populate_fields.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/wpe_section_form_item/functional_icon_buttons.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/wpe_section_form_item/select_condition_date.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/wpe_section_form_item/update_item.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/crud/update/update_section.dart';
import 'package:xapptor_ui/values/ui.dart';
import 'package:xapptor_logic/form_field_validators.dart';
import 'package:xapptor_ui/values/xapptor_colors.dart';

class WpeSectionFormItem extends StatefulWidget {
  final WpeSectionFormType wpe_section_form_type;
  final List<String> text_list;
  final List<String> time_text_list;
  final Color text_color;
  final String language_code;
  final int item_index;
  final int section_index;

  final Function({
    required int item_index,
    required int section_index,
    required dynamic section,
    ChangeItemPositionType change_item_position_type,
    bool update_widget,
  }) update_item;

  final Function({
    required int item_index,
    required int section_index,
  }) remove_item;

  final Function({
    required int item_index,
    required int section_index,
  }) clone_item;

  final dynamic section;

  final bool show_up_arrow;
  final bool show_down_arrow;

  const WpeSectionFormItem({
    super.key,
    required this.wpe_section_form_type,
    required this.text_list,
    required this.time_text_list,
    required this.text_color,
    required this.language_code,
    required this.item_index,
    required this.section_index,
    required this.update_item,
    required this.remove_item,
    required this.clone_item,
    required this.section,
    required this.show_up_arrow,
    required this.show_down_arrow,
  });

  @override
  State<WpeSectionFormItem> createState() => WpeSectionFormItemState();
}

class WpeSectionFormItemState extends State<WpeSectionFormItem> {
  TextEditingController field_1_input_controller = TextEditingController();
  TextEditingController field_2_input_controller = TextEditingController();
  TextEditingController field_3_input_controller = TextEditingController();
  TextEditingController field_4_input_controller = TextEditingController();

  DateTime? selected_date_1;
  DateTime? selected_date_2;
  int selected_date_index = 0;
  String timeframe_text = "";

  @override
  void initState() {
    super.initState();
  }

  double current_slider_value = 2;

  Color picker_color = Colors.blue;
  Color current_color = Colors.blue;

  @override
  Widget build(BuildContext context) {
    populate_fields();

    double screen_width = MediaQuery.of(context).size.width;

    // if (selected_date_1 != null && selected_date_2 != null) {
    //   timeframe_text = get_timeframe_text(
    //     begin: selected_date_1!,
    //     end: selected_date_2!,
    //     language_code: widget.language_code,
    //     present_text: widget.text_list[4],
    //     text_list: widget.time_text_list,
    //   );
    // } else {
    //   timeframe_text = widget.text_list[5];
    // }

    DateFormat date_formatter = DateFormat.yMMMMd('en_US');
    String date_now_formatted = date_formatter.format(selected_date_1!);
    timeframe_text = date_now_formatted;

    String field_1_hint = "";
    String field_2_hint = "";
    String field_3_hint = "";

    switch (widget.wpe_section_form_type) {
      case WpeSectionFormType.education:
        field_1_hint = widget.text_list[10];
        field_2_hint = widget.text_list[11];
        field_3_hint = widget.text_list[12];
        break;
    }

    return Container(
      alignment: Alignment.center,
      width: double.maxFinite,
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
          color: current_color,
          width: 3,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          SizedBox(
            height: sized_box_space,
          ),
          TextFormField(
            onChanged: (new_value) {
              update_item(
                update_widget: false,
              );
            },
            decoration: InputDecoration(
              labelText: field_1_hint,
              labelStyle: TextStyle(
                color: XapptorColors.blue[700],
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: widget.text_color,
                ),
              ),
            ),
            controller: field_1_input_controller,
            validator: (value) => FormFieldValidators(
              value: value!,
              type: FormFieldValidatorsType.name,
            ).validate(),
            maxLength: 60,
          ),
          Column(
            children: [
              TextFormField(
                onChanged: (new_value) {
                  update_item(
                    update_widget: false,
                  );
                },
                decoration: InputDecoration(
                  labelText: field_2_hint,
                  labelStyle: TextStyle(
                    color: XapptorColors.blue[700],
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: widget.text_color,
                    ),
                  ),
                ),
                controller: field_2_input_controller,
                validator: (value) => FormFieldValidators(
                  value: value!,
                  type: FormFieldValidatorsType.name,
                ).validate(),
                maxLength: 60,
              ),
              TextFormField(
                onChanged: (new_value) {
                  update_item(
                    update_widget: false,
                  );
                },
                decoration: InputDecoration(
                  labelText: field_3_hint,
                  labelStyle: TextStyle(
                    color: XapptorColors.blue[700],
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: widget.text_color,
                    ),
                  ),
                ),
                controller: field_3_input_controller,
                validator: (value) => FormFieldValidators(
                  value: value!,
                  type: FormFieldValidatorsType.name,
                ).validate(),
                keyboardType: TextInputType.multiline,
                maxLines: null,
                maxLength: 60,
              ),
            ],
          ),
          SizedBox(
            height: sized_box_space,
          ),
          SizedBox(
            width: screen_width,
            child: ElevatedButton(
              style: ButtonStyle(
                elevation: WidgetStateProperty.all<double>(
                  0,
                ),
                backgroundColor: WidgetStateProperty.all<Color>(
                  Colors.transparent,
                ),
                overlayColor: WidgetStateProperty.all<Color>(
                  Colors.grey.withOpacity(0.2),
                ),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.width,
                    ),
                    side: BorderSide(
                      color: widget.text_color,
                    ),
                  ),
                ),
              ),
              onPressed: () {
                select_condition_date();
              },
              child: Text(
                timeframe_text,
                style: TextStyle(
                  //color: widget.text_color,
                  color: XapptorColors.neutral[800],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          functional_icon_buttons(),
        ],
      ),
    );
  }
}
