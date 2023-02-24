import 'package:flutter/material.dart';

class WpeList extends StatefulWidget {
  @override
  _WpeListState createState() => _WpeListState();
}

class _WpeListState extends State<WpeList> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Text(
            'Pending',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Closed',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          ListView.builder(
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('Title'),
                subtitle: Text('Subtitle'),
              );
            },
          ),
          Text(
            'Current',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
