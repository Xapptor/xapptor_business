import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xapptor_business/models/reservation_cabin.dart';
import 'package:xapptor_db/xapptor_db.dart';

Future<List<ReservationCabin>> get_reservations({
  required String user_id,
  required Map<String, dynamic> user_info,
  required bool show_older_reservations,
}) async {
  List<ReservationCabin> reservations = [];

  bool get_all_reservations = false;

  if (user_info["admin"] != null) {
    if (user_info["admin"]) {
      get_all_reservations = true;
    }
  }

  QuerySnapshot<Map<String, dynamic>> reservations_snap;

  if (get_all_reservations) {
    if (show_older_reservations) {
      reservations_snap = await XapptorDB.instance.collection("reservations").get();
    } else {
      reservations_snap = await XapptorDB.instance
          .collection("reservations")
          .where(
            "date_init",
            isGreaterThanOrEqualTo: DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day - 1,
            ),
          )
          .get();
    }
  } else {
    reservations_snap = await XapptorDB.instance
        .collection("reservations")
        .where(
          "user_id",
          isEqualTo: user_id,
        )
        .get();
  }

  if (reservations_snap.docs.isNotEmpty) {
    for (var snap in reservations_snap.docs) {
      reservations.add(ReservationCabin.from_snapshot(snap.id, snap.data()));
    }
  }

  var reservations_copy = reservations.toList();

  for (var reservation in reservations) {
    DateTime comparison_date = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day - 1,
    );
    if (!show_older_reservations && reservation.date_init.isBefore(comparison_date)) {
      reservations_copy.remove(reservation);
    }
  }
  reservations = reservations_copy.toList();
  reservations.sort((a, b) => a.date_init.compareTo(b.date_init));
  if (show_older_reservations) {
    reservations = reservations.reversed.toList();
  }
  return reservations;
}
