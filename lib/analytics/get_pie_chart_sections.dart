import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'get_sum_of_payments_by_parameter.dart';

Future<List<PieChartSectionData>> get_pie_chart_sections({
  required List<Map<String, dynamic>> payments,
  required String parameter,
  required bool same_background_color,
}) async {
  List<Map<String, dynamic>> sum_of_payments_by_parameter =
      get_sum_of_payments_by_parameter(
    payments: payments,
    parameter: parameter,
  );

  List<PieChartSectionData> pie_chart_sections = [];

  int total_amount_in_sales = 0;

  for (var payments_by_parameter in sum_of_payments_by_parameter) {
    total_amount_in_sales += payments_by_parameter["amount"] as int;
  }

  for (var payments_by_parameter in sum_of_payments_by_parameter) {
    Color random_color =
        Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);

    double payments_by_parameter_percentage =
        ((payments_by_parameter["amount"] as int) * 100) /
            total_amount_in_sales;

    String title = "";
    if (parameter == "dispenser") {
      title = (payments_by_parameter[parameter] + 1).toString();
    } else {
      String id = payments_by_parameter[parameter];

      String collection_name =
          parameter.substring(0, parameter.indexOf("_id")) + "s";

      await FirebaseFirestore.instance
          .collection(collection_name)
          .doc(id)
          .get()
          .then((DocumentSnapshot snapshot) {
        Map<String, dynamic> snapshot_data =
            snapshot.data() as Map<String, dynamic>;
        title = snapshot_data["name"];
      });
    }

    pie_chart_sections.add(
      PieChartSectionData(
        color: random_color,
        value: payments_by_parameter_percentage,
        title: title,
        titleStyle: TextStyle(
          color: Colors.white,
          backgroundColor:
              same_background_color ? random_color : Colors.transparent,
        ),
      ),
    );
  }
  return pie_chart_sections;
}
