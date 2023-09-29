import 'package:flutter/material.dart';

class WpeRisksSegment extends StatefulWidget {
  final Widget main_button;
  final Color main_color;
  final ValueNotifier<String> lototo;
  final ValueNotifier<String> hit_or_caught;
  final ValueNotifier<String> burn;
  final ValueNotifier<String> health;
  final ValueNotifier<String> work_enviroment_conditions;
  final ValueNotifier<String> fall;

  const WpeRisksSegment({super.key, 
    required this.main_button,
    required this.main_color,
    required this.lototo,
    required this.hit_or_caught,
    required this.burn,
    required this.health,
    required this.work_enviroment_conditions,
    required this.fall,
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
              'LOTOTO',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          DropdownButton<String>(
            value: widget.lototo.value,
            onChanged: (String? new_value) {
              setState(() {
                widget.lototo.value = new_value!;
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
            child: const Text(
              'Hit or Caught',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          DropdownButton<String>(
            value: widget.hit_or_caught.value,
            onChanged: (String? new_value) {
              setState(() {
                widget.hit_or_caught.value = new_value!;
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
            child: const Text(
              'Burn',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          DropdownButton<String>(
            value: widget.burn.value,
            onChanged: (String? new_value) {
              setState(() {
                widget.burn.value = new_value!;
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
            child: const Text(
              'Health',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          DropdownButton<String>(
            value: widget.health.value,
            onChanged: (String? new_value) {
              setState(() {
                widget.health.value = new_value!;
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
            child: const Text(
              'Work Enviroment Conditions',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          DropdownButton<String>(
            value: widget.work_enviroment_conditions.value,
            onChanged: (String? new_value) {
              setState(() {
                widget.work_enviroment_conditions.value = new_value!;
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
            child: const Text(
              'Fall',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          DropdownButton<String>(
            value: widget.fall.value,
            onChanged: (String? new_value) {
              setState(() {
                widget.fall.value = new_value!;
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
          widget.main_button,
        ],
      ),
    );
  }
}
