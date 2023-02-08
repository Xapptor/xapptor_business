import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:xapptor_business/wpe/model/workplace_exam.dart';
import 'package:xapptor_ui/widgets/is_portrait.dart';
import 'workplace_exam_segments/wpe_initial_Segment.dart';
import 'workplace_exam_segments/wpe_general_segment.dart';
import 'workplace_exam_segments/wpe_risks_segment.dart';
import 'workplace_exam_segments/wpe_description_segment.dart';
import 'workplace_exam_segments/wpe_correctives_segment.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WorkplaceExamView extends StatefulWidget {
  final Color main_color;

  WorkplaceExamView({
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

  int segment_length = 5;

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
    return current_step.value == -1
        ? Container()
        : wpe_segments[current_step.value];
  }

  Widget main_button() {
    return Container(
      margin: const EdgeInsets.only(
        top: 20,
        bottom: 30,
      ),
      child: ElevatedButton(
        onPressed: () async {
          DocumentReference doc_ref =
              FirebaseFirestore.instance.collection('wpes').doc();

          if (current_step.value >= 0 && current_step.value < segment_length) {
            if (current_step.value == 0) {
              await doc_ref.set(workplace_exam.value.to_json()).then((value) {
                workplace_exam.value.id = doc_ref.id;
                current_step.value++;
                setState(() {});
              });
            } else {
              doc_ref.update(workplace_exam.value.to_json()).then((value) {
                current_step.value++;
                setState(() {});
              });
            }
          } else if (current_step.value == segment_length) {
            doc_ref.update(workplace_exam.value.to_json()).then((value) {
              Navigator.pop(context);
            });
          }
        },
        child: Text(current_step.value == 0
            ? 'Start'
            : current_step.value == segment_length
                ? 'Finish'
                : 'Next'),
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
      body: Container(
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
                'Step ${current_step.value + 1} of ${segment_length}',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
