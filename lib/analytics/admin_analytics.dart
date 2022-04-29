import 'package:flutter/material.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:xapptor_business/analytics/analytics_segment.dart';
import 'package:xapptor_business/analytics/main_line_chart.dart';
import 'package:xapptor_business/analytics/payments_pie_chart_by_parameter.dart';
import 'package:xapptor_business/models/payment.dart';
import 'package:xapptor_logic/is_portrait.dart';
import 'package:xapptor_ui/values/ui.dart';
import 'package:xapptor_ui/widgets/timeframe_chart_functions.dart';

class AdminAnalytics extends StatefulWidget {
  const AdminAnalytics({
    required this.screen_title,
    required this.text_color,
    required this.icon_color,
    required this.payments,
    required this.filtered_payments,
    required this.filter_payments,
    required this.sum_of_payments,
    required this.analytics_segments,
    required this.timeframe_values,
    required this.timeframe_value,
    required this.current_timeframe,
    required this.update_timeframe_value,
    required this.download_analytics_callback,
    required this.download_button_tooltip,
  });

  final String screen_title;
  final Color text_color;
  final Color icon_color;
  final List<Payment> payments;
  final List<Payment> filtered_payments;
  final Function filter_payments;
  final List<Map<String, dynamic>> sum_of_payments;
  final List<AnalyticsSegment> analytics_segments;
  final List<String> timeframe_values;
  final String timeframe_value;
  final TimeFrame current_timeframe;
  final Function(String new_value) update_timeframe_value;
  final Function(BuildContext context) download_analytics_callback;
  final String download_button_tooltip;

  @override
  _AdminAnalyticsState createState() => _AdminAnalyticsState();
}

class _AdminAnalyticsState extends State<AdminAnalytics> {
  @override
  Widget build(BuildContext context) {
    double screen_height = MediaQuery.of(context).size.height;
    double screen_width = MediaQuery.of(context).size.width;
    bool portrait = is_portrait(context);

    double title_size = 20;
    double subtitle_size = 16;
    double max_y = 0;

    if (widget.sum_of_payments.isNotEmpty) {
      List filtered_sum_of_payments = widget.sum_of_payments;
      filtered_sum_of_payments
          .sort((a, b) => a["amount"].compareTo(b["amount"]));
      max_y = filtered_sum_of_payments.last["amount"] * 1.35;
    }

    return Container(
      height: screen_height,
      width: screen_width,
      color: Colors.white,
      child: SingleChildScrollView(
        child: FractionallySizedBox(
          widthFactor: portrait ? 0.85 : 0.75,
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
                      widget.screen_title,
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
                      onPressed: () =>
                          widget.download_analytics_callback(context),
                      icon: Icon(
                        Typicons.down_outline,
                        color: widget.icon_color,
                      ),
                      tooltip: widget.download_button_tooltip,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: sized_box_space * 2,
              ),
              Flex(
                direction: portrait ? Axis.vertical : Axis.horizontal,
                crossAxisAlignment: portrait
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.start,
                children: [
                  Container(
                    height: (widget.analytics_segments.length + 1) * 70,
                    width: screen_width * (portrait ? 0.85 : 0.25),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.analytics_segments.length + 1,
                      itemBuilder: (context, index) {
                        return index == 0
                            ? DropdownButton<String>(
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  color: widget.text_color,
                                ),
                                value: widget.timeframe_value,
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
                                onChanged: (new_value) =>
                                    widget.update_timeframe_value(new_value!),
                                items: widget.timeframe_values
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              )
                            : DropdownButton<String>(
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  color: widget.text_color,
                                ),
                                value: widget.analytics_segments[index - 1]
                                    .product_value,
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
                                  widget.analytics_segments[index - 1]
                                      .update_product_value(new_value!);
                                  widget.filter_payments();
                                },
                                items: widget
                                    .analytics_segments[index - 1].products
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              );
                      },
                    ),
                  ),
                  widget.filtered_payments.length > 0
                      ? Container(
                          height: screen_height / 3,
                          width: screen_width * (portrait ? 0.85 : 0.50),
                          child: main_line_chart(
                            current_timeframe: widget.current_timeframe,
                            max_y: max_y,
                            sum_of_payments: widget.sum_of_payments,
                            text_color: widget.text_color,
                            icon_color: widget.icon_color,
                          ),
                        )
                      : Container(),
                ],
              ),
              SizedBox(
                height: sized_box_space * 2,
              ),
              Container(
                height: (widget.analytics_segments.length *
                    (screen_height / 3) *
                    1.5),
                child: ListView.builder(
                  itemCount: widget.analytics_segments.length,
                  itemBuilder: (context, index) {
                    return FractionallySizedBox(
                      widthFactor: 0.75,
                      child: Column(
                        children: [
                          SizedBox(
                            height: sized_box_space * 6,
                          ),
                          Text(
                            widget.analytics_segments[index].pie_chart_title,
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
                              payments:
                                  payment_list_to_json_list(widget.payments),
                              filtered_payments: null,
                              parameter: widget.analytics_segments[index]
                                  .pie_chart_parameter,
                              collection: widget.analytics_segments[index]
                                  .pie_chart_collection,
                              same_background_color: true,
                              seed_colors: [
                                widget.text_color,
                                widget.icon_color,
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
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
