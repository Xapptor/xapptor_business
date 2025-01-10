import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:xapptor_business/models/wpe.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:xapptor_business/workplace_exam/wpe_editor/wpe_editor.dart';
import 'package:xapptor_router/app_screen.dart';
import 'package:xapptor_router/app_screens.dart';
import 'package:xapptor_translation/model/text_list.dart';
import 'package:xapptor_translation/translation_stream.dart';
import 'package:xapptor_ui/widgets/top_and_bottom/topbar.dart';
import 'package:xapptor_db/xapptor_db.dart';
import 'package:intl/intl.dart'; // Importar la librería intl
import 'package:xapptor_ui/utils/is_portrait.dart';

class WpeList extends StatefulWidget {
  final Color language_picker_items_text_color;
  final bool language_picker;
  final Color text_color;
  final Color topbar_color;
  final String website;

  const WpeList({
    super.key,
    required this.language_picker_items_text_color,
    required this.language_picker,
    required this.text_color,
    required this.topbar_color,
    required this.website,
  });

  @override
  State createState() => _WpeListState();
}

class _WpeListState extends State<WpeList> {
  List<Wpe> wpes = <Wpe>[];
  Map<String, dynamic> user_info = {};

  TranslationTextListArray text_list = TranslationTextListArray([
    TranslationTextList(
      source_language: "en",
      text_list: ["You don't have DOCs"],
    ),
  ]);

  late TranslationStream translation_stream;
  List<TranslationStream> translation_stream_list = [];

  int source_language_index = 0;

  update_source_language({
    required int new_source_language_index,
  }) {
    source_language_index = new_source_language_index;
    setState(() {});
  }

  update_text_list({
    required int index,
    required String new_text,
    required int list_index,
  }) {
    text_list.get(source_language_index)[index] = new_text;
    setState(() {});
  }

  get_wpes() async {
    //user_info = await get_user_info(FirebaseAuth.instance.currentUser!.uid);
    wpes.clear();

    QuerySnapshot wpe_snaps = await XapptorDB.instance
        .collection("wpes")
        .where("site_id", isEqualTo: 'zKxyFr2xtIcCEcWZqCNq')
        .get();

    wpes = wpe_snaps.docs
        .map((wpe_snap) => Wpe.from_snapshot(
              wpe_snap.id,
              wpe_snap.data() as Map<String, dynamic>,
            ))
        .toList();
    wpes.sort((a, b) => b.number.compareTo(a.number));
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    get_wpes();

    translation_stream = TranslationStream(
      translation_text_list_array: text_list,
      update_text_list_function: update_text_list,
      list_index: 0,
      source_language_index: source_language_index,
    );

    translation_stream_list = [
      translation_stream,
    ];
  }

  @override
  Widget build(BuildContext context) {
    bool portrait = is_portrait(context);

    return PopScope(
      canPop: true,
      child: Scaffold(
        appBar: TopBar(
          context: context,
          background_color: widget.text_color,
          has_back_button: true,
          actions: [],
          custom_leading: null,
          logo_path: "assets/images/logo.png",
        ),
        body: wpes.isNotEmpty
            ? Align(
                alignment: Alignment.topCenter,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    columnSpacing: portrait ? 20 : 56,
                    sortColumnIndex: 0,
                    sortAscending: true,
                    columns: const [
                      DataColumn(label: Text('ID')),
                      DataColumn(label: Text('Date')),
                      DataColumn(label: Text('Shift')),
                      DataColumn(label: Text('Supervisor')),
                      DataColumn(label: Text('Area')),
                      DataColumn(label: Text('Status')),
                    ],
                    rows: wpes.map((document) {
                      return DataRow(
                        cells: [
                          DataCell(
                            Text(document.number.toString()),
                            onTap: () {
                              String wpe_id = document.id;
                              add_new_app_screen(
                                AppScreen(
                                  name: "home/wpes/$wpe_id",
                                  child: WpeEditor(
                                    id: wpe_id,
                                    color_topbar: widget.topbar_color,
                                    base_url: widget.website,
                                    organization_name:
                                        'American Business Excellence',
                                  ),
                                ),
                              );
                              open_screen("home/wpes/$wpe_id");
                            },
                          ),
                          DataCell(Text(DateFormat('MM/dd/yy')
                              .format(document.date_wpe.toDate())
                              .toString())),
                          DataCell(Text(document.shift)),
                          DataCell(Text(document.supervisor_name)),
                          DataCell(Text(document.area)),
                          DataCell(
                            Text(
                              document.close ? "Close" : "Open",
                              style: TextStyle(
                                  color: document.close
                                      ? Colors.red
                                      : Colors.green),
                            ),
                          ),
                          //DataCell(Text(document.close ? 'Yes' : 'No')),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              )
            : Center(
                child: Text(
                  text_list.get(source_language_index)[0],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            String wpe_id = "New";
            add_new_app_screen(
              AppScreen(
                name: "home/wpes/$wpe_id",
                child: WpeEditor(
                  id: wpe_id,
                  color_topbar: widget.topbar_color,
                  base_url: widget.website,
                  organization_name: 'American Business Excellence',
                ),
              ),
            );
            open_screen("home/wpes/$wpe_id");
          },
          backgroundColor: Colors.green,
          tooltip: 'Add Workplace Exam',
          child: const Icon(
            FontAwesomeIcons.clipboardList,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
