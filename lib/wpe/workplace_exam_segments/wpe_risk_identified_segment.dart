import 'package:flutter/material.dart';

class WpeRiskIdentifiedSegment extends StatefulWidget {
  final Widget main_button;
  final Color main_color;
  final ValueNotifier<bool> any_risk_identified;

  const WpeRiskIdentifiedSegment({super.key, 
    required this.main_button,
    required this.main_color,
    required this.any_risk_identified,
  });

  @override
  _WpeRiskIdentifiedSegmentState createState() =>
      _WpeRiskIdentifiedSegmentState();
}

class _WpeRiskIdentifiedSegmentState extends State<WpeRiskIdentifiedSegment> {
  List<String> risk_identified_list = [
    'No',
    'Yes',
  ];

  String risk_identified = 'No';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: const Text(
              'Do you identify any Hazard(s)/Risk(s)?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          DropdownButton<String>(
            value: risk_identified,
            onChanged: (String? new_value) {
              setState(() {
                risk_identified = new_value!;
                widget.any_risk_identified.value =
                    new_value.toLowerCase() == 'yes';
              });
            },
            items: risk_identified_list
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            isExpanded: true,
          ),
          widget.main_button,
        ],
      ),
    );
  }
}
