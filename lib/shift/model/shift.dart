import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:xapptor_business/shift/model/shift_participant.dart';
import 'package:xapptor_business/wpe/workplace_exam_view.dart';

enum ShiftType {
  first,
  second,
  third,
  day,
  night,
}

class Shift {
  String id;
  String supervisor_id;
  String organization_id;
  String name;
  ShiftType type;
  List<ShiftParticipant> participants;
  DateTime start;
  DateTime end;

  Shift({
    required this.id,
    required this.supervisor_id,
    required this.organization_id,
    required this.name,
    required this.type,
    required this.participants,
    required this.start,
    required this.end,
  });

  Map<String, dynamic> to_json() {
    return {
      'supervisor_id': supervisor_id,
      'organization_id': organization_id,
      'type': type,
      'name': name,
      'participants': participants.map((e) => e.id).toList(),
      'start': start,
      'end': end,
    };
  }
}

Future<Shift> get_shift_from_snapshot(
  String id,
  Map snapshot,
) async {
  List<ShiftParticipant> participants =
      await get_shift_participants((snapshot['participants']).cast<String>());

  return Shift(
    id: id,
    supervisor_id: snapshot['supervisor_id'],
    organization_id: snapshot['organization_id'],
    type: get_most_similar_enum_value(
      ShiftType.values,
      snapshot['type'],
    ),
    name: snapshot['name'],
    participants: participants,
    start: (snapshot['start'] as Timestamp).toDate(),
    end: (snapshot['end'] as Timestamp).toDate(),
  );
}

get_shifts(Function(List<Shift>) update_function) async {
  User? user = await FirebaseAuth.instance.currentUser;
  List<Shift> shifts = [];

  QuerySnapshot shifts_snaps = await FirebaseFirestore.instance
      .collection('shifts')
      .where('supervisor_id', isEqualTo: user!.uid)
      .get();

  if (shifts_snaps.docs.isEmpty) {
    update_function(shifts);
  } else {
    shifts_snaps.docs.asMap().forEach((index, shift_snap) async {
      shifts.add(
        await get_shift_from_snapshot(
          shift_snap.id,
          shift_snap.data() as Map,
        ),
      );

      if (index == shifts_snaps.docs.length - 1) {
        update_function(shifts);
      }
    });
  }
}
