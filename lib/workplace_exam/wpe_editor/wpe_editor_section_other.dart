// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:xapptor_business/models/maint_supervisor.dart';
import 'package:xapptor_business/models/transversal.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/wpe_editor.dart';
import 'package:xapptor_logic/form_field_validators.dart';
import 'package:xapptor_ui/values/ui.dart';
import 'package:xapptor_ui/widgets/text_field/custom_text_field.dart';
import 'package:xapptor_ui/widgets/text_field/custom_text_field_model.dart';

extension StateExtension on WpeEditorState {
  wpe_editor_section_other() => Container(
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
              text_list.get(source_language_index)[25],
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: sized_box_space),
            CustomTextField(
              model: CustomTextFieldModel(
                title: text_list.get(source_language_index)[6],
                hint: text_list.get(source_language_index)[6],
                focus_node: focus_node_3,
                on_field_submitted: (fieldValue) => focus_node_4.requestFocus(),
                controller: order_input_controller,
                length_limit: FormFieldValidatorsType.name.get_Length(),
                validator: (value) => FormFieldValidators(
                  value: value!,
                  type: FormFieldValidatorsType.name,
                ).validate(),
                keyboard_type: TextInputType.multiline,
                max_lines: null,
              ),
            ),
            SizedBox(height: sized_box_space),
            //Transversal
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<Transversal>(
                    value: selectedTransversal,
                    onChanged: (Transversal? new_value) {
                      setState(() {
                        selectedTransversal = new_value!;
                        responsibleController.text =
                            selectedTransversal?.responsible ?? '';
                      });
                    },
                    items: transversal_list.map((Transversal p_transversal) {
                      return DropdownMenuItem<Transversal>(
                        value: p_transversal,
                        child: Text(p_transversal.location),
                      );
                    }).toList(),
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: text_list.get(source_language_index)[7],
                      hintText: text_list.get(source_language_index)[7],
                      border: const OutlineInputBorder(),
                      labelStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(0, 51, 160, 1),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                //SizedBox(height: sized_box_space),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: responsibleController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: text_list.get(source_language_index)[39],
                      labelStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(0, 51, 160, 1),
                      ),
                    ),
                    readOnly: true, // Solo lectura
                  ),
                ),
              ],
            ),
            SizedBox(height: sized_box_space),
            DropdownButtonFormField<MaintSupervisor>(
              value: selectedMaintSupervisor,
              onChanged: (MaintSupervisor? new_value) {
                selectedMaintSupervisor = new_value!;
              },
              items: maintenance_list.map((MaintSupervisor p_maint) {
                return DropdownMenuItem<MaintSupervisor>(
                  value: p_maint,
                  child: Text(p_maint.name),
                );
              }).toList(),
              isExpanded: true,
              decoration: InputDecoration(
                  labelText: text_list.get(source_language_index)[8],
                  hintText: text_list.get(source_language_index)[8],
                  border: const OutlineInputBorder(),
                  labelStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(0, 51, 160, 1),
                  )),
            ),
          ],
        ),
      );
}
