import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:xapptor_business/models/product.dart';

Future set_product(
  Product product,
  Uint8List? image_data,
  String image_name,
  String category_id,
) async {
  String doc_id = product.id;
  if (product.id == '') {
    DocumentReference doc_ref = FirebaseFirestore.instance.collection('products').doc();
    doc_id = doc_ref.id;
  }

  Map<String, dynamic> product_json = product.to_json();

  product_json['category_id'] = category_id;

  if (image_data != null) {
    Reference doc_ref = FirebaseStorage.instance.ref('products/$doc_id/$image_name');
    await doc_ref.putData(image_data);
    String image_url = await doc_ref.getDownloadURL();
    product_json['image_src'] = image_url;
  }

  await FirebaseFirestore.instance
      .collection('products')
      .doc(doc_id)
      .set(
        product_json,
        SetOptions(merge: true),
      )
      .then((doc_snap) async {});
}
