import 'package:flutter/material.dart';
import 'package:xapptor_business/models/product.dart';
import 'package:xapptor_ui/widgets/card_holder.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({
    required this.product,
  });

  final Product product;
  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  double elevation = 3;
  double border_radius = 20;

  @override
  Widget build(BuildContext context) {
    String inventory_quantity = widget.product.product_type_index == 1
        ? widget.product.inventory_quantity.toString()
        : "";

    return CardHolder(
      image_src: widget.product.image_src,
      title:
          "${widget.product.name} ${widget.product.price}\$ ${inventory_quantity}",
      subtitle: widget.product.description,
      background_image_alignment: Alignment.center,
      icon: null,
      icon_background_color: null,
      on_pressed: () {
        //
      },
      elevation: elevation,
      border_radius: border_radius,
      is_focused: false,
      has_delete_button: true,
      has_edit_button: true,
    );
  }
}
