import 'package:xapptor_db/xapptor_db.dart';
import 'package:xapptor_business/models/cabin.dart';

set_cabins(List<Cabin> cabins) {
  for (var cabin in cabins) {
    XapptorDB.instance.collection("cabins").doc(cabin.id).set(cabin.to_json());
  }
}
