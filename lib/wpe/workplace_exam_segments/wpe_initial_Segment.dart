import 'package:flutter/material.dart';

class WpeInitialSegment extends StatefulWidget {
  final Widget main_button;
  final Color main_color;

  const WpeInitialSegment({
    super.key,
    required this.main_button,
    required this.main_color,
  });

  @override
  State<WpeInitialSegment> createState() => _WpeInitialSegmentState();
}

class _WpeInitialSegmentState extends State<WpeInitialSegment> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.all(20),
          child: const Text(
            'Complete the Workplace Exam',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        widget.main_button,
      ],
    );
  }
}
