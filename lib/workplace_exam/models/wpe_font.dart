import 'package:pdf/widgets.dart';

class WpeFont {
  final String name;
  final Font? base;
  final Font? bold;
  final String google_font_family;

  const WpeFont({
    required this.name,
    required this.base,
    required this.bold,
    required this.google_font_family,
  });

  factory WpeFont.empty() {
    return const WpeFont(
      name: '',
      base: null,
      bold: null,
      google_font_family: '',
    );
  }
}
