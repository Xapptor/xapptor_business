class StripePayment {
  final String price_id;
  final String user_id;
  final String product_id;
  final String customer_email;
  final String success_url;
  final String cancel_url;

  StripePayment({
    required this.price_id,
    required this.user_id,
    required this.product_id,
    required this.customer_email,
    required this.success_url,
    required this.cancel_url,
  });

  Map<String, dynamic> to_json() {
    return {
      'price_id': price_id,
      'user_id': user_id,
      'product_id': product_id,
      'customer_email': customer_email,
      'success_url': success_url,
      'cancel_url': cancel_url,
    };
  }
}
