import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:xapptor_business/analytics/admin_analytics.dart';
import 'package:xapptor_business/analytics/analytics_segment.dart';
import 'package:xapptor_business/analytics/chart_type.dart';
import 'package:xapptor_business/analytics/get_sum_of_payments_by_timeframe.dart';
import 'package:xapptor_business/models/payment_vending_machine.dart';
import 'package:xapptor_business/models/product.dart';
import 'package:xapptor_business/models/vending_machine.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:xapptor_business/vending_machine/download_vending_machines_analytics_excel_file.dart';
import 'package:xapptor_business/analytics/timeframe_chart_functions.dart';

class VendingMachinesAnalytics extends StatefulWidget {
  const VendingMachinesAnalytics({super.key, 
    required this.screen_title,
    required this.text_color,
    required this.icon_color,
    required this.chart_titles,
    required this.download_analytics_titles,
    required this.timeframe_values,
    required this.vending_machine_value,
    required this.dispenser_values,
    required this.product_value,
    required this.loading_message,
    required this.base_file_name,
    required this.download_button_tooltip,
    required this.chart_type,
  });

  final String screen_title;
  final Color text_color;
  final Color icon_color;
  final List<String> chart_titles;
  final List<String> download_analytics_titles;
  final List<String> timeframe_values;
  final String vending_machine_value;
  final List<String> dispenser_values;
  final String product_value;
  final String loading_message;
  final String base_file_name;
  final String download_button_tooltip;
  final ChartType chart_type;

  @override
  _VendingMachinesAnalyticsState createState() =>
      _VendingMachinesAnalyticsState();
}

class _VendingMachinesAnalyticsState extends State<VendingMachinesAnalytics> {
  String user_id = "";

  String timeframe_value = "";
  TimeFrame current_timeframe = TimeFrame.year;

  List<VendingMachine> vending_machines = [];
  List<String> vending_machine_values = [];
  String vending_machine_value = "";

  String dispenser_value = "";

  List<Product> products = [];
  List<String> product_values = [];
  String product_value = "";

  List<PaymentVendingMachine> payments = [];
  List<PaymentVendingMachine> filtered_payments = [];

  List<Map<String, dynamic>> sum_of_payments = [];

  @override
  void initState() {
    timeframe_value = widget.timeframe_values[3];

    vending_machine_values = [widget.vending_machine_value];
    vending_machine_value = widget.vending_machine_value;

    dispenser_value = widget.dispenser_values.first;

    product_values = [widget.product_value];
    product_value = widget.product_value;

    super.initState();
    get_vending_machines();
  }

  get_vending_machines() async {
    vending_machines.clear();
    vending_machine_values.clear();

    vending_machine_values.add(widget.vending_machine_value);

    user_id = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('vending_machines')
        .where(
          'user_id',
          isEqualTo: user_id,
        )
        .get()
        .then((QuerySnapshot query_snapshot) {
      for (var doc in query_snapshot.docs) {
        vending_machines.add(
          VendingMachine.from_snapshot(
            doc.id,
            doc.data() as Map<String, dynamic>,
          ),
        );
        vending_machine_values.add(vending_machines.last.name);
      }
      vending_machine_value = vending_machine_values.first;
      get_products();
    });
  }

  // Retrieving products.

  get_products() async {
    products.clear();
    product_values.clear();

    product_values.add(widget.product_value);

    await FirebaseFirestore.instance
        .collection("products")
        .get()
        .then((snapshot_products) {
      for (var snapshot_product in snapshot_products.docs) {
        products.add(
          Product.from_snapshot(
            snapshot_product.id,
            snapshot_product.data(),
          ),
        );
        product_values.add(products.last.name);
      }
      product_value = product_values.first;
      get_payments();
    });
  }

  // Retrieving payments.

  get_payments() async {
    for (var vending_machine in vending_machines) {
      await FirebaseFirestore.instance
          .collection('payments')
          .where(
            'vending_machine_id',
            isEqualTo: vending_machine.id,
          )
          .get()
          .then((QuerySnapshot query_snapshot) {
        for (var doc in query_snapshot.docs) {
          payments.add(
            PaymentVendingMachine.from_snapshot(
              doc.id,
              doc.data() as Map<String, dynamic>,
            ),
          );
        }
        if (vending_machine == vending_machines.last) {
          get_filtered_payments();
        }
      });
    }
  }

  // Filtering payments.

  get_filtered_payments() {
    filtered_payments.clear();
    payments.sort((a, b) => a.date.compareTo(b.date));

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

    if (vending_machine_values.indexOf(vending_machine_value) != 0) {
      filtered_payments = filtered_payments
          .where(
            (payment) =>
                payment.vending_machine_id ==
                vending_machines
                    .firstWhere((vending_machine) =>
                        vending_machine.name == vending_machine_value)
                    .id,
          )
          .toList();
    }

    if (widget.dispenser_values.indexOf(dispenser_value) != 0) {
      filtered_payments = filtered_payments.where((payment) {
        int dispenser_value_number = dispenser_value.characters.last == "0"
            ? 9
            : (int.parse(dispenser_value.characters.last) - 1);
        return payment.dispenser == dispenser_value_number;
      }).toList();
    }

    if (product_values.indexOf(product_value) != 0) {
      filtered_payments = filtered_payments
          .where(
            (payment) =>
                payment.product_id ==
                products
                    .firstWhere((product) => product.name == product_value)
                    .id,
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
          products: vending_machine_values,
          product_value: vending_machine_value,
          update_product_value: (String new_value) {
            vending_machine_value = new_value;
            setState(() {});
          },
          chart_title: widget.chart_titles[0],
          chart_parameter: "vending_machine_id",
          chart_collection: "vending_machines",
        ),
        AnalyticsSegment(
          products: widget.dispenser_values,
          product_value: dispenser_value,
          update_product_value: (String new_value) {
            dispenser_value = new_value;
            setState(() {});
          },
          chart_title: widget.chart_titles[1],
          chart_parameter: "dispenser",
          chart_collection: "dispensers",
        ),
        AnalyticsSegment(
          products: product_values,
          product_value: product_value,
          update_product_value: (String new_value) {
            product_value = new_value;
            setState(() {});
          },
          chart_title: widget.chart_titles[2],
          chart_parameter: "product_id",
          chart_collection: "products",
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
        setState(() {});
      },
      download_analytics_callback: (BuildContext context) =>
          download_vending_machines_analytics_excel_file(
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
