import 'package:flutter/material.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/wpe_editor.dart';
import 'package:xapptor_logic/form_field_validators.dart';
import 'package:xapptor_ui/values/ui.dart';
import 'package:xapptor_ui/widgets/text_field/custom_text_field.dart';
import 'package:xapptor_ui/widgets/text_field/custom_text_field_model.dart';

extension StateExtension on WpeEditorState {
  wpe_editor_section_hazard() => Container(
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
              text_list.get(source_language_index)[26],
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: sized_box_space),
            DropdownButtonFormField<String>(
              value: lototo_input_controller,
              onChanged: (String? new_value) {
                lototo_input_controller = new_value!;
              },
              items:
                  hazard!.lototos.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              isExpanded: true,
              decoration: InputDecoration(
                  labelText: text_list.get(source_language_index)[30],
                  hintText: text_list.get(source_language_index)[30],
                  border: const OutlineInputBorder(),
                  labelStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(0, 51, 160, 1),
                  )),
            ),
            SizedBox(height: sized_box_space),
            DropdownButtonFormField<String>(
              value: hit_or_caught_input_controller,
              onChanged: (String? new_value) {
                hit_or_caught_input_controller = new_value!;
              },
              items: hazard!.hit_or_caughts
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              isExpanded: true,
              decoration: InputDecoration(
                  labelText: text_list.get(source_language_index)[31],
                  hintText: text_list.get(source_language_index)[31],
                  border: const OutlineInputBorder(),
                  labelStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(0, 51, 160, 1),
                  )),
            ),
            SizedBox(height: sized_box_space),
            DropdownButtonFormField<String>(
              value: burn_input_controller,
              onChanged: (String? new_value) {
                burn_input_controller = new_value!;
              },
              items:
                  hazard!.burns.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              isExpanded: true,
              decoration: InputDecoration(
                  labelText: text_list.get(source_language_index)[32],
                  hintText: text_list.get(source_language_index)[32],
                  border: const OutlineInputBorder(),
                  labelStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(0, 51, 160, 1),
                  )),
            ),
            SizedBox(height: sized_box_space),
            DropdownButtonFormField<String>(
              value: health_input_controller,
              onChanged: (String? new_value) {
                health_input_controller = new_value!;
              },
              items:
                  hazard!.healths.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              isExpanded: true,
              decoration: InputDecoration(
                  labelText: text_list.get(source_language_index)[33],
                  hintText: text_list.get(source_language_index)[33],
                  border: const OutlineInputBorder(),
                  labelStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(0, 51, 160, 1),
                  )),
            ),
            SizedBox(height: sized_box_space),
            DropdownButtonFormField<String>(
              value: work_condition_input_controller,
              onChanged: (String? new_value) {
                work_condition_input_controller = new_value!;
              },
              items: hazard!.work_conditions
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              isExpanded: true,
              decoration: InputDecoration(
                  labelText: text_list.get(source_language_index)[34],
                  hintText: text_list.get(source_language_index)[34],
                  border: const OutlineInputBorder(),
                  labelStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(0, 51, 160, 1),
                  )),
            ),
            SizedBox(height: sized_box_space),
            DropdownButtonFormField<String>(
              value: fall_input_controller,
              onChanged: (String? new_value) {
                fall_input_controller = new_value!;
              },
              items:
                  hazard!.falls.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              isExpanded: true,
              decoration: InputDecoration(
                  labelText: text_list.get(source_language_index)[35],
                  hintText: text_list.get(source_language_index)[35],
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
                title: text_list.get(source_language_index)[40],
                hint: text_list.get(source_language_index)[40],
                focus_node: focus_node_4,
                on_field_submitted: (fieldValue) => null,
                controller: hazard_input_controller,
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
          ],
        ),
      );
}
