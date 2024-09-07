import 'package:xapptor_business/models/cabin.dart';

Cabin get_cabin_from_id({
  required String id,
  required List<Cabin> cabins,
}) {
  return cabins.firstWhere((cabin) => cabin.id == id);
}
