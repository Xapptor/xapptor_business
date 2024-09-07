import 'package:flutter/material.dart';
import 'package:xapptor_business/product_details/product_details.dart';
import 'package:xapptor_business/product_details/save_product_changes.dart';

extension StateExtension on ProductDetailsState {
  show_save_data_alert_dialog({
    required BuildContext context,
  }) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("¿Deseas guardar los cambios?"),
          actions: [
            TextButton(
              child: const Text("Descartar cambios"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              onPressed: save_product_changes,
              child: const Text("Aceptar"),
            ),
          ],
        );
      },
    );
  }
}
