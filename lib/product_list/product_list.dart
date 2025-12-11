// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:xapptor_business/models/dispenser.dart';
import 'package:xapptor_business/models/product.dart';
import 'package:xapptor_business/product_details/product_details.dart';
import 'package:xapptor_business/product_list/dispenser_and_product_item.dart';
import 'package:xapptor_business/product_list/get_products.dart';
import 'package:xapptor_logic/firebase_tasks/update.dart';
import 'package:xapptor_router/V2/app_screens_v2.dart';
import 'package:xapptor_ui/widgets/top_and_bottom/topbar.dart';

class ProductList extends StatefulWidget {
  final String? vending_machine_id;
  final bool allow_edit;
  final bool has_topbar;
  final bool for_dispensers;
  final Color topbar_color;
  final Color text_color;
  final Color title_color;

  const ProductList({
    super.key,
    required this.vending_machine_id,
    required this.allow_edit,
    required this.has_topbar,
    required this.for_dispensers,
    required this.topbar_color,
    required this.text_color,
    required this.title_color,
  });

  @override
  State<StatefulWidget> createState() => ProductListState();
}

class ProductListState extends State<ProductList> {
  final ScrollController _scroll_controller = ScrollController();
  List<Product> vending_machine_products = [];
  List<Product> products = [];
  List<Dispenser> dispensers = [];
  List<String> products_values = [];
  String products_value = "";

  // Getting products data.

  @override
  void dispose() {
    _scroll_controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    get_products();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.has_topbar
          ? TopBar(
              context: context,
              background_color: widget.topbar_color,
              has_back_button: true,
              actions: [],
              custom_leading: null,
              logo_path: "assets/images/logo.png",
              logo_color: Colors.white,
            )
          : null,
      body: Container(
        color: Colors.white,
        child: ListView.builder(
          controller: _scroll_controller,
          itemCount: widget.for_dispensers ? vending_machine_products.length : products.length,
          itemBuilder: (context, i) {
            return dispenser_and_product_item(
              product: widget.for_dispensers ? vending_machine_products[i] : products[i],
              context: context,
              dispenser: widget.for_dispensers ? dispensers[i] : null,
              dispenser_id: i,
            );
          },
        ),
      ),
      floatingActionButton: widget.for_dispensers
          ? null
          : FloatingActionButton.extended(
              onPressed: () {
                add_new_app_screen_v2(
                  AppScreenV2(
                    name: "home/products/details",
                    child: ProductDetails(
                      product: null,
                      is_editing: true,
                      text_color: widget.text_color,
                      title_color: widget.title_color,
                    ),
                  ),
                );
                open_screen_v2("home/products/details");
              },
              label: const Text("Agregar Producto"),
              icon: const Icon(Icons.add),
              backgroundColor: widget.text_color,
            ),
    );
  }

  // Setting "enabled" parameter in dispenser.

  update_enabled_in_dispenser(int index, bool enabled) {
    Dispenser dispenser_updated = dispensers[index];
    dispenser_updated.enabled = enabled;
    update_dispenser(dispenser_updated, index);
  }

  // Update product in dispenser.

  update_product_in_dispenser(int index) {
    Dispenser dispenser_updated = dispensers[index];
    Product current_product = products.firstWhere((product) => product.name == products_value);

    dispenser_updated.product_id = current_product.id;
    update_dispenser(dispenser_updated, index);

    Timer(const Duration(milliseconds: 500), () {
      get_products();
    });
  }

  // Update dispenser.

  update_dispenser(Dispenser dispenser, int index) {
    update_item_value_in_array(
      document_id: widget.vending_machine_id!,
      collection_id: "vending_machines",
      field_key: "dispensers",
      field_value: dispenser.to_json(),
      index: index,
    );
  }
}
