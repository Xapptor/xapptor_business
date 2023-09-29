import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:xapptor_business/shift/model/shift.dart';
import 'package:xapptor_business/wpe/workplace_exam_view.dart';

enum Area {
  quarry_or_mine,
  raw_material_proportioning_and_blending,
  raw_mill_milling_operations,
  coal_or_fuel_operations,
  preheater_and_calciner_area,
  kiln_area,
  clinker_cooler_operations,
  finish_mill_milling_operations,
  laboratory,
  packing_shipping_and_distribution,
  baghouses_and_presipitators,
  maintenance_area_indicate_which,
  facility_grounds_indicate_which,
  procurement_warehouse,
  other_area_indicate,
}

enum Lototo {
  none,
  electricity,
  gravity,
  hydraulic,
  mechanical,
  pneumatic,
  thermal,
  steam,
  water,
  gas,
  chemistry,
}

enum HitOrCaught {
  none,
  crushed_by,
  suspended_load,
  falling_object,
  flying_object,
  comp_gas,
  sharp_object,
  low_headroom,
  pressure_release,
  in_between,
  in_machine,
}

enum Burn {
  none,
  open_flame,
  explosion,
  flam_gas,
  corrosive_material,
  hot_work,
  electric_shock,
  hot_material,
  hot_surface,
  cold_surface,
  fire_hazard,
}

enum Health {
  none,
  inhalation,
  noise,
  bending_lift,
  reaching_lift,
  radiation,
  toxic_material,
  snake_insect,
  biohazard,
  harmful_light,
  engulfment,
}

enum WorkEnviromentConditions {
  none,
  high_temp,
  low_temp,
  ice_snow,
  rain_lightning,
  wind,
  traffic_truck_car,
  traffic_mixer,
  traffic_mobile_equipment,
  traffic_pedestrian,
}

enum Fall {
  none,
  stairs,
  ladder,
  open_edge,
  slip,
  trip,
  into_water,
  tools_hand_tool,
  tools_power_tool,
  tools_utility_knife,
}

class WorkplaceExam {
  String id;
  String user_id;
  DateTime date_created;
  List<String> supervisors;
  List<String> participants;

  // General Segment
  ShiftType shift;
  Area area;
  String specific_area;

  // Risk Segment
  Lototo lototo;
  HitOrCaught hit_or_caught;
  Burn burn;
  Health health;
  WorkEnviromentConditions work_enviroment_conditions;
  Fall fall;

  // Description Segment
  String potential_risk_description;

  // Correctives Segment
  bool eliminated;
  bool reduced;
  bool isolated;
  bool controlled;
  bool ppe;

  WorkplaceExam({
    required this.id,
    required this.user_id,
    required this.date_created,
    required this.supervisors,
    required this.participants,

    // General Segment
    required this.shift,
    required this.area,
    required this.specific_area,

    // Risk Segment
    required this.lototo,
    required this.hit_or_caught,
    required this.burn,
    required this.health,
    required this.work_enviroment_conditions,
    required this.fall,

    // Description Segment
    required this.potential_risk_description,

    // Correctives Segment
    required this.eliminated,
    required this.reduced,
    required this.isolated,
    required this.controlled,
    required this.ppe,
  });

  WorkplaceExam.from_snapshot(
    String id,
    Map snapshot,
  )   : id = id,
        user_id = snapshot['user_id'],
        date_created = snapshot['date_created'].toDate(),
        supervisors = (snapshot['supervisors'] ?? []).cast<String>(),
        participants = (snapshot['participants'] ?? []).cast<String>(),

        // General Segment
        shift = get_most_similar_enum_value(
          ShiftType.values,
          snapshot['shift'] ?? '',
        ),
        area = get_most_similar_enum_value(
          Area.values,
          snapshot['area'] ?? '',
        ),
        specific_area = snapshot['specific_area'],

        // Risk Segment
        lototo = get_most_similar_enum_value(
          Lototo.values,
          snapshot['lototo'] ?? '',
        ),
        hit_or_caught = get_most_similar_enum_value(
          HitOrCaught.values,
          snapshot['hit_or_caught'] ?? '',
        ),
        burn = get_most_similar_enum_value(
          Burn.values,
          snapshot['burn'] ?? '',
        ),
        health = get_most_similar_enum_value(
          Health.values,
          snapshot['health'] ?? '',
        ),
        work_enviroment_conditions = get_most_similar_enum_value(
          WorkEnviromentConditions.values,
          snapshot['work_enviroment_conditions'] ?? '',
        ),
        fall = get_most_similar_enum_value(
          Fall.values,
          snapshot['fall'] ?? '',
        ),

        // Description Segment
        potential_risk_description = snapshot['potential_risk_description'],

        // Correctives Segment
        eliminated = snapshot['eliminated'],
        reduced = snapshot['reduced'],
        isolated = snapshot['isolated'],
        controlled = snapshot['controlled'],
        ppe = snapshot['ppe'];

  factory WorkplaceExam.empty() {
    return WorkplaceExam(
      id: '',
      user_id: '',
      date_created: DateTime.now(),
      supervisors: [],
      participants: [],

      // General Segment
      shift: ShiftType.day,
      area: Area.quarry_or_mine,
      specific_area: '',

      // Risk Segment
      lototo: Lototo.none,
      hit_or_caught: HitOrCaught.none,
      burn: Burn.none,
      health: Health.none,
      work_enviroment_conditions: WorkEnviromentConditions.none,
      fall: Fall.none,

      // Description Segment
      potential_risk_description: '',

      // Correctives Segment
      eliminated: false,
      reduced: false,
      isolated: false,
      controlled: false,
      ppe: false,
    );
  }

  Map<String, dynamic> to_json() {
    return {
      'user_id': user_id,
      'date_created': date_created,
      'supervisors': supervisors,
      'participants': participants,

      // General Segment
      'shift': shift.name,
      'area': area.name,
      'specific_area': specific_area,

      // Risk Segment
      'lototo': lototo.name,
      'hit_or_caught': hit_or_caught.name,
      'burn': burn.name,
      'health': health.name,
      'work_enviroment_conditions': work_enviroment_conditions.name,
      'fall': fall.name,

      // Description Segment
      'potential_risk_description': potential_risk_description,

      // Correctives Segment
      'eliminated': eliminated,
      'reduced': reduced,
      'isolated': isolated,
      'controlled': controlled,
      'ppe': ppe,
    };
  }
}

get_wpes(Function(List<WorkplaceExam>) update_function) async {
  User? user = FirebaseAuth.instance.currentUser;
  List<WorkplaceExam> wpes = [];

  QuerySnapshot wpes_snaps =
      await FirebaseFirestore.instance.collection('wpes').get();

  if (wpes_snaps.docs.isEmpty) {
    update_function(wpes);
  } else {
    wpes_snaps.docs.asMap().forEach((index, wpes_snap) async {
      wpes.add(
        WorkplaceExam.from_snapshot(
          wpes_snap.id,
          wpes_snap.data() as Map,
        ),
      );

      if (index == wpes_snaps.docs.length - 1) {
        update_function(wpes);
      }
    });
  }
}
