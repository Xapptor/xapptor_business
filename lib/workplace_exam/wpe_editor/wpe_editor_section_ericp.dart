import 'package:flutter/material.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/wpe_editor.dart';
import 'package:xapptor_logic/form_field_validators.dart';
import 'package:xapptor_ui/values/ui.dart';
import 'package:xapptor_ui/values/xapptor_colors.dart';

extension StateExtension on WpeEditorState {
  wpe_editor_section_ericp() => Container(
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
              text_list.get(source_language_index)[27],
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: sized_box_space),
            TextFormField(
              decoration: InputDecoration(
                labelText: text_list.get(source_language_index)[16],
                labelStyle: TextStyle(
                  color: XapptorColors.blue[700],
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: current_color,
                  ),
                ),
              ),
              controller: eliminated_input_controller,
              validator: (value) => FormFieldValidators(
                value: value!,
                type: FormFieldValidatorsType.name,
              ).validate(),
              maxLength: 60,
            ),
            SizedBox(height: sized_box_space),
            TextFormField(
              decoration: InputDecoration(
                labelText: text_list.get(source_language_index)[17],
                labelStyle: TextStyle(
                  color: XapptorColors.blue[700],
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: current_color,
                  ),
                ),
              ),
              controller: reduced_input_controller,
              validator: (value) => FormFieldValidators(
                value: value!,
                type: FormFieldValidatorsType.name,
              ).validate(),
              maxLength: 60,
            ),
            SizedBox(height: sized_box_space),
            TextFormField(
              decoration: InputDecoration(
                labelText: text_list.get(source_language_index)[18],
                labelStyle: TextStyle(
                  color: XapptorColors.blue[700],
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: current_color,
                  ),
                ),
              ),
              controller: isolated_input_controller,
              validator: (value) => FormFieldValidators(
                value: value!,
                type: FormFieldValidatorsType.name,
              ).validate(),
              maxLength: 60,
            ),
            SizedBox(height: sized_box_space),
            TextFormField(
              decoration: InputDecoration(
                labelText: text_list.get(source_language_index)[19],
                labelStyle: TextStyle(
                  color: XapptorColors.blue[700],
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: current_color,
                  ),
                ),
              ),
              controller: controled_input_controller,
              validator: (value) => FormFieldValidators(
                value: value!,
                type: FormFieldValidatorsType.name,
              ).validate(),
              maxLength: 60,
            ),
            SizedBox(height: sized_box_space),
            TextFormField(
              decoration: InputDecoration(
                labelText: text_list.get(source_language_index)[20],
                labelStyle: TextStyle(
                  color: XapptorColors.blue[700],
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: current_color,
                  ),
                ),
              ),
              controller: ppe_input_controller,
              validator: (value) => FormFieldValidators(
                value: value!,
                type: FormFieldValidatorsType.name,
              ).validate(),
              maxLength: 60,
            ),
            SizedBox(height: sized_box_space),
          ],
        ),
      );
}
