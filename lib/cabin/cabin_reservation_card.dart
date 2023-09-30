import 'package:flutter/material.dart';
import 'package:xapptor_business/models/cabin.dart';
import 'package:xapptor_business/models/reservation_cabin.dart';
import 'package:xapptor_business/models/season.dart';
import 'package:xapptor_logic/bool_to_text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:xapptor_ui/widgets/is_portrait.dart';

class CabinReservationCard extends StatefulWidget {
  const CabinReservationCard({
    super.key,
    required this.reservation,
    required this.select_date_available,
    required this.select_date_callback,
    required this.main_color,
    required this.text_list,
    required this.cabin,
    required this.reservation_period_label,
    required this.selected_cabin,
    required this.update_selected_cabin,
    required this.register_reservation,
    required this.available_cabins,
    required this.cancel_button_callback,
    required this.delete_button_callback,
    required this.edit_button_callback,
    required this.editing_mode,
    required this.register_payment_callback,
    required this.total_price_from_reservation,
    required this.reservation_payments_total,
    required this.user_info,
    required this.seasons,
    required this.number_of_days,
  });

  final ReservationCabin? reservation;
  final bool select_date_available;
  final Function select_date_callback;
  final Color main_color;
  final List<String> text_list;
  final Cabin cabin;
  final String reservation_period_label;
  final String selected_cabin;
  final Function update_selected_cabin;
  final Function(String reservation_id, bool register) register_reservation;
  final List<Cabin> available_cabins;
  final Function cancel_button_callback;
  final Function(String reservation_id, bool register) delete_button_callback;
  final Function(String reservation_id) edit_button_callback;
  final bool editing_mode;
  final Function(String reservation_id) register_payment_callback;
  final int total_price_from_reservation;
  final int reservation_payments_total;
  final Map<String, dynamic> user_info;
  final List<Season> seasons;
  final int number_of_days;

  @override
  State<CabinReservationCard> createState() => _CabinReservationCardState();
}

class _CabinReservationCardState extends State<CabinReservationCard> {
  @override
  void initState() {
    super.initState();
    get_user_info_from_reservation();
  }

  String user_name = "";
  bool admin = false;

  get_user_info_from_reservation() async {
    if (widget.reservation != null) {
      if (widget.user_info["admin"] != null) {
        admin = widget.user_info["admin"];
      }
      update_user_name();
    }
  }

