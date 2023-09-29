import 'package:flutter/material.dart';

class InvitationsView extends StatefulWidget {
  final String base_path;
  final Color main_color;

  const InvitationsView({super.key, 
    required this.base_path,
    required this.main_color,
  });
  @override
  _InvitationsViewState createState() => _InvitationsViewState();
}

class _InvitationsViewState extends State<InvitationsView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.main_color,
        title: const Text('Invitations View'),
      ),
      body: Container(),
    );
  }
}
