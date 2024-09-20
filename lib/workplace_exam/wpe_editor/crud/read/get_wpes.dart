import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xapptor_business/models/wpe.dart';
import 'package:xapptor_db/xapptor_db.dart';

Future<List<Wpe>> get_wpes({
  required String user_id,
}) async {
  QuerySnapshot<Map<String, dynamic>> wpes_snaps = await XapptorDB.instance
      .collection("wpes")
      .where("user_id", isEqualTo: user_id)
      .get();

  List<Wpe> wpes = wpes_snaps.docs
      .map((doc) => Wpe.from_snapshot(doc.id, doc.data()))
      .toList();

  wpes = wpes..sort((Wpe a, Wpe b) => a.slot_index.compareTo(b.slot_index));

  if (wpes.isEmpty) wpes.add(Wpe.empty());
  return wpes;
}
