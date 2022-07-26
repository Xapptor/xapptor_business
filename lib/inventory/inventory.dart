import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:xapptor_business/inventory/product_editor_view.dart';
import 'package:xapptor_business/models/product.dart';
import 'package:xapptor_logic/is_portrait.dart';
import 'package:xapptor_router/app_screen.dart';
import 'package:xapptor_router/app_screens.dart';
import 'package:xapptor_ui/widgets/card_holder.dart';
import 'package:xapptor_ui/widgets/topbar.dart';
import 'delete_product.dart';

class Inventory extends StatefulWidget {
  const Inventory({
    required this.products_collection_name,
    required this.categories_collection_name,
    required this.text_list,
    required this.text_list_delete_product,
    required this.text_list_add_product,
    required this.product_editor_text_list,
    required this.product_editor_confirmation_text_list,
    required this.main_color,
  });

  final String products_collection_name;
  final String categories_collection_name;
  final List<String> text_list;
  final List<String> text_list_delete_product;
  final List<String> text_list_add_product;
  final List<String> product_editor_text_list;
  final List<String> product_editor_confirmation_text_list;
  final Color main_color;

  @override
  _InventoryState createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  String chosen_value = "";
  double elevation = 3;
  double border_radius = 20;

  @override
  void initState() {
    super.initState();
    get_products();
  }

  List<Product> products = [];

  get_products() async {
    final products_snap = await FirebaseFirestore.instance
        .collection(widget.products_collection_name)
        .get();

    products = products_snap.docs
        .map(
          (product_snap) => Product.from_snapshot(
            product_snap.id,
            product_snap.data(),
          ),
        )
        .toList();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double screen_height = MediaQuery.of(context).size.height;
    double screen_width = MediaQuery.of(context).size.width;
    bool portrait = is_portrait(context);

    return SafeArea(
      top: true,
      child: Scaffold(
        appBar: TopBar(
          context: context,
          background_color: widget.main_color,
          has_back_button: true,
          actions: [],
          custom_leading: null,
          logo_path: "assets/images/logo.png",
        ),
        body: Container(
          child: products.length > 0
              ? ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    Product product = products[index];

                    String inventory_quantity =
                        product.inventory_quantity.toString();
                    String title = '';

                    if (product.inventory_quantity == -1) {
                      title = "${product.name}, ${product.price}\$";
                    } else {
                      title =
                          "${product.name}, ${product.price}\$, ${widget.text_list[1]}: ${inventory_quantity}";
                    }

                    return Container(
                      height: screen_height / 2.5,
                      width: screen_width * (portrait ? 1 : 0.5),
                      child: FractionallySizedBox(
                        widthFactor: portrait ? 1 : 0.5,
                        child: CardHolder(
                          image_src: product.image_src,
                          title: title,
                          subtitle: product.description,
                          background_image_alignment: Alignment.center,
                          icon: null,
                          icon_background_color: null,
                          on_pressed: () {
                            //
                          },
                          elevation: elevation,
                          border_radius: border_radius,
                          is_focused: false,
                          delete_function: () {
                            delete_product_alert(
                              context: context,
                              text_list: widget.text_list_delete_product,
                              product_id: product.id,
                            );
                          },
                          edit_function: () {
                            String screen_name = "home/products/${product.id}";
                            add_new_app_screen(
                              AppScreen(
                                name: screen_name,
                                child: ProductEditorView(
                                  product: product,
                                  main_color: widget.main_color,
                                  text_list: widget.product_editor_text_list,
                                  confirmation_text_list: widget
                                      .product_editor_confirmation_text_list,
                                ),
                              ),
                            );

                            open_screen(screen_name);
                          },
                        ),
                      ),
                    );
                  },
                )
              : Center(
                  child: Text(
                    widget.text_list[0],
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: widget.main_color,
          onPressed: () {
            add_product_alert(
              context: context,
              text_list: widget.text_list_add_product,
            );
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  delete_product_alert({
    required BuildContext context,
    required List<String> text_list,
    required String product_id,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(text_list[6]),
          actions: <Widget>[
            TextButton(
              child: Text(text_list[4]),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(text_list[5]),
              onPressed: () async {
                delete_product(product_id);
              },
            ),
          ],
        );
      },
    );
  }

  add_product_alert({
    required BuildContext context,
    required List<String> text_list,
  }) {
    chosen_value = text_list[1];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(text_list[0]),
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return DropdownButton<String>(
              value: chosen_value,
              underline: Container(),
              items: text_list.sublist(1, 3).map((String value) {
                return new DropdownMenuItem<String>(
                  value: value,
                  child: new Text(
                    value,
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  chosen_value = value!;
                });
              },
            );
          }),
          actions: <Widget>[
            TextButton(
              child: Text(text_list[3]),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(text_list[4]),
              onPressed: () async {
                Product product = Product.empty();
                String screen_name = "home/products/${product.id}";
                add_new_app_screen(
                  AppScreen(
                    name: screen_name,
                    child: ProductEditorView(
                      product: product,
                      main_color: widget.main_color,
                      text_list: widget.product_editor_text_list,
                      confirmation_text_list:
                          widget.product_editor_confirmation_text_list,
                    ),
                  ),
                );

                open_screen(screen_name);
              },
            ),
          ],
        );
      },
    );
  }
}
