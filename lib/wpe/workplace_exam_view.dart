import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:xapptor_business/shift/model/shift.dart';
import 'package:xapptor_business/wpe/model/workplace_exam.dart';
import 'package:xapptor_ui/widgets/is_portrait.dart';
import 'workplace_exam_segments/wpe_initial_Segment.dart';
import 'workplace_exam_segments/wpe_general_segment.dart';
import 'workplace_exam_segments/wpe_risk_identified_segment.dart';
import 'workplace_exam_segments/wpe_risks_segment.dart';
import 'workplace_exam_segments/wpe_description_segment.dart';
import 'workplace_exam_segments/wpe_correctives_segment.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WorkplaceExamView extends StatefulWidget {
  final Color main_color;

  const WorkplaceExamView({super.key, 
    required this.main_color,
  });
  @override
  _WorkplaceExamViewState createState() => _WorkplaceExamViewState();
}

class _WorkplaceExamViewState extends State<WorkplaceExamView> {
  ValueNotifier<WorkplaceExam> workplace_exam =
      ValueNotifier(WorkplaceExam.empty());
  ValueNotifier<int> current_step = ValueNotifier(0);

  // General Segment
  ValueNotifier<String> shift = ValueNotifier('First');
  ValueNotifier<String> area = ValueNotifier('Quarry or Mine');
  ValueNotifier<TextEditingController> specific_area_controller =
      ValueNotifier(TextEditingController());

  // Risk Segment
  ValueNotifier<String> lototo = ValueNotifier('None');
  ValueNotifier<String> hit_or_caught = ValueNotifier('None');
  ValueNotifier<String> burn = ValueNotifier('None');
  ValueNotifier<String> health = ValueNotifier('None');
  ValueNotifier<String> work_enviroment_conditions = ValueNotifier('None');
  ValueNotifier<String> fall = ValueNotifier('None');

  // Description Segment
  ValueNotifier<TextEditingController> potential_risk_description_controller =
      ValueNotifier(TextEditingController());

  // Correctives Segment
  ValueNotifier<bool> eliminated = ValueNotifier(false);
  ValueNotifier<bool> reduced = ValueNotifier(false);
  ValueNotifier<bool> isolated = ValueNotifier(false);
  ValueNotifier<bool> controlled = ValueNotifier(false);
  ValueNotifier<bool> ppe = ValueNotifier(false);

  ValueNotifier<bool> any_risk_identified = ValueNotifier(false);
  int segment_length = 6;

  Widget get_wpe_segments() {
    List<Widget> wpe_segments = [
      WpeInitialSegment(
        main_button: main_button(),
        main_color: widget.main_color,
      ),
      WpeGeneralSegment(
        main_button: main_button(),
        main_color: widget.main_color,
        shift: shift,
        area: area,
        specific_area_controller: specific_area_controller,
      ),
      WpeRiskIdentifiedSegment(
        main_button: main_button(),
        main_color: widget.main_color,
        any_risk_identified: any_risk_identified,
      ),
      WpeRisksSegment(
        main_button: main_button(),
        main_color: widget.main_color,
        lototo: lototo,
        hit_or_caught: hit_or_caught,
        burn: burn,
        health: health,
        work_enviroment_conditions: work_enviroment_conditions,
        fall: fall,
      ),
      WpeDescriptionSegment(
        main_button: main_button(),
        main_color: widget.main_color,
        potential_risk_description_controller:
            potential_risk_description_controller,
      ),
      WpeCorrectivesSegment(
        main_button: main_button(),
        main_color: widget.main_color,
        eliminated: eliminated,
        reduced: reduced,
        isolated: isolated,
        controlled: controlled,
        ppe: ppe,
      ),
    ];
    return wpe_segments[current_step.value];
  }

