import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:xapptor_business/models/wpe.dart';
import 'package:xapptor_business/workplace_exam/models/wpe_section.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/wpe_editor.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/wpe_editor_additional_options.dart';

extension StateExtension on WpeEditorState {
  Wpe generate_wpe({
    required int slot_index,
  }) {
    Wpe wpe = Wpe(
      before_picture1: chosen_image_url,
      number: 100,
      date_wpe: Timestamp.now(),
      shift: shift_input_controller,
      area: area_input_controller,
      specific: specific_input_controller.text,
      supervisor: supervisor_input_controller.text,
      //condition_sections: condition_sections,
      created_date: Timestamp.now(),
      user_id: current_user!.uid,
      slot_index: slot_index,
    );
    return wpe;
  }
}
