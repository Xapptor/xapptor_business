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
    this.is_a_product_category = false,
    this.category_id = "",
  });

  final String id;
  final String price_id;
  final String name;
  final String image_src;
  final int price;
  final String description;
  final bool enabled;
  final int inventory_quantity;
  final bool is_a_product_category;
  final String category_id;

  Product.from_snapshot(
    String id,
    Map<String, dynamic> snapshot,
  )   : id = id,
        price_id = snapshot[current_build_mode == BuildMode.release
                ? "stripe_id"
                : "stripe_id_test"] ??
            "",
        name = snapshot['name'],
        image_src = snapshot['image_src'] ?? "",
        price = snapshot['price'],
        enabled = snapshot['enabled'] ?? true,
        description = snapshot['description'] ?? "",
        inventory_quantity = snapshot['inventory_quantity'] ?? -1,
        is_a_product_category = snapshot['is_a_product_category'] ?? false,
        category_id = snapshot['category_id'] ?? "";

  Map<String, dynamic> to_json() {
    return {
      'name': name,
      'price_id': price_id,
      'image_src': image_src,
      'price': price,
      'enabled': enabled,
      'description': description,
      'inventory_quantity': inventory_quantity,
      'is_a_product_category': is_a_product_category,
      'category_id': category_id,
    };
  }

  factory Product.empty() {
    return const Product(
      id: "",
      price_id: "",
      name: "",
      image_src: "",
      price: 0,
      description: "",
      enabled: true,
      inventory_quantity: -1,
      is_a_product_category: false,
      category_id: "",
    );
  }
}

List<Map<String, dynamic>> product_list_to_json_list(List<Product> products) {
  List<Map<String, dynamic>> json_list = [];
  for (var product in products) {
    json_list.add(product.to_json());
  }

  return json_list;
}

enum ProductType {
  raw_material,
  finished_product,
  service,
}