  Widget main_button() {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(
        top: 20,
        bottom: 30,
      ),
      child: ElevatedButton(
        onPressed: () => check_fields(),
        child: Text(current_step.value == 0
            ? 'Start'
            : current_step.value == segment_length
                ? 'Finish'
                : 'Next'),
      ),
    );
  }

  String user_id = '';

  check_fields() {
    if (current_step.value == 0) {
      user_id = FirebaseAuth.instance.currentUser!.uid;

      if (user_id != '') {
        current_step.value++;
        setState(() {});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Please sign in',
            ),
          ),
        );
      }
    } else if (current_step.value == 1) {
      if (specific_area_controller.value.text.isNotEmpty) {
        set_wpe_values();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Please describe the specific area',
            ),
          ),
        );
      }
    } else if (current_step.value == 2 ||
        current_step.value == 3 ||
        current_step.value == 5) {
      set_wpe_values(finish_wpe: !any_risk_identified.value);
    } else if (current_step.value == 4) {
      if (any_risk_identified.value) {
        if (potential_risk_description_controller.value.text.isNotEmpty) {
          set_wpe_values();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Please describe the potential risk',
              ),
            ),
          );
        }
      } else {
        set_wpe_values();
      }
    }
  }

  set_wpe_values({
    bool finish_wpe = false,
  }) {
    workplace_exam.value.user_id = user_id;
    workplace_exam.value.date_created = DateTime.now();
    workplace_exam.value.supervisors = [user_id];
    workplace_exam.value.participants = [user_id];

    workplace_exam.value.shift = get_most_similar_enum_value(
      ShiftType.values,
      shift.value,
    );

    workplace_exam.value.area = get_most_similar_enum_value(
      Area.values,
      area.value,
    );

    workplace_exam.value.specific_area = specific_area_controller.value.text;

    workplace_exam.value.lototo = get_most_similar_enum_value(
      Lototo.values,
      lototo.value,
    );

    workplace_exam.value.hit_or_caught = get_most_similar_enum_value(
      HitOrCaught.values,
      hit_or_caught.value,
    );

    workplace_exam.value.burn = get_most_similar_enum_value(
      Burn.values,
      burn.value,
    );

    workplace_exam.value.health = get_most_similar_enum_value(
      Health.values,
      health.value,
    );

    workplace_exam.value.work_enviroment_conditions =
        get_most_similar_enum_value(
      WorkEnviromentConditions.values,
      work_enviroment_conditions.value,
    );

    workplace_exam.value.fall = get_most_similar_enum_value(
      Fall.values,
      fall.value,
    );

    workplace_exam.value.potential_risk_description =
        potential_risk_description_controller.value.text;

    workplace_exam.value.eliminated = eliminated.value;
    workplace_exam.value.reduced = reduced.value;
    workplace_exam.value.isolated = isolated.value;
    workplace_exam.value.controlled = controlled.value;
    workplace_exam.value.ppe = ppe.value;

    save_in_firebase(finish_wpe: finish_wpe);
  }

  save_in_firebase({
    bool finish_wpe = false,
  }) async {
    CollectionReference wpes_ref =
        FirebaseFirestore.instance.collection('wpes');
    late DocumentReference doc_ref;
    if (workplace_exam.value.id != '') {
      doc_ref = wpes_ref.doc(workplace_exam.value.id);
    } else {
      doc_ref = wpes_ref.doc();
    }

    //print(workplace_exam.value.to_json());

    if (finish_wpe) {
      finish_wpe_alert();
      Navigator.pop(context);
    } else {
      if (current_step.value >= 0 && current_step.value < segment_length - 1) {
        if (current_step.value == 1) {
          await doc_ref.set(workplace_exam.value.to_json()).then((value) {
            workplace_exam.value.id = doc_ref.id;
            current_step.value++;
            setState(() {});
          });
        } else {
          await doc_ref.update(workplace_exam.value.to_json()).then((value) {
            current_step.value++;
            setState(() {});
          });
        }
      } else if (current_step.value == segment_length - 1) {
        await doc_ref.update(workplace_exam.value.to_json()).then((value) {
          finish_wpe_alert();
          Navigator.pop(context);
        });
      }
    }
  }

  finish_wpe_alert() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        duration: Duration(seconds: 2),
        backgroundColor: Colors.green,
        content: Text(
          'Workplace exam finished and saved',
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool portrait = is_portrait(context);
    double screen_height = MediaQuery.of(context).size.height;
    double screen_width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SizedBox(
        height: screen_height,
        width: screen_width,
        child: Column(
          children: [
            current_step.value == 0
                ? Container()
                : Expanded(
                    flex: 3,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.all(10),
                      child: IconButton(
                        icon: Icon(
                          FontAwesomeIcons.angleLeft,
                          color: widget.main_color,
                        ),
                        onPressed: () {
                          current_step.value--;
                          setState(() {});
                        },
                      ),
                    ),
                  ),
            Expanded(
              flex: 30,
              child: FractionallySizedBox(
                widthFactor: portrait ? 0.8 : 0.4,
                child: get_wpe_segments(),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                'Step ${current_step.value + 1} of $segment_length',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String keep_only_alphabetic_chars(String input) {
  String result = '';
  for (int i = 0; i < input.length; i++) {
    String char = input[i];
    if (char.codeUnitAt(0) >= 65 && char.codeUnitAt(0) <= 90 ||
        char.codeUnitAt(0) >= 97 && char.codeUnitAt(0) <= 122) {
      result += char;
    }
  }
  return result;
}

Map<String, int> count_alphabet_chars(String input) {
  Map<String, int> result = {};
  for (int i = 0; i < input.length; i++) {
    String char = input[i];
    if (result.containsKey(char)) {
      result[char] = result[char]! + 1;
    } else {
      result[char] = 1;
    }
  }
  return result;
}

get_most_similar_enum_value(List enum_values, String input) {
  String input_only_alphabet = keep_only_alphabetic_chars(input.toLowerCase());

  List<String> enum_string_values = enum_values
      .map((e) => keep_only_alphabetic_chars(
          e.toString().split('.').last.toLowerCase()))
      .toList();

  var enum_index = 0;
  enum_string_values.asMap().forEach((index, element) {
    if (element == input_only_alphabet) {
      enum_index = index;
    }
  });
  return enum_values[enum_index];
}
