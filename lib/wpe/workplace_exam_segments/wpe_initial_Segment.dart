import 'package:flutter/material.dart';

class WpeInitialSegment extends StatefulWidget {
  final ValueNotifier<int> current_step;
  final Function setState;
  final Color main_color;

  WpeInitialSegment({
    required this.current_step,
    required this.setState,
    required this.main_color,
  });

  @override
  _WpeInitialSegmentState createState() => _WpeInitialSegmentState();
}

class _WpeInitialSegmentState extends State<WpeInitialSegment> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.all(20),
            child: Text(
              'Complete the Workplace Exam',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: () {
                widget.current_step.value++;
                widget.setState();
              },
              child: Text('Start'),
            ),
          ),
        ],
      ),
    );
  }
}
