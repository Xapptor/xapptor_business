import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:xapptor_ui/widgets/webview/webview.dart';

class RTSPView extends StatefulWidget {
  const RTSPView({
    super.key,
    required this.url,
  });

  final String url;

  @override
  State<RTSPView> createState() => _RTSPViewState();
}

class _RTSPViewState extends State<RTSPView> {
  String rtsp_html = "";

  read_rtsp_html() async {
    rtsp_html = await rootBundle.loadString('packages/xapptor_business/assets/rtsp/index.html');
    rtsp_html = rtsp_html.replaceAll("[URL]", widget.url);

    Timer(const Duration(milliseconds: 300), () {
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    read_rtsp_html();
  }

  @override
  Widget build(BuildContext context) {
    return rtsp_html != ""
        ? Webview(
            id: "",
            src: rtsp_html,
          )
        : const SizedBox();
  }
}
