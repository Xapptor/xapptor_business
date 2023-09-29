import 'package:flutter/material.dart';

class WpeDescriptionSegment extends StatefulWidget {
  final Widget main_button;
  final Color main_color;
  ValueNotifier<TextEditingController> potential_risk_description_controller;

  WpeDescriptionSegment({super.key, 
    required this.main_button,
    required this.main_color,
    required this.potential_risk_description_controller,
  });
  @override
  _WpeDescriptionSegmentState createState() => _WpeDescriptionSegmentState();
}

class _WpeDescriptionSegmentState extends State<WpeDescriptionSegment> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        shrinkWrap: true,
        children: [
          const Text(
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
              controller: widget.potential_risk_description_controller.value,
              decoration: const InputDecoration(
                hintText:
                    'Describe related Present and / or\nPotential Hazards in your area',
              ),
              keyboardType: TextInputType.multiline,
              maxLines: null,
            ),
          ),
          widget.main_button,
        ],
      ),
    );
  }
}
