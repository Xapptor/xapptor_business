import 'package:flutter/material.dart';
import 'package:xapptor_business/cabin/reservation/cabin_reservation_card/cabin_reservation_card.dart';

extension StateExtension on CabinReservationCardState {
  editing_mode_buttons() {
    return Row(
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
              backgroundColor: WidgetStateProperty.all<Color>(
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
              backgroundColor: WidgetStateProperty.all<Color>(
                widget.main_color,
              ),
            ),
            child: Text(
              widget.text_list[20],
            ),
          ),
        ),
      ],
    );
  }
}
