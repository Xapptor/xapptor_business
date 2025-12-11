import 'package:flutter/material.dart';
import 'package:xapptor_auth/sign_out.dart';
import 'package:xapptor_business/home_container/home_container.dart';
import 'package:xapptor_router/V2/app_screens_v2.dart';

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
                sign_out(
                  context: context,
                );
              },
            ),
            TextButton(
              child: const Text("Ok"),
              onPressed: () async {
                open_screen_v2("home/account");
              },
            ),
          ],
        );
      },
    );
  }
}
