import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:xapptor_ui/widgets/webview/webview.dart';
import 'package:universal_platform/universal_platform.dart';

class PaymentWebview extends StatefulWidget {
  const PaymentWebview({
    required this.url_base,
  });

  final String url_base;

  @override
  _PaymentWebviewState createState() => _PaymentWebviewState();
}

class _PaymentWebviewState extends State<PaymentWebview> {
  bool fisrt_time_on_host = true;

  // Payment was canceled.

  loaded_callback(String url) async {
    if (!UniversalPlatform.isWeb) {
      if (!url.contains("stripe")) {
        if (fisrt_time_on_host) {
          fisrt_time_on_host = false;
          Navigator.of(context).pop();
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        body: Webview(
          src: widget.url_base,
          id: Uuid().v4(),
          loaded_callback: loaded_callback,
        ),
      ),
    );
  }
}

// StripePayment model.

class Payment {
  final String price_id;
  final String user_id;
  final String product_id;
  final String customer_email;
  final String success_url;
  final String cancel_url;

  Payment({
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
