// To parse this JSON data, do
//
//     final wpe = wpeFromJson(jsonString);

// Wpe wpeFromJson(String str) => Wpe.fromJson(json.decode(str));

// String wpeToJson(Wpe data) => json.encode(data.toJson());

class Wpe {
  String id;
  final String site;
  final int number;
  final DateClose dateWpe;
  final String shift;
  final String area;
  final String areaDepartment;
  final String specific;
  final String supervisorUserid;
  final String supervisor;
  final String supervisorDepartment;
  final List<Person> persons;
  final String order;
  final String transversal;
  final String transversalUserid;
  final String transversalResponsible;
  final String maintenanceUserid;
  final String maintenanceSupervisor;
  final String lototo;
  final String hitOrCaught;
  final String burn;
  final String health;
  final String workCondition;
  final String fall;
  final String beforePicture1;
  final String beforePicture2;
  final String beforePicture3;
  final String beforePicture4;
  final String eliminated;
  final String reduced;
  final String isolated;
  final String controled;
  final String ppe;
  final String afterPicture1;
  final String afterPicture2;
  final List<Condition> conditions;
  final String maintenanceComment;
  final String afterMaintPicture2;
  final String afterMaintPicture1;
  final String supervisorComment;
  final bool close;
  final DateClose dateCorrected;
  final DateClose dateClose;
  final Audit audit;
  final String user_id;

  Wpe({
    this.id = "",
    required this.site,
    required this.number,
    required this.dateWpe,
    required this.shift,
    required this.area,
    required this.areaDepartment,
    required this.specific,
    required this.supervisorUserid,
    required this.supervisor,
    required this.supervisorDepartment,
    required this.persons,
    required this.order,
    required this.transversal,
    required this.transversalUserid,
    required this.transversalResponsible,
    required this.maintenanceUserid,
    required this.maintenanceSupervisor,
    required this.lototo,
    required this.hitOrCaught,
    required this.burn,
    required this.health,
    required this.workCondition,
    required this.fall,
    required this.beforePicture1,
    required this.beforePicture2,
    required this.beforePicture3,
    required this.beforePicture4,
    required this.eliminated,
    required this.reduced,
    required this.isolated,
    required this.controled,
    required this.ppe,
    required this.afterPicture1,
    required this.afterPicture2,
    required this.conditions,
    required this.maintenanceComment,
    required this.afterMaintPicture2,
    required this.afterMaintPicture1,
    required this.supervisorComment,
    required this.close,
    required this.dateCorrected,
    required this.dateClose,
    required this.audit,
    required this.user_id,
  });

  Wpe.from_snapshot(
    this.id,
    Map<dynamic, dynamic> snapshot,
  )   : site = snapshot['site'] ?? '',
        number = snapshot['number'] ?? '',
        dateWpe = DateClose.fromJson(snapshot['date_wpe']),
        shift = snapshot['shift'] ?? '',
        area = snapshot['area'] ?? '',
        areaDepartment = snapshot['area_department'] ?? '',
        specific = snapshot['specific'] ?? '',
        supervisorUserid = snapshot['supervisor_userid'] ?? '',
        supervisor = snapshot['supervisor'],
        supervisorDepartment = snapshot['supervisor_department'],
        persons = List<Person>.from(
            snapshot['persons'].map((x) => Person.fromJson(x))),
        order = snapshot['order'] ?? '',
        transversal = snapshot['transversal'] ?? '',
        transversalUserid = snapshot['transversal_userid'] ?? '',
        transversalResponsible = snapshot['transversal_responsible'] ?? '',
        maintenanceUserid = snapshot['maintenance_userid'] ?? '',
        maintenanceSupervisor = snapshot['maintenance_supervisor'] ?? '',
        lototo = snapshot['lototo'] ?? '',
        hitOrCaught = snapshot['hit_or_caught'] ?? '',
        burn = snapshot['burn'] ?? '',
        health = snapshot['health'] ?? '',
        workCondition = snapshot['work_condition'] ?? '',
        fall = snapshot['fall'] ?? '',
        beforePicture1 = snapshot['before_picture1'] ?? '',
        beforePicture2 = snapshot['before_picture2'] ?? '',
        beforePicture3 = snapshot['before_picture3'] ?? '',
        beforePicture4 = snapshot['before_picture4'] ?? '',
        eliminated = snapshot['eliminated'] ?? '',
        reduced = snapshot['reduced'] ?? '',
        isolated = snapshot['isolated'] ?? '',
        controled = snapshot['controled'] ?? '',
        ppe = snapshot['ppe'] ?? '',
        afterPicture1 = snapshot['after_picture1'] ?? '',
        afterPicture2 = snapshot['after_picture2'] ?? '',
        conditions = List<Condition>.from(
            snapshot['conditions'].map((x) => Condition.fromJson(x))),
        maintenanceComment = snapshot['maintenance_comment'] ?? '',
        afterMaintPicture2 = snapshot['after_maint_picture2'] ?? '',
        afterMaintPicture1 = snapshot['after_maint_picture1'] ?? '',
        supervisorComment = snapshot['supervisor_comment'] ?? '',
        close = snapshot['close'] ?? '',
        dateCorrected = DateClose.fromJson(snapshot['date_corrected']),
        dateClose = DateClose.fromJson(snapshot['date_close']),
        audit = Audit.fromJson(snapshot['audit']);

