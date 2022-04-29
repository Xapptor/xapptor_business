import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:xapptor_business/analytics/timeframe_chart_functions.dart';
import 'package:xapptor_logic/is_int.dart';

List<double> generate_numbers() {
  List<double> current_number_list = [];
  for (var i = 0; i <= 10; i++) {
    for (var j = 0; j <= 10; j++) {
      current_number_list.add((i * (pow(10, j))).toDouble());
    }
  }
  current_number_list = current_number_list.toSet().toList();
  current_number_list.sort();
  return current_number_list;
}

List<double> number_list = generate_numbers();

LineChart main_line_chart({
  required TimeFrame current_timeframe,
  required double max_y,
  required List<Map<String, dynamic>> sum_of_payments,
  required Color text_color,
  required Color icon_color,
}) {
  sum_of_payments.sort((a, b) => a["date"].compareTo(b["date"]));

  double max_x = sum_of_payments.length > 0
      ? get_max_x(
          timeframe: current_timeframe,
          first_year: (sum_of_payments.first["date"] as DateTime).year,
        )
      : 0;

  List<String> original_bottom_labels = get_bottom_labels(
    max_x: current_timeframe != TimeFrame.beginning ? max_x + 1 : max_x,
    timeframe: current_timeframe,
  );

  int original_bottom_labels_length = original_bottom_labels.length;
  int original_bottom_labels_length_quarter =
      (original_bottom_labels_length / 4).round();

  List<String> current_bottom_labels = [];

  for (var i = 0; i < original_bottom_labels_length; i++) {
    if (i == original_bottom_labels_length_quarter * 0 ||
        i == original_bottom_labels_length_quarter * 1 ||
        i == original_bottom_labels_length_quarter * 2 ||
        i == original_bottom_labels_length_quarter * 3 ||
        i == original_bottom_labels_length_quarter * 4) {
      current_bottom_labels.add(original_bottom_labels[i]);
    } else {
      current_bottom_labels.add("");
    }
  }

  List<FlSpot> spots = [];

  for (var sum_of_payment in sum_of_payments) {
    DateTime current_date = sum_of_payment["date"] as DateTime;

    Duration date_difference = DateTime.now().difference(current_date);

    double date_difference_result = 0;
    switch (current_timeframe) {
      case TimeFrame.day:
        date_difference_result = date_difference.inHours.toDouble();
        break;

      case TimeFrame.week:
        date_difference_result = date_difference.inDays.toDouble();
        break;

      case TimeFrame.month:
        date_difference_result = date_difference.inDays.toDouble();
        break;

      case TimeFrame.year:
        date_difference_result = date_difference.inDays.toDouble() / 30;
        break;

      case TimeFrame.beginning:
        date_difference_result = date_difference.inDays.toDouble() / 365;
        break;
    }

    double result = max_x - date_difference_result;

    spots.add(
      FlSpot(
        result,
        sum_of_payment["amount"].toDouble(),
      ),
    );
  }

  if (spots.length == 1) {
    spots.add(
      FlSpot(
        spots.last.x,
        spots.last.y + 0.5,
      ),
    );
  } else if (spots.isEmpty) {
    max_y = 50;
    spots.add(
      FlSpot(
        max_x,
        0,
      ),
    );
  }

  for (var i = 0; i < spots.length; i++) {
    if (spots[i].x < 0) {
      spots[i] = FlSpot(
        0,
        spots[i].y,
      );
    }
  }

  return LineChart(
    LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: icon_color.withOpacity(0.5),
        ),
        touchCallback: (touch_event, touch_response) {},
        handleBuiltInTouches: true,
      ),
      gridData: FlGridData(),
      titlesData: FlTitlesData(
        topTitles: AxisTitles(),
        rightTitles: AxisTitles(),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 50,
            getTitlesWidget: (value, titleMeta) {
              String title = "";
              if (value <= current_bottom_labels.length - 1 && value.isInt) {
                title = current_bottom_labels[value.toInt()];
              }

              return Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  title,
                  style: TextStyle(
                    color: text_color,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                ),
              );
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 70,
            getTitlesWidget: (value, title_meta) {
              String label = "";

              if (number_list.contains(value)) {
                if (value > 999) {
                  label = "\$${(value / 1000)}k";
                } else {
                  label = "\$$value";
                }
              }

              return Text(
                label,
                style: TextStyle(
                  color: icon_color,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
              );
            },
          ),
        ),
      ),
      borderData: FlBorderData(
        border: Border(
          bottom: BorderSide(
            color: text_color,
            width: 4,
          ),
          left: BorderSide(
            color: Colors.transparent,
          ),
          right: BorderSide(
            color: Colors.transparent,
          ),
          top: BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
      minX: 0,
      maxX: max_x,
      minY: 0,
      maxY: max_y,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          curveSmoothness: 0.15,
          color: text_color.withOpacity(0.7),
          barWidth: 6,
          isStrokeCapRound: true,
          dotData: FlDotData(),
          belowBarData: BarAreaData(
            gradient: LinearGradient(
              colors: [
                icon_color.withOpacity(0.3),
                text_color.withOpacity(0.3),
              ],
              stops: [
                0.2,
                1.0,
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
            spotsLine: BarAreaSpotsLine(
              flLineStyle: FlLine(
                color: text_color.withOpacity(0.3),
                strokeWidth: 4,
              ),
            ),
          ),
        )
      ],
    ),
    swapAnimationDuration: const Duration(milliseconds: 600),
    swapAnimationCurve: Curves.easeInOutCubicEmphasized,
  );
}
