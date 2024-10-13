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
      site_id: wpe_site,
      number: 100,
      date_wpe: Timestamp.now(),
      shift: shift_input_controller,
      area: selectedArea!.area,
      area_department: selectedArea!.department,
      specific: specific_input_controller.text,
      supervisor_name: selectedSupervisor!.name,
      supervisor_userid: selectedSupervisor!.user_id,
      supervisor_department: selectedSupervisor!.department_name,
      conditions: condition_sections,
      //Person Section
      persons: persons_wpe_list,
      //Other Section
      order: order_input_controller.text,
      transversal: selectedTransversal!.location,
      transversal_userid: selectedTransversal!.userid,
      transversal_responsible: selectedTransversal!.responsible,
      maintenance_supervisor: selectedMaintSupervisor!.name,
      maintenance_userid: selectedMaintSupervisor!.user_id,

      //Hazard Section
      lototo: lototo_input_controller,
      hit_or_caught: hit_or_caught_input_controller,
      burn: burn_input_controller,
      health: health_input_controller,
      work_condition: work_condition_input_controller,
      fall: fall_input_controller,
      hazard_comment: hazard_input_controller.text,
      //ERICP Section
      eliminated: eliminated_input_controller.text,
      reduced: reduced_input_controller.text,
      isolated: isolated_input_controller.text,
      controled: controled_input_controller.text,
      ppe: ppe_input_controller.text,
      //Maintenance Section
      maintenance_comment: maint_cmmt_input_controller.text,
      maintenance_date: (maint_cmmt != maint_cmmt_input_controller.text)
          ? Timestamp.now()
          : maint_cmmt_date,
      //Supervisor Section
      supervisor_comment: supervisor_cmmt_input_controller.text,
      close: wpe_close,
      date_close: wpe_date_close,

      created_date: Timestamp.now(),
      user_id: current_user!.uid,
      slot_index: slot_index,
    );
    return wpe;
  }
}
