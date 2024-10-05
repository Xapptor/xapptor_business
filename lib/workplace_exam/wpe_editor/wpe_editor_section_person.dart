// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:xapptor_business/models/person.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/wpe_editor.dart';
import 'package:xapptor_ui/values/ui.dart';

extension StateExtension on WpeEditorState {
  wpe_editor_section_person() => Container(
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text_list.get(source_language_index)[24],
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: sized_box_space),
          // Autocomplete para seleccionar valores
          Autocomplete<Person>(
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text.isEmpty) {
                return const Iterable<Person>.empty();
              } else {
                return person_list.where((Person person) => person.name
                    .toLowerCase()
                    .contains(textEditingValue.text.toLowerCase()));
              }
            },
            displayStringForOption: (option) => option.name,
            onSelected: (Person new_person) {
              setState(() {
                selectedPerson = new_person;
              });
            },
            fieldViewBuilder:
                (context, textEditingController, focusNode, onFieldSubmitted) {
              person_controller = textEditingController;
              return TextField(
                controller:
                    person_controller, // Utilizamos nuestro controlador aquí
                focusNode: focusNode,
                onSubmitted: (String value) {
                  onFieldSubmitted();
                },
                decoration: InputDecoration(
                  labelText: text_list.get(source_language_index)[37],
                ),
              );
            },
          ),
          SizedBox(height: sized_box_space),
          ElevatedButton(
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
                    color: widget.color_topbar,
                  ),
                ),
              ),
            ),
            onPressed: () {
              if (selectedPerson != null &&
                  !persons_wpe_list.contains(selectedPerson)) {
                setState(() {
                  persons_wpe_list.add(selectedPerson!);
                });
              }
              person_controller.clear(); // Limpiar el campo de texto
            },
            child: Text(
              text_list.get(source_language_index)[36],
              style: TextStyle(
                color: widget.color_topbar,
              ),
            ),
          ),
          SizedBox(height: sized_box_space),
          Flexible(
            child: Column(
              children: persons_wpe_list.map((person) {
                return ListTile(
                  title: Text(person.name),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        persons_wpe_list
                            .remove(person); // Elimina el elemento de la lista
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          )
        ],
      ));
}
