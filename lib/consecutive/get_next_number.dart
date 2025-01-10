import 'package:xapptor_db/xapptor_db.dart';

Future<int> get_next_number(String siteId, String type) async {
  final querySnapshot = await XapptorDB.instance
      .collection('consecutive')
      .where('site_id', isEqualTo: siteId)
      .where('type', isEqualTo: type)
      .limit(1)
      .get();

  if (querySnapshot.docs.isNotEmpty) {
    // Obtener el documento
    final doc = querySnapshot.docs.first;
    int currentNumber = doc['last_number'] ?? 0;
    int newConsecutive = currentNumber + 1;

    // Actualizar el last_number en Firestore
    await doc.reference.update({'last_number': newConsecutive});

    return newConsecutive; // Retorna el nuevo número de consecutivo
  } else {
    throw Exception(
        "A consecutive number was not found for the specified site_id and type.");
  }
}
