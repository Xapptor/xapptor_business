import 'package:flutter/material.dart';
import 'package:xapptor_ui/widgets/custom_card.dart';

class ProductCard extends StatefulWidget {
  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      on_pressed: () {
        //
      },
      child: Container(),
    );
  }
}
