// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:xapptor_business/models/dispenser.dart';
import 'package:xapptor_business/models/product.dart';
import 'package:xapptor_business/product_list/open_details.dart';
import 'package:xapptor_business/product_list/product_list.dart';
import 'package:xapptor_business/product_list/show_delete_product_dialog.dart';
import 'package:xapptor_business/product_list/show_product_picker_dialog.dart';
import 'package:xapptor_ui/utils/is_portrait.dart';
import 'package:xapptor_ui/widgets/card/custom_card.dart';
import 'package:xapptor_ui/widgets/webview/webview.dart';

extension StateExtension on ProductListState {
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
            if (widget.allow_edit && widget.for_dispensers)
              Align(
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
              ),
            if (!widget.for_dispensers)
              Align(
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
              ),
            if (!widget.for_dispensers)
              Align(
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
              ),
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
}
