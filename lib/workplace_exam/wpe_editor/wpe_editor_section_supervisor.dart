import 'package:flutter/material.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/wpe_editor.dart';
import 'package:xapptor_logic/form_field_validators.dart';
import 'package:xapptor_ui/values/ui.dart';
import 'package:xapptor_ui/widgets/text_field/custom_text_field.dart';
import 'package:xapptor_ui/widgets/text_field/custom_text_field_model.dart';

extension StateExtension on WpeEditorState {
  wpe_editor_section_supervisor() => Container(
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
            Text(
              text_list.get(source_language_index)[29],
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: sized_box_space),
            CustomTextField(
              model: CustomTextFieldModel(
                title: text_list.get(source_language_index)[22],
                hint: text_list.get(source_language_index)[22],
                focus_node: focus_node_5,
                on_field_submitted: (fieldValue) => focus_node_6.requestFocus(),
                controller: supervisor_cmmt_input_controller,
                length_limit:
                    FormFieldValidatorsType.multiline_long.get_Length(),
                validator: (value) => FormFieldValidators(
                  value: value!,
                  type: FormFieldValidatorsType.multiline_long,
                ).validate(),
                keyboard_type: TextInputType.multiline,
                max_lines: null,
              ),
            ),
            SizedBox(height: sized_box_space),
          ],
        ),
      );
}
