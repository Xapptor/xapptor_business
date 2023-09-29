import 'package:flutter/material.dart';

class WpeGeneralSegment extends StatefulWidget {
  final Widget main_button;
  final Color main_color;
  final ValueNotifier<String> shift;
  final ValueNotifier<String> area;
  final ValueNotifier<TextEditingController> specific_area_controller;

  const WpeGeneralSegment({
    super.key,
    required this.main_button,
    required this.main_color,
    required this.shift,
    required this.area,
    required this.specific_area_controller,
  });
  @override
  State<WpeGeneralSegment> createState() => _WpeGeneralSegmentState();
}

class _WpeGeneralSegmentState extends State<WpeGeneralSegment> {
  List<String> shift_list = [
    'First',
    'Second',
    'Night',
    'Normal',
  ];

  List<String> area_list = [
    'Quarry or Mine',
    'Raw Material Proportioning and Blending',
    'Raw Mill (Milling) Operations',
    'Coal or Fuel Operations',
    'Preheater and Calciner Area',
    'Kiln Area',
    'Clinker Cooler Operations',
    'Finish Mill (Milling) Operations',
    'Laboratory',
    'Packing, Shipping, and Distribution',
    'Baghouses and Presipitators',
    'Maintenance Area (Indicate which)',
    'Facility Grounds (Indicate which)',
    'procurement/Warehouse',
    'Other Area (Indicate)',
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        shrinkWrap: true,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: const Text(
              'Shift',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          DropdownButton<String>(
            value: widget.shift.value,
            onChanged: (String? new_value) {
              setState(() {
                widget.shift.value = new_value!;
              });
            },
            items: shift_list.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            isExpanded: true,
          ),
          Container(
            margin: const EdgeInsets.only(
              top: 20,
              bottom: 10,
            ),
            child: const Text(
              'Area',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          DropdownButton<String>(
            value: widget.area.value,
            onChanged: (String? new_value) {
              setState(() {
                widget.area.value = new_value!;
              });
            },
            items: area_list.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            isExpanded: true,
          ),
          TextField(
            controller: widget.specific_area_controller.value,
            decoration: const InputDecoration(
              labelText: 'Specific Area',
            ),
          ),
          widget.main_button,
        ],
      ),
    );
  }
}
