import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:xapptor_business/inventory/product_card.dart';
import 'package:xapptor_business/models/product.dart';

class Inventory extends StatefulWidget {
  const Inventory({
    required this.products_collection_name,
  });

  final String products_collection_name;

  @override
  _InventoryState createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  @override
  void initState() {
    super.initState();
  }

  List<Product> products = [];

  get_products() async {
    final products_snap = await FirebaseFirestore.instance
        .collection(widget.products_collection_name)
        .get();

    products_snap.docs.forEach((product_snap) {
      products.add(
        Product.from_snapshot(
          product_snap.id,
          product_snap.data(),
        ),
      );
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        body: Container(
          child: ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              return ProductCard(
                product: products[index],
              );
            },
          ),
        ),
      ),
    );
  }
}
