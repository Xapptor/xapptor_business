class AnalyticsSegment {
  const AnalyticsSegment({
    required this.products,
    required this.product_value,
    required this.update_product_value,
    required this.pie_chart_title,
    required this.pie_chart_parameter,
  });

  final List<String> products;
  final String product_value;
  final Function(String new_value) update_product_value;
  final String pie_chart_title;
  final String pie_chart_parameter;
}
