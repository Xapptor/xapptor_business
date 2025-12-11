import 'package:xapptor_business/product_catalog/product_catalog.dart';
import 'package:xapptor_logic/firebase_tasks/check.dart';
import 'package:xapptor_router/V2/app_screens_v2.dart';

extension StateExtension on ProductCatalogState {
  validate_coupon() async {
    String coupon_id = coupon_controller.text.isNotEmpty ? coupon_controller.text : " ";

    coupon_controller.clear();

    String check_coupon_response = await check_if_coupon_is_valid(
      coupon_id,
      context,
      widget.translation_text_list_array.get(source_language_index)[6],
      widget.translation_text_list_array.get(source_language_index)[7],
    );

    if (check_coupon_response.isNotEmpty) {
      open_screen_v2(check_coupon_response);
    }
  }
}
