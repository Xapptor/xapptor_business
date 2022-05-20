import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xapptor_business/models/payment.dart';

Future<Payment> get_payment_by_id(String payment_id) async {
  var payment_snap = await FirebaseFirestore.instance
      .collection("payments")
      .doc(payment_id)
      .get();
  return Payment.from_snapshot(
      payment_snap.id, payment_snap.data() as Map<String, dynamic>);
}
