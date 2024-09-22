import 'package:cloud_firestore/cloud_firestore.dart';
//import 'person.dart';
//import 'conditions.dart';

class Wpe {
  String id;
  // final String site;
  final int number;
  final Timestamp date_wpe;
  final String shift;
  final String area;
  //final String area_department;
  final String specific;
  //final String supervisor_userid;
  final String supervisor;
  //final String supervisor_department;
  int slot_index;
  //final List<Person> persons;
  final String order;
  final String transversal;
  // final String transversal_userid;
  // final String transversal_responsible;
  // final String maintenance_userid;
  final String maintenance_supervisor;
  // final String lototo;
  // final String hit_or_caught;
  // final String burn;
  // final String health;
  // final String work_condition;
  // final String fall;
  String before_picture1;
  // final String before_picture2;
  // final String before_picture3;
  // final String before_picture4;
  final String eliminated;
  final String reduced;
  final String isolated;
  final String controled;
  final String ppe;
  // final String after_picture1;
  // final String after_picture2;
  // final List<Condition> conditions;
  final String maintenance_comment;
  // final String after_maint_picture2;
  // final String after_maint_picture1;
  final String supervisor_comment;
  // final bool close;
  // DateTime? date_corrected;
  // Timestamp? date_close;
  final String user_id;
  // final String created_userid;
  // final String created_name;
  final Timestamp created_date;
  // final String modified_userid;
  // final String modified_name;
  // final Timestamp modified_date;

  Wpe({
    this.id = "",
    //required this.site,
    required this.number,
    required this.date_wpe,
    required this.shift,
    required this.area,
    //required this.area_department,
    required this.specific,
    //required this.supervisor_userid,
    required this.supervisor,
    //required this.supervisor_department,
    required this.slot_index,
    // required this.persons,
    required this.order,
    required this.transversal,
    // required this.transversal_userid,
    // required this.transversal_responsible,
    // required this.maintenance_userid,
    required this.maintenance_supervisor,
    // required this.lototo,
    // required this.hit_or_caught,
    // required this.burn,
    // required this.health,
    // required this.work_condition,
    // required this.fall,
    required this.before_picture1,
    // required this.before_picture2,
    // required this.before_picture3,
    // required this.before_picture4,
    required this.eliminated,
    required this.reduced,
    required this.isolated,
    required this.controled,
    required this.ppe,
    // required this.after_picture1,
    // required this.after_picture2,
    // required this.conditions,
    required this.maintenance_comment,
    // required this.after_maint_picture2,
    // required this.after_maint_picture1,
    required this.supervisor_comment,
    // required this.close,
    //this.date_corrected,
    //this.date_close,
    required this.user_id,
    // required this.created_userid,
    // required this.created_name,
    required this.created_date,
    // required this.modified_userid,
    // required this.modified_name,
    // required this.modified_date,
  });

  Wpe.from_snapshot(
    this.id,
    Map<dynamic, dynamic> snapshot,
  )   : //site = snapshot['site'] ?? '',
        number = snapshot['number'],
        date_wpe = snapshot['date_wpe'] ?? Timestamp.now(),
        shift = snapshot['shift'] ?? '',
        area = snapshot['area'] ?? '',
        //area_department = snapshot['area_department'] ?? '',
        specific = snapshot['specific'] ?? '',
        //supervisor_userid = snapshot['supervisor_userid'] ?? '',
        supervisor = snapshot['supervisor'] ?? '',
        //supervisor_department = snapshot['supervisor_department'],
        slot_index = snapshot['slot_index'] ?? 0,
        // persons = ((snapshot['persons'] ?? []) as List)
        //     .map((person) => Person.from_snapshot(person))
        //     .toList(),
        order = snapshot['order'] ?? '',
        transversal = snapshot['transversal'] ?? '',
        // transversal_userid = snapshot['transversal_userid'] ?? '',
        // transversal_responsible = snapshot['transversal_responsible'] ?? '',
        // maintenance_userid = snapshot['maintenance_userid'] ?? '',
        maintenance_supervisor = snapshot['maintenance_supervisor'] ?? '',
        // lototo = snapshot['lototo'] ?? '',
        // hit_or_caught = snapshot['hit_or_caught'] ?? '',
        // burn = snapshot['burn'] ?? '',
        // health = snapshot['health'] ?? '',
        // work_condition = snapshot['work_condition'] ?? '',
        // fall = snapshot['fall'] ?? '',
        before_picture1 = snapshot['before_picture1'] ?? '',
        // before_picture2 = snapshot['before_picture2'] ?? '',
        // before_picture3 = snapshot['before_picture3'] ?? '',
        // before_picture4 = snapshot['before_picture4'] ?? '',
        eliminated = snapshot['eliminated'] ?? '',
        reduced = snapshot['reduced'] ?? '',
        isolated = snapshot['isolated'] ?? '',
        controled = snapshot['controled'] ?? '',
        ppe = snapshot['ppe'] ?? '',
        // after_picture1 = snapshot['after_picture1'] ?? '',
        // after_picture2 = snapshot['after_picture2'] ?? '',
        // conditions = ((snapshot['conditions'] ?? []) as List)
        //     .map((condition) => Condition.from_snapshot(condition))
        //     .toList(),
        maintenance_comment = snapshot['maintenance_comment'] ?? '',
        // after_maint_picture2 = snapshot['after_maint_picture2'] ?? '',
        // after_maint_picture1 = snapshot['after_maint_picture1'] ?? '',
        supervisor_comment = snapshot['supervisor_comment'] ?? '',
        // close = snapshot['close'] ?? '',
        // date_corrected = snapshot['date_corrected'] != null
        //     ? (snapshot['date_corrected'] as Timestamp).toDate()
        //     : null,
        // date_close = snapshot['dateClose'] != null
        //     ? (snapshot['date_corrected'] as Timestamp)
        //     : null,
        user_id = snapshot['user_id'] ?? '',
        // created_userid = snapshot["created_userid"],
        // created_name = snapshot["created_name"],
        created_date = snapshot['created_date'] ?? Timestamp.now();
  // modified_userid = snapshot["modified_userid"],
  // modified_name = snapshot["modified_name"],
  // modified_date = snapshot["modified_date"] ?? Timestamp.now();

