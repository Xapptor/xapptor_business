// ignore_for_file: invalid_use_of_protected_member

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:xapptor_business/models/wpe.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/load_wpe.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/wpe_editor.dart';
import 'package:xapptor_logic/check_browser_type.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/crud/read/get_wpes.dart';

extension StateExtension on WpeEditorState {
  update_language_callback_and_load({
    required Wpe? last_wpe,
    required String past_language_code,
    required String new_language_code,
  }) async {
    BrowserType browser_type = await check_browser_type();
    int timer_duration = browser_type == BrowserType.mobile ? 3000 : 1200;

    Timer(Duration(milliseconds: timer_duration), () async {
      current_user = FirebaseAuth.instance.currentUser!;

      wpes = await get_wpes(
        user_id: current_user!.uid,
      );

      bool wpes_contains_any_with_new_language_code = wpes.any(
        (element) => element.id.contains('_${new_language_code}_'),
      );

      if (!wpes_contains_any_with_new_language_code) {
        if (last_wpe != null) {
          last_wpe.id = last_wpe.id
              .replaceAll('_$past_language_code', '_$new_language_code');

          wpes.add(last_wpe);
        } else {
          Wpe new_wpe = wpes.firstWhere(
            (element) => !element.id.contains('_bu'),
          );

          new_wpe.id = '${new_wpe.id.split('_').first}_$new_language_code';
          wpes.add(new_wpe);
        }
        load_wpe(new_slot_index: 0);
      } else {
        load_wpe(new_slot_index: 0);
      }
    });
  }
}
