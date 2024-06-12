import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:xapptor_business/shift/model/shift.dart';
import 'package:xapptor_business/shift/model/shift_participant.dart';
import 'package:xapptor_ui/values/ui.dart';
import 'package:xapptor_ui/utils/is_portrait.dart';

class ShiftParticipantsSelection extends StatefulWidget {
  final Color main_color;

  const ShiftParticipantsSelection({
    super.key,
    required this.main_color,
  });

  @override
  State<ShiftParticipantsSelection> createState() => _ShiftParticipantsSelectionState();
}

class _ShiftParticipantsSelectionState extends State<ShiftParticipantsSelection> {
  List<Shift> shifts = [];
  Map<int, Map<int, bool>> participants_selection_matrix = {};

  fetch_shifts() async {
    get_shifts((List<Shift> new_shifts) {
      shifts = new_shifts;
      setState(() {});
    });

    // shifts.asMap().forEach((shift_index, shift) {
    //   shift.participants.asMap().forEach((participant_index, participant) {
    //     participants_selection_matrix[shift_index]!.addEntries({});
    //   });
    // });
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
        child: shifts.isEmpty
            ? const CircularProgressIndicator()
            : SingleChildScrollView(
                child: SizedBox(
                  width: width,
                  child: FractionallySizedBox(
                    widthFactor: portrait ? 0.9 : 0.4,
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            top: sized_box_space * 4,
                            bottom: sized_box_space * 2,
                          ),
                          child: const Text(
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
                              String start_time = DateFormat.jm().format(shift.start);
                              String end_time = DateFormat.jm().format(shift.end);
                              String shift_time = '$start_time - $end_time';

                              return ExpansionTile(
                                initiallyExpanded: true,
                                title: Text(
                                  shift.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  'Available ${shift.participants.length} participants\n$shift_time',
                                ),
                                children: [
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: shift.participants.length,
                                    itemBuilder: (context, participant_index) {
                                      return ShiftParticipantTile(
                                        shift_participant: shift.participants[participant_index],
                                        shift_index: index,
                                        participant_index: participant_index,
                                        on_changed: ({
                                          required bool selected,
                                          required int shift_index,
                                          required int participant_index,
                                          required bool update_state,
                                        }) {
                                          // participants_selection_matrix[
                                          //         shift_index]![
                                          //     participant_index] = selected;
                                          if (update_state) setState(() {});
                                        },
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
                            child: const Text('Confirm'),
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
          title: const Text('Confirmation'),
          content: const Text('Are you sure you want to confirm the participant selection?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () {
                participants_selection_matrix.forEach((key, value) {
                  debugPrint('Shift $key - participants: $value');
                });
                Navigator.of(context).pop();
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
  final int shift_index;
  final int participant_index;
  final Function({
    required bool selected,
    required int shift_index,
    required int participant_index,
    required bool update_state,
  }) on_changed;

  const ShiftParticipantTile({
    super.key,
    required this.shift_participant,
    required this.shift_index,
    required this.participant_index,
    required this.on_changed,
  });

  @override
  State<ShiftParticipantTile> createState() => _ShiftParticipantTileState();
}

class _ShiftParticipantTileState extends State<ShiftParticipantTile> {
  bool selected = true;

  @override
  void initState() {
    super.initState();
    // widget.on_changed(
    //   selected: selected,
    //   shift_index: widget.shift_index,
    //   participant_index: widget.participant_index,
    //   update_state: false,
    // );
  }

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(widget.shift_participant.full_name),
      value: selected,
      onChanged: (value) {
        selected = value!;
        widget.on_changed(
          selected: selected,
          shift_index: widget.shift_index,
          participant_index: widget.participant_index,
          update_state: true,
        );
      },
    );
  }
}
