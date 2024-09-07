import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xapptor_business/analytics/chart_type.dart';
import 'package:flutter/material.dart';
import 'package:xapptor_business/analytics/admin_analytics.dart';
import 'package:xapptor_business/analytics/analytics_segment.dart';
import 'package:xapptor_business/analytics/get_sum_of_payments_by_timeframe.dart';
import 'package:xapptor_business/cabin/analytics/download_cabins_analytics_excel_file.dart';
import 'package:xapptor_business/models/cabin.dart';
import 'package:xapptor_business/models/payment.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:xapptor_business/analytics/timeframe_chart_functions.dart';
import 'package:xapptor_db/xapptor_db.dart';

class CabinsAnalytics extends StatefulWidget {
  final String screen_title;
  final Color text_color;
  final Color icon_color;
  final List<String> chart_titles;
  final List<String> download_analytics_titles;
  final List<String> timeframe_values;
  final String cabin_value;
  final String loading_message;
  final String base_file_name;
  final String download_button_tooltip;
  final ChartType chart_type;

  const CabinsAnalytics({
    super.key,
    required this.screen_title,
    required this.text_color,
    required this.icon_color,
    required this.chart_titles,
    required this.download_analytics_titles,
    required this.timeframe_values,
    required this.cabin_value,
    required this.loading_message,
    required this.base_file_name,
    required this.download_button_tooltip,
    required this.chart_type,
  });

  @override
  State<CabinsAnalytics> createState() => _CabinsAnalyticsState();
}

class _CabinsAnalyticsState extends State<CabinsAnalytics> {
  String user_id = "";

  String timeframe_value = "";
  TimeFrame current_timeframe = TimeFrame.year;

  List<Cabin> cabins = [];
  List<String> cabin_values = [];
  String cabin_value = "";

  List<Payment> payments = [];
  List<Payment> filtered_payments = [];

  List<Map<String, dynamic>> sum_of_payments = [];

  @override
  void initState() {
    timeframe_value = widget.timeframe_values[3];

    cabin_values = [widget.cabin_value];
    cabin_value = widget.cabin_value;

    super.initState();
    get_cabins();
  }

  get_cabins() async {
    cabins.clear();
    cabin_values.clear();

    cabin_values.add(widget.cabin_value);

    user_id = FirebaseAuth.instance.currentUser!.uid;

    await XapptorDB.instance.collection('cabins').get().then((QuerySnapshot query_snapshot) {
      for (var doc in query_snapshot.docs) {
        cabins.add(
          Cabin.from_snapshot(
            doc.id,
            doc.data() as Map<String, dynamic>,
          ),
        );
      }

      cabins.sort((cabin_a, cabin_b) => int.parse(cabin_a.id).compareTo(int.parse(cabin_b.id)));

      cabin_values = [widget.cabin_value] + cabins.map((cabin) => cabin.id).toList();

      cabin_value = cabin_values.first;
      get_payments();
    });
  }

  // Retrieving payments.

  get_payments() async {
    for (var cabin in cabins) {
      await XapptorDB.instance
          .collection('payments')
          .where(
            'product_id',
            isEqualTo: cabin.id,
          )
          .get()
          .then((QuerySnapshot query_snapshot) {
        for (var doc in query_snapshot.docs) {
          payments.add(
            Payment.from_snapshot(
              doc.id,
              doc.data() as Map<String, dynamic>,
            ),
          );
        }
        if (cabin == cabins.last) {
          get_filtered_payments();
        }
      });
    }
  }

  // Filtering payments.

  get_filtered_payments() {
    filtered_payments.clear();
    payments.sort((a, b) => a.date.compareTo(b.date));

    if (current_timeframe == TimeFrame.beginning) {
      filtered_payments = payments.toList();
    } else {
      filtered_payments = payments
          .where(
            (payment) => payment.date.isAfter(
              get_timeframe_date(
                timeframe: current_timeframe,
                first_year: payments.first.date.year,
              ),
            ),
          )
          .toList();
    }

    if (cabin_values.indexOf(cabin_value) != 0) {
      filtered_payments = filtered_payments
          .where(
            (payment) => payment.product_id == cabins.firstWhere((cabin) => cabin.id == cabin_value).id,
          )
          .toList();
    }

    filtered_payments.sort((a, b) => a.date.compareTo(b.date));

    sum_of_payments = get_sum_of_payments_by_timeframe(
      filtered_payments: filtered_payments,
      current_timeframe: current_timeframe,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AdminAnalytics(
      screen_title: widget.screen_title,
      icon_color: widget.icon_color,
      text_color: widget.text_color,
      payments: payments,
      filtered_payments: filtered_payments,
      filter_payments: () => get_filtered_payments(),
      sum_of_payments: sum_of_payments,
      analytics_segments: [
        AnalyticsSegment(
          products: cabin_values,
          product_value: cabin_value,
          update_product_value: (String new_value) {
            cabin_value = new_value;
            setState(() {});
          },
          chart_title: widget.chart_titles[0],
          chart_parameter: "product_id",
          chart_collection: "cabins",
        ),
      ],
      timeframe_values: widget.timeframe_values,
      timeframe_value: timeframe_value,
      current_timeframe: current_timeframe,
      update_timeframe_value: (new_value) {
        timeframe_value = new_value;
        switch (widget.timeframe_values.indexOf(timeframe_value)) {
          case 0:
            current_timeframe = TimeFrame.day;
            break;
          case 1:
            current_timeframe = TimeFrame.week;
            break;
          case 2:
            current_timeframe = TimeFrame.month;
            break;
          case 3:
            current_timeframe = TimeFrame.year;
            break;
          case 4:
            current_timeframe = TimeFrame.beginning;
            break;
        }
        get_filtered_payments();
      },
      download_analytics_callback: (BuildContext context) => download_cabins_analytics_excel_file(
        context: context,
        titles: widget.download_analytics_titles,
        filtered_payments: filtered_payments,
        loading_message: widget.loading_message,
        base_file_name: widget.base_file_name,
      ),
      download_button_tooltip: widget.download_button_tooltip,
      chart_type: widget.chart_type,
    );
  }
}
