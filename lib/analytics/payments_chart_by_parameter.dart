import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:xapptor_business/analytics/chart_type.dart';
import 'get_chart_sections.dart';

Widget payments_chart_by_parameter({
  required List<Map<String, dynamic>> payments,
  required List<Map<String, dynamic>>? filtered_payments,
  required String parameter,
  required String collection,
  required bool same_background_color,
  required List<Color> seed_colors,
  required ChartType chart_type,
  required double width,
  required bool portrait,
}) {
  return FutureBuilder<List<dynamic>>(
    future: get_chart_sections(
      payments: filtered_payments ?? payments,
      parameter: parameter,
      collection: collection,
      same_background_color: same_background_color,
      seed_colors: seed_colors,
      chart_type: chart_type,
      width: width,
      portrait: portrait,
    ),
    builder: (
      BuildContext context,
      AsyncSnapshot<List<dynamic>> snapshot,
    ) {
      Widget current_widget = const SizedBox();

      Widget waiting_widget = const Center(
        child: CircularProgressIndicator(),
      );

      if (snapshot.connectionState == ConnectionState.waiting) {
        current_widget = waiting_widget;
      } else {
        if (snapshot.hasData) {
          if (chart_type == ChartType.bar) {
            List<Map<String, dynamic>> snap_map = snapshot.data!.cast<Map<String, dynamic>>();

            List<BarChartGroupData> sections = snap_map.map((map) => map["section"]).toList().cast<BarChartGroupData>();

            if (sections.isEmpty) {
              current_widget = waiting_widget;
            } else {
              current_widget = BarChart(
                BarChartData(
                  barGroups: sections,
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: (BarChartGroupData group) => Colors.grey.withValues(alpha: 0.15),
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    topTitles: const AxisTitles(),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              snap_map[value.toInt()]["title"],
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          );
                        },
                        reservedSize: 35,
                      ),
                    ),
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 35,
                        interval: 20,
                      ),
                    ),
                    rightTitles: const AxisTitles(),
                  ),
                ),
              );
            }
          } else if (chart_type == ChartType.pie) {
            current_widget = FractionallySizedBox(
              heightFactor: 0.8,
              widthFactor: 0.8,
              child: PieChart(
                PieChartData(
                  sections: snapshot.data!.cast<PieChartSectionData>(),
                  startDegreeOffset: 0,
                ),
              ),
            );
          }
        } else {
          current_widget = const Center(
            child: Text('Error'),
          );
        }
      }

      return Container(
        child: current_widget,
      );
    },
  );
}
