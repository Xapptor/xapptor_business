import 'package:flutter/material.dart';

class WpeCorrectivesSegment extends StatefulWidget {
  final ValueNotifier<int> current_step;
  final Function setState;
  final Color main_color;

  WpeCorrectivesSegment({
    required this.current_step,
    required this.setState,
    required this.main_color,
  });
  @override
  _WpeCorrectivesSegmentState createState() => _WpeCorrectivesSegmentState();
}

class _WpeCorrectivesSegmentState extends State<WpeCorrectivesSegment> {
  ValueNotifier<bool> _corrective_check_eliminated = ValueNotifier(false);
  ValueNotifier<bool> _corrective_check_reduced = ValueNotifier(false);
  ValueNotifier<bool> _corrective_check_isolated = ValueNotifier(false);
  ValueNotifier<bool> _corrective_check_controled = ValueNotifier(false);
  ValueNotifier<bool> _corrective_check_ppe = ValueNotifier(false);

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
            child: Text(
              'Inmediate Corrective Actions:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          corrective_check('Eliminated', _corrective_check_eliminated),
          corrective_check('Reduced', _corrective_check_reduced),
          corrective_check('Isolated', _corrective_check_isolated),
          corrective_check('Controled', _corrective_check_controled),
          corrective_check('PPE', _corrective_check_ppe),
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(
              top: 20,
            ),
            child: ElevatedButton(
              onPressed: () {
                widget.current_step.value = -1;
                widget.setState();
              },
              child: Text('Save and Upload'),
            ),
          ),
        ],
      ),
    );
  }

  Widget corrective_check(
    String label,
    ValueNotifier<bool> _corrective_check,
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
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
              icon: Icon(
                _corrective_check.value == true
                    ? Icons.check_box
                    : Icons.check_box_outline_blank,
                color: widget.main_color,
              ),
              onPressed: () {
                _corrective_check.value = !_corrective_check.value;
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
