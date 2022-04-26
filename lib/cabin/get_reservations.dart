import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xapptor_business/models/reservation_cabin.dart';

Future<List<ReservationCabin>> get_reservations({
  required String user_id,
  required Map<String, dynamic> user_info,
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
    reservations_snap = await FirebaseFirestore.instance
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
  } else {
    reservations_snap = await FirebaseFirestore.instance
        .collection("reservations")
        .where(
          "user_id",
          isEqualTo: user_id,
        )
        .get();
  }

  if (reservations_snap.docs.length > 0) {
    reservations_snap.docs.forEach((snap) {
      reservations.add(ReservationCabin.from_snapshot(snap.id, snap.data()));
    });
  }

  var reservations_copy = reservations.toList();

  reservations.forEach((reservation) {
    DateTime comparison_date = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day - 1,
    );
    if (reservation.date_init.isBefore(comparison_date)) {
      reservations_copy.remove(reservation);
    }
  });
  reservations = reservations_copy.toList();
  return reservations;
}
