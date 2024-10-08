import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:xapptor_business/models/product.dart';
import 'package:xapptor_db/xapptor_db.dart';

Future delete_product(
  Product product,
  String collection_name,
) async {
  await XapptorDB.instance.collection('products').doc(product.id).delete();
  Reference doc_ref = FirebaseStorage.instance.ref('products/${product.id}');
  doc_ref.listAll().then((list_result) {
    for (var element in list_result.items) {
      element.delete();
    }
  });

  if (product.is_a_product_category) {
    List<Product> products = [];

    QuerySnapshot products_snap =
        await XapptorDB.instance.collection(collection_name).where('category_id', isEqualTo: product.id).get();

    products = products_snap.docs
        .map(
          (product_snap) => Product.from_snapshot(
            product_snap.id,
            product_snap.data() as Map<String, dynamic>,
          ),
        )
        .toList();

    for (var product in products) {
      delete_product(product, collection_name);
    }
  }
}
