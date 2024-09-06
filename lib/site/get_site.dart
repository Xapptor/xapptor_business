import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xapptor_business/models/site.dart';
import 'package:xapptor_db/xapptor_db.dart';

Future<Site?> get_site(String id) async {
  DocumentSnapshot site_snap = await XapptorDB.instance.collection("sites").doc(id).get();
  return site_snap.data() != null ? Site.from_snapshot(site_snap) : null;
}
