import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xapptor_business/models/cabin.dart';

Future<List<Cabin>> get_cabins() async {
  List<Cabin> cabins = [];
  var cabins_snap = await FirebaseFirestore.instance.collection("cabins").get();

  for (var snap in cabins_snap.docs) {
    cabins
        .add(Cabin.from_snapshot(snap.id, snap.data()));
  }
  return cabins;
}
