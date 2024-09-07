import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:xapptor_ui/widgets/webview/webview.dart';
import 'package:universal_platform/universal_platform.dart';

class PaymentWebview extends StatefulWidget {
  final String url_base;

  const PaymentWebview({
    super.key,
    required this.url_base,
  });

  @override
  State<PaymentWebview> createState() => _PaymentWebviewState();
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
          id: const Uuid().v8(),
          loaded_callback: loaded_callback,
        ),
      ),
    );
  }
}
