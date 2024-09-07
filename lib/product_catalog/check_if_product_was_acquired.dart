import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xapptor_db/xapptor_db.dart';

Future<bool> check_if_product_was_acquired({
  required String user_id,
  required String product_id,
}) async {
  DocumentSnapshot user_snap = await XapptorDB.instance.collection("users").doc(user_id).get();
  Map user_snap_data = user_snap.data()! as Map;
  List products_acquired = user_snap_data["products_acquired"] ?? [];
  return products_acquired.contains(product_id);
}
