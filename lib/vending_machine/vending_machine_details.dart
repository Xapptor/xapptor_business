import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:xapptor_business/models/vending_machine.dart';
import 'package:xapptor_business/product_list.dart';
import 'package:xapptor_logic/firebase_tasks.dart';
import 'package:xapptor_router/app_screen.dart';
import 'package:xapptor_router/app_screens.dart';
import 'package:xapptor_ui/widgets/custom_card.dart';
import 'package:xapptor_ui/widgets/switch_button.dart';
import 'package:xapptor_ui/widgets/topbar.dart';
import 'package:xapptor_logic/is_portrait.dart';

class VendingMachineDetails extends StatefulWidget {
  const VendingMachineDetails({
    required this.vending_machine,
    required this.topbar_color,
    required this.text_color,
    required this.textfield_color,
  });

  final VendingMachine? vending_machine;
  final Color topbar_color;
  final Color text_color;
  final Color textfield_color;

  @override
  _VendingMachineDetailsState createState() => _VendingMachineDetailsState();
}

class _VendingMachineDetailsState extends State<VendingMachineDetails> {
  TextEditingController _controller_name = TextEditingController();
  TextEditingController _controller_user_id = TextEditingController();
  bool is_editing = false;
  bool enabled = true;

  @override
  void dispose() {
    _controller_name.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    set_values();
  }

  // Callback button switch "enabled" parameter.

  switch_button_callback(bool new_value) async {
    await FirebaseFirestore.instance
        .collection("vending_machines")
        .doc(widget.vending_machine!.id)
        .update({"enabled": new_value}).then((value) {
      setState(() {
        enabled = new_value;
      });
    });
  }

  // Setting vending machine data.

  set_values() {
    if (widget.vending_machine != null) {
      _controller_name.text = widget.vending_machine!.name;
      _controller_user_id.text = widget.vending_machine!.user_id;
      enabled = widget.vending_machine!.enabled;
      setState(() {});
    } else {
      is_editing = true;
    }
  }

  // Save changes, alert dialog.

