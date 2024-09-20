import 'package:flutter/material.dart';
import 'package:xapptor_business/models/wpe.dart';
//import 'package:xapptor_business/workplace_exam/wpe_visualizer/wpe_visualizer.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/wpe_editor.dart';
import 'package:xapptor_ui/values/ui.dart';

extension StateExtension on WpeEditorState {
  wpe_editor_preview({
    required BuildContext context,
    required bool portrait,
    required Wpe wpe,
    required String base_url,
  }) {
    return Container(
      margin: EdgeInsets.all(portrait ? 6 : 16),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.deepOrangeAccent,
          width: 6,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          SizedBox(
            height: sized_box_space * 2,
          ),
          Container(
            alignment: Alignment.center,
            width: double.maxFinite,
            padding: const EdgeInsets.only(bottom: 20),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.deepOrangeAccent,
                  width: 6,
                ),
              ),
            ),
            child: Text(
              text_list.get(source_language_index)[6],
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // WpeVisualizer(
          //   wpe: wpe,
          //   language_code:
          //       text_list.list[source_language_index].source_language,
          //   base_url: widget.base_url,
          // ),
        ],
      ),
    );
  }
}
