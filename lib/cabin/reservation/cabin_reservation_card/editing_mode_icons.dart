import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:xapptor_business/cabin/reservation/cabin_reservation_card/cabin_reservation_card.dart';

extension StateExtension on CabinReservationCardState {
  Widget editing_mode_icons() {
    return Container(
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
              if (admin)
                IconButton(
                  onPressed: () {
                    widget.register_payment_callback(widget.reservation!.id);
                  },
                  icon: const Icon(
                    FontAwesomeIcons.creditCard,
                  ),
                  tooltip: widget.text_list[31],
                ),
            ],
          ),
        ],
      ),
    );
  }
}
