import 'package:xapptor_business/models/bed.dart';
import 'package:xapptor_business/models/season.dart';

class Cabin {
  const Cabin({
    required this.id,
    required this.high_price,
    required this.low_price,
    required this.capacity,
    required this.beds,
    required this.bathrooms,
    required this.kitchen,
    required this.sauna,
    required this.livingroom,
    required this.chimney,
    required this.balcony,
  });

  final String id;
  final int high_price;
  final int low_price;
  final int capacity;
  final List<Bed> beds;
  final int bathrooms;
  final bool kitchen;
  final bool sauna;
  final bool livingroom;
  final bool chimney;
  final bool balcony;

  Cabin.from_snapshot(
    this.id,
    Map<String, dynamic> snapshot,
  )   : high_price = snapshot['high_price'],
        low_price = snapshot['low_price'],
        capacity = snapshot['capacity'],
        beds = (snapshot['beds'] as List)
            .map((bed) => Bed.values.firstWhere((bed_type) => bed_type.toShortString() == bed))
            .toList(),
        bathrooms = snapshot['bathrooms'],
        kitchen = snapshot['kitchen'],
        sauna = snapshot['sauna'],
        livingroom = snapshot['livingroom'],
        chimney = snapshot['chimney'],
        balcony = snapshot['balcony'];

  Map<String, dynamic> to_json() {
    return {
      'high_price': high_price,
      'low_price': low_price,
      'capacity': capacity,
      'beds': beds.map((element) => element.toShortString()),
      'bathrooms': bathrooms,
      'kitchen': kitchen,
      'sauna': sauna,
      'livingroom': livingroom,
      'chimney': chimney,
      'balcony': balcony,
    };
  }

  String get_beds_string() {
    List<String> bed_string = [];

    for (var i = 0; i < beds.length; i++) {
      Bed bed_1 = beds[i];
      int bed_counter = 0;

      for (var bed_2 in beds) {
        if (bed_1 == bed_2) {
          bed_counter++;
        }
      }

      bed_string.add("$bed_counter ${bed_1.toShortString()}");
    }

    return "${bed_string.toSet().join(", ")}.";
  }

  int get_season_price({
    required DateTime date_1,
    required DateTime date_2,
    required List<Season> seasons,
  }) {
    List<Map<String, int>> season_distances_1 = [];
    List<Map<String, int>> season_distances_2 = [];

    for (var season in seasons) {
      int index = seasons.indexOf(season);

      if (date_1.year != date_2.year) {
        if (season.begin.month == 12 && season.end.month == 1) {
          season.begin = DateTime(
            date_1.year,
            season.begin.month,
            season.begin.day,
          );
        }
      }

      season_distances_1.add({
        "index": index,
        "value": date_1.difference(season.begin).inDays.abs(),
      });

      season_distances_2.add({
        "index": index,
        "value": date_1.difference(season.end).inDays.abs(),
      });
    }

    season_distances_1.sort((a, b) => a["value"]!.compareTo(b["value"]!));
    season_distances_2.sort((a, b) => a["value"]!.compareTo(b["value"]!));

    Season posible_season_1 = seasons[season_distances_1.first["index"]!];
    Season posible_season_2 = seasons[season_distances_2.first["index"]!];

    int season_distance_1 = season_distances_1.first["value"]!;
    int season_distance_2 = season_distances_2.first["value"]!;

    late Season current_season;

    if (season_distance_1 < season_distance_2) {
      current_season = posible_season_1;
    } else {
      current_season = posible_season_2;
    }

    return current_season.type == SeasonType.high ? high_price : low_price;
  }
}
