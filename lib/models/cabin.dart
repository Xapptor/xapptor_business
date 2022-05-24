// Cabine model.

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
    String id,
    Map<String, dynamic> snapshot,
  )   : id = id,
        high_price = snapshot['high_price'],
        low_price = snapshot['low_price'],
        capacity = snapshot['capacity'],
        beds = (snapshot['beds'] as List)
            .map((bed) => Bed.values
                .firstWhere((bed_type) => bed_type.toShortString() == bed))
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

      beds.forEach((bed_2) {
        if (bed_1 == bed_2) {
          bed_counter++;
        }
      });

      bed_string.add("${bed_counter} " + bed_1.toShortString());
    }

    return bed_string.toSet().join(", ") + ".";
  }

  int get_season_price({
    required DateTime date_1,
    required DateTime date_2,
    required List<Season> seasons,
  }) {
    Season current_season = seasons.firstWhere((season) {
      DateTime season_begin = DateTime(
        date_1.year,
        season.begin.month,
        season.begin.day,
      );

      DateTime season_end = DateTime(
        season.begin.month == 12 && season.end.month == 1
            ? date_2.year + 1
            : date_1.year,
        season.end.month,
        season.end.day,
      );

      bool after_begin = date_1.isAfter(season_begin) || date_1 == season_begin;
      bool before_end = date_2.isBefore(season_end) || date_2 == season_end;

      return after_begin && before_end;
    });

    return current_season.type == SeasonType.high
        ? this.high_price
        : this.low_price;
  }
}
