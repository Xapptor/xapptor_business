import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:xapptor_business/models/site.dart';
import 'package:xapptor_business/models/wpe.dart';
import 'package:xapptor_business/site/get_site.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/crud/read/get_slot_label.dart';
//todo: eliminar sino se va a usar cambio de tipo de letras
//import 'package:xapptor_business/workplace_exam/wpe_editor/wpe_editor_additional_options.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/wpe_editor_fab.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/wpe_editor_init_state.dart';
//todo: eliminar sino se va a usar preview
//import 'package:xapptor_business/workplace_exam/wpe_editor/wpe_editor_preview.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/wpe_editor_section_header.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/wpe_editor_section_other.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/wpe_editor_section_ericp.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/wpe_editor_section_maintenance.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/wpe_editor_section_supervisor.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/wpe_editor_text_lists.dart';
import 'package:xapptor_business/workplace_exam/models/wpe_section.dart';
//todo: eliminar sino se va a usar botones arriba
//import 'package:xapptor_business/workplace_exam/wpe_editor/wpe_editor_top_option_buttons.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/wpe_sections.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/crud/update/update_source_language.dart';
import 'package:xapptor_translation/language_picker.dart';
import 'package:xapptor_translation/model/text_list.dart';
import 'package:xapptor_translation/translation_stream.dart';
import 'package:xapptor_ui/widgets/top_and_bottom/topbar.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WpeEditor extends StatefulWidget {
  final Color color_topbar;
  final String base_url;
  final double text_bottom_margin_for_section;
  final String organization_name;

  const WpeEditor({
    super.key,
    required this.color_topbar,
    required this.base_url,
    this.text_bottom_margin_for_section = 3,
    required this.organization_name,
  });

  @override
  State<WpeEditor> createState() => WpeEditorState();
}

class WpeEditorState extends State<WpeEditor> {
  //Header Section
  String wpe_number = '';
  DateTime wpe_date = DateTime.now();
  String shift_input_controller = '';
  String area_input_controller = '';
  String supervisor_input_controller = '';
  TextEditingController specific_input_controller = TextEditingController();

  //Other Section
  TextEditingController order_input_controller = TextEditingController();
  String transversal_input_controller = '';
  String maintenance_input_controller = '';

  //ERICP Section
  TextEditingController eliminated_input_controller = TextEditingController();
  TextEditingController reduced_input_controller = TextEditingController();
  TextEditingController isolated_input_controller = TextEditingController();
  TextEditingController controled_input_controller = TextEditingController();
  TextEditingController ppe_input_controller = TextEditingController();

  //Maintenance Section
  TextEditingController maint_cmmt_input_controller = TextEditingController();

  //Supervisor Section
  TextEditingController supervisor_cmmt_input_controller =
      TextEditingController();

  TextEditingController sections_by_page_input_controller =
      TextEditingController();

  FocusNode focus_node_1 = FocusNode();
  FocusNode focus_node_2 = FocusNode();
  FocusNode focus_node_3 = FocusNode();
  FocusNode focus_node_4 = FocusNode();
  FocusNode focus_node_5 = FocusNode();
  FocusNode focus_node_6 = FocusNode();
  FocusNode focus_node_7 = FocusNode();
  FocusNode focus_node_8 = FocusNode();
  FocusNode focus_node_9 = FocusNode();
  FocusNode focus_node_10 = FocusNode();

  double screen_height = 0;
  double screen_width = 0;

  late TranslationTextListArray text_list;
  TranslationTextListArray alert_text_list =
      WpeEditorTextLists().alert_text_list;
  TranslationTextListArray education_text_list =
      WpeEditorTextLists().education_text_list;
  TranslationTextListArray picker_text_list =
      WpeEditorTextLists().picker_text_list;
  TranslationTextListArray sections_by_page_text_list =
      WpeEditorTextLists().sections_by_page_text_list;
  TranslationTextListArray time_text_list = WpeEditorTextLists().time_text_list;

  late TranslationStream translation_stream;
  late TranslationStream education_translation_stream;
  late TranslationStream picker_translation_stream;
  late TranslationStream sections_by_page_translation_stream;
  late TranslationStream time_translation_stream;

