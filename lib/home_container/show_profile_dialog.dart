import 'package:flutter/material.dart';
import 'package:xapptor_business/home_container/home_container.dart';
import 'package:xapptor_router/app_screens.dart';

extension StateExtension on HomeContainerState {
  show_profile_dialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("You need to complete your profile"),
          actions: [
            TextButton(
              child: const Text("Logout"),
              onPressed: () async {
                //sign_out(context: context);
              },
            ),
            TextButton(
              child: const Text("Ok"),
              onPressed: () async {
                //Navigator.of(context).pop();
                open_screen("home/account");
              },
            ),
          ],
        );
      },
    );
  }
}
