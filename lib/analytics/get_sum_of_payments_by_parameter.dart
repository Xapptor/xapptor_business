List<Map<String, dynamic>> get_sum_of_payments_by_parameter({
  required List<Map<String, dynamic>> payments,
  required String parameter,
}) {
  payments.sort((a, b) => a[parameter].compareTo(b[parameter]));

  List<Map<String, dynamic>> sum_of_payments = [];
  for (var payment in payments) {
    if (sum_of_payments.isEmpty) {
      sum_of_payments.add({
        parameter: payment[parameter],
        "amount": payment["amount"],
      });
    } else {
      bool current_parameter_is_same_as_past =
          payment[parameter] == sum_of_payments.last[parameter];

      if (current_parameter_is_same_as_past) {
        sum_of_payments.last["amount"] += payment["amount"];
      } else {
        sum_of_payments.add({
          parameter: payment[parameter],
          "amount": payment["amount"],
        });
      }
    }
  }
  return sum_of_payments;
}
