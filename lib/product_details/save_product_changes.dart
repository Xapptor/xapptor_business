// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:xapptor_db/xapptor_db.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:xapptor_business/product_details/product_details.dart';

extension StateExtension on ProductDetailsState {
  save_product_changes() async {
    if (widget.product == null) {
      if (current_image_file_base64.isEmpty ||
          controller_name.text.isEmpty ||
          controller_description.text.isEmpty ||
          controller_price.text.isEmpty) {
        Navigator.of(context).pop();
        SnackBar snackBar = const SnackBar(
          content: Text("Debes llenar todos los campos"),
          duration: Duration(seconds: 2),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        try {
          await firebase_storage.FirebaseStorage.instance
              .ref('images/products/$current_image_file_name')
              .putString(current_image_file_base64, format: firebase_storage.PutStringFormat.dataUrl)
              .then((firebase_storage.TaskSnapshot task_snapshot) async {
            String products_length_text = "";

            await XapptorDB.instance.collection("products").get().then((collection_snapshot) {
              products_length_text = (collection_snapshot.size + 1).toString();
            });

            while (products_length_text.length < 3) {
              products_length_text = "0$products_length_text";
            }

            String new_product_id = "zzzzzzzzzzzzzzzzz$products_length_text";

            XapptorDB.instance.collection("products").doc(new_product_id).set({
              "name": controller_name.text,
              "description": controller_description.text,
              "price": int.parse(controller_price.text),
              "url": await task_snapshot.ref.getDownloadURL(),
            }).then((result) {
              is_editing = false;
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            });
          });
        } catch (e) {
          debugPrint("Error: $e");
        }
      }
    } else {
      if (current_image_file_base64 != "") {
        await firebase_storage.FirebaseStorage.instance
            .refFromURL(widget.product!.image_src)
            .delete()
            .then((value) async {
          await firebase_storage.FirebaseStorage.instance
              .ref('images/products/$current_image_file_name')
              .putString(current_image_file_base64, format: firebase_storage.PutStringFormat.dataUrl)
              .then((firebase_storage.TaskSnapshot task_snapshot) async {
            XapptorDB.instance.collection("products").doc(widget.product!.id).update({
              "name": controller_name.text,
              "description": controller_description.text,
              "price": int.parse(controller_price.text),
              "url": await task_snapshot.ref.getDownloadURL(),
            }).then((result) {
              is_editing = false;
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            });
          });
        });
      } else {
        XapptorDB.instance.collection("products").doc(widget.product!.id).update({
          "name": controller_name.text,
          "description": controller_description.text,
          "price": int.parse(controller_price.text),
        }).then((result) {
          is_editing = false;
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        });
      }
    }
  }
}
