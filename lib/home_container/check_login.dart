import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:xapptor_business/home_container/add_screens.dart';
import 'package:xapptor_business/home_container/check_user_fields.dart';
import 'package:xapptor_business/home_container/home_container.dart';
import 'package:xapptor_router/V2/app_screens_v2.dart';

extension StateExtension on HomeContainerState {
  check_login() {
    if (FirebaseAuth.instance.currentUser != null) {
      loading = false;
      //debugPrint("User is sign");
      add_screens();
      check_user_fields();
    } else {
      Timer(const Duration(milliseconds: 3000), () {
        loading = false;
        if (FirebaseAuth.instance.currentUser != null) {
          //debugPrint("User is sign");
          add_screens();
        } else {
          //debugPrint("User is not sign");
          open_screen_v2("login");
        }
      });
    }
  }
}
