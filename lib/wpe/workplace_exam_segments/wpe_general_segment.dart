import 'package:flutter/material.dart';

class WpeGeneralSegment extends StatefulWidget {
  final ValueNotifier<int> current_step;
  final Function setState;
  final Color main_color;

  WpeGeneralSegment({
    required this.current_step,
    required this.setState,
    required this.main_color,
  });
  @override
  _WpeGeneralSegmentState createState() => _WpeGeneralSegmentState();
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

  String current_shift = '';
  String current_area = '';

  TextEditingController _specific_area_controller = TextEditingController();

  @override
  void initState() {
    current_shift = shift_list[0];
    current_area = area_list[0];
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
            child: Text(
              'Shift',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          DropdownButton<String>(
            value: current_shift,
            onChanged: (String? new_value) {
              setState(() {
                current_shift = new_value!;
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
            child: Text(
              'Area',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          DropdownButton<String>(
            value: current_area,
            onChanged: (String? new_value) {
              setState(() {
                current_area = new_value!;
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
            controller: _specific_area_controller,
            decoration: InputDecoration(
              labelText: 'Specific Area',
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(top: 20),
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
