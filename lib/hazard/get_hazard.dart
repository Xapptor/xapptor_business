import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xapptor_business/models/hazard.dart';
import 'package:xapptor_db/xapptor_db.dart';

Future<Hazard?> get_hazard(String id) async {
  DocumentSnapshot hazard_snap =
      await XapptorDB.instance.collection("hazards").doc(id).get();
  return hazard_snap.data() != null ? Hazard.from_snapshot(hazard_snap) : null;
}