  update_user_name() {
    user_name = "${widget.text_list[28]}: ${widget.user_info["firstname"]} ${widget.user_info["lastname"]}";

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    bool portrait = is_portrait(context);

    String description = "";

    if (widget.cabin.capacity >= 6) {
      description = widget.text_list[17];
    } else if (widget.cabin.capacity >= 4) {
      description = widget.text_list[18];
    } else if (widget.cabin.capacity >= 2) {
      description = widget.text_list[19];
    }
    if (widget.user_info.isNotEmpty) {
      update_user_name();
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: widget.main_color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              widget.reservation != null
                  ? SelectableText(
                      "ID: ${widget.reservation!.id}",
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : Container(),
              GestureDetector(
                onTap: () {
                  if (widget.editing_mode) {
                    widget.select_date_callback();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: widget.main_color.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Text(
                        widget.text_list[2],
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.visible,
                        maxLines: 10,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        widget.reservation_period_label,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.visible,
                        maxLines: 10,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "${widget.text_list[3]}: ",
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.visible,
                        maxLines: 10,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 10),
                      !widget.editing_mode
                          ? Text(
                              widget.cabin.id,
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.visible,
                              maxLines: 10,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : DropdownButton<String>(
                              items: widget.available_cabins
                                  .map((cabin) => cabin.id)
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (new_value) {
                                widget.update_selected_cabin(new_value!);
                              },
                              value: widget.selected_cabin,
                            ),
                    ],
                  ),
                  Text(
                    description,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.visible,
                    maxLines: 10,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "${widget.text_list[4]}: ${widget.reservation != null ? widget.cabin.get_season_price(
                          date_1: widget.reservation!.date_init,
                          date_2: widget.reservation!.date_end,
                          seasons: widget.seasons,
                        ).toString() : (widget.total_price_from_reservation / widget.number_of_days).toString()} ${widget.text_list[35]}${widget.text_list[36]}",
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.visible,
                    maxLines: 10,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "${widget.text_list[33]}: ${widget.total_price_from_reservation} ${widget.text_list[35]}",
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.visible,
                    maxLines: 10,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  widget.reservation == null
                      ? Container()
                      : Text(
                          "${widget.text_list[34]}: ${widget.reservation_payments_total} ${widget.text_list[35]}",
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.visible,
                          maxLines: 10,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                  Flex(
                    direction: portrait ? Axis.vertical : Axis.horizontal,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${widget.text_list[5]}: ${widget.cabin.capacity} ${widget.text_list[6]}",
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.visible,
                        maxLines: 10,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Text(
                        "${widget.text_list[8]}: ${widget.cabin.get_beds_string()}",
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.visible,
                        maxLines: 10,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Text(
                        "${widget.text_list[9]}: ${widget.cabin.bathrooms}",
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.visible,
                        maxLines: 10,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "${widget.text_list[10]}: ${bool_to_text(
                          value: widget.cabin.kitchen,
                          true_text: widget.text_list[15],
                          false_text: widget.text_list[16],
                        )}",
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.visible,
                        maxLines: 10,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Text(
                        "${widget.text_list[11]}: ${bool_to_text(
                          value: widget.cabin.sauna,
                          true_text: widget.text_list[15],
                          false_text: widget.text_list[16],
                        )}",
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.visible,
                        maxLines: 10,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "${widget.text_list[12]}: ${bool_to_text(
                          value: widget.cabin.livingroom,
                          true_text: widget.text_list[15],
                          false_text: widget.text_list[16],
                        )}",
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.visible,
                        maxLines: 10,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Text(
                        "${widget.text_list[13]}: ${bool_to_text(
                          value: widget.cabin.chimney,
                          true_text: widget.text_list[15],
                          false_text: widget.text_list[16],
                        )}",
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.visible,
                        maxLines: 10,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Text(
                        "${widget.text_list[14]}: ${bool_to_text(
                          value: widget.cabin.balcony,
                          true_text: widget.text_list[15],
                          false_text: widget.text_list[16],
                        )}",
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.visible,
                        maxLines: 10,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  widget.reservation != null && admin
                      ? Text(
                          user_name,
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.visible,
                          maxLines: 10,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : Container(),
                  widget.editing_mode
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.all(20),
                              child: ElevatedButton(
                                onPressed: () {
                                  widget.cancel_button_callback();
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(
                                    widget.main_color,
                                  ),
                                ),
                                child: Text(
                                  widget.text_list[22],
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.all(20),
                              child: ElevatedButton(
                                onPressed: () {
                                  widget.register_reservation(widget.reservation?.id ?? "", true);
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(
                                    widget.main_color,
                                  ),
                                ),
                                child: Text(
                                  widget.text_list[20],
                                ),
                              ),
                            ),
                          ],
                        )
                      : Container(),
                ],
              ),
            ],
          ),
        ),
        !widget.editing_mode
            ? Container(
                alignment: Alignment.topCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {
                        widget.delete_button_callback(widget.reservation!.id, false);
                      },
                      icon: const Icon(
                        FontAwesomeIcons.trashCan,
                        color: Colors.red,
                      ),
                      tooltip: widget.text_list[29],
                    ),
                    Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            widget.edit_button_callback(widget.reservation!.id);
                          },
                          icon: const Icon(
                            FontAwesomeIcons.penToSquare,
                          ),
                          tooltip: widget.text_list[30],
                        ),
                        admin
                            ? IconButton(
                                onPressed: () {
                                  widget.register_payment_callback(widget.reservation!.id);
                                },
                                icon: const Icon(
                                  FontAwesomeIcons.creditCard,
                                ),
                                tooltip: widget.text_list[31],
                              )
                            : Container(),
                      ],
                    ),
                  ],
                ),
              )
            : Container(),
      ],
    );
  }
}
