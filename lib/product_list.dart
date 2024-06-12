import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:xapptor_logic/firebase_tasks/update.dart';
import 'package:xapptor_router/app_screen.dart';
import 'package:xapptor_router/app_screens.dart';
import 'models/dispenser.dart';
import 'models/product.dart';
import 'package:xapptor_ui/widgets/webview/webview.dart';
import 'package:xapptor_ui/widgets/card/custom_card.dart';
import 'package:xapptor_ui/widgets/top_and_bottom/topbar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'vending_machine/dispenser_details.dart';
import 'product_details.dart';
import 'package:xapptor_ui/utils/is_portrait.dart';

class ProductList extends StatefulWidget {
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

  final String? vending_machine_id;
  final bool allow_edit;
  final bool has_topbar;
  final bool for_dispensers;
  final Color topbar_color;
  final Color text_color;
  final Color title_color;

  @override
  State<StatefulWidget> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final ScrollController _scroll_controller = ScrollController();
  List<Product> vending_machine_products = [];
  List<Product> products = [];
  List<Dispenser> dispensers = [];
  List<String> products_values = [];
  String products_value = "";

  // Getting products data.

  get_products() async {
    products = [];
    vending_machine_products = [];
    dispensers = [];
    products_values = [];

    setState(() {});

    await FirebaseFirestore.instance.collection("products").get().then((snapshot_products) async {
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
            await FirebaseFirestore.instance.collection("vending_machines").doc(widget.vending_machine_id).get();

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
                add_new_app_screen(
                  AppScreen(
                    name: "home/products/details",
                    child: ProductDetails(
                      product: null,
                      is_editing: true,
                      text_color: widget.text_color,
                      title_color: widget.title_color,
                    ),
                  ),
                );
                open_screen("home/products/details");
              },
              label: const Text("Agregar Producto"),
              icon: const Icon(Icons.add),
              backgroundColor: widget.text_color,
            ),
    );
  }

  Widget dispenser_and_product_item({
    required Product product,
    required BuildContext context,
    required Dispenser? dispenser,
    required int dispenser_id,
  }) {
    bool portrait = is_portrait(context);
    double fractional_factor = 0.85;
    double border_radius = 10;

    return SizedBox(
      height: MediaQuery.of(context).size.height / 3,
      child: FractionallySizedBox(
        heightFactor: fractional_factor,
        widthFactor: portrait ? fractional_factor : 0.3,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 3,
              child: CustomCard(
                splash_color: widget.text_color.withOpacity(0.2),
                elevation: 3,
                border_radius: border_radius,
                on_pressed: () {
                  open_details(
                    dispenser: dispenser,
                    product: product,
                    dispenser_id: dispenser_id,
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(border_radius),
                  child: FractionallySizedBox(
                    heightFactor: 0.6,
                    child: IgnorePointer(
                      child: Webview(
                        id: const Uuid().v8(),
                        src: product.image_src,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Text(
                  (dispenser_id + 1).toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            widget.allow_edit && widget.for_dispensers
                ? Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      alignment: Alignment.center,
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          products_value =
                              products_values[products_values.indexOf(vending_machine_products[dispenser_id].name)];
                          show_product_picker_dialog(context, dispenser_id);
                        });
                      },
                    ),
                  )
                : Container(),
            !widget.for_dispensers
                ? Align(
                    alignment: Alignment.bottomLeft,
                    child: IconButton(
                      alignment: Alignment.center,
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        show_delete_product_dialog(
                          context,
                          product,
                        );
                      },
                    ),
                  )
                : Container(),
            !widget.for_dispensers
                ? Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      margin: const EdgeInsets.only(
                        top: 18,
                      ),
                      child: Text(
                        product.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                : Container(),
            Align(
              alignment: Alignment.topRight,
              child: Container(
                height: 20,
                width: 20,
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: dispenser != null
                      ? dispenser.enabled
                          ? Colors.green
                          : Colors.red
                      : Colors.transparent,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Open dispenser details.

  open_details({
    required Product product,
    required Dispenser? dispenser,
    required int dispenser_id,
  }) {
    if (widget.for_dispensers) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DispenserDetails(
            product: product,
            dispenser: dispenser!,
            dispenser_id: dispenser_id,
            allow_edit: widget.allow_edit,
            update_enabled_in_dispenser: update_enabled_in_dispenser,
          ),
        ),
      );
    } else {
      add_new_app_screen(
        AppScreen(
          name: "home/products/details",
          child: ProductDetails(
            product: product,
            is_editing: false,
            text_color: widget.text_color,
            title_color: widget.title_color,
          ),
        ),
      );
      open_screen("home/products/details");
    }
  }

  // Show product deletion option dialog.

  show_delete_product_dialog(BuildContext context, Product product) async {
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
                          await FirebaseFirestore.instance
                              .collection("products")
                              .doc(product.id)
                              .delete()
                              .then((value) async {
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

  // Show product picker dialog.

  show_product_picker_dialog(BuildContext context, int index) async {
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
                    "Selecciona el producto para este dispensador",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: sized_box_height),
                  DropdownButton<String>(
                    value: products_value,
                    iconSize: 24,
                    elevation: 16,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    underline: Container(
                      height: 1,
                      color: Colors.black,
                    ),
                    onChanged: (new_value) {
                      setState(() {
                        products_value = new_value!;
                      });
                    },
                    items: products_values.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
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
                        onPressed: () {
                          update_product_in_dispenser(index);
                          Navigator.pop(context);
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