  show_save_data_alert_dialog({
    required BuildContext context,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("¿Deseas guardar los cambios?"),
          actions: <Widget>[
            TextButton(
              child: Text("Descartar cambios"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Aceptar"),
              onPressed: () async {
                check_vending_machine_data();
              },
            ),
          ],
        );
      },
    );
  }

  // Validating vending machine data.

  check_vending_machine_data() async {
    if (_controller_name.text.isNotEmpty &&
        _controller_user_id.text.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(_controller_user_id.text)
          .get()
          .then((user_snapshot) async {
        var user_snapshot_data = user_snapshot.data();
        if (user_snapshot_data != null) {
          if (widget.vending_machine != null) {
            FirebaseFirestore.instance
                .collection("vending_machines")
                .doc(widget.vending_machine!.id)
                .update({
              "name": _controller_name.text,
              "user_id": _controller_user_id.text,
              "enabled": enabled,
            }).then((result) {
              is_editing = false;
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            });
          } else {
            await FirebaseFirestore.instance
                .collection("products")
                .get()
                .then((collection) async {
              await FirebaseFirestore.instance
                  .collection("vending_machines")
                  .add({
                "name": _controller_name.text,
                "enabled": false,
                "money_change": 0,
                "user_id": _controller_user_id.text,
                "dispensers": [
                  {
                    "enabled": true,
                    "product_id": collection.docs.first.id,
                    "quantity_remaining": 1,
                  },
                ],
              }).then((result) {
                duplicate_item_in_array(
                    document_id: result.id,
                    collection_id: "vending_machines",
                    field_key: "dispensers",
                    index: 0,
                    times: 9,
                    callback: () {
                      is_editing = false;
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    });
              });
            });
          }
        } else {
          Navigator.of(context).pop();
          SnackBar snackBar = SnackBar(
            content: Text("Debes ingresar un ID de usuario válido"),
            duration: Duration(seconds: 2),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      });
    } else {
      Navigator.of(context).pop();
      SnackBar snackBar = SnackBar(
        content: Text("Debes llenar todos los campos"),
        duration: Duration(seconds: 2),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    double textfield_size = 24;
    double title_size = 20;
    double subtitle_size = 18;
    bool portrait = is_portrait(context);
    double screen_width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: TopBar(
        context: context,
        background_color: widget.topbar_color,
        has_back_button: true,
        actions: [],
        custom_leading: null,
        logo_path: "assets/images/logo.png",
        logo_color: Colors.white,
      ),
      body: Container(
        alignment: Alignment.center,
        color: Colors.white,
        child: FractionallySizedBox(
          widthFactor: portrait ? 0.7 : 0.2,
          child: Column(
            children: [
              Spacer(flex: 4),
              Expanded(
                flex: 2,
                child: TextField(
                  onTap: () {
                    //
                  },
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: widget.textfield_color,
                    fontSize: textfield_size,
                  ),
                  controller: _controller_name,
                  decoration: InputDecoration(
                    hintText: "Nombre",
                    hintStyle: TextStyle(
                      color: widget.textfield_color,
                      fontSize: textfield_size,
                    ),
                  ),
                  enabled: is_editing,
                ),
              ),
              Expanded(
                flex: 2,
                child: TextField(
                  onTap: () {
                    //
                  },
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: widget.textfield_color,
                    fontSize: textfield_size,
                  ),
                  controller: _controller_user_id,
                  decoration: InputDecoration(
                    hintText: "ID de usuario",
                    hintStyle: TextStyle(
                      color: widget.textfield_color,
                      fontSize: textfield_size,
                    ),
                  ),
                  enabled: is_editing,
                ),
              ),
              widget.vending_machine == null
                  ? Container()
                  : Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              "CAMBIO \$" +
                                  (widget.vending_machine?.money_change
                                          .toString() ??
                                      "0"),
                              style: TextStyle(
                                color: Colors.pink,
                                fontSize: title_size,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: FractionallySizedBox(
                              heightFactor: 0.8,
                              widthFactor: 0.7,
                              child: switch_button(
                                text: enabled ? "HABILITADO" : "DESHABILITADO",
                                value: enabled,
                                enabled: is_editing,
                                active_track_color:
                                    widget.text_color.withOpacity(0.5),
                                active_color: Colors.lightGreen,
                                inactive_color:
                                    !is_editing ? Colors.grey : Colors.red,
                                background_color: widget.topbar_color,
                                callback: switch_button_callback,
                                border_radius:
                                    MediaQuery.of(context).size.width,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: FractionallySizedBox(
                              heightFactor: 0.8,
                              widthFactor: 0.7,
                              child: Container(
                                child: CustomCard(
                                  child: Center(
                                    child: Text(
                                      "DISPENSADORES",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  border_radius:
                                      MediaQuery.of(context).size.width,
                                  on_pressed: () {
                                    add_new_app_screen(
                                      AppScreen(
                                        name:
                                            "home/vending_machine_details/dispensers_list",
                                        child: ProductList(
                                          vending_machine_id:
                                              widget.vending_machine!.id,
                                          allow_edit: true,
                                          has_topbar: true,
                                          for_dispensers: true,
                                          text_color: widget.text_color,
                                          topbar_color: widget.topbar_color,
                                          title_color: widget.textfield_color,
                                        ),
                                      ),
                                    );
                                    open_screen(
                                        "home/vending_machine_details/dispensers_list");
                                  },
                                  linear_gradient: LinearGradient(
                                    colors: [
                                      widget.topbar_color.withOpacity(0.4),
                                      widget.textfield_color.withOpacity(0.4),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
              Spacer(flex: 4),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (is_editing) {
              show_save_data_alert_dialog(
                context: context,
              );
            } else {
              is_editing = true;
            }
          });
        },
        backgroundColor: widget.textfield_color,
        child: Icon(
          is_editing ? Icons.done : Icons.edit,
          color: Colors.white,
        ),
      ),
    );
  }
}
