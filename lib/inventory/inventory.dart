import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:xapptor_business/inventory/product_editor_view.dart';
import 'package:xapptor_business/models/product.dart';
import 'package:xapptor_ui/utils/is_portrait.dart';
import 'package:xapptor_router/app_screen.dart';
import 'package:xapptor_router/app_screens.dart';
import 'package:xapptor_ui/widgets/card/card_holder.dart';
import 'package:xapptor_ui/widgets/top_and_bottom/topbar.dart';
import 'delete_product.dart';
import 'package:xapptor_db/xapptor_db.dart';

class Inventory extends StatefulWidget {
  final String? old_path;
  final Product? product;
  final String collection_name;
  final List<String> text_list;
  final List<String> text_list_delete_product;
  final List<String> text_list_add_product;
  final List<String> product_editor_text_list;
  final List<String> product_editor_confirmation_text_list;
  final Color main_color;

  const Inventory({
    super.key,
    required this.old_path,
    required this.product,
    required this.collection_name,
    required this.text_list,
    required this.text_list_delete_product,
    required this.text_list_add_product,
    required this.product_editor_text_list,
    required this.product_editor_confirmation_text_list,
    required this.main_color,
  });

  @override
  State<Inventory> createState() => _InventoryState();
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
    late QuerySnapshot products_snap;

    if (widget.product == null) {
      products_snap =
          await XapptorDB.instance.collection(widget.collection_name).where('category_id', isEqualTo: '').get();
    } else {
      products_snap = await XapptorDB.instance
          .collection(widget.collection_name)
          .where('category_id', isEqualTo: widget.product!.id)
          .get();
    }

    products = products_snap.docs
        .map(
          (product_snap) => Product.from_snapshot(
            product_snap.id,
            product_snap.data() as Map<String, dynamic>,
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
        body: Column(
          children: [
            const Spacer(flex: 1),
            Expanded(
              flex: 1,
              child: Text(
                widget.product == null
                    ? (widget.text_list[1].substring(0, 1).toUpperCase() + widget.text_list[1].substring(1))
                    : widget.product!.name,
                style: TextStyle(
                  color: widget.main_color,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              flex: 20,
              child: products.isNotEmpty
                  ? ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        Product product = products[index];

                        String inventory_quantity = product.inventory_quantity.toString();
                        String title = '';

                        if (!product.is_a_product_category) {
                          if (product.inventory_quantity == -1) {
                            title = "${product.name}, ${product.price}\$";
                          } else {
                            title = "${product.name}, ${product.price}\$, ${widget.text_list[1]}: $inventory_quantity";
                          }
                        } else {
                          title = product.name;
                        }

                        return SizedBox(
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
                                if (product.is_a_product_category) {
                                  String path = "";

                                  if (widget.old_path == null) {
                                    path = "home/products/${product.name}";
                                  } else {
                                    path = "${widget.old_path!}/${product.name}";
                                  }
                                  add_new_app_screen(
                                    AppScreen(
                                      name: path,
                                      child: Inventory(
                                        old_path: path,
                                        product: product,
                                        collection_name: "products",
                                        text_list: widget.text_list,
                                        text_list_delete_product: widget.text_list_delete_product,
                                        text_list_add_product: widget.text_list_add_product,
                                        product_editor_text_list: widget.product_editor_text_list,
                                        product_editor_confirmation_text_list:
                                            widget.product_editor_confirmation_text_list,
                                        main_color: widget.main_color,
                                      ),
                                    ),
                                  );
                                  open_screen(path);
                                }
                              },
                              elevation: elevation,
                              border_radius: border_radius,
                              is_focused: false,
                              delete_function: () {
                                delete_product_alert(
                                  context: context,
                                  text_list: widget.text_list_delete_product,
                                  product: product,
                                );
                              },
                              edit_function: () {
                                String screen_name = "home/products/${product.id}";
                                add_new_app_screen(
                                  AppScreen(
                                    name: screen_name,
                                    child: ProductEditorView(
                                      category_id: widget.product?.id,
                                      product: product,
                                      is_a_product_category: product.is_a_product_category,
                                      main_color: widget.main_color,
                                      text_list: widget.product_editor_text_list,
                                      confirmation_text_list: widget.product_editor_confirmation_text_list,
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
                        "${widget.text_list[0]} ${widget.product == null ? widget.text_list[1] : widget.text_list[2]}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: widget.main_color,
          onPressed: () {
            add_product_alert(
              context: context,
              text_list: widget.text_list_add_product,
            );
          },
          child: const Icon(
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
    required Product product,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(text_list[0]),
          actions: [
            TextButton(
              child: Text(text_list[1]),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(text_list[2]),
              onPressed: () async {
                await delete_product(product, widget.collection_name);
                if (context.mounted) Navigator.pop(context);
                get_products();
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
          content: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
            return DropdownButton<String>(
              value: chosen_value,
              underline: const SizedBox(),
              items: text_list.sublist(1, 3).map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: const TextStyle(fontWeight: FontWeight.w500),
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
          actions: [
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
                String screen_name = "home/products/new";
                add_new_app_screen(
                  AppScreen(
                    name: screen_name,
                    child: ProductEditorView(
                      category_id: widget.product?.id,
                      product: product,
                      is_a_product_category: chosen_value == text_list[2],
                      main_color: widget.main_color,
                      text_list: widget.product_editor_text_list,
                      confirmation_text_list: widget.product_editor_confirmation_text_list,
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
