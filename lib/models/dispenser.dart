// Dispenser model.

class Dispenser {
  String product_id;
  bool enabled;
  int quantity_remaining;

  Dispenser({
    required this.product_id,
    required this.enabled,
    required this.quantity_remaining,
  });

  Dispenser.from_snapshot(Map<String, dynamic> snapshot)
      : product_id = snapshot['product_id'],
        enabled = snapshot['enabled'],
        quantity_remaining = snapshot['quantity_remaining'];

  Map<String, dynamic> to_json() {
    return {
      'product_id': product_id,
      'enabled': enabled,
      'quantity_remaining': quantity_remaining,
    };
  }
}
