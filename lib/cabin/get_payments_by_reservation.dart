import 'package:xapptor_business/cabin/get_payment_by_id.dart';
import 'package:xapptor_business/models/payment.dart';
import 'package:xapptor_business/models/reservation_cabin.dart';

Future<List<Payment>> get_payments_by_reservation(
    ReservationCabin reservation) async {
  List<Payment> reservation_payments = [];

  reservation.payments.forEach((payment_id) async {
    Payment current_payment = await get_payment_by_id(payment_id);
    reservation_payments.add(current_payment);
  });
  return reservation_payments;
}
