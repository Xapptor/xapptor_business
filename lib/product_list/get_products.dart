// ignore_for_file: invalid_use_of_protected_member

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xapptor_business/models/dispenser.dart';
import 'package:xapptor_business/models/product.dart';
import 'package:xapptor_business/product_list/product_list.dart';
import 'package:xapptor_db/xapptor_db.dart';

extension StateExtension on ProductListState {
  get_products() async {
    products = [];
    vending_machine_products = [];
    dispensers = [];
    products_values = [];

    setState(() {});

    await XapptorDB.instance.collection("products").get().then((snapshot_products) async {
      for (var snapshot_product in snapshot_products.docs) {
        products.add(
          Product.from_snapshot(
            snapshot_product.id,
            snapshot_product.data(),
          ),
        );
      }

      if (widget.for_dispensers) {
        DocumentSnapshot vending_machine =
            await XapptorDB.instance.collection("vending_machines").doc(widget.vending_machine_id).get();

        List vending_machine_dispensers = vending_machine["dispensers"];

        for (var dispenser in vending_machine_dispensers) {
          Dispenser current_dispenser = Dispenser.from_snapshot(dispenser as Map<String, dynamic>);

          Product current_product = products.firstWhere((product) => product.id == current_dispenser.product_id);

          vending_machine_products.add(current_product);
          dispensers.add(current_dispenser);
        }

        for (var product in products) {
          products_values.add(product.name);
        }
        products_value = products_values.first;
      }
      setState(() {});
    });
  }
}
