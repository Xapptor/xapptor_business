// Product model.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xapptor_router/initial_values_routing.dart';

class Reservation {
  const Reservation({
    required this.id,
    this.price_id = "",
    required this.name,
    required this.image_src,
    required this.price,
    required this.description,
    this.enabled = true,
    required this.date_created,
    required this.reservation_period,
  });

  final String id;
  final String price_id;
  final String name;
  final String image_src;
  final int price;
  final String description;
  final bool enabled;
  final DateTime date_created;
  final List<DateTime> reservation_period;

  Reservation.from_snapshot(
    String id,
    Map<String, dynamic> snapshot,
  )   : id = id,
        price_id = snapshot[current_build_mode == BuildMode.release
                ? "stripe_id"
                : "stripe_id_test"] ??
            "",
        name = snapshot['name'],
        image_src = snapshot['image_src'],
        price = snapshot['price'],
        enabled = snapshot['enabled'] ?? true,
        description = snapshot['description'] ?? "",
        date_created = (snapshot['date_created'] as Timestamp).toDate(),
        reservation_period = [
          (snapshot['reservation_period'][0] as Timestamp).toDate(),
          (snapshot['reservation_period'][1] as Timestamp).toDate()
        ];
}
