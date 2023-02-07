enum Shift {
  first,
  second,
  night,
  normal,
}

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
  final String id;
  final String user_id;
  final DateTime date_created;
  final List<String> supervisors;

  // General Segment
  final Shift shift;
  final Area area;
  final String specific_area;

  // Risk Segment
  final Lototo lototo;
  final HitOrCaught hit_or_caught;
  final Burn burn;
  final Health health;
  final WorkEnviromentConditions work_enviroment_conditions;
  final Fall fall;

  // Description Segment
  final String potential_risk_description;

  // Correctives Segment
  final bool eliminated;
  final bool reduced;
  final bool isolated;
  final bool controlled;
  final bool ppe;

  const WorkplaceExam({
    required this.id,
    required this.user_id,
    required this.date_created,
    required this.supervisors,

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
    Map<String, dynamic> snapshot,
  )   : id = id,
        user_id = snapshot['user_id'],
        date_created = snapshot['date_created'].toDate(),
        supervisors = snapshot['supervisors'],

        // General Segment
        shift = Shift.values[snapshot['shift']],
        area = Area.values[snapshot['area']],
        specific_area = snapshot['specific_area'],

        // Risk Segment
        lototo = Lototo.values[snapshot['lototo']],
        hit_or_caught = HitOrCaught.values[snapshot['hit_or_caught']],
        burn = Burn.values[snapshot['burn']],
        health = Health.values[snapshot['health']],
        work_enviroment_conditions = WorkEnviromentConditions
            .values[snapshot['work_enviroment_conditions']],
        fall = Fall.values[snapshot['fall']],

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

      // General Segment
      shift: Shift.normal,
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

      // General Segment
      'shift': shift.index,
      'area': area.index,
      'specific_area': specific_area,

      // Risk Segment
      'lototo': lototo.index,
      'hit_or_caught': hit_or_caught.index,
      'burn': burn.index,
      'health': health.index,
      'work_enviroment_conditions': work_enviroment_conditions.index,
      'fall': fall.index,

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
