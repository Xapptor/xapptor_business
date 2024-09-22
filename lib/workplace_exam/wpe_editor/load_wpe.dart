// ignore_for_file: invalid_use_of_protected_member

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xapptor_business/workplace_exam/font_configuration.dart';
import 'package:xapptor_business/models/wpe.dart';
import 'package:xapptor_business/workplace_exam/models/wpe_font.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/wpe_editor.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/wpe_editor_additional_options.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/show_result_snack_bar.dart';
import 'package:xapptor_db/xapptor_db.dart';

extension StateExtension on WpeEditorState {
  //todo: eliminar si no se va a usar a WPE de ejemplo
  // Future<Wpe> load_wpe_from_json(String wpe_id) async {
  //   String wpe_string = await rootBundle
  //       .loadString('packages/xapptor_business/assets/wpe_example.json');
  //   Map<String, dynamic> wpe_map = jsonDecode(wpe_string);
  //   Wpe wpe = Wpe.from_json(
  //     wpe_id,
  //     wpe_map,
  //   );
  //   return wpe;
  // }

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

    // Timestamp current_wpe_date = current_wpe.creation_date;
    // Timestamp empty_wpe_date = Wpe.empty().creation_date;
    //Todo: cambiar el tipo
    // String current_wpe_date = current_wpe.date_wpe;
    // String empty_wpe_date = Wpe.empty().date_wpe;

    // if (current_wpe_date != empty_wpe_date) {
    //   // SETTING TRANSLATED TITLES

    //   List<String> text_array = text_list.get(source_language_index);
    //   //current_wpe.profile_section.title = text_array[5];

    //   //current_wpe.condition_sections.first.title = text_array[15];

    //   List<String> time_text_array = time_text_list.get(source_language_index);

    //   // current_wpe.text_list = [
    //   //       text_array[11],
    //   //     ] +
    //   //     text_array.sublist(18, 20) +
    //   //     [
    //   //       widget.base_url,
    //   //     ] +
    //   //     time_text_array;

    //   current_wpe_id = current_wpe.id;

    //   chosen_image_url = current_wpe.before_picture1;

    //   // current_color = current_wpe.icon_color;
    //   // picker_color = current_wpe.icon_color;

    //   // wpe_number.text = current_wpe.number;
    //   // wpe_date.text = current_wpe.date_wpe;
    //   shift_input_controller.text = current_wpe.shift;
    //   area_input_controller.text = current_wpe.area;
    //   specific_input_controller.text = current_wpe.specific;

    //   // sections_by_page_input_controller.text =
    //   //     current_wpe.sections_by_page.join(", ");

    //   font_families_value = await font_families();

    //   current_font_value = font_families_value.first;

    //   // current_font_value = font_families_value.firstWhere(
    //   //   (WpeFont font) =>
    //   //       font.name.toLowerCase() == current_wpe.font_name.toLowerCase(),
    //   // );

    //   //show_time_amount = current_wpe.show_time_amount;

    //   // Timer(const Duration(milliseconds: 0), () {
    //   //   condition_sections = current_wpe.condition_sections;
    //   //   setState(() {});
    //   // });
    // } else {
    //todo cambiar a su verdadero valor
    wpe_number = current_wpe.number.toString();
    wpe_date = current_wpe.date_wpe.toDate();
    shift_input_controller = current_wpe.shift;
    area_input_controller = current_wpe.area;
    specific_input_controller.text = current_wpe.specific;
    supervisor_input_controller.text = current_wpe.supervisor;
    condition_sections = [];

    setState(() {});
    //}

    show_result_snack_bar(
      result_snack_bar_type: ResultSnackBarType.loaded,
      slot_index: new_slot_index,
    );
  }
}
