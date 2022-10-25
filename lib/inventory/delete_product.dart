import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:xapptor_business/models/product.dart';

Future delete_product(Product product, String collection_name) async {
  await FirebaseFirestore.instance
      .collection('products')
      .doc(product.id)
      .delete();
  Reference doc_ref =
      await FirebaseStorage.instance.ref('products/' + product.id);
  doc_ref.listAll().then((list_result) {
    list_result.items.forEach((element) {
      element.delete();
    });
  });

  if (product.is_a_product_category) {
    List<Product> products = [];

    QuerySnapshot products_snap = await FirebaseFirestore.instance
        .collection(collection_name)
        .where('category_id', isEqualTo: product.id)
        .get();

    products = products_snap.docs
        .map(
          (product_snap) => Product.from_snapshot(
            product_snap.id,
            product_snap.data() as Map<String, dynamic>,
          ),
        )
        .toList();

    products.forEach((product) {
      delete_product(product, collection_name);
    });
  }
}
