import 'package:flutter/material.dart';
import 'package:xapptor_business/cabin/reservation/cabin_reservation_card/cabin_reservation_card.dart';

extension StateExtension on CabinReservationCardState {
  reservation_period_button() {
    return GestureDetector(
      onTap: () {
        if (widget.editing_mode) {
          widget.select_date_callback();
        }
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: widget.main_color.withValues(alpha: 0.4),
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
    );
  }
}
