import 'dispenser.dart';

// VendingMachine model.

class VendingMachine {
  final String id;
  final String user_id;
  final List<Dispenser> dispensers;
  final bool enabled;
  final int money_change;
  final String name;

  const VendingMachine({
    required this.id,
    required this.user_id,
    required this.dispensers,
    required this.enabled,
    required this.money_change,
    required this.name,
  });

  VendingMachine.from_snapshot(String id, Map<String, dynamic> snapshot)
      : id = id,
        user_id = snapshot['user_id'],
        dispensers = List<Dispenser>.from(
          snapshot['dispensers'].map((dispenser) {
            return Dispenser.from_snapshot(dispenser);
          }).toList(),
        ),
        enabled = snapshot['enabled'],
        money_change = snapshot['money_change'],
        name = snapshot['name'];

  Map<String, dynamic> to_json() {
    List<Map<String, dynamic>> map_dispenser_list = [];

    for (var dispenser in dispensers) {
      map_dispenser_list.add(dispenser.to_json());
    }

    return {
      'admin': user_id,
      'dispensers': map_dispenser_list,
      'enabled': enabled,
      'money_change': money_change,
      'name': name,
    };
  }
}

List<Map<String, dynamic>> vending_machine_list_to_json_list(
    List<VendingMachine> vending_machines) {
  List<Map<String, dynamic>> json_list = [];

  for (var product in vending_machines) {
    json_list.add(product.to_json());
  }

  return json_list;
}
