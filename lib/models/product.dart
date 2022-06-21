// Product model.

import 'package:xapptor_router/initial_values_routing.dart';

class Product {
  const Product({
    required this.id,
    this.price_id = "",
    required this.name,
    required this.image_src,
    required this.price,
    this.description = "",
    this.enabled = true,
    this.inventory_quantity = 0,
    required this.product_type_index,
    this.linked_products = const [],
  });

  final String id;
  final String price_id;
  final String name;
  final String image_src;
  final int price;
  final String description;
  final bool enabled;
  final int inventory_quantity;
  final int product_type_index;
  final List<String> linked_products;

  Product.from_snapshot(
    String id,
    Map<String, dynamic> snapshot,
  )   : id = id,
        price_id = snapshot[current_build_mode == BuildMode.release
                ? "stripe_id"
                : "stripe_id_test"] ??
            "",
        name = snapshot['name'],
        image_src = snapshot['image_src'],
        price = snapshot['price'],
        enabled = snapshot['enabled'] ?? true,
        description = snapshot['description'] ?? "",
        inventory_quantity = snapshot['inventory_quantity'] ?? 0,
        product_type_index = snapshot['product_type_index'] ?? 0,
        linked_products = (snapshot['linked_products'] ?? <String>[] as List)
            .map((e) => e as String)
            .toList();

  Map<String, dynamic> to_json() {
    return {
      'name': name,
      'price_id': price_id,
      'image_src': image_src,
      'price': price,
      'enabled': enabled,
      'description': description,
      'inventory_quantity': inventory_quantity,
      'product_type_index': product_type_index,
      'linked_products': linked_products,
    };
  }
}

List<Map<String, dynamic>> product_list_to_json_list(List<Product> products) {
  List<Map<String, dynamic>> json_list = [];

  products.forEach((product) {
    json_list.add(product.to_json());
  });

  return json_list;
}

enum ProductType {
  raw_material,
  finished_product,
  service,
}
