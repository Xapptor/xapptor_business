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

  int first_year = 1;

  if (sum_of_payments.length > 1) {
    first_year = (DateTime.now().difference((sum_of_payments.first["date"] as DateTime)).inDays / 365).round() + 1;
  }

  double max_x = sum_of_payments.isNotEmpty
      ? get_max_x(
          timeframe: current_timeframe,
          first_year: first_year,
        )
      : 10;

  List<String> original_bottom_labels = get_bottom_labels(
    max_x: current_timeframe != TimeFrame.beginning ? max_x + 1 : max_x,
    timeframe: current_timeframe,
  );

  int labels_length = original_bottom_labels.length;
  int labels_length_quarter = (labels_length / 4).round();

  List<String> current_bottom_labels = [];

  for (var i = 0; i < labels_length; i++) {
    if (i == labels_length_quarter * 0 ||
        i == labels_length_quarter * 1 ||
        i == labels_length_quarter * 2 ||
        i == labels_length_quarter * 3 ||
        i == labels_length_quarter * 4) {
      current_bottom_labels.add(original_bottom_labels[i]);
    } else {
      current_bottom_labels.add("");
    }
  }

  if (current_timeframe == TimeFrame.beginning) {
    current_bottom_labels = original_bottom_labels.toList();
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
        date_difference_result = date_difference.inDays.toDouble() / 31;
        break;

      case TimeFrame.beginning:
        date_difference_result = date_difference.inDays.toDouble() / 365;
        break;
    }

    double result = max_x - date_difference_result - (current_timeframe == TimeFrame.beginning ? 1 : 0);

    if (current_timeframe == TimeFrame.beginning &&
        sum_of_payments.indexOf(sum_of_payment) == sum_of_payments.length - 1) {
      result = max_x - 1;
    }

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

  List<String> bottom_labels_used = [];

  return LineChart(
    LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (LineBarSpot spot) => icon_color.withOpacity(0.5),
        ),
        touchCallback: (touch_event, touch_response) {},
        handleBuiltInTouches: true,
      ),
      gridData: const FlGridData(),
      titlesData: FlTitlesData(
        topTitles: const AxisTitles(),
        rightTitles: const AxisTitles(),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 50,
            getTitlesWidget: (value, title_meta) {
              String label = "";

              if (number_list.contains(value)) {
                if (value > 999) {
                  label = "\$${(value / 1000)}k";
                } else {
                  label = "\$$value";
                }
              }

              String divider_string = "1";
              for (var i = 0; i < (max_y.toString().length - 1); i++) {
                divider_string += "0";
              }
              int divider = int.parse(divider_string);

              Color current_color = Color.lerp(
                icon_color,
                text_color,
                ((max_y - value) / divider) - 0.2,
              )!;

              return Text(
                label,
                style: TextStyle(
                  color: current_color,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                textAlign: TextAlign.left,
              );
            },
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 50,
            getTitlesWidget: (value, title_meta) {
              String title = "";

              if (value <= current_bottom_labels.length - 1) {
                if (current_timeframe == TimeFrame.beginning) {
                  double current_difference = (value - value.round()).abs();

                  if (current_difference <= 0.1) {
                    String new_title = current_bottom_labels[value.round()];

                    if (bottom_labels_used.length == current_bottom_labels.length &&
                        current_bottom_labels.indexOf(new_title) == 0) {
                      bottom_labels_used.clear();
                    }

                    if (!bottom_labels_used.contains(new_title)) {
                      bottom_labels_used.add(new_title);
                      title = new_title;
                    }
                  }
                } else {
                  if (value.isInt) {
                    String new_title = current_bottom_labels[value.toInt()];
                    title = new_title;
                  }
                }
              }

              return Padding(
                padding: const EdgeInsets.only(top: 10),
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
      ),
      borderData: FlBorderData(
        border: Border(
          bottom: BorderSide(
            color: text_color,
            width: 3,
          ),
          left: BorderSide(
            color: text_color.withOpacity(0.2),
            width: 3,
          ),
          right: BorderSide(
            color: text_color.withOpacity(0.2),
            width: 3,
          ),
          top: BorderSide(
            color: text_color.withOpacity(0.2),
            width: 3,
          ),
        ),
      ),
      minX: 0,
      maxX: current_timeframe == TimeFrame.beginning ? max_x - 1 : max_x,
      minY: 0,
      maxY: max_y,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          curveSmoothness: 0.1,
          gradient: LinearGradient(
            colors: [
              text_color.withOpacity(0.7),
              icon_color.withOpacity(0.7),
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
          barWidth: 6,
          isStrokeCapRound: true,
          dotData: const FlDotData(),
          belowBarData: BarAreaData(
            gradient: LinearGradient(
              colors: [
                icon_color.withOpacity(0.3),
                text_color.withOpacity(0.3),
              ],
              stops: const [
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
    duration: const Duration(milliseconds: 500),
    curve: Curves.easeInOutCubicEmphasized,
  );
}
