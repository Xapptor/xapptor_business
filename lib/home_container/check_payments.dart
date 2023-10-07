// ignore_for_file: invalid_use_of_protected_member

import 'package:xapptor_business/home_container/get_products_for_product_catalog.dart';
import 'package:xapptor_business/home_container/home_container.dart';
import 'package:xapptor_logic/check_if_payments_are_enabled.dart';

extension StateExtension on HomeContainerState {
  check_payments() async {
    payment_enabled = await check_if_payments_are_enabled();
    widget.update_payment_enabled(payment_enabled);
    setState(() {});
    if (payment_enabled) {
      if (widget.product_catalog != null) {
        get_products_for_product_catalog();
      }
    }
  }
}
