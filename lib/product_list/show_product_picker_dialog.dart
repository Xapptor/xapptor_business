import 'package:flutter/material.dart';
import 'package:xapptor_business/product_list/product_list.dart';

extension StateExtension on ProductListState {
  show_product_picker_dialog(
    BuildContext context,
    int index,
  ) async {
    double sized_box_height = 10;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: StatefulBuilder(
            builder: (
              BuildContext context,
              StateSetter setState,
            ) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: sized_box_height),
                  const Text(
                    "Selecciona el producto para este dispensador",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: sized_box_height),
                  DropdownButton<String>(
                    value: products_value,
                    iconSize: 24,
                    elevation: 16,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    underline: Container(
                      height: 1,
                      color: Colors.black,
                    ),
                    onChanged: (new_value) {
                      setState(() {
                        products_value = new_value!;
                      });
                    },
                    items: products_values.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: sized_box_height),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancelar"),
                      ),
                      TextButton(
                        onPressed: () {
                          update_product_in_dispenser(index);
                          Navigator.pop(context);
                        },
                        child: const Text("Aceptar"),
                      ),
                    ],
                  ),
                  SizedBox(height: sized_box_height),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
