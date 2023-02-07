import 'package:flutter/material.dart';

class WpeDescriptionSegment extends StatefulWidget {
  final ValueNotifier<int> current_step;
  final Function setState;
  final Color main_color;

  WpeDescriptionSegment({
    required this.current_step,
    required this.setState,
    required this.main_color,
  });
  @override
  _WpeDescriptionSegmentState createState() => _WpeDescriptionSegmentState();
}

class _WpeDescriptionSegmentState extends State<WpeDescriptionSegment> {
  TextEditingController _potential_risk_description_controller =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        shrinkWrap: true,
        children: [
          Text(
            'Describe related Present and / or\nPotential Hazards in your area:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
              top: 10,
              bottom: 10,
            ),
            child: TextField(
              controller: _potential_risk_description_controller,
              decoration: InputDecoration(
                hintText:
                    'Describe related Present and / or\nPotential Hazards in your area',
              ),
              keyboardType: TextInputType.multiline,
              maxLines: null,
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(
              top: 20,
              bottom: 30,
            ),
            child: ElevatedButton(
              onPressed: () {
                widget.current_step.value++;
                widget.setState();
              },
              child: Text('Continue'),
            ),
          ),
        ],
      ),
    );
  }
}
