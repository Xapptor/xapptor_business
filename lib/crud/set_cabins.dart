import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xapptor_business/models/cabin.dart';

set_cabins(List<Cabin> cabins) {
  for (var cabin in cabins) {
    FirebaseFirestore.instance
        .collection("cabins")
        .doc(cabin.id)
        .set(cabin.to_json());
  }
}
