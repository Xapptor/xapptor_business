import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;
import 'package:universal_platform/universal_platform.dart';
import 'package:xapptor_business/models/payment.dart';
import 'package:xapptor_logic/file_downloader/file_downloader.dart';
import 'package:xapptor_logic/firebase_tasks.dart';

download_cabins_analytics_excel_file({
  required BuildContext context,
  required List<String> titles,
  required List<Payment> filtered_payments,
  required String loading_message,
  required String base_file_name,
}) async {
  SnackBar snackBar = SnackBar(
    content: Text(loading_message),
    duration: const Duration(seconds: 2),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);

  final xlsio.Workbook workbook = xlsio.Workbook();
  final xlsio.Worksheet sheet = workbook.worksheets[0];

  for (var i = 0; i < titles.length; i++) {
    String current_cell_position = "${String.fromCharCode(65 + i)}1";
    sheet.getRangeByName(current_cell_position).setText(titles[i]);
  }

  int current_row_number = 2;

  for (var filtred_payment in filtered_payments) {
    String current_date = DateFormat("dd/MM/yyyy").format(filtred_payment.date);
    String current_date_hour = DateFormat.Hm().format(filtred_payment.date);

    List<String> cell_values = [
      filtred_payment.id,
      filtred_payment.amount.toString(),
      filtred_payment.product_id,
      filtred_payment.user_id,
      current_date,
      current_date_hour
    ];

    for (var i = 0; i < cell_values.length; i++) {
      String current_cell_position =
          '${String.fromCharCode(65 + i)}$current_row_number';
      sheet.getRangeByName(current_cell_position).setText(cell_values[i]);
    }

    current_row_number++;
  }

  for (var i = 0; i < titles.length; i++) {
    sheet.autoFitColumn(i + 1);
  }

  String file_name = "$base_file_name${DateTime.now()}.xlsx";
  file_name = file_name
      .replaceAll(":", "_")
      .replaceAll("-", "_")
      .replaceAll(" ", "_")
      .replaceFirst(".", "_");

  Uint8List bytes = workbook.saveAsStream() as Uint8List;

  String temporary_file_url = "";

  if (UniversalPlatform.isWeb) {
    temporary_file_url = await save_temporary_file(
      bytes: bytes,
      file_name: file_name,
    );
  }
  FileDownloader.save(
    src: UniversalPlatform.isWeb ? temporary_file_url : base64Encode(bytes),
    file_name: file_name,
  ).then((value) {
    workbook.dispose();
  });
}
