import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xapptor_business/product_catalog/product_catalog.dart';
import 'package:xapptor_business/product_catalog/show_purchase_result_banner.dart';
import 'package:xapptor_db/xapptor_db.dart';

extension StateExtension on ProductCatalogState {
  restore_purchase(String product_id) async {
    XapptorDB.instance.collection("users").doc(user_id).update({
      "products_acquired": FieldValue.arrayUnion([product_id]),
    }).then((value) {
      show_purchase_result_banner(true, "Purchase Restored");
    });
  }
}
