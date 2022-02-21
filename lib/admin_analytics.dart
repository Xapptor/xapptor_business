import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;
import 'package:xapptor_logic/file_downloader/file_downloader.dart';
import 'models/payments.dart';
import 'models/product.dart';
import 'models/vending_machine.dart';
import 'package:xapptor_ui/values/ui.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:xapptor_ui/widgets/timeframe_chart_functions.dart';

class AdminAnalytics extends StatefulWidget {
  const AdminAnalytics({
    required this.text_color,
    required this.icon_color,
  });

  final Color text_color;
  final Color icon_color;
  @override
  _AdminAnalyticsState createState() => _AdminAnalyticsState();
}

class _AdminAnalyticsState extends State<AdminAnalytics> {
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

  List<Payment> payments = [];
  List<Payment> filtered_payments = [];
  List<Payment> filtered_payments_by_vending_machine = [];

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
            Payment.from_snapshot(
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
      base64_string: base64Encode(workbook.saveAsStream()),
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

    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: FractionallySizedBox(
          widthFactor: 0.75,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: sized_box_space * 3,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 8,
                    child: Text(
                      'Analíticas de ventas',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: widget.text_color,
                        fontSize: title_size,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Spacer(flex: 2),
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      onPressed: download_excel_file,
                      icon: Icon(
                        Typicons.down_outline,
                        color: widget.icon_color,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: sized_box_space * 2,
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 10,
                        child: DropdownButton<String>(
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: widget.text_color,
                          ),
                          value: timeframe_value,
                          iconSize: 24,
                          elevation: 16,
                          isExpanded: true,
                          style: TextStyle(
                            color: widget.text_color,
                          ),
                          underline: Container(
                            height: 1,
                            color: widget.text_color,
                          ),
                          onChanged: (new_value) {
                            setState(() {
                              timeframe_value = new_value!;
                              switch (
                                  timeframe_values.indexOf(timeframe_value)) {
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
                            });
                          },
                          items: timeframe_values
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                      Spacer(flex: 1),
                      Expanded(
                        flex: 10,
                        child: DropdownButton<String>(
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: widget.text_color,
                          ),
                          value: vending_machine_value,
                          iconSize: 24,
                          elevation: 16,
                          isExpanded: true,
                          style: TextStyle(
                            color: widget.text_color,
                          ),
                          underline: Container(
                            height: 1,
                            color: widget.text_color,
                          ),
                          onChanged: (new_value) {
                            setState(() {
                              vending_machine_value = new_value!;
                              get_filtered_payments();
                            });
                          },
                          items: vending_machine_values
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        flex: 10,
                        child: DropdownButton<String>(
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: widget.text_color,
                          ),
                          value: dispenser_value,
                          iconSize: 24,
                          elevation: 16,
                          isExpanded: true,
                          style: TextStyle(
                            color: widget.text_color,
                          ),
                          underline: Container(
                            height: 1,
                            color: widget.text_color,
                          ),
                          onChanged: (new_value) {
                            setState(() {
                              dispenser_value = new_value!;
                              get_filtered_payments();
                            });
                          },
                          items: dispenser_values
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                      Spacer(flex: 1),
                      Expanded(
                        flex: 10,
                        child: DropdownButton<String>(
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: widget.text_color,
                          ),
                          value: product_value,
                          iconSize: 24,
                          elevation: 16,
                          isExpanded: true,
                          style: TextStyle(
                            color: widget.text_color,
                          ),
                          underline: Container(
                            height: 1,
                            color: widget.text_color,
                          ),
                          onChanged: (new_value) {
                            setState(() {
                              product_value = new_value!;
                              get_filtered_payments();
                            });
                          },
                          items: product_values
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              payments.isNotEmpty
                  ? Column(
                      children: [
                        SizedBox(
                          height: sized_box_space * 2,
                        ),
                        Container(
                          height: screen_height / 3,
                          width: screen_width,
                          child: main_line_chart(
                            current_timeframe: current_timeframe,
                            max_y: max_y,
                            sum_of_payments: sum_of_payments,
                            text_color: widget.text_color,
                            icon_color: widget.icon_color,
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: 0.75,
                          child: Column(
                            children: [
                              SizedBox(
                                height: sized_box_space * 6,
                              ),
                              Text(
                                'Ventas por Máquina',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: widget.text_color,
                                  fontSize: subtitle_size,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: sized_box_space,
                              ),
                              Container(
                                height: screen_height / 3,
                                width: screen_width,
                                child: payments_pie_chart_by_parameter(
                                  payments: payment_list_to_json_list(payments),
                                  filtered_payments_by_vending_machine: null,
                                  parameter: "vending_machine_id",
                                  same_background_color: true,
                                ),
                              ),
                              SizedBox(
                                height: sized_box_space * 4,
                              ),
                              Text(
                                'Ventas por Dispensador',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: widget.text_color,
                                  fontSize: subtitle_size,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: sized_box_space,
                              ),
                              Container(
                                height: screen_height / 3,
                                width: screen_width,
                                child: payments_pie_chart_by_parameter(
                                  payments: payment_list_to_json_list(payments),
                                  filtered_payments_by_vending_machine:
                                      payment_list_to_json_list(
                                          filtered_payments_by_vending_machine),
                                  parameter: "dispenser",
                                  same_background_color: false,
                                ),
                              ),
                              SizedBox(
                                height: sized_box_space * 4,
                              ),
                              Text(
                                'Ventas por Producto',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: widget.text_color,
                                  fontSize: subtitle_size,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: sized_box_space,
                              ),
                              Container(
                                height: screen_height / 3,
                                width: screen_width,
                                child: payments_pie_chart_by_parameter(
                                  payments: payment_list_to_json_list(payments),
                                  filtered_payments_by_vending_machine:
                                      payment_list_to_json_list(
                                          filtered_payments_by_vending_machine),
                                  parameter: "product_id",
                                  same_background_color: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Container(),
              SizedBox(
                height: sized_box_space * 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
        i == original_bottom_labels_length_quarter * 3) {
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
      gridData: FlGridData(
        show: true,
      ),
      titlesData: FlTitlesData(
        topTitles: SideTitles(
          reservedSize: 0,
          showTitles: false,
        ),
        rightTitles: SideTitles(
          reservedSize: 0,
          showTitles: false,
        ),
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 0,
          getTextStyles: (context, value) => TextStyle(
            color: text_color,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          margin: 10,
          getTitles: (value) {
            if (value <= current_bottom_labels.length - 1) {
              return current_bottom_labels[value.toInt()];
            } else {
              return "";
            }
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (context, value) => TextStyle(
            color: icon_color,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
          getTitles: (value) {
            String label = "";

            if (value > 999) {
              label = "\$${(value / 1000).round()}k";
            } else {
              label = "\$${value.toInt()}";
            }

            if (max_y < 201) {
              if (value == 0 ||
                  value == 50 ||
                  value == 100 ||
                  value == 150 ||
                  value == 200) {
                return label;
              } else {
                return "";
              }
            } else if (max_y > 200 && max_y < 1001) {
              if (value == 0 ||
                  value == 200 ||
                  value == 400 ||
                  value == 600 ||
                  value == 800 ||
                  value == 1000) {
                return label;
              } else {
                return "";
              }
            } else if (max_y > 1000 && max_y < 2001) {
              if (value == 0 ||
                  value == 500 ||
                  value == 1000 ||
                  value == 1500 ||
                  value == 2000) {
                return label;
              } else {
                return "";
              }
            } else {
              if (value == 0 ||
                  value == 1000 ||
                  value == 2000 ||
                  value == 3000 ||
                  value == 4000 ||
                  value == 5000 ||
                  value == 6000 ||
                  value == 7000 ||
                  value == 8000 ||
                  value == 9000 ||
                  value == 10000) {
                return label;
              } else {
                return "";
              }
            }
          },
          margin: 10,
          reservedSize: 40,
        ),
      ),
      borderData: FlBorderData(
        show: true,
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
          colors: [
            text_color.withOpacity(0.7),
          ],
          barWidth: 6,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors: [
              icon_color.withOpacity(0.3),
              text_color.withOpacity(0.3),
            ],
            gradientFrom: Offset(0, 0),
            gradientTo: Offset(0, 1),
            gradientColorStops: [
              0.2,
              1.0,
            ],
            spotsLine: BarAreaSpotsLine(
              show: true,
              flLineStyle: FlLine(
                color: text_color.withOpacity(0.3),
                strokeWidth: 4,
              ),
            ),
          ),
        )
      ],
    ),
    swapAnimationDuration: const Duration(milliseconds: 200),
  );
}

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

List<Map<String, dynamic>> get_sum_of_payments_by_parameter({
  required List<Map<String, dynamic>> payments,
  required String parameter,
}) {
  payments.sort((a, b) => a[parameter].compareTo(b[parameter]));

  List<Map<String, dynamic>> sum_of_payments = [];
  for (var payment in payments) {
    if (sum_of_payments.isEmpty) {
      sum_of_payments.add({
        parameter: payment[parameter],
        "amount": payment["amount"],
      });
    } else {
      bool current_parameter_is_same_as_past =
          payment[parameter] == sum_of_payments.last[parameter];

      if (current_parameter_is_same_as_past) {
        sum_of_payments.last["amount"] += payment["amount"];
      } else {
        sum_of_payments.add({
          parameter: payment[parameter],
          "amount": payment["amount"],
        });
      }
    }
  }
  return sum_of_payments;
}
