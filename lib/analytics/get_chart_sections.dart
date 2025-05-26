import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:xapptor_business/analytics/chart_type.dart';
import 'get_sum_of_payments_by_parameter.dart';
import 'package:xapptor_logic/color/get_random_color.dart';
import 'package:xapptor_db/xapptor_db.dart';

Future<List> get_chart_sections({
  required List<Map<String, dynamic>> payments,
  required String parameter,
  required String collection,
  required bool same_background_color,
  required List<Color> seed_colors,
  required ChartType chart_type,
  required double width,
  required bool portrait,
}) async {
  List<Map<String, dynamic>> sum_of_payments_by_parameter = get_sum_of_payments_by_parameter(
    payments: payments,
    parameter: parameter,
  );

  List chart_sections = [];

  int total_amount_in_sales = 0;

  for (var payments_by_parameter in sum_of_payments_by_parameter) {
    total_amount_in_sales += payments_by_parameter["amount"] as int;
  }

  for (var payments_by_parameter in sum_of_payments_by_parameter) {
    double payments_by_parameter_percentage = ((payments_by_parameter["amount"] as int) * 100) / total_amount_in_sales;

    String title = "";
    if (parameter == "dispenser") {
      title = (payments_by_parameter[parameter] + 1).toString();
    } else {
      String id = payments_by_parameter[parameter];

      await XapptorDB.instance.collection(collection).doc(id).get().then((DocumentSnapshot snapshot) {
        Map<String, dynamic> snapshot_data = snapshot.data() as Map<String, dynamic>;
        title = snapshot_data["name"] ?? snapshot.id;
      });
    }

    Color random_color = get_random_color(
      seed_color: seed_colors[sum_of_payments_by_parameter.indexOf(payments_by_parameter).isEven ? 1 : 0],
    );

    if (chart_type == ChartType.bar) {
      chart_sections.add({
        "section": BarChartGroupData(
          x: sum_of_payments_by_parameter.indexOf(payments_by_parameter),
          barRods: [
            BarChartRodData(
              toY: payments_by_parameter_percentage.roundToDouble(),
              gradient: LinearGradient(
                colors: [
                  random_color,
                  random_color.withValues(alpha: 0.1),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              width: (width / sum_of_payments_by_parameter.length) * (portrait ? 0.2 : 0.1),
              backDrawRodData: BackgroundBarChartRodData(
                show: true,
                toY: 100,
                color: Colors.transparent,
              ),
            ),
          ],
        ),
        "title": title,
      });
    } else if (chart_type == ChartType.pie) {
      chart_sections.add(
        PieChartSectionData(
          color: random_color,
          value: payments_by_parameter_percentage,
          title: title,
          titleStyle: TextStyle(
            color: Colors.white,
            backgroundColor: same_background_color ? random_color : Colors.transparent,
          ),
        ),
      );
    }
  }
  return chart_sections;
}
