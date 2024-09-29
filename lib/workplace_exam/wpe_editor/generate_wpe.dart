import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xapptor_business/models/wpe.dart';
//import 'package:xapptor_business/models/condition.dart';
//import 'package:xapptor_business/models/condition.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/wpe_editor.dart';

extension StateExtension on WpeEditorState {
  Wpe generate_wpe({
    required int slot_index,
  }) {
    Wpe wpe = Wpe(
      before_picture1: chosen_image_url,
      //Header Section
      number: 100,
      date_wpe: Timestamp.now(),
      shift: shift_input_controller,
      area: area_input_controller,
      specific: specific_input_controller.text,
      supervisor: supervisor_input_controller,
      conditions: condition_sections,
      //Other Section
      order: order_input_controller.text,
      transversal: transversal_input_controller,
      maintenance_supervisor: maintenance_input_controller,
      //Hazard Section
      lototo: lototo_input_controller,
      hit_or_caught: hit_or_caught_input_controller,
      burn: burn_input_controller,
      health: health_input_controller,
      work_condition: work_condition_input_controller,
      fall: fall_input_controller,
      //ERICP Section
      eliminated: eliminated_input_controller.text,
      reduced: reduced_input_controller.text,
      isolated: isolated_input_controller.text,
      controled: controled_input_controller.text,
      ppe: ppe_input_controller.text,
      //Maintenance Section
      maintenance_comment: maint_cmmt_input_controller.text,
      //Supervisor Section
      supervisor_comment: maint_cmmt_input_controller.text,

      created_date: Timestamp.now(),
      user_id: current_user!.uid,
      slot_index: slot_index,
    );
    return wpe;
  }
}
