import 'package:flutter/material.dart';
import 'package:xapptor_business/shift/model/shift.dart';
import 'package:xapptor_business/shift/model/shift_participant.dart';
import 'package:xapptor_ui/values/ui.dart';
import 'package:xapptor_ui/widgets/is_portrait.dart';

class ShiftParticipantsSelection extends StatefulWidget {
  final Color main_color;

  const ShiftParticipantsSelection({
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
    get_shifts((List<Shift> new_shifts) {
      shifts = new_shifts;
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    fetch_shifts();
  }

  @override
  Widget build(BuildContext context) {
    bool portrait = is_portrait(context);

    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: shifts.length == 0
            ? CircularProgressIndicator()
            : FractionallySizedBox(
                widthFactor: portrait ? 0.9 : 0.4,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Shift Participants Selection',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          bottom: sized_box_space,
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: shifts.length,
                          itemBuilder: (context, index) {
                            Shift shift = shifts[index];

                            return ExpansionTile(
                              initiallyExpanded: true,
                              title: Text(
                                shift.name,
                              ),
                              subtitle: Text(
                                'Available Participants ${shift.participants.length}',
                              ),
                              children: <Widget>[
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: shift.participants.length,
                                  itemBuilder: (context, participant_index) {
                                    return ShiftParticipantTile(
                                      shift_participant:
                                          shift.participants[participant_index],
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      Container(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: widget.main_color,
                          ),
                          onPressed: () {
                            //
                          },
                          child: Text('Next'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
