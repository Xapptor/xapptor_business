// ignore_for_file: invalid_use_of_protected_member

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:xapptor_business/workplace_exam/models/wpe.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/load_wpe.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/wpe_editor.dart';
import 'package:xapptor_logic/check_browser_type.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/crud/read/get_wpes.dart';

extension StateExtension on ResumeEditorState {
  update_language_callback_and_load({
    required Resume? last_resume,
    required String past_language_code,
    required String new_language_code,
  }) async {
    BrowserType browser_type = await check_browser_type();
    int timer_duration = browser_type == BrowserType.mobile ? 3000 : 1200;

    Timer(Duration(milliseconds: timer_duration), () async {
      current_user = FirebaseAuth.instance.currentUser!;

      resumes = await get_resumes(
        user_id: current_user!.uid,
      );

      bool resumes_contains_any_with_new_language_code = resumes.any(
        (element) => element.id.contains('_${new_language_code}_'),
      );

      if (!resumes_contains_any_with_new_language_code) {
        if (last_resume != null) {
          last_resume.id = last_resume.id
              .replaceAll('_$past_language_code', '_$new_language_code');

          resumes.add(last_resume);
        } else {
          Resume new_resume = resumes.firstWhere(
            (element) => !element.id.contains('_bu'),
          );

          new_resume.id =
              '${new_resume.id.split('_').first}_$new_language_code';
          resumes.add(new_resume);
        }
        load_resume(new_slot_index: 0);
      } else {
        load_resume(new_slot_index: 0);
      }
    });
  }
}