  List<TranslationStream> translation_stream_list = [];

  int source_language_index = 1;

  String chosen_image_path = "";
  String chosen_image_url = "";
  Uint8List? chosen_image_bytes;

  List<WpeCondition> condition_sections = [];

  Color picker_color = Colors.blue;
  Color current_color = Colors.blue;

  User? current_user;

  int slot_index = 0;
  String slot_value = "";

  GlobalKey<ExpandableFabState> expandable_fab_key =
      GlobalKey<ExpandableFabState>();

  List<Wpe> wpes = [];

  bool asked_for_backup_alert = false;

  String current_wpe_id = "";

  //List envoirement
  Site? site;
  late List<String> area_list;
  late List<String> transversal_list;
  //todo Cambiar por consulta a la BD
  List<String> supervisor_list = [
    'Caldwell Parker',
    'Juan Suarez',
    'Kasimir Frazier'
  ];
  List<String> maintenance_list = ['Andrew Quinn', 'Juan Suarez'];

  retrieve_site() async {
    site = await get_site('zKxyFr2xtIcCEcWZqCNq');

    if (site != null) {
      area_list = site!.areas.map((areaObj) => areaObj.area).toList();
      transversal_list =
          site!.transversals.map((transObj) => transObj.location).toList();
    } else {
      area_list = [];
      transversal_list = [];
    }

    // if (site != null) print(site!.to_json());
  }

  @override
  void initState() {
    init_text_lists();

    super.initState();

    wpe_editor_init_state();

    retrieve_site();
  }

  init_text_lists() {
    text_list = WpeEditorTextLists().text_list(
      organization_name: widget.organization_name,
    );
  }

  @override
  Widget build(BuildContext context) {
    screen_height = MediaQuery.of(context).size.height;
    screen_width = MediaQuery.of(context).size.width;
    bool portrait = screen_height > screen_width;

    Widget body = Container(
      color: Colors.white,
      width: double.maxFinite,
      child: Center(
        child: CircularProgressIndicator(
          color: widget.color_topbar,
        ),
      ),
    );

    if (wpes.isNotEmpty) {
      Wpe current_wpe = wpes
          .firstWhere((element) => element.id == current_wpe_id, orElse: () {
        return wpes.firstWhere((element) => !element.id.contains("_bu"));
      });

      String slot_label = get_slot_label(
        slot_index: slot_index,
      );

      body = Stack(
        children: [
          Container(
            color: Colors.white,
            width: double.maxFinite,
            child: ListView(
              children: [
                FractionallySizedBox(
                  widthFactor: portrait ? 0.9 : 0.4,
                  child: Column(
                    children: [
                      //wpe_editor_top_option_buttons(),
                      wpe_editor_section_header(),
                      wpe_editor_section_other(),
                      wpe_editor_section_ericp(),
                      wpe_sections(),
                      wpe_editor_section_maintenance(),
                      wpe_editor_section_supervisor(),
                      // if (font_families_value.isNotEmpty)
                      //   WpeEditorAdditionalOptions(
                      //     callback: () {
                      //       setState(() {});
                      //     },
                      //   ),
                    ],
                  ),
                ),
                // wpe_editor_preview(
                //   context: context,
                //   portrait: portrait,
                //   wpe: current_wpe,
                //   base_url: widget.base_url,
                // ),
                const SizedBox(height: 100),
              ],
            ),
          ),
          Container(
            color: widget.color_topbar.withOpacity(0.7),
            width: double.maxFinite,
            height: 40,
            child: Center(
              child: Text(
                "${alert_text_list.get(source_language_index)[13]}: $slot_label",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: TopBar(
        context: context,
        background_color: widget.color_topbar,
        has_back_button: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 20),
            width: 150,
            child: LanguagePicker(
              translation_stream_list: translation_stream_list,
              language_picker_items_text_color: widget.color_topbar,
              update_source_language: update_source_language,
            ),
          ),
        ],
        custom_leading: null,
        logo_path: "assets/images/logo.png",
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: current_user != null ? wpe_editor_fab() : null,
      body: body,
    );
  }
}
