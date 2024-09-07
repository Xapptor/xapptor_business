import 'package:xapptor_business/cabin/payments/get_payment_by_id.dart';
import 'package:xapptor_business/models/payment.dart';
import 'package:xapptor_business/models/reservation_cabin.dart';

Future<List<Payment>> get_payments_by_reservation(ReservationCabin reservation) async {
  List<Payment> reservation_payments = [];
  reservation_payments = await Future.wait(
    reservation.payments.map((payment_id) => get_payment_by_id(payment_id)).toList(),
  );
  return reservation_payments;
}
