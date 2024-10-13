// ignore_for_file: invalid_use_of_protected_member

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:xapptor_business/models/area.dart';
import 'package:xapptor_business/models/supervisor.dart';
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
                "Doc ID: $wpe_number",
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SelectableText(
                "Date: ${DateFormat('MM-dd-yyyy').format(wpe_date).toString()}",
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: sized_box_space),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SelectableText(
                text_list.get(source_language_index)[41],
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Switch(
                value: wpe_close,
                onChanged: (value) {
                  setState(() {
                    wpe_close = value;
                    wpe_date_close = wpe_close ? Timestamp.now() : null;
                  });
                },
                activeTrackColor: Colors.white,
                activeColor: Colors.red,
                inactiveThumbColor: Colors.green,
                inactiveTrackColor: Colors.white,
                trackOutlineColor: WidgetStateProperty.resolveWith<Color?>(
                    (Set<WidgetState> states) {
                  return Colors.blue.withOpacity(.48);
                }),
              ),
              Text(
                wpe_close
                    ? text_list.get(source_language_index)[42]
                    : text_list.get(source_language_index)[43],
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: wpe_close ? Colors.red : Colors.green),
              ),
            ],
          ),
          SizedBox(height: sized_box_space),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SelectableText(
                text_list.get(source_language_index)[44],
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SelectableText(
                wpe_date_close != null
                    ? " ${DateFormat('MM-dd-yyyy').format(wpe_date_close!.toDate()).toString()}"
                    : "",
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ],
          ),
          SizedBox(height: sized_box_space * 2),
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
          //Supervisor
          Row(
            children: [
              // Dropdown para seleccionar supervisores
              Expanded(
                flex: 2,
                child: DropdownButtonFormField<Supervisor>(
                  value: selectedSupervisor,
                  onChanged: (Supervisor? new_value) {
                    setState(() {
                      selectedSupervisor = new_value!;
                      departmentSupervisorController.text =
                          selectedSupervisor?.department_name ?? '';
                    });
                  },
                  items: supervisor_list.map((Supervisor supervisor) {
                    return DropdownMenuItem<Supervisor>(
                      value: supervisor,
                      child: Text(supervisor.name),
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
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              //SizedBox(height: sized_box_space),
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: departmentSupervisorController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: text_list.get(source_language_index)[38],
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
          //Area
          Row(
            children: [
              Expanded(
                flex: 2,
                child: DropdownButtonFormField<Area>(
                  value: selectedArea,
                  onChanged: (Area? new_value) {
                    setState(() {
                      selectedArea = new_value!;
                      departmentAreaController.text =
                          selectedArea?.department ?? '';
                    });
                  },
                  items: area_list.map((Area p_area) {
                    return DropdownMenuItem<Area>(
                      value: p_area,
                      child: Text(p_area.area),
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
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              //SizedBox(height: sized_box_space),
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: departmentAreaController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: text_list.get(source_language_index)[38],
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
        ],
      );
}
