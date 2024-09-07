import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:xapptor_ui/widgets/webview/webview.dart';

class RTSPView extends StatefulWidget {
  final String url;

  const RTSPView({
    super.key,
    required this.url,
  });

  @override
  State<RTSPView> createState() => _RTSPViewState();
}

class _RTSPViewState extends State<RTSPView> {
  Future<String> read_rtsp_html() async {
    String rtsp_html = await rootBundle.loadString('packages/xapptor_business/assets/rtsp/index.html');
    rtsp_html = rtsp_html.replaceAll("[URL]", widget.url);

    await Future.delayed(const Duration(milliseconds: 300));
    return rtsp_html;
  }

  @override
  void initState() {
    super.initState();
    read_rtsp_html();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: read_rtsp_html(),
      builder: (
        BuildContext context,
        AsyncSnapshot<String> snapshot,
      ) {
        if (snapshot.hasError) {
          return const SizedBox();
        } else {
          return Webview(
            id: "",
            src: snapshot.data!,
          );
        }
      },
    );
  }
}
