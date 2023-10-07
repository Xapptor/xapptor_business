import 'package:flutter/material.dart';
import 'package:xapptor_auth/account_view/account_view.dart';
import 'package:xapptor_auth/auth_form_type.dart';
import 'package:xapptor_auth/translation_text_values.dart';
import 'package:xapptor_business/home_container/home_container.dart';
import 'package:xapptor_router/app_screen.dart';
import 'package:xapptor_router/app_screens.dart';
import 'package:xapptor_ui/screens/privacy_policy/privacy_policy.dart';

extension HomeContainerExtension on HomeContainerState {
  add_screens() {
    add_new_app_screen(
      AppScreen(
        name: "home/account",
        child: AccountView(
          text_list: account_values,
          tc_and_pp_text: RichText(text: const TextSpan()),
          gender_values: gender_values,
          country_values: const [
            'United States',
            'Mexico',
            'Canada',
            'Brazil',
          ],
          text_color: widget.topbar_color,
          first_button_color: widget.main_button_color,
          second_button_color: widget.topbar_color,
          logo_path: widget.logo_path,
          has_language_picker: widget.has_language_picker,
          topbar_color: widget.topbar_color,
          custom_background: null,
          auth_form_type: AuthFormType.edit_account,
          outline_border: true,
          first_button_action: null,
          second_button_action: null,
          has_back_button: true,
          text_field_background_color: null,
        ),
      ),
    );

    if (widget.privacy_policy_model != null) {
      add_new_app_screen(
        AppScreen(
          name: "home/privacy_policy",
          child: PrivacyPolicy(
            privacy_policy_model: widget.privacy_policy_model!,
            use_topbar: true,
            topbar_color: widget.topbar_color,
            logo_path: widget.logo_path_white ?? widget.logo_path,
          ),
        ),
      );
    }
  }
}
