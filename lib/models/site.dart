import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xapptor_business/models/area.dart';
import 'package:xapptor_business/models/transversal.dart';

class Site {
  String id;
  String site_name;
  String company_id;
  String company_name;
  String address_line1;
  String address_line2;
  String address_line3;
  String city;
  String state;
  String zipcode;
  String country;
  String phone1;
  String phone2;
  int lastwpe;
  int lastws;
  String hazard_id;
  List<String> shifts;
  List<String> departments;
  List<Area> areas;
  List<Transversal> transversals;

  Site({
    required this.id,
    required this.site_name,
    required this.company_id,
    required this.company_name,
    required this.address_line1,
    required this.address_line2,
    required this.address_line3,
    required this.city,
    required this.state,
    required this.zipcode,
    required this.country,
    required this.phone1,
    required this.phone2,
    required this.lastwpe,
    required this.lastws,
    required this.hazard_id,
    required this.shifts,
    required this.departments,
    required this.areas,
    required this.transversals,
  });

  Site.from_snapshot(DocumentSnapshot snapshot)
      : id = snapshot.id,
        site_name = snapshot.get("site_name"),
        company_id = snapshot.get("company_id"),
        company_name = snapshot.get("company_name"),
        address_line1 = snapshot.get("address_line1"),
        address_line2 = snapshot.get("address_line2"),
        address_line3 = snapshot.get("address_line3"),
        city = snapshot.get("city"),
        state = snapshot.get("state"),
        zipcode = snapshot.get("zipcode"),
        country = snapshot.get("country"),
        phone1 = snapshot.get("phone1"),
        phone2 = snapshot.get("phone2"),
        lastwpe = snapshot.get("lastwpe"),
        lastws = snapshot.get("lastws"),
        hazard_id = snapshot.get("hazard_id"),
        shifts = (snapshot['shifts'] as List).map((e) => e as String).toList(),
        departments =
            (snapshot['departments'] as List).map((e) => e as String).toList(),
        areas = ((snapshot['areas'] ?? []) as List)
            .map((area) => Area.from_snapshot(area))
            .toList(),
        transversals = ((snapshot['transversals'] ?? []) as List)
            .map((transversal) => Transversal.from_snapshot(transversal))
            .toList();

  Map<String, dynamic> to_json() {
    return {
      "id": id,
      "site_name": site_name,
      "company_id": company_id,
      "company_name": company_name,
      "address_line1": address_line1,
      "address_line2": address_line2,
      "address_line3": address_line3,
      "city": city,
      "state": state,
      "zipcode": zipcode,
      "country": country,
      "phone1": phone1,
      "phone2": phone2,
      "lastwpe": lastwpe,
      "lastws": lastws,
      "hazard_id": hazard_id,
      "shifts": shifts,
      "departments": departments,
      "areas": List<dynamic>.from(areas.map((x) => x.to_json())),
      "transversals": List<dynamic>.from(transversals.map((x) => x.to_json())),
    };
  }
}
