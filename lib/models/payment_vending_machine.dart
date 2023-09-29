import 'package:xapptor_business/models/payment.dart';

// Payment model.

class PaymentVendingMachine extends Payment {
  final int dispenser;
  final String vending_machine_id;

  const PaymentVendingMachine({
    required String id,
    required int amount,
    required DateTime date,
    required String product_id,
    required String user_id,
    required this.dispenser,
    required this.vending_machine_id,
  }) : super(
          id: id,
          amount: amount,
          date: date,
          product_id: product_id,
          user_id: user_id,
        );

  factory PaymentVendingMachine.from_snapshot(
    String id,
    Map<String, dynamic> snapshot,
  ) {
    Payment payment = Payment.from_snapshot(id, snapshot);
    return PaymentVendingMachine(
      id: id,
      amount: payment.amount,
      date: payment.date,
      product_id: payment.product_id,
      user_id: payment.user_id,
      dispenser: snapshot['dispenser'],
      vending_machine_id: snapshot['vending_machine_id'],
    );
  }

  @override
  Map<String, dynamic> to_json() {
    return {
      'amount': amount,
      'date': date,
      'product_id': product_id,
      'user_id': user_id,
      'dispenser': dispenser,
      'vending_machine_id': vending_machine_id,
    };
  }
}

List<Map<String, dynamic>> payment_list_to_json_list(
    List<PaymentVendingMachine> payments) {
  List<Map<String, dynamic>> json_list = [];

  for (var payment in payments) {
    json_list.add(payment.to_json());
  }

  return json_list;
}
