// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:xapptor_business/department/department_fab.dart';
import 'package:xapptor_business/models/site.dart';
import 'package:xapptor_business/site/get_site.dart';
import 'package:xapptor_translation/language_picker.dart';
import 'package:xapptor_translation/model/text_list.dart';
import 'package:xapptor_translation/translation_stream.dart';
import 'package:xapptor_business/department/department_text_lists.dart';
import 'package:xapptor_ui/widgets/top_and_bottom/topbar.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Department extends StatefulWidget {
  //final String id;
  final Color color_topbar;

  const Department({
    super.key,
    //required this.id,
    required this.color_topbar,
  });

  @override
  State<Department> createState() => DepartmentState();
}

class DepartmentState extends State<Department> {
  double screen_height = 0;
  double screen_width = 0;
  //Definicion de variables
  String site_id = '';
  Site? site;
  List department_list = [];
  TextEditingController department_input_controller = TextEditingController();
  Color current_color = Colors.blue;

  late TranslationTextListArray text_list;
  TranslationTextListArray alert_text_list =
      DepartmentTextLists().alert_text_list;

  late TranslationStream translation_stream;

  List<TranslationStream> translation_stream_list = [];

  int source_language_index = 1;

  User? current_user = FirebaseAuth.instance.currentUser!;

  GlobalKey<ExpandableFabState> expandable_fab_key =
      GlobalKey<ExpandableFabState>();

  update_source_language({
    required int new_source_language_index,
  }) {
    source_language_index = new_source_language_index;
  }

  fetching_information() async {
    bool site_retrieving = await retrieve_site();
    print('__1__ $department_list ');
    if (site_retrieving) setState(() {});
  }

  Future<bool> retrieve_site() async {
    site = await get_site('zKxyFr2xtIcCEcWZqCNq');

    if (site != null) {
      department_list = site!.departments;
      site_id = site!.id;
      print('__2__ $department_list ');
      return true;
    } else {
      return false;
    }
  }

  init_text_lists() {
    text_list = DepartmentTextLists().text_list(
      organization_name: "Cambiar por Site_name",
    );
  }

  //open a dialog box to add a register
  void openBoxAdd() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: department_input_controller,
        ),
        actions: [
          //button to add
          ElevatedButton(
            onPressed: () {
              department_list.add(department_input_controller.text);
              department_input_controller.clear();
              Navigator.pop(context);
            },
            child: const Text("Add"),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    init_text_lists();
    super.initState();
    fetching_information();
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
    print('__3__ $department_list ');
    if (department_list.isNotEmpty) {
      body = ListView.builder(
        itemCount: department_list.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(department_list[index]),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                // Eliminar un departamento de la lista
                setState(() {
                  department_list.removeAt(index);
                });
              },
            ),
          );
        },
      );
    }

    return PopScope(
      canPop: true,
      child: Scaffold(
          appBar: TopBar(
            context: context,
            background_color: widget.color_topbar,
            has_back_button: true,
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 20),
                width: 150,
                // child: LanguagePicker(
                //   translation_stream_list: translation_stream_list,
                //   language_picker_items_text_color: widget.color_topbar,
                //   update_source_language: update_source_language,
                //),
              ),
            ],
            custom_leading: null,
            logo_path: "assets/images/logo.png",
          ),
          floatingActionButtonLocation: ExpandableFab.location,
          floatingActionButton: current_user != null ? department_fab() : null,
          body: body),
    );
  }
}
