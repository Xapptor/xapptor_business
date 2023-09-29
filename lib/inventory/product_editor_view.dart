import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:xapptor_business/inventory/set_product.dart';
import 'package:xapptor_business/models/product.dart';
import 'package:xapptor_logic/check_if_user_is_admin.dart';
import 'package:xapptor_logic/form_field_validators.dart';
import 'package:xapptor_ui/widgets/is_portrait.dart';
import 'package:xapptor_ui/values/ui.dart';
import 'package:xapptor_ui/widgets/topbar.dart';

class ProductEditorView extends StatefulWidget {
  const ProductEditorView({super.key, 
    required this.category_id,
    required this.product,
    required this.is_a_product_category,
    required this.main_color,
    required this.text_list,
    required this.confirmation_text_list,
  });

  final String? category_id;
  final Product product;
  final bool is_a_product_category;
  final Color main_color;
  final List<String> text_list;
  final List<String> confirmation_text_list;

  @override
  _ProductEditorViewState createState() => _ProductEditorViewState();
}

class _ProductEditorViewState extends State<ProductEditorView> {
  TextEditingController name_input_controller = TextEditingController();
  TextEditingController image_input_controller = TextEditingController();
  TextEditingController price_input_controller = TextEditingController();
  TextEditingController description_input_controller = TextEditingController();
  TextEditingController quantity_input_controller = TextEditingController();
  bool is_admin = false;

  Uint8List? image_data;
  String image_name = '';
  bool use_image_url = false;

  @override
  void initState() {
    super.initState();
    check_if_is_admin();
  }

  check_if_is_admin() async {
    is_admin = await check_if_user_is_admin(null);
    fill_params();
  }

