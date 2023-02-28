import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    double width = MediaQuery.of(context).size.width;
    bool portrait = is_portrait(context);

    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: shifts.length == 0
            ? CircularProgressIndicator()
            : SingleChildScrollView(
                child: Container(
                  width: width,
                  child: FractionallySizedBox(
                    widthFactor: portrait ? 0.9 : 0.4,
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(
                            top: sized_box_space * 4,
                            bottom: sized_box_space * 2,
                          ),
                          child: Text(
                            'Shift Participants Selection',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            bottom: sized_box_space * 2,
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: shifts.length,
                            itemBuilder: (context, index) {
                              Shift shift = shifts[index];
                              String start_time =
                                  DateFormat.jm().format(shift.start);
                              String end_time =
                                  DateFormat.jm().format(shift.end);
                              String shift_time = start_time + ' - ' + end_time;

                              return ExpansionTile(
                                initiallyExpanded: true,
                                title: Text(
                                  shift.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  'Available ${shift.participants.length} participants\n${shift_time}',
                                ),
                                children: <Widget>[
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: shift.participants.length,
                                    itemBuilder: (context, participant_index) {
                                      return ShiftParticipantTile(
                                        shift_participant: shift
                                            .participants[participant_index],
                                      );
                                    },
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            bottom: sized_box_space * 4,
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: widget.main_color,
                            ),
                            onPressed: () {
                              show_confirmation_alert();
                            },
                            child: Text('Confirm'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  show_confirmation_alert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text(
              'Are you sure you want to confirm the participant selection?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Confirm'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
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
  bool selected = true;

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
