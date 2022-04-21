import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'get_pie_chart_sections.dart';

Widget payments_pie_chart_by_parameter({
  required List<Map<String, dynamic>> payments,
  required List<Map<String, dynamic>>? filtered_payments,
  required String parameter,
  required String collection,
  required bool same_background_color,
}) {
  return FutureBuilder<List<PieChartSectionData>>(
    future: get_pie_chart_sections(
      payments: filtered_payments != null ? filtered_payments : payments,
      parameter: parameter,
      collection: collection,
      same_background_color: same_background_color,
    ),
    builder: (
      BuildContext context,
      AsyncSnapshot<List<PieChartSectionData>> snapshot,
    ) {
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
