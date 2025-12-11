import 'package:flutter/material.dart';
import 'package:xapptor_business/models/dispenser.dart';
import 'package:xapptor_business/models/product.dart';
import 'package:xapptor_business/product_details/product_details.dart';
import 'package:xapptor_business/product_list/product_list.dart';
import 'package:xapptor_business/vending_machine/dispenser_details.dart';
import 'package:xapptor_router/V2/app_screens_v2.dart';

extension StateExtension on ProductListState {
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
      add_new_app_screen_v2(
        AppScreenV2(
          name: "home/products/details",
          child: ProductDetails(
            product: product,
            is_editing: false,
            text_color: widget.text_color,
            title_color: widget.title_color,
          ),
        ),
      );
      open_screen_v2("home/products/details");
    }
  }
}
