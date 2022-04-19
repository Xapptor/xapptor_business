import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;
import 'package:xapptor_business/admin_analytics.dart';
import 'package:xapptor_business/models/payment_vending_machine.dart';
import 'package:xapptor_business/models/product.dart';
import 'package:xapptor_business/models/vending_machine.dart';
import 'package:xapptor_logic/file_downloader/file_downloader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:xapptor_ui/widgets/timeframe_chart_functions.dart';

class VendingMachinesAnalytics extends StatefulWidget {
  const VendingMachinesAnalytics({
    required this.text_color,
    required this.icon_color,
  });

  final Color text_color;
  final Color icon_color;
  @override
  _VendingMachinesAnalyticsState createState() =>
      _VendingMachinesAnalyticsState();
}

class _VendingMachinesAnalyticsState extends State<VendingMachinesAnalytics> {
  String user_id = "";

  static List<String> timeframe_values = [
    "Del último día",
    "De la última semana",
    "Del último mes",
    "Del último año",
    "Desde el inicio",
  ];
  String timeframe_value = timeframe_values[3];
  TimeFrame current_timeframe = TimeFrame.year;

  List<VendingMachine> vending_machines = [];
  List<String> vending_machine_values = ["Máquinas"];
  String vending_machine_value = "Máquinas";

  static List<String> dispenser_values = ["Dispensadores"] +
      List<String>.generate(10, (i) => "Dispensador ${(i + 1)}");
  String dispenser_value = dispenser_values.first;

  List<Product> products = [];
  List<String> product_values = ["Productos"];
  String product_value = "Productos";

  List<PaymentVendingMachine> payments = [];
  List<PaymentVendingMachine> filtered_payments = [];
  List<PaymentVendingMachine> filtered_payments_by_vending_machine = [];

  List<Map<String, dynamic>> sum_of_payments = [];

  @override
  void initState() {
    super.initState();
    get_vending_machines();
    // duplicate_document(
    //   document_id: "",
    //   collection_id: "vending_machines",
    //   times: 0,
    // );
  }

  // Retrieving vending machines.

  get_vending_machines() async {
    vending_machines.clear();
    vending_machine_values.clear();

    vending_machine_values.add("Máquinas");

    user_id = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('vending_machines')
        .where(
          'user_id',
          isEqualTo: user_id,
        )
        .get()
        .then((QuerySnapshot query_snapshot) {
      query_snapshot.docs.forEach((DocumentSnapshot doc) {
        vending_machines.add(
          VendingMachine.from_snapshot(
            doc.id,
            doc.data() as Map<String, dynamic>,
          ),
        );
        vending_machine_values.add(vending_machines.last.name);
      });
      vending_machine_value = vending_machine_values.first;
      get_products();
    });
  }

  // Retrieving products.

  get_products() async {
    products.clear();
    product_values.clear();

    product_values.add("Productos");

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
        query_snapshot.docs.forEach((DocumentSnapshot doc) {
          payments.add(
            PaymentVendingMachine.from_snapshot(
              doc.id,
              doc.data() as Map<String, dynamic>,
            ),
          );
        });
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

    filtered_payments_by_vending_machine = payments;

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

      filtered_payments_by_vending_machine = payments
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

    if (dispenser_values.indexOf(dispenser_value) != 0)
      filtered_payments = filtered_payments.where((payment) {
        int dispenser_value_number = dispenser_value.characters.last == "0"
            ? 9
            : (int.parse(dispenser_value.characters.last) - 1);
        return payment.dispenser == dispenser_value_number;
      }).toList();

    if (product_values.indexOf(product_value) != 0)
      filtered_payments = filtered_payments
          .where(
            (payment) =>
                payment.product_id ==
                products
                    .firstWhere((product) => product.name == product_value)
                    .id,
          )
          .toList();

    filtered_payments.sort((a, b) => a.date.compareTo(b.date));
    get_sum_of_payments_by_timeframe();
  }

  get_sum_of_payments_by_timeframe() {
    sum_of_payments.clear();
    for (var filtered_payment in filtered_payments) {
      if (sum_of_payments.isEmpty) {
        sum_of_payments.add({
          "date": filtered_payment.date,
          "amount": filtered_payment.amount,
        });
      } else {
        bool payment_was_made_at_same_timeframe = false;

        bool same_hour =
            filtered_payment.date.hour == sum_of_payments.last["date"].hour;

        bool same_day =
            filtered_payment.date.day == sum_of_payments.last["date"].day;

        bool same_month =
            filtered_payment.date.month == sum_of_payments.last["date"].month;

        bool same_year =
            filtered_payment.date.year == sum_of_payments.last["date"].year;

        switch (current_timeframe) {
          case TimeFrame.day:
            if (same_hour && same_day && same_month && same_year)
              payment_was_made_at_same_timeframe = true;
            break;
          case TimeFrame.week:
            if (same_day && same_month && same_year)
              payment_was_made_at_same_timeframe = true;
            break;
          case TimeFrame.month:
            if (same_day && same_month && same_year)
              payment_was_made_at_same_timeframe = true;
            break;
          case TimeFrame.year:
            if (same_month && same_year)
              payment_was_made_at_same_timeframe = true;
            break;
          case TimeFrame.beginning:
            if (same_year) payment_was_made_at_same_timeframe = true;
            break;
        }

        if (payment_was_made_at_same_timeframe) {
          sum_of_payments.last["amount"] += filtered_payment.amount;
        } else {
          sum_of_payments.add({
            "date": filtered_payment.date,
            "amount": filtered_payment.amount,
          });
        }
      }
    }
    setState(() {});
  }

  // Download excel file.

  download_excel_file() async {
    SnackBar snackBar = SnackBar(
      content: Text("Descargando..."),
      duration: Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    final xlsio.Workbook workbook = new xlsio.Workbook();
    final xlsio.Worksheet sheet = workbook.worksheets[0];

    List<String> titles = [
      "ID DE PAGO",
      "MONTO",
      "NOMBRE DE MÁQUINA",
      "ID DE MÁQUINA",
      "ID DE DISPENSADOR",
      "NOMBRE DE PRODUCTO",
      "ID DE PRODUCTO",
      "ID DE USUARIO",
      "FECHA",
      "HORA",
    ];

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

    String file_name = "pagos_lum_" + DateTime.now().toString() + ".xlsx";
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

  @override
  Widget build(BuildContext context) {
    double screen_height = MediaQuery.of(context).size.height;
    double screen_width = MediaQuery.of(context).size.width;
    double title_size = 20;
    double subtitle_size = 16;

    double max_y = 0;

    if (sum_of_payments.isNotEmpty) {
      List filtered_sum_of_payments = sum_of_payments;
      filtered_sum_of_payments
          .sort((a, b) => a["amount"].compareTo(b["amount"]));
      max_y = filtered_sum_of_payments.last["amount"] * 1.3;
    }

    return AdminAnalytics(
      icon_color: widget.icon_color,
      text_color: widget.text_color,
      products: products,
      product_value: product_value,
      update_product_value: (String new_value) {
        product_value = new_value;
        setState(() {});
      },
      payments: payments,
      filtered_payments: filtered_payments,
      filter_payments: () => get_filtered_payments(),
    );
  }
}
