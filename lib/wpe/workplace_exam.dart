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
  ValueNotifier<int> current_step = ValueNotifier(0);

  List<Widget> wpe_segments = [
    WpeInitialSegment(
      current_step: ValueNotifier(0),
      setState: () {},
      main_color: Colors.black,
    ),
    WpeGeneralSegment(
      current_step: ValueNotifier(0),
      setState: () {},
      main_color: Colors.black,
    ),
    WpeRisksSegment(
      current_step: ValueNotifier(0),
      setState: () {},
      main_color: Colors.black,
    ),
    WpeDescriptionSegment(
      current_step: ValueNotifier(0),
      setState: () {},
      main_color: Colors.black,
    ),
    WpeCorrectivesSegment(
      current_step: ValueNotifier(0),
      setState: () {},
      main_color: Colors.black,
    ),
  ];

  Widget get_wpe_segments() {
    wpe_segments = [
      WpeInitialSegment(
        current_step: current_step,
        setState: () => setState(() {}),
        main_color: widget.main_color,
      ),
      WpeGeneralSegment(
        current_step: current_step,
        setState: () => setState(() {}),
        main_color: widget.main_color,
      ),
      WpeRisksSegment(
        current_step: current_step,
        setState: () => setState(() {}),
        main_color: widget.main_color,
      ),
      WpeDescriptionSegment(
        current_step: current_step,
        setState: () => setState(() {}),
        main_color: widget.main_color,
      ),
      WpeCorrectivesSegment(
        current_step: current_step,
        setState: () => setState(() {}),
        main_color: widget.main_color,
      ),
    ];
    return current_step.value == -1
        ? Container()
        : wpe_segments[current_step.value];
  }

  ValueNotifier<WorkplaceExam> workplace_exam =
      ValueNotifier(WorkplaceExam.empty());

  @override
  void initState() {
    super.initState();
    current_step.addListener(() {
      if (current_step.value == -1) Navigator.pop(context);
    });
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
                'Step ${current_step.value + 1} of ${wpe_segments.length}',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
