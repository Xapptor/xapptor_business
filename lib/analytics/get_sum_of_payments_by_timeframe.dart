import 'package:xapptor_business/models/payment_vending_machine.dart';
import 'package:xapptor_ui/widgets/timeframe_chart_functions.dart';

List<Map<String, dynamic>> get_sum_of_payments_by_timeframe({
  required List<PaymentVendingMachine> filtered_payments,
  required TimeFrame current_timeframe,
}) {
  List<Map<String, dynamic>> sum_of_payments = [];

  for (var filtered_payment in filtered_payments) {
    if (sum_of_payments.isEmpty) {
      sum_of_payments.add({
        "date": filtered_payment.date,
        "amount": filtered_payment.amount,
      });
    } else {
      bool payment_was_made_at_same_timeframe = false;

      bool same_hour =
          filtered_payment.date.hour == sum_of_payments.last["date"].hour;

      bool same_day =
          filtered_payment.date.day == sum_of_payments.last["date"].day;

      bool same_month =
          filtered_payment.date.month == sum_of_payments.last["date"].month;

      bool same_year =
          filtered_payment.date.year == sum_of_payments.last["date"].year;

      switch (current_timeframe) {
        case TimeFrame.day:
          if (same_hour && same_day && same_month && same_year)
            payment_was_made_at_same_timeframe = true;
          break;
        case TimeFrame.week:
          if (same_day && same_month && same_year)
            payment_was_made_at_same_timeframe = true;
          break;
        case TimeFrame.month:
          if (same_day && same_month && same_year)
            payment_was_made_at_same_timeframe = true;
          break;
        case TimeFrame.year:
          if (same_month && same_year)
            payment_was_made_at_same_timeframe = true;
          break;
        case TimeFrame.beginning:
          if (same_year) payment_was_made_at_same_timeframe = true;
          break;
      }

      if (payment_was_made_at_same_timeframe) {
        sum_of_payments.last["amount"] += filtered_payment.amount;
      } else {
        sum_of_payments.add({
          "date": filtered_payment.date,
          "amount": filtered_payment.amount,
        });
      }
    }
  }
  return sum_of_payments;
}