  Map<String, dynamic> to_json() {
    return {
      //"site": site,
      "number": number,
      "date_wpe": date_wpe,
      "shift": shift,
      "area": area,
      //"area_department": area_department,
      "specific": specific,
      //"supervisor_userid": supervisor_userid,
      "supervisor": supervisor,
      //"supervisor_department": supervisor_department,
      "slot_index": slot_index,
      // "persons": List<dynamic>.from(persons.map((x) => x.to_json())),
      "order": order,
      "transversal": transversal,
      // "transversal_userid": transversal_userid,
      // "transversal_responsible": transversal_responsible,
      // "maintenance_userid": maintenance_userid,
      "maintenance_supervisor": maintenance_supervisor,
      // "lototo": lototo,
      // "hit_or_caught": hit_or_caught,
      // "burn": burn,
      // "health": health,
      // "work_condition": work_condition,
      // "fall": fall,
      "before_picture1": before_picture1,
      // "before_picture2": before_picture2,
      // "before_picture3": before_picture3,
      // "before_picture4": before_picture4,
      "eliminated": eliminated,
      "reduced": reduced,
      "isolated": isolated,
      "controled": controled,
      "ppe": ppe,
      // "after_picture1": after_picture1,
      // "after_picture2": after_picture2,
      // "conditions": List<dynamic>.from(conditions.map((x) => x.to_json())),
      "maintenance_comment": maintenance_comment,
      // "after_maint_picture2": after_maint_picture2,
      // "after_maint_picture1": after_maint_picture1,
      "supervisor_comment": supervisor_comment,
      // "close": close,
      // "date_corrected": date_corrected,
      // "date_close": date_close,
      "user_id": user_id,
      // "created_userid": created_userid,
      // "created_name": created_name,
      "created_date": created_date,
      // "modified_userid": modified_userid,
      // "modified_name": modified_name,
      // "modified_date": modified_date,
    };
  }

  factory Wpe.empty() {
    return Wpe(
      //site: '',
      number: 0,
      date_wpe: Timestamp.now(),
      shift: '',
      area: '',
      //area_department: '',
      specific: '',
      //supervisor_userid: '',
      supervisor: '',
      //supervisor_department: '',
      slot_index: 0,
      //persons: [],
      order: '',
      transversal: '',
      //transversal_userid: '',
      //transversal_responsible: '',
      // maintenance_userid: '',
      maintenance_supervisor: '',
      // lototo: '',
      // hit_or_caught: '',
      // burn: '',
      // health: '',
      // work_condition: '',
      // fall: '',
      before_picture1: '',
      // before_picture2: '',
      // before_picture3: '',
      // before_picture4: '',
      eliminated: '',
      reduced: '',
      isolated: '',
      controled: '',
      ppe: '',
      // after_picture1: '',
      // after_picture2: '',
      // conditions: [],
      maintenance_comment: '',
      // after_maint_picture2: '',
      // after_maint_picture1: '',
      supervisor_comment: '',
      // close: false,
      // date_corrected: null,
      // date_close: null,
      user_id: '',
      //created_userid: '',
      //created_name: '',
      created_date: Timestamp.now(),
    );
    //modified_userid: '',
    //modified_name: '',
    //modified_date: Timestamp.now());
  }
}