  fill_params() {
    name_input_controller.text = widget.product.name;
    image_input_controller.text = widget.product.image_src;
    if (widget.product.image_src != '') use_image_url = true;
    price_input_controller.text = widget.product.price.toString();
    description_input_controller.text = widget.product.description;
    quantity_input_controller.text = widget.product.inventory_quantity != -1
        ? widget.product.inventory_quantity.toString()
        : '0';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double screen_height = MediaQuery.of(context).size.height;
    double screen_width = MediaQuery.of(context).size.width;
    bool portrait = is_portrait(context);
    String inventory_quantity = widget.product.inventory_quantity.toString();

    return SafeArea(
      top: true,
      child: Scaffold(
        appBar: TopBar(
          context: context,
          background_color: widget.main_color,
          has_back_button: true,
          actions: [],
          custom_leading: null,
          logo_path: "assets/images/logo.png",
        ),
        body: Container(
          color: Colors.white,
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: SizedBox(
              width: screen_width,
              child: FractionallySizedBox(
                widthFactor: portrait ? 0.9 : 0.5,
                child: Column(
                  children: [
                    SizedBox(
                      height: sized_box_space * 4,
                    ),
                    Text(
                      widget.text_list[0],
                      style: TextStyle(
                        color: widget.main_color,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextFormField(
                      style: TextStyle(
                        color: widget.main_color,
                      ),
                      decoration: InputDecoration(
                        labelText: widget.text_list[1],
                        labelStyle: TextStyle(
                          color: widget.main_color,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: widget.main_color,
                          ),
                        ),
                      ),
                      controller: name_input_controller,
                      validator: (value) => FormFieldValidators(
                        value: value!,
                        type: FormFieldValidatorsType.name,
                      ).validate(),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          flex: portrait ? 10 : 20,
                          child: TextFormField(
                            onChanged: (value) {
                              use_image_url = true;
                              setState(() {});
                            },
                            style: TextStyle(
                              color: widget.main_color,
                            ),
                            decoration: InputDecoration(
                              labelText: widget.text_list[2],
                              labelStyle: TextStyle(
                                color: widget.main_color,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: widget.main_color,
                                ),
                              ),
                            ),
                            controller: image_input_controller,
                            validator: (value) => FormFieldValidators(
                              value: value!,
                              type: FormFieldValidatorsType.name,
                            ).validate(),
                          ),
                        ),
                        const Spacer(flex: 1),
                        Expanded(
                          flex: 10,
                          child: ElevatedButton(
                            onPressed: () async {
                              FilePickerResult? result =
                                  await FilePicker.platform.pickFiles();
                              if (result != null) {
                                image_data = result.files.single.bytes!;
                                image_name = result.files.single.name;
                                use_image_url = false;
                                setState(() {});
                              }
                            },
                            style: ButtonStyle(
                              elevation: MaterialStateProperty.all<double>(
                                0,
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                widget.main_color,
                              ),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    MediaQuery.of(context).size.width,
                                  ),
                                ),
                              ),
                            ),
                            child: Text(
                              widget.text_list[6],
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: sized_box_space * 2,
                    ),
                    image_input_controller.text != "" || image_data != null
                        ? Container(
                            decoration: BoxDecoration(
                              color: widget.main_color,
                              borderRadius: BorderRadius.circular(
                                20,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                20,
                              ),
                              child: use_image_url
                                  ? image_input_controller.text.contains('http')
                                      ? Image.network(
                                          image_input_controller.text,
                                          fit: BoxFit.fitWidth,
                                        )
                                      : Image.asset(
                                          image_input_controller.text,
                                          fit: BoxFit.fitWidth,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Container(),
                                        )
                                  : Image.memory(
                                      image_data!,
                                      fit: BoxFit.fitWidth,
                                    ),
                            ),
                          )
                        : Container(),
                    SizedBox(
                      height: sized_box_space,
                    ),
                    !widget.is_a_product_category
                        ? TextFormField(
                            style: TextStyle(
                              color: widget.main_color,
                            ),
                            decoration: InputDecoration(
                              labelText: widget.text_list[3],
                              labelStyle: TextStyle(
                                color: widget.main_color,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: widget.main_color,
                                ),
                              ),
                            ),
                            controller: price_input_controller,
                            validator: (value) => FormFieldValidators(
                              value: value!,
                              type: FormFieldValidatorsType.name,
                            ).validate(),
                          )
                        : Container(),
                    TextFormField(
                      style: TextStyle(
                        color: widget.main_color,
                      ),
                      decoration: InputDecoration(
                        labelText: widget.text_list[4],
                        labelStyle: TextStyle(
                          color: widget.main_color,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: widget.main_color,
                          ),
                        ),
                      ),
                      controller: description_input_controller,
                      validator: (value) => FormFieldValidators(
                        value: value!,
                        type: FormFieldValidatorsType.name,
                      ).validate(),
                    ),
                    is_admin &&
                            widget.product.id != '' &&
                            !widget.is_a_product_category
                        ? TextFormField(
                            style: TextStyle(
                              color: widget.main_color,
                            ),
                            decoration: InputDecoration(
                              labelText: widget.text_list[5],
                              labelStyle: TextStyle(
                                color: widget.main_color,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: widget.main_color,
                                ),
                              ),
                            ),
                            controller: quantity_input_controller,
                            validator: (value) => FormFieldValidators(
                              value: value!,
                              type: FormFieldValidatorsType.name,
                            ).validate(),
                          )
                        : Container(),
                    SizedBox(
                      height: sized_box_space * 2,
                    ),
                    SizedBox(
                      width: portrait ? double.infinity : screen_width * 0.1,
                      child: ElevatedButton(
                        onPressed: () async {
                          confirmation_alert(
                            context: context,
                            text_list: widget.confirmation_text_list,
                          );
                        },
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all<double>(
                            0,
                          ),
                          backgroundColor: MaterialStateProperty.all<Color>(
                            widget.main_color,
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                MediaQuery.of(context).size.width,
                              ),
                            ),
                          ),
                        ),
                        child: Text(
                          widget.text_list[7],
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
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
      ),
    );
  }

  confirmation_alert({
    required BuildContext context,
    required List<String> text_list,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(widget.confirmation_text_list[0]),
          actions: <Widget>[
            TextButton(
              child: Text(widget.confirmation_text_list[1]),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(widget.confirmation_text_list[2]),
              onPressed: () async {
                Product product = Product(
                  id: widget.product.id,
                  name: name_input_controller.text,
                  image_src: image_input_controller.text,
                  price: int.tryParse(price_input_controller.text) ?? 0,
                  description: description_input_controller.text,
                  is_a_product_category: widget.is_a_product_category,
                  inventory_quantity: int.parse(
                    quantity_input_controller.text,
                  ),
                );
                await set_product(
                  product,
                  image_data,
                  image_name,
                  widget.category_id ?? '',
                );
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
