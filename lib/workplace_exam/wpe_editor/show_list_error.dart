import 'package:flutter/material.dart';

void showListError(
  BuildContext context,
  List<String> errorMessages,
  String titleDialog,
  String buttonText,
) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(titleDialog),
        content: SingleChildScrollView(
          child: ListBody(
            children: errorMessages
                .map((error) => Text('- $error'))
                .toList(), // Convierte la lista de errores en widgets Text
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Cierra el diálogo
            },
            child: Text(buttonText),
          ),
        ],
      );
    },
  );
}
