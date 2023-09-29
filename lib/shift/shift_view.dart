import 'package:flutter/material.dart';

class ShiftView extends StatefulWidget {
  final String base_path;
  final Color main_color;

  const ShiftView({super.key, 
    required this.base_path,
    required this.main_color,
  });
  @override
  _ShiftViewState createState() => _ShiftViewState();
}

class _ShiftViewState extends State<ShiftView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.main_color,
        title: const Text('Shift View'),
      ),
      body: Container(),
    );
  }
}
