// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:xapptor_auth/account_view/account_view.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/wpe_section_form_item/update_item.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/wpe_section_form_item/wpe_section_form_item.dart';

extension StateExtension on WpeSectionFormItemState {
  Future select_condition_date() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: AccountViewState.first_date,
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        selected_date_1 = picked;

        DateFormat date_formatter = DateFormat.yMMMMd('en_US');
        String date_now_formatted = date_formatter.format(selected_date_1!);
        timeframe_text = date_now_formatted;
        update_item();
        setState(() {});
      });
    }
  }
}
