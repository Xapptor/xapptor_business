import 'package:flutter/material.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/wpe_editor.dart';

extension StateExtension on WpeEditorState {
  wpe_editor_text_field({
    required String label_text,
    required TextEditingController controller,
    required String? Function(String?)? validator,
    TextInputType? keyboardType,
    int? maxLines,
  }) =>
      TextFormField(
        style: TextStyle(
          color: widget.color_topbar,
        ),
        decoration: InputDecoration(
          labelText: label_text,
          labelStyle: TextStyle(
            color: widget.color_topbar,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: widget.color_topbar,
            ),
          ),
        ),
        controller: controller,
        validator: validator,
      );
}
