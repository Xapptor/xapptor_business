class AnalyticsSegment {
  final List<String> products;
  final String product_value;
  final Function(String new_value) update_product_value;
  final String chart_title;
  final String chart_parameter;
  final String chart_collection;

  const AnalyticsSegment({
    required this.products,
    required this.product_value,
    required this.update_product_value,
    required this.chart_title,
    required this.chart_parameter,
    required this.chart_collection,
  });
}
