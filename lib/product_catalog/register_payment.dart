import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xapptor_business/product_catalog/check_if_product_was_acquired.dart';
import 'package:xapptor_business/product_catalog/product_catalog.dart';
import 'package:xapptor_business/product_catalog/show_purchase_result_banner.dart';
import 'package:xapptor_db/xapptor_db.dart';

extension StateExtension on ProductCatalogState {
  register_payment(String product_id) async {
    bool product_was_acquired = await check_if_product_was_acquired(
      user_id: user_id,
      product_id: product_id,
    );
    if (!product_was_acquired) {
      XapptorDB.instance.collection("users").doc(user_id).update({
        "products_acquired": FieldValue.arrayUnion([product_id]),
      }).then((value) {
        XapptorDB.instance.collection("payments").add({
          "payment_intent_id": "",
          "user_id": user_id,
          "product_id": product_id,
          "date": Timestamp.now(),
        }).then((value) {
          show_purchase_result_banner(true, null);
        });
      });
    }
  }
}
