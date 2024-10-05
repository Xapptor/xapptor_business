import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/wpe_editor.dart';
import 'package:xapptor_logic/form_field_validators.dart';
import 'package:xapptor_ui/values/ui.dart';
import 'package:xapptor_ui/widgets/text_field/custom_text_field.dart';
import 'package:xapptor_ui/widgets/text_field/custom_text_field_model.dart';

extension StateExtension on WpeEditorState {
  wpe_editor_section_header() => Column(
        children: [
          SizedBox(height: sized_box_space * 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SelectableText(
                "DOC ID: $wpe_number",
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SelectableText(
                "DATE: ${DateFormat('MM-dd-yyyy').format(wpe_date).toString()}",
                //"DATE: ${wpe_date.toString()}",
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: sized_box_space),
          DropdownButtonFormField<String>(
            value: shift_input_controller,
            onChanged: (String? new_value) {
              shift_input_controller = new_value!;
            },
            items: site?.shifts.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            isExpanded: true,
            decoration: InputDecoration(
                labelText: text_list.get(source_language_index)[2],
                hintText: text_list.get(source_language_index)[2],
                border: const OutlineInputBorder(),
                labelStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(0, 51, 160, 1),
                )),
          ),
          SizedBox(height: sized_box_space),
          DropdownButtonFormField<String>(
            value: supervisor_input_controller,
            onChanged: (String? new_value) {
              supervisor_input_controller = new_value!;
            },
            items:
                supervisor_list.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            isExpanded: true,
            decoration: InputDecoration(
                labelText: text_list.get(source_language_index)[5],
                hintText: text_list.get(source_language_index)[5],
                border: const OutlineInputBorder(),
                labelStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(0, 51, 160, 1),
                )),
          ),
          SizedBox(height: sized_box_space),
          DropdownButtonFormField<String>(
            value: area_input_controller,
            onChanged: (String? new_value) {
              area_input_controller = new_value!;
            },
            items: area_list.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            isExpanded: true,
            decoration: InputDecoration(
                labelText: text_list.get(source_language_index)[3],
                hintText: text_list.get(source_language_index)[3],
                border: const OutlineInputBorder(),
                labelStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(0, 51, 160, 1),
                )),
          ),
          SizedBox(height: sized_box_space),
          CustomTextField(
            model: CustomTextFieldModel(
              title: text_list.get(source_language_index)[4],
              hint: text_list.get(source_language_index)[4],
              focus_node: focus_node_1,
              on_field_submitted: (fieldValue) => null,
              controller: specific_input_controller,
              length_limit: FormFieldValidatorsType.name.get_Length(),
              validator: (value) => FormFieldValidators(
                value: value!,
                type: FormFieldValidatorsType.name,
              ).validate(),
              keyboard_type: TextInputType.multiline,
              max_lines: null,
            ),
          ),

          //SizedBox(height: sized_box_space),
          // CustomTextField(
          //   model: CustomTextFieldModel(
          //     title: text_list.get(source_language_index)[5],
          //     hint: text_list.get(source_language_index)[5],
          //     focus_node: focus_node_5,
          //     on_field_submitted: (fieldValue) => null,
          //     controller: sections_by_page_input_controller,
          //     length_limit: FormFieldValidatorsType.multiline_long.get_Length(),
          //     validator: (value) => FormFieldValidators(
          //       value: value!,
          //       type: FormFieldValidatorsType.multiline_long,
          //     ).validate(),
          //     keyboard_type: TextInputType.multiline,
          //     max_lines: null,
          //   ),
          // ),
        ],
      );
}
