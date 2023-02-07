import 'package:flutter/material.dart';

class WpeRisksSegment extends StatefulWidget {
  final ValueNotifier<int> current_step;
  final Function setState;
  final Color main_color;

  WpeRisksSegment({
    required this.current_step,
    required this.setState,
    required this.main_color,
  });
  @override
  _WpeRisksSegmentState createState() => _WpeRisksSegmentState();
}

class _WpeRisksSegmentState extends State<WpeRisksSegment> {
  List<String> lototo_list = [
    'None',
    'Electricity',
    'Gravity',
    'Hydraulic',
    'Mechanical',
    'Pneumatic',
    'Thermal',
    'Steam',
    'Water',
    'Gas',
    'Chemistry',
  ];

  List<String> hit_or_caught_list = [
    'None',
    'Crushed By',
    'Suspended Load',
    'Falling Object',
    'Flying Object',
    'Comp. Gas',
    'Sharp Object',
    'Low Headroom',
    'Pressure Release',
    'In Between',
    'In Machine',
  ];

  List<String> burn_list = [
    'None',
    'Open Flame',
    'Explosion',
    'Flam. Gas',
    'Corrosive Material',
    'Hot Work',
    'Electric Shock',
    'Hot Material',
    'Hot Surface',
    'Cold Surface',
    'Fire Hazard',
  ];

  List<String> health_list = [
    'None',
    'Inhalation',
    'Noise',
    'Bending Lift',
    'Reaching Lift',
    'Radiation',
    'Toxic Material',
    'Snake / Insect',
    'Biohazard',
    'Harmful Light',
    'Engulfment',
  ];

  List<String> work_enviroment_conditions_list = [
    'None',
    'High Temp.',
    'Low Temp.',
    'Ice / Snow',
    'Rain / Lightning',
    'Wind',
    'Traffic - Truck / Car',
    'Traffic - Mixer',
    'Traffic - Mobile Equipment',
    'Traffic - Pedestrian',
  ];

  List<String> fall_list = [
    'None',
    'Stairs',
    'Ladder',
    'Open Edge',
    'Slip',
    'Trip',
    'Into Water',
    'Tools - Hand Tool',
    'Tools - Power Tool',
    'Tools - Utility Knife',
  ];

  String current_lototo = '';
  String current_hit_or_caught = '';
  String current_burn = '';
  String current_health = '';
  String current_work_enviroment_conditions = '';
  String current_fall = '';

  @override
  void initState() {
    current_lototo = lototo_list[0];
    current_hit_or_caught = hit_or_caught_list[0];
    current_burn = burn_list[0];
    current_health = health_list[0];
    current_work_enviroment_conditions = work_enviroment_conditions_list[0];
    current_fall = fall_list[0];
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
              'LOTOTO',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          DropdownButton<String>(
            value: current_lototo,
            onChanged: (String? new_value) {
              setState(() {
                current_lototo = new_value!;
              });
            },
            items: lototo_list.map<DropdownMenuItem<String>>((String value) {
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
              'Hit or Caught',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          DropdownButton<String>(
            value: current_hit_or_caught,
            onChanged: (String? new_value) {
              setState(() {
                current_hit_or_caught = new_value!;
              });
            },
            items: hit_or_caught_list
                .map<DropdownMenuItem<String>>((String value) {
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
              'Burn',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          DropdownButton<String>(
            value: current_burn,
            onChanged: (String? new_value) {
              setState(() {
                current_burn = new_value!;
              });
            },
            items: burn_list.map<DropdownMenuItem<String>>((String value) {
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
              'Health',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          DropdownButton<String>(
            value: current_health,
            onChanged: (String? new_value) {
              setState(() {
                current_health = new_value!;
              });
            },
            items: health_list.map<DropdownMenuItem<String>>((String value) {
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
              'Work Enviroment Conditions',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          DropdownButton<String>(
            value: current_work_enviroment_conditions,
            onChanged: (String? new_value) {
              setState(() {
                current_work_enviroment_conditions = new_value!;
              });
            },
            items: work_enviroment_conditions_list
                .map<DropdownMenuItem<String>>((String value) {
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
              'Fall',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          DropdownButton<String>(
            value: current_fall,
            onChanged: (String? new_value) {
              setState(() {
                current_fall = new_value!;
              });
            },
            items: fall_list.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            isExpanded: true,
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
