class ProductCategory {
  final String id;
  final String name;
  final String image_src;
  final String category_id;
  final bool has_subcategory;

  const ProductCategory({
    required this.id,
    required this.name,
    required this.image_src,
    this.category_id = "",
    this.has_subcategory = false,
  });

  ProductCategory.from_snapshot(
    this.id,
    Map<String, dynamic> snapshot,
  )   : name = snapshot['name'],
        image_src = snapshot['image_src'] ?? "",
        category_id = snapshot['category_id'] ?? "",
        has_subcategory = snapshot['has_subcategory'] ?? false;

  Map<String, dynamic> to_json() {
    return {
      'name': name,
      'image_src': image_src,
      'category_id': category_id,
      'has_subcategory': has_subcategory,
    };
  }
}
