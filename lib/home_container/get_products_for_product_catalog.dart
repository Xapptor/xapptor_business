import 'package:xapptor_db/xapptor_db.dart';
import 'package:xapptor_business/home_container/home_container.dart';
import 'package:xapptor_business/models/product.dart';
import 'package:xapptor_router/app_screen.dart';
import 'package:xapptor_router/app_screens.dart';

extension StateExtension on HomeContainerState {
  get_products_for_product_catalog() async {
    List<Product> products = [];
    var query = await XapptorDB.instance.collection(widget.products_collection_name).orderBy("price").get();

    for (var course in query.docs) {
      products.add(
        Product.from_snapshot(
          course.id,
          course.data(),
        ),
      );
    }
    widget.product_catalog!.products = products;
    add_new_app_screen(
      AppScreen(
        name: "home/products",
        child: widget.product_catalog!,
      ),
    );
  }
}
