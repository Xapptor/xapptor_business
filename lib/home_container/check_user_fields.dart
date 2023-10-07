import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:xapptor_auth/model/xapptor_user.dart';
import 'package:xapptor_business/home_container/home_container.dart';
import 'package:xapptor_business/home_container/show_profile_dialog.dart';

extension HomeContainerExtension on HomeContainerState {
  check_user_fields() async {
    if (FirebaseAuth.instance.currentUser != null) {
      User auth_user = FirebaseAuth.instance.currentUser!;
      DocumentSnapshot user = await FirebaseFirestore.instance.collection("users").doc(auth_user.uid).get();

      Map<String, dynamic> user_data = user.data() as Map<String, dynamic>;

      XapptorUser xapptor_user = XapptorUser.from_snapshot(auth_user.uid, auth_user.email ?? '', user_data);

      bool firstname_is_empty = xapptor_user.firstname.isEmpty;
      bool lastname_is_empty = xapptor_user.lastname.isEmpty;
      bool country_is_empty = xapptor_user.country.isEmpty;

      if (firstname_is_empty || lastname_is_empty || country_is_empty) {
        show_profile_dialog();
      } else {
        check_user_roles(xapptor_user);
      }
    }
  }

  check_user_roles(XapptorUser user) async {
    if (user.roles.isNotEmpty) {
      //open_screen("home/business_solutions");
    }
  }
}
