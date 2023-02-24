import 'package:cloud_firestore/cloud_firestore.dart';

class ShiftParticipant {
  String id;
  String full_name;

  ShiftParticipant({
    required this.id,
    required this.full_name,
  });

  ShiftParticipant.from_snapshot(
    String id,
    Map<String, dynamic> snapshot,
  )   : id = id,
        full_name = snapshot['firstname'] + ' ' + snapshot['lastnmame'];
}

Future<List<ShiftParticipant>> get_shift_participants(
    List<String> participants_id) async {
  List<ShiftParticipant> participants = [];

  for (var participant_id in participants_id) {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(participant_id)
        .get();

    participants.add(
      ShiftParticipant.from_snapshot(
          participant_id, snapshot.data() as Map<String, dynamic>),
    );
  }
  return participants;
}
