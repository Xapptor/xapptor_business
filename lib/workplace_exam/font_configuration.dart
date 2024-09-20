import 'package:google_fonts/google_fonts.dart';
import 'package:printing/printing.dart';
import 'package:xapptor_business/workplace_exam/models/wpe_font.dart';

// FONT FAMILIES FOR VISUALIZER AND PDF
Future<List<WpeFont>> font_families() async => [
      WpeFont(
        name: 'Nunito',
        base: await PdfGoogleFonts.nunitoRegular(),
        bold: await PdfGoogleFonts.nunitoMedium(),
        google_font_family: GoogleFonts.nunito().fontFamily!,
      ),
      WpeFont(
        name: 'QuickSand',
        base: await PdfGoogleFonts.quicksandRegular(),
        bold: await PdfGoogleFonts.quicksandMedium(),
        google_font_family: GoogleFonts.quicksand().fontFamily!,
      ),
      WpeFont(
        name: 'Ubuntu',
        base: await PdfGoogleFonts.ubuntuRegular(),
        bold: await PdfGoogleFonts.ubuntuMedium(),
        google_font_family: GoogleFonts.ubuntu().fontFamily!,
      ),
      WpeFont(
        name: 'Lexend',
        base: await PdfGoogleFonts.lexendRegular(),
        bold: await PdfGoogleFonts.lexendMedium(),
        google_font_family: GoogleFonts.lexend().fontFamily!,
      ),
      WpeFont(
        name: 'Roboto',
        base: await PdfGoogleFonts.robotoRegular(),
        bold: await PdfGoogleFonts.robotoMedium(),
        google_font_family: GoogleFonts.roboto().fontFamily!,
      ),
      WpeFont(
        name: 'OpenSans',
        base: await PdfGoogleFonts.openSansRegular(),
        bold: await PdfGoogleFonts.openSansMedium(),
        google_font_family: GoogleFonts.openSans().fontFamily!,
      ),
      WpeFont(
        name: 'Montserrat',
        base: await PdfGoogleFonts.montserratRegular(),
        bold: await PdfGoogleFonts.montserratMedium(),
        google_font_family: GoogleFonts.montserrat().fontFamily!,
      ),
    ];
// FONT FAMILIES FOR VISUALIZER AND PDF

// FONT SIZES FOR VISUALIZER AND PDF
double font_size_name = 12;
double font_size_job_title = 11;
double font_size_website_url = 9;

double font_size_section_title = 11;
double font_size_section_subtitle = 10;
double font_size_section_description = 9;
double font_size_section_timeframe = 8;

double font_size_info_title = 9;
double font_size_info_url = 9;
// FONT SIZES FOR VISUALIZER AND PDF
