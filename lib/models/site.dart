import 'package:cloud_firestore/cloud_firestore.dart';

class Site {
  String id;
  String state;

  Site({
    required this.id,
    required this.state,
  });

  Site.from_snapshot(DocumentSnapshot snapshot)
      : id = snapshot.id,
        state = snapshot.get("state");
}
