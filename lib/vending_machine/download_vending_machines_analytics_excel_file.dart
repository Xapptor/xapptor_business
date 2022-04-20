import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;
import 'package:xapptor_business/models/payment_vending_machine.dart';
import 'package:xapptor_business/models/product.dart';
import 'package:xapptor_business/models/vending_machine.dart';
import 'package:xapptor_logic/file_downloader/file_downloader.dart';
import 'dart:convert';

download_vending_machines_analytics_excel_file({
  required BuildContext context,
  required List<String> titles,
  required List<PaymentVendingMachine> filtered_payments,
  required String loading_message,
  required String base_file_name,
}) async {
  SnackBar snackBar = SnackBar(
    content: Text(loading_message),
    duration: Duration(seconds: 2),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);

  final xlsio.Workbook workbook = new xlsio.Workbook();
  final xlsio.Worksheet sheet = workbook.worksheets[0];

  for (var i = 0; i < titles.length; i++) {
    String current_cell_position = "${String.fromCharCode(65 + i)}1";
    sheet.getRangeByName(current_cell_position).setText(titles[i]);
  }

  int current_row_number = 2;

  for (var filtred_payment in filtered_payments) {
    await FirebaseFirestore.instance
        .collection('vending_machines')
        .doc(filtred_payment.vending_machine_id)
        .get()
        .then((DocumentSnapshot vending_machine_snapshot) async {
      VendingMachine vending_machine = VendingMachine.from_snapshot(
        vending_machine_snapshot.id,
        vending_machine_snapshot.data() as Map<String, dynamic>,
      );

      String current_date =
          DateFormat("dd/MM/yyyy").format(filtred_payment.date);
      String current_date_hour = DateFormat.Hm().format(filtred_payment.date);

      await FirebaseFirestore.instance
          .collection('products')
          .doc(filtred_payment.product_id)
          .get()
          .then((DocumentSnapshot product_snapshot) {
        Product product = Product.from_snapshot(
          product_snapshot.id,
          product_snapshot.data() as Map<String, dynamic>,
        );

        List<String> cell_values = [
          filtred_payment.id,
          filtred_payment.amount.toString(),
          vending_machine.name,
          filtred_payment.vending_machine_id,
          filtred_payment.dispenser.toString(),
          product.name,
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
      });
    });
  }

  for (var i = 0; i < titles.length; i++) {
    sheet.autoFitColumn(i + 1);
  }

  String file_name = base_file_name + DateTime.now().toString() + ".xlsx";
  file_name = file_name
      .replaceAll(":", "_")
      .replaceAll("-", "_")
      .replaceAll(" ", "_")
      .replaceFirst(".", "_");

  FileDownloader.save(
    src: base64Encode(workbook.saveAsStream()),
    file_name: file_name,
  );

  workbook.dispose();
}
