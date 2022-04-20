import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'get_pie_chart_sections.dart';

Widget payments_pie_chart_by_parameter({
  required List<Map<String, dynamic>> payments,
  required List<Map<String, dynamic>>? filtered_payments_by_vending_machine,
  required String parameter,
  required bool same_background_color,
}) {
  return FutureBuilder<List<PieChartSectionData>>(
    future: get_pie_chart_sections(
      payments: filtered_payments_by_vending_machine != null
          ? filtered_payments_by_vending_machine
          : payments,
      parameter: parameter,
      same_background_color: same_background_color,
    ),
    builder: (BuildContext context,
        AsyncSnapshot<List<PieChartSectionData>> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(
          child: Text('Please wait its loading...'),
        );
      } else {
        if (snapshot.hasError)
          return Center(
            child: Text('Error'),
          );
        else
          return PieChart(
            PieChartData(
              sections: snapshot.data,
              startDegreeOffset: 0,
            ),
          );
      }
    },
  );
}
