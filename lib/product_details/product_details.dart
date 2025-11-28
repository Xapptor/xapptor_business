import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:xapptor_business/models/product.dart';
import 'package:xapptor_business/product_details/open_file_picker.dart';
import 'package:xapptor_business/product_details/show_save_data_alert_dialog.dart';
import 'package:xapptor_logic/color/get_main_color_from_remote_svg.dart';
import 'package:xapptor_ui/values/ui.dart';
import 'package:xapptor_ui/widgets/webview/webview.dart';
import 'package:xapptor_ui/widgets/card/custom_card.dart';
import 'package:xapptor_ui/widgets/top_and_bottom/topbar.dart';
import 'package:xapptor_ui/utils/is_portrait.dart';

class ProductDetails extends StatefulWidget {
  final Product? product;
  final bool is_editing;
  final Color title_color;
  final Color text_color;

  const ProductDetails({
    super.key,
    required this.product,
    required this.is_editing,
    required this.title_color,
    required this.text_color,
  });

  @override
  State<ProductDetails> createState() => ProductDetailsState();
}

class ProductDetailsState extends State<ProductDetails> {
  final TextEditingController controller_name = TextEditingController();
  final TextEditingController controller_description = TextEditingController();
  final TextEditingController controller_price = TextEditingController();

  bool is_editing = false;
  String url = "";
  String current_image_file_base64 = "";
  String current_image_file_name = "";
  String upload_image_button_label = "Subir imágen SVG";
  Color main_color = Colors.grey;

  @override
  void dispose() {
    controller_name.dispose();
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
    controller_name.text = widget.product?.name ?? "";
    controller_price.text = widget.product?.price.toString() ?? "";
    controller_description.text = widget.product?.description ?? "";
    url = widget.product?.image_src ?? "";
    is_editing = widget.is_editing;
    setState(() {});
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
                  const SizedBox(height: sized_box_space * 4),
                  if (widget.product != null)
                    SizedBox(
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
                    controller: controller_name,
                    decoration: InputDecoration(
                      hintText: "Nombre",
                      hintStyle: TextStyle(
                        color: widget.title_color,
                        fontSize: textfield_size,
                      ),
                    ),
                    enabled: is_editing,
                  ),
                  const SizedBox(height: sized_box_space * 2),
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
                            controller: controller_price,
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
                            splash_color: widget.text_color.withValues(alpha: is_editing ? 0.3 : 0),
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
                  const SizedBox(height: sized_box_space * 2),
                  TextField(
                    onTap: () {
                      //
                    },
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: widget.text_color,
                      fontSize: textfield_size,
                    ),
                    controller: controller_description,
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
                  const SizedBox(height: sized_box_space * 4),
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
