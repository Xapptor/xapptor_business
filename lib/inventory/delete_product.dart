import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

Future delete_product(String id) async {
  await FirebaseFirestore.instance.collection('products').doc(id).delete();
  Reference doc_ref = await FirebaseStorage.instance.ref('products/' + id);
  doc_ref.listAll().then((list_result) {
    list_result.items.forEach((element) {
      if (element.name.contains('logo')) {
        element.delete();
      }
    });
  });
}
