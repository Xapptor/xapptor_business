import 'package:flutter/material.dart';
import 'package:xapptor_business/shift/model/shift.dart';
import 'package:xapptor_business/shift/model/shift_participant.dart';
import 'package:xapptor_business/wpe/workplace_exam_view.dart';

class ShiftParticipantsSelection extends StatefulWidget {
  final List<String> shift_ids;
  final Color main_color;

  const ShiftParticipantsSelection({
    required this.shift_ids,
    required this.main_color,
  });

  @override
  _ShiftParticipantsSelectionState createState() =>
      _ShiftParticipantsSelectionState();
}

class _ShiftParticipantsSelectionState
    extends State<ShiftParticipantsSelection> {
  List<Shift> shifts = [];

  fetch_shifts() async {
    shifts = await get_shifts(widget.shift_ids);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetch_shifts();
  }

  @override
  Widget build(BuildContext context) {
    return shifts.length == 0
        ? Center(
            child: CircularProgressIndicator(),
          )
        : SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text(
                  'Shift Participants Selection',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ListView.builder(
                  itemCount: shifts.length,
                  itemBuilder: (context, index) {
                    Shift shift = shifts[index];

                    return ExpansionTile(
                      title: Text(
                        get_most_similar_enum_value(
                          ShiftType.values,
                          shift.type.name,
                        ),
                      ),
                      subtitle: Text(
                        'Available Participants ${shift.participants.length}',
                      ),
                      children: <Widget>[
                        ShiftParticipantTile(
                          shift_participant: shift.participants[index],
                        ),
                      ],
                    );
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.main_color,
                  ),
                  onPressed: () {
                    //
                  },
                  child: Text('Next'),
                ),
              ],
            ),
          );
  }
}

class ShiftParticipantTile extends StatefulWidget {
  final ShiftParticipant shift_participant;

  const ShiftParticipantTile({
    required this.shift_participant,
  });

  @override
  _ShiftParticipantTileState createState() => _ShiftParticipantTileState();
}

class _ShiftParticipantTileState extends State<ShiftParticipantTile> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(widget.shift_participant.full_name),
      value: selected,
      onChanged: (value) {
        setState(() {
          selected = value!;
        });
      },
    );
  }
}
