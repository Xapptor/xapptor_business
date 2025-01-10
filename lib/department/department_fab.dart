import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:xapptor_business/department/department.dart';

extension StateExtension on DepartmentState {
  department_fab() {
    String language_code =
        text_list.list[source_language_index].source_language;
    List alert_text_array = alert_text_list.get(source_language_index);

    String menu_label = alert_text_array[0];
    String close_label = alert_text_array[1];
    String add_label = alert_text_array[2];
    String save_label = alert_text_array[3];

    return ExpandableFab(
      key: expandable_fab_key,
      distance: 100,
      duration: const Duration(milliseconds: 150),
      overlayStyle: const ExpandableFabOverlayStyle(
        blur: 5,
      ),
      openButtonBuilder: FloatingActionButtonBuilder(
        size: 20,
        builder: (context, on_pressed, progress) {
          return FloatingActionButton(
            heroTag: null,
            onPressed: on_pressed,
            tooltip: menu_label,
            child: const Icon(
              Icons.menu,
              color: Colors.white,
            ),
          );
        },
      ),
      closeButtonBuilder: FloatingActionButtonBuilder(
        size: 20,
        builder: (context, onPressed, progress) {
          return FloatingActionButton(
            heroTag: null,
            onPressed: onPressed,
            tooltip: close_label,
            child: const Icon(
              Icons.close,
              color: Colors.white,
            ),
          );
        },
      ),
      children: [
        //ADD
        FloatingActionButton.extended(
          heroTag: null,
          onPressed: openBoxAdd,
          backgroundColor: Colors.green,
          tooltip: add_label,
          label: Row(
            children: [
              Text(
                add_label,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                FontAwesomeIcons.cloudArrowUp,
                color: Colors.white,
                size: 20,
              ),
            ],
          ),
        ),

        // SAVE
        FloatingActionButton.extended(
          heroTag: null,
          onPressed: () {},
          backgroundColor: Colors.orange,
          tooltip: save_label,
          label: Row(
            children: [
              Text(
                save_label,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                FontAwesomeIcons.cloudArrowUp,
                color: Colors.white,
                size: 20,
              ),
            ],
          ),
        ),
      ].reversed.toList(),
    );
  }
}
