// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';
import 'package:xapptor_logic/color/get_main_color_from_remote_svg.dart';
import 'models/product.dart';
import 'package:xapptor_ui/values/ui.dart';
import 'package:xapptor_ui/widgets/webview/webview.dart';
import 'package:xapptor_ui/widgets/custom_card.dart';
import 'package:xapptor_ui/widgets/check_permission.dart';
import 'package:xapptor_ui/widgets/topbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart' as file_picker;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:xapptor_ui/widgets/is_portrait.dart';
import 'package:xapptor_ui/utils/get_platform_name.dart';
import 'package:xapptor_ui/utils/get_browser_name.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({
    super.key,
    required this.product,
    required this.is_editing,
    required this.title_color,
    required this.text_color,
  });

  final Product? product;
  final bool is_editing;
  final Color title_color;
  final Color text_color;

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final TextEditingController _controller_name = TextEditingController();
  final TextEditingController _controller_description = TextEditingController();
  final TextEditingController _controller_price = TextEditingController();
  bool is_editing = false;
  String url = "";
  String current_image_file_base64 = "";
  String current_image_file_name = "";
  String upload_image_button_label = "Subir imágen SVG";
  Color main_color = Colors.grey;

  @override
  void dispose() {
    _controller_name.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    set_values();
    check_main_color();
  }

  // Checking main color.

  check_main_color() async {
    if (widget.product != null) {
      main_color = await get_main_color_from_remote_svg(widget.product!.image_src);
      setState(() {});
    }
  }

  // Setting product values.

  set_values() {
    _controller_name.text = widget.product?.name ?? "";
    _controller_price.text = widget.product?.price.toString() ?? "";
    _controller_description.text = widget.product?.description ?? "";
    url = widget.product?.image_src ?? "";
    is_editing = widget.is_editing;
    setState(() {});
  }

  // Save changes, alert dialog.

  show_save_data_alert_dialog({
    required BuildContext context,
  }) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("¿Deseas guardar los cambios?"),
          actions: [
            TextButton(
              child: const Text("Descartar cambios"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              onPressed: save_product_changes,
              child: const Text("Aceptar"),
            ),
          ],
        );
      },
    );
  }

  // Save product changes.

  save_product_changes() async {
    if (widget.product == null) {
      if (current_image_file_base64.isEmpty ||
          _controller_name.text.isEmpty ||
          _controller_description.text.isEmpty ||
          _controller_price.text.isEmpty) {
        Navigator.of(context).pop();
        SnackBar snackBar = const SnackBar(
          content: Text("Debes llenar todos los campos"),
          duration: Duration(seconds: 2),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        try {
          await firebase_storage.FirebaseStorage.instance
              .ref('images/products/$current_image_file_name')
              .putString(current_image_file_base64, format: firebase_storage.PutStringFormat.dataUrl)
              .then((firebase_storage.TaskSnapshot task_snapshot) async {
            String products_length_text = "";

            await FirebaseFirestore.instance.collection("products").get().then((collection_snapshot) {
              products_length_text = (collection_snapshot.size + 1).toString();
            });

            while (products_length_text.length < 3) {
              products_length_text = "0$products_length_text";
            }

            String new_product_id = "zzzzzzzzzzzzzzzzz$products_length_text";

            FirebaseFirestore.instance.collection("products").doc(new_product_id).set({
              "name": _controller_name.text,
              "description": _controller_description.text,
              "price": int.parse(_controller_price.text),
              "url": await task_snapshot.ref.getDownloadURL(),
            }).then((result) {
              is_editing = false;
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            });
          });
        } catch (e) {
          debugPrint("Error: $e");
        }
      }
    } else {
      if (current_image_file_base64 != "") {
        await firebase_storage.FirebaseStorage.instance
            .refFromURL(widget.product!.image_src)
            .delete()
            .then((value) async {
          await firebase_storage.FirebaseStorage.instance
              .ref('images/products/$current_image_file_name')
              .putString(current_image_file_base64, format: firebase_storage.PutStringFormat.dataUrl)
              .then((firebase_storage.TaskSnapshot task_snapshot) async {
            FirebaseFirestore.instance.collection("products").doc(widget.product!.id).update({
              "name": _controller_name.text,
              "description": _controller_description.text,
              "price": int.parse(_controller_price.text),
              "url": await task_snapshot.ref.getDownloadURL(),
            }).then((result) {
              is_editing = false;
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            });
          });
        });
      } else {
        FirebaseFirestore.instance.collection("products").doc(widget.product!.id).update({
          "name": _controller_name.text,
          "description": _controller_description.text,
          "price": int.parse(_controller_price.text),
        }).then((result) {
          is_editing = false;
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        });
      }
    }
  }

  // Open file picker for image selection.

  open_file_picker(BuildContext context) async {
    await check_permission(
      platform_name: get_platform_name(),
      browser_name: await get_browser_name(),
      context: context,
      title: "Debes dar permiso al almacenamiento para la selección de imágen",
      label_no: "Cancelar",
      label_yes: "Aceptar",
      permission_type: Permission.storage,
    );

    await file_picker.FilePicker.platform
        .pickFiles(
      type: file_picker.FileType.custom,
      allowedExtensions: ['svg'],
      withData: true,
    )
        .then((file_picker.FilePickerResult? result) async {
      if (result != null) {
        current_image_file_base64 = "data:image/svg+xml;base64,${base64Encode(result.files.first.bytes!)}";
        current_image_file_name = result.files.first.name;
        upload_image_button_label = current_image_file_name;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool portrait = is_portrait(context);
    double screen_height = MediaQuery.of(context).size.height;
    double textfield_size = 18;

    return Scaffold(
      appBar: TopBar(
        context: context,
        background_color: main_color,
        has_back_button: true,
        actions: [],
        custom_leading: null,
        logo_path: "assets/images/logo.png",
        logo_color: Colors.white,
      ),
      body: Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: FractionallySizedBox(
              widthFactor: portrait ? 0.7 : 0.2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: sized_box_space * 4,
                  ),
                  widget.product == null
                      ? Container()
                      : SizedBox(
                          height: screen_height / 3,
                          width: screen_height / 3,
                          child: Webview(
                            id: const Uuid().v8(),
                            src: widget.product!.image_src,
                          ),
                        ),
                  TextField(
                    onTap: () {
                      //
                    },
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: widget.title_color,
                      fontSize: textfield_size,
                    ),
                    controller: _controller_name,
                    decoration: InputDecoration(
                      hintText: "Nombre",
                      hintStyle: TextStyle(
                        color: widget.title_color,
                        fontSize: textfield_size,
                      ),
                    ),
                    enabled: is_editing,
                  ),
                  SizedBox(
                    height: sized_box_space * 2,
                  ),
                  SizedBox(
                    height: 40,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            "\$",
                            style: TextStyle(
                              color: widget.text_color,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 6,
                          child: TextField(
                            onTap: () {
                              //
                            },
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: widget.text_color,
                              fontSize: textfield_size,
                            ),
                            controller: _controller_price,
                            decoration: InputDecoration(
                              hintText: "Precio",
                              hintStyle: TextStyle(
                                color: widget.text_color,
                                fontSize: textfield_size,
                              ),
                            ),
                            enabled: is_editing,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const Spacer(flex: 1),
                        Expanded(
                          flex: 16,
                          child: CustomCard(
                            border_radius: 10,
                            on_pressed: () {
                              if (is_editing) {
                                open_file_picker(context);
                              }
                            },
                            linear_gradient: const LinearGradient(
                              colors: [
                                Colors.white,
                                Colors.white,
                              ],
                            ),
                            splash_color: widget.text_color.withOpacity(is_editing ? 0.3 : 0),
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                upload_image_button_label,
                                style: TextStyle(
                                  color: widget.text_color,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Spacer(flex: 1),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: sized_box_space * 2,
                  ),
                  TextField(
                    onTap: () {
                      //
                    },
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: widget.text_color,
                      fontSize: textfield_size,
                    ),
                    controller: _controller_description,
                    decoration: InputDecoration(
                      hintText: "Descripción",
                      hintStyle: TextStyle(
                        color: widget.text_color,
                        fontSize: textfield_size,
                      ),
                    ),
                    enabled: is_editing,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                  ),
                  SizedBox(
                    height: sized_box_space * 4,
                  ),
                ],
              ),
            ),
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
        backgroundColor: main_color,
        child: Icon(
          is_editing ? Icons.done : Icons.edit,
          color: Colors.white,
        ),
      ),
    );
  }
}