  Map<String, dynamic> toJson() => {
        "site": site,
        "number": number,
        "date_wpe": dateWpe.toJson(),
        "shift": shift,
        "area": area,
        "area_department": areaDepartment,
        "specific": specific,
        "supervisor_userid": supervisorUserid,
        "supervisor": supervisor,
        "supervisor_department": supervisorDepartment,
        "persons": List<dynamic>.from(persons.map((x) => x.toJson())),
        "order": order,
        "transversal": transversal,
        "transversal_userid": transversalUserid,
        "transversal_responsible": transversalResponsible,
        "maintenance_userid": maintenanceUserid,
        "maintenance_supervisor": maintenanceSupervisor,
        "lototo": lototo,
        "hit_or_caught": hitOrCaught,
        "burn": burn,
        "health": health,
        "work_condition": workCondition,
        "fall": fall,
        "before_picture1": beforePicture1,
        "before_picture2": beforePicture2,
        "before_picture3": beforePicture3,
        "before_picture4": beforePicture4,
        "eliminated": eliminated,
        "reduced": reduced,
        "isolated": isolated,
        "controled": controled,
        "ppe": ppe,
        "after_picture1": afterPicture1,
        "after_picture2": afterPicture2,
        "conditions": List<dynamic>.from(conditions.map((x) => x.toJson())),
        "maintenance_comment": maintenanceComment,
        "after_maint_picture2": afterMaintPicture2,
        "after_maint_picture1": afterMaintPicture1,
        "supervisor_comment": supervisorComment,
        "close": close,
        "date_corrected": dateCorrected.toJson(),
        "date_close": dateClose.toJson(),
        "audit": audit.toJson(),
      };
}

class Audit {
  final String createdUserid;
  final String createdName;
  final DateClose createdDate;
  final String modifiedUserid;
  final String modifiedName;
  final DateClose modifiedDate;

  Audit({
    required this.createdUserid,
    required this.createdName,
    required this.createdDate,
    required this.modifiedUserid,
    required this.modifiedName,
    required this.modifiedDate,
  });

  factory Audit.fromJson(Map<String, dynamic> json) => Audit(
        createdUserid: json["created_userid"],
        createdName: json["created_name"],
        createdDate: DateClose.fromJson(json["created_date"]),
        modifiedUserid: json["modified_userid"],
        modifiedName: json["modified_name"],
        modifiedDate: DateClose.fromJson(json["modified_date"]),
      );

  Map<String, dynamic> toJson() => {
        "created_userid": createdUserid,
        "created_name": createdName,
        "created_date": createdDate.toJson(),
        "modified_userid": modifiedUserid,
        "modified_name": modifiedName,
        "modified_date": modifiedDate.toJson(),
      };
}

class DateClose {
  final String datatype;
  final Value value;

  DateClose({
    required this.datatype,
    required this.value,
  });

  factory DateClose.fromJson(Map<String, dynamic> json) => DateClose(
        datatype: json["__datatype__"],
        value: Value.fromJson(json["value"]),
      );

  Map<String, dynamic> toJson() => {
        "__datatype__": datatype,
        "value": value.toJson(),
      };
}

class Value {
  final int seconds;
  final int nanoseconds;

  Value({
    required this.seconds,
    required this.nanoseconds,
  });

  factory Value.fromJson(Map<String, dynamic> json) => Value(
        seconds: json["_seconds"],
        nanoseconds: json["_nanoseconds"],
      );

  Map<String, dynamic> toJson() => {
        "_seconds": seconds,
        "_nanoseconds": nanoseconds,
      };
}

class Condition {
  final DateClose dateCorrected;
  final String promptlyCorrected;
  final String notPromptlyCorrected;
  final String mitigatingAction;

  Condition({
    required this.dateCorrected,
    required this.promptlyCorrected,
    required this.notPromptlyCorrected,
    required this.mitigatingAction,
  });

  factory Condition.fromJson(Map<String, dynamic> json) => Condition(
        dateCorrected: DateClose.fromJson(json["date_corrected"]),
        promptlyCorrected: json["promptly_corrected"],
        notPromptlyCorrected: json["not_promptly_corrected"],
        mitigatingAction: json["mitigating_action"],
      );

  Map<String, dynamic> toJson() => {
        "date_corrected": dateCorrected.toJson(),
        "promptly_corrected": promptlyCorrected,
        "not_promptly_corrected": notPromptlyCorrected,
        "mitigating_action": mitigatingAction,
      };
}

class Person {
  final String person;
  final String personUserid;

  Person({
    required this.person,
    required this.personUserid,
  });

  factory Person.fromJson(Map<String, dynamic> json) => Person(
        person: json["person"],
        personUserid: json["person_userid"],
      );

  Map<String, dynamic> toJson() => {
        "person": person,
        "person_userid": personUserid,
      };
}
