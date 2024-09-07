import 'package:xapptor_db/xapptor_db.dart';
import 'package:xapptor_business/models/cabin.dart';

Future<List<Cabin>> get_cabins() async {
  List<Cabin> cabins = [];
  var cabins_snap = await XapptorDB.instance.collection("cabins").get();

  for (var snap in cabins_snap.docs) {
    cabins.add(Cabin.from_snapshot(snap.id, snap.data()));
  }
  return cabins;
}
