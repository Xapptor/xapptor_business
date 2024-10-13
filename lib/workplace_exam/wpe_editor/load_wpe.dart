// ignore_for_file: invalid_use_of_protected_member
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xapptor_business/models/wpe.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/wpe_editor.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/show_result_snack_bar.dart';
import 'package:xapptor_db/xapptor_db.dart';

extension StateExtension on WpeEditorState {
  load_wpe({
    required int new_slot_index,
  }) async {
    slot_index = new_slot_index;

    String wpe_id =
        ("${current_user!.uid}_${text_list.list[source_language_index].source_language}");

    if (new_slot_index != 0) {
      wpe_id += "_bu_$new_slot_index";
    }

    Wpe current_wpe = Wpe.empty();

    if (wpes.map((e) => e.id).contains(wpe_id)) {
      current_wpe = wpes.firstWhere((element) => element.id == wpe_id);
    } else {
      DocumentSnapshot wpe_doc =
          await XapptorDB.instance.collection("wpes").doc(wpe_id).get();

      Map? wpe_map = wpe_doc.data() as Map?;
      if (wpe_map != null) {
        current_wpe = Wpe.from_snapshot(wpe_id, wpe_map);
      }
    }

    //Header Section
    wpe_number = current_wpe.number.toString();
    wpe_date = current_wpe.date_wpe.toDate();
    shift_input_controller = current_wpe.shift;
    //area_input_controller = current_wpe.area;
    specific_input_controller.text = current_wpe.specific;

    selectedArea =
        area_list.firstWhere((area) => area.area == current_wpe.area);
    departmentAreaController.text = selectedArea!.department;

    selectedSupervisor = supervisor_list.firstWhere(
        (supervisor) => supervisor.user_id == current_wpe.supervisor_userid);
    departmentSupervisorController.text = selectedSupervisor!.department_name;

    //Person Section
    persons_wpe_list = current_wpe.persons;

    //Other Section
    order_input_controller.text = current_wpe.order;
    selectedTransversal = transversal_list.firstWhere(
        (transversal) => transversal.location == current_wpe.transversal);
    responsibleController.text = selectedTransversal!.responsible;
    selectedMaintSupervisor = maintenance_list.firstWhere(
        (p_maintsup) => p_maintsup.user_id == current_wpe.maintenance_userid);

    //Hazard Section
    lototo_input_controller = current_wpe.lototo;
    hit_or_caught_input_controller = current_wpe.hit_or_caught;
    burn_input_controller = current_wpe.burn;
    health_input_controller = current_wpe.health;
    work_condition_input_controller = current_wpe.work_condition;
    fall_input_controller = current_wpe.fall;
    hazard_input_controller.text = current_wpe.hazard_comment;

    //ERICP Section
    eliminated_input_controller.text = current_wpe.eliminated;
    reduced_input_controller.text = current_wpe.reduced;
    isolated_input_controller.text = current_wpe.isolated;
    controled_input_controller.text = current_wpe.controled;
    ppe_input_controller.text = current_wpe.ppe;

    //Maintenance Section
    maint_cmmt_input_controller.text = current_wpe.maintenance_comment;
    maint_cmmt = current_wpe.maintenance_comment;
    maint_cmmt_date = current_wpe.maintenance_date;
    maint_date_controller.text = current_wpe.maintenance_date != null
        ? "${current_wpe.maintenance_date!.toDate().month}/${current_wpe.maintenance_date!.toDate().day}/${current_wpe.maintenance_date!.toDate().year} "
            "${current_wpe.maintenance_date!.toDate().hour}:${current_wpe.maintenance_date!.toDate().minute.toString().padLeft(2, '0')}"
        : "";

    //Supervisor Section
    supervisor_cmmt_input_controller.text = current_wpe.supervisor_comment;
    wpe_date_close = current_wpe.date_close;
    wpe_close = current_wpe.close;

    //Condition Section
    condition_sections = current_wpe.conditions;

    setState(() {});
    //}

    show_result_snack_bar(
      result_snack_bar_type: ResultSnackBarType.loaded,
      slot_index: new_slot_index,
    );
  }
}
