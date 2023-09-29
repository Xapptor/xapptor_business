import 'package:flutter/material.dart';

class WpeCorrectivesSegment extends StatefulWidget {
  final Widget main_button;
  final Color main_color;
  final ValueNotifier<bool> eliminated;
  final ValueNotifier<bool> reduced;
  final ValueNotifier<bool> isolated;
  final ValueNotifier<bool> controlled;
  final ValueNotifier<bool> ppe;

  const WpeCorrectivesSegment({
    super.key,
    required this.main_button,
    required this.main_color,
    required this.eliminated,
    required this.reduced,
    required this.isolated,
    required this.controlled,
    required this.ppe,
  });
  @override
  State<WpeCorrectivesSegment> createState() => _WpeCorrectivesSegmentState();
}

class _WpeCorrectivesSegmentState extends State<WpeCorrectivesSegment> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        shrinkWrap: true,
        children: [
          Container(
            margin: const EdgeInsets.only(
              bottom: 30,
            ),
            child: const Text(
              'Inmediate Corrective Actions:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          corrective_check('Eliminated', widget.eliminated),
          corrective_check('Reduced', widget.reduced),
          corrective_check('Isolated', widget.isolated),
          corrective_check('Controled', widget.controlled),
          corrective_check('PPE', widget.ppe),
          widget.main_button,
        ],
      ),
    );
  }

  Widget corrective_check(
    String label,
    ValueNotifier<bool> corrective_check,
  ) {
    Widget corrective = Container(
      margin: const EdgeInsets.only(
        bottom: 20,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
              icon: Icon(
                corrective_check.value == true ? Icons.check_box : Icons.check_box_outline_blank,
                color: widget.main_color,
              ),
              onPressed: () {
                corrective_check.value = !corrective_check.value;
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
    return corrective;
  }
}
