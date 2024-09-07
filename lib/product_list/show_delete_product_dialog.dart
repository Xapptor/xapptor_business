// ignore_for_file: use_build_context_synchronously

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:xapptor_business/models/product.dart';
import 'package:xapptor_business/product_list/get_products.dart';
import 'package:xapptor_business/product_list/product_list.dart';
import 'package:xapptor_db/xapptor_db.dart';

extension StateExtension on ProductListState {
  show_delete_product_dialog(
    BuildContext context,
    Product product,
  ) async {
    double sized_box_height = 10;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: StatefulBuilder(
            builder: (
              BuildContext context,
              StateSetter setState,
            ) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: sized_box_height),
                  const Text(
                    "¿Eliminar este producto?",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: sized_box_height),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancelar"),
                      ),
                      TextButton(
                        onPressed: () async {
                          await XapptorDB.instance.collection("products").doc(product.id).delete().then((value) async {
                            await FirebaseStorage.instance.refFromURL(product.image_src).delete().then((value) async {
                              get_products();
                              Navigator.pop(context);
                            }).onError((error, stackTrace) {
                              debugPrint(error.toString());
                              get_products();
                              Navigator.pop(context);
                            });
                          });
                        },
                        child: const Text("Aceptar"),
                      ),
                    ],
                  ),
                  SizedBox(height: sized_box_height),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
