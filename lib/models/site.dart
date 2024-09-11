import 'package:cloud_firestore/cloud_firestore.dart';

class Site {
  String id;
  String state;

  Site({
    required this.id,
    required this.state,
  });

  Site.from_snapshot(DocumentSnapshot snapshot)
      : id = snapshot.id,
        state = snapshot.get("state");
}

// To parse this JSON data, do

//     final site = siteFromJson(jsonString);

// import 'dart:convert';

// Site siteFromJson(String str) => Site.fromJson(json.decode(str));

// String siteToJson(Site data) => json.encode(data.toJson());

// class Site {
//   final String country;
//   final String companyId;
//   final int lastwpe;
//   final String city;
//   final String phone2;
//   final List<Area> areas;
//   final int lastws;
//   final String phone1;
//   final String siteName;
//   final String zipcode;
//   final String addressLine3;
//   final String addressLine2;
//   final String addressLine1;
//   final String hazard;
//   final String companyName;
//   final List<String> shifts;
//   final String state;
//   final List<String> departments;
//   final List<Transversal> transversals;

//   Site({
//     required this.country,
//     required this.companyId,
//     required this.lastwpe,
//     required this.city,
//     required this.phone2,
//     required this.areas,
//     required this.lastws,
//     required this.phone1,
//     required this.siteName,
//     required this.zipcode,
//     required this.addressLine3,
//     required this.addressLine2,
//     required this.addressLine1,
//     required this.hazard,
//     required this.companyName,
//     required this.shifts,
//     required this.state,
//     required this.departments,
//     required this.transversals,
//   });

//   factory Site.fromJson(Map<String, dynamic> json) => Site(
//         country: json["country"],
//         companyId: json["company_id"],
//         lastwpe: json["lastwpe"],
//         city: json["city"],
//         phone2: json["phone2"],
//         areas: List<Area>.from(json["areas"].map((x) => Area.fromJson(x))),
//         lastws: json["lastws"],
//         phone1: json["phone1"],
//         siteName: json["site_name"],
//         zipcode: json["zipcode"],
//         addressLine3: json["address_line3"],
//         addressLine2: json["address_line2"],
//         addressLine1: json["address_line1"],
//         hazard: json["hazard"],
//         companyName: json["company_name"],
//         shifts: List<String>.from(json["shifts"].map((x) => x)),
//         state: json["state"],
//         departments: List<String>.from(json["departments"].map((x) => x)),
//         transversals: List<Transversal>.from(
//             json["transversals"].map((x) => Transversal.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "country": country,
//         "company_id": companyId,
//         "lastwpe": lastwpe,
//         "city": city,
//         "phone2": phone2,
//         "areas": List<dynamic>.from(areas.map((x) => x.toJson())),
//         "lastws": lastws,
//         "phone1": phone1,
//         "site_name": siteName,
//         "zipcode": zipcode,
//         "address_line3": addressLine3,
//         "address_line2": addressLine2,
//         "address_line1": addressLine1,
//         "hazard": hazard,
//         "company_name": companyName,
//         "shifts": List<dynamic>.from(shifts.map((x) => x)),
//         "state": state,
//         "departments": List<dynamic>.from(departments.map((x) => x)),
//         "transversals": List<dynamic>.from(transversals.map((x) => x.toJson())),
//       };
// }

// class Area {
//   final String area;
//   final String department;

//   Area({
//     required this.area,
//     required this.department,
//   });

//   factory Area.fromJson(Map<String, dynamic> json) => Area(
//         area: json["area"],
//         department: json["department"],
//       );

//   Map<String, dynamic> toJson() => {
//         "area": area,
//         "department": department,
//       };
// }

// class Transversal {
//   final String responsible;
//   final String location;

//   Transversal({
//     required this.responsible,
//     required this.location,
//   });

//   factory Transversal.fromJson(Map<String, dynamic> json) => Transversal(
//         responsible: json["responsible"],
//         location: json["location"],
//       );

//   Map<String, dynamic> toJson() => {
//         "responsible": responsible,
//         "location": location,
//       };
// }
