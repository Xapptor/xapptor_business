import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:xapptor_logic/firebase_tasks.dart';
import 'package:xapptor_logic/random_number_with_range.dart';
import 'package:xapptor_router/app_screens.dart';
import 'package:xapptor_translation/language_picker.dart';
import 'package:xapptor_translation/model/text_list.dart';
import 'package:xapptor_translation/translation_stream.dart';
import 'models/product.dart';
import 'payment_webview.dart';
import 'package:xapptor_ui/values/ui.dart';
import 'package:xapptor_ui/widgets/custom_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:xapptor_ui/widgets/is_portrait.dart';
import 'package:xapptor_ui/widgets/loading.dart';
import 'product_catalog_item.dart';
import 'package:xapptor_ui/widgets/topbar.dart';

class ProductCatalog extends StatefulWidget {
  ProductCatalog({
    this.topbar_color,
    this.language_picker_items_text_color,
    required this.products,
    required this.linear_gradients,
    required this.translation_text_list_array,
    required this.background_color,
    required this.title_color,
    required this.subtitle_color,
    required this.text_color,
    required this.button_color,
    required this.success_url,
    required this.cancel_url,
    required this.use_iap,
    required this.use_coupons,
  });

  final Color? topbar_color;
  final Color? language_picker_items_text_color;
  List<Product> products;
  final List<LinearGradient> linear_gradients;
  final TranslationTextListArray translation_text_list_array;
  final Color background_color;
  final Color title_color;
  final Color subtitle_color;
  final Color text_color;
  final Color button_color;
  final String success_url;
  final String cancel_url;
  final bool use_iap;
  final bool use_coupons;

  @override
  _ProductCatalogState createState() => _ProductCatalogState();
}

class _ProductCatalogState extends State<ProductCatalog> {
  TextEditingController coupon_controller = TextEditingController();
  bool loading = false;

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
    widget.translation_text_list_array.get(source_language_index)[index] =
        new_text;
    setState(() {});
  }

  String user_id = "";
  String user_email = "";

  @override
  void initState() {
    // Checking if user is logged.

    if (FirebaseAuth.instance.currentUser != null) {
      User current_user = FirebaseAuth.instance.currentUser!;
      user_id = current_user.uid;
      user_email = current_user.email!;
    }

    if (widget.topbar_color != null &&
        widget.language_picker_items_text_color != null) {
      translation_stream = TranslationStream(
        translation_text_list_array: widget.translation_text_list_array,
        update_text_list_function: update_text_list,
        list_index: 0,
        source_language_index: source_language_index,
      );
      translation_stream_list = [translation_stream];
    }

    if (widget.use_iap) {
      _subscription = InAppPurchase.instance.purchaseStream.listen(
        (purchase_details_list) {
          _listen_to_purchase_updated(purchase_details_list);
        },
        onDone: () {
          _subscription.cancel();
        },
        onError: (error) {
          // handle error here.
        },
      );
    }

    super.initState();
  }

  @override
  void dispose() {
    if (widget.use_iap) {
      _subscription.cancel();
    }
    super.dispose();
  }

  late StreamSubscription<List<PurchaseDetails>> _subscription;

  _listen_to_purchase_updated(List<PurchaseDetails> purchase_details_list) {
    int random_number_1 = random_number_with_range(1000, 2000);
    int random_number_2 = random_number_with_range(500, 1000);
    int random_number_3 = random_number_with_range(100, 500);

    int random_number_timer =
        ((random_number_1 + random_number_2 + random_number_3) *
                (random_number_with_range(1, 9) / 10))
            .toInt();

    print(random_number_timer);

    purchase_details_list.forEach(
      (PurchaseDetails purchase_details) async {
        if (purchase_details.status == PurchaseStatus.pending) {
          //print("payment process pending");
          loading = true;
          setState(() {});
        } else {
          if (purchase_details.status == PurchaseStatus.error) {
            //print("payment process error" + purchase_details.error!.toString());
            loading = false;
            setState(() {});

            show_purchase_result_banner(false, null);
          } else if (purchase_details.status == PurchaseStatus.purchased) {
            //print("payment process success");
            loading = false;
            setState(() {});

            Timer(Duration(milliseconds: random_number_timer), () {
              register_payment(purchase_details.productID);
            });
          } else if (purchase_details.status == PurchaseStatus.restored) {
            loading = false;
            setState(() {});
            restore_purchase(purchase_details.productID);
          }

          if (purchase_details.pendingCompletePurchase) {
            await InAppPurchase.instance.completePurchase(purchase_details);
          }
        }
      },
    );
  }

  restore_purchase(String product_id) async {
    FirebaseFirestore.instance.collection("users").doc(user_id).update({
      "products_acquired": FieldValue.arrayUnion([product_id]),
    }).then((value) {
      show_purchase_result_banner(true, "Purchase Restored");
    });
  }

  register_payment(String product_id) async {
    bool product_was_acquired = await check_if_product_was_acquired(
      user_id: user_id,
      product_id: product_id,
    );
    if (!product_was_acquired) {
      FirebaseFirestore.instance.collection("users").doc(user_id).update({
        "products_acquired": FieldValue.arrayUnion([product_id]),
      }).then((value) {
        FirebaseFirestore.instance.collection("payments").add({
          "payment_intent_id": "",
          "user_id": user_id,
          "product_id": product_id,
          "date": Timestamp.now(),
        }).then((value) {
          show_purchase_result_banner(true, null);
        });
      });
    }
  }

  show_purchase_result_banner(bool purchase_success, String? custom_message) {
    ScaffoldMessenger.of(context).hideCurrentMaterialBanner();

    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        content: Text(
          custom_message ??
              (purchase_success ? "Purchase Successful" : "Purchase Failed"),
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        leading: Icon(
          purchase_success ? Icons.check_circle_rounded : Icons.info,
          color: Colors.white,
        ),
        backgroundColor: purchase_success ? Colors.green : Colors.red,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.close,
              color: Colors.white,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
            },
          ),
        ],
      ),
    );

    Timer(Duration(seconds: 3), () {
      ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
    });
  }

  @override
  Widget build(BuildContext context) {
    bool portrait = is_portrait(context);
    double screen_height = MediaQuery.of(context).size.height;
    double screen_width = MediaQuery.of(context).size.width;

    Widget body = Container(
      color: widget.background_color,
      height: screen_height,
      width: screen_width,
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: FractionallySizedBox(
              widthFactor: 1,
              child: Center(
                child: Text(
                  widget.translation_text_list_array
                      .get(source_language_index)[0],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: widget.title_color,
                    fontSize: 40,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: FractionallySizedBox(
              widthFactor: 0.7,
              child: Text(
                widget.translation_text_list_array
                    .get(source_language_index)[1],
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: widget.subtitle_color,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          widget.use_coupons
              ? Expanded(
                  flex: 4,
                  child: FractionallySizedBox(
                    widthFactor: portrait ? 0.8 : 0.2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextField(
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            labelText: widget.translation_text_list_array
                                .get(source_language_index)[4],
                            labelStyle: TextStyle(
                              color: Colors.white,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(1000),
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(1000),
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          controller: coupon_controller,
                        ),
                        SizedBox(
                          height: sized_box_space,
                        ),
                        Container(
                          height: 50,
                          child: CustomCard(
                            on_pressed: () async {
                              // Checking if coupon is valid.

                              String coupon_id =
                                  coupon_controller.text.isNotEmpty
                                      ? coupon_controller.text
                                      : " ";

                              coupon_controller.clear();

                              String check_coupon_response =
                                  await check_if_coupon_is_valid(
                                coupon_id,
                                context,
                                widget.translation_text_list_array
                                    .get(source_language_index)[6],
                                widget.translation_text_list_array
                                    .get(source_language_index)[7],
                              );

                              if (check_coupon_response.isNotEmpty) {
                                open_screen(check_coupon_response);
                              }
                            },
                            border_radius: 1000,
                            splash_color: widget.text_color.withOpacity(0.3),
                            child: Center(
                              child: Text(
                                widget.translation_text_list_array
                                    .get(source_language_index)[5],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: widget.background_color,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : FractionallySizedBox(
                  widthFactor: portrait ? 0.8 : 0.2,
                  child: Container(
                    height: 50,
                    child: CustomCard(
                      on_pressed: () async {
                        // Restoring previous purchases.

                        await InAppPurchase.instance.restorePurchases();
                      },
                      border_radius: 1000,
                      splash_color: widget.text_color.withOpacity(0.3),
                      child: Center(
                        child: Text(
                          "Restore Purchase",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: widget.background_color,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
          Expanded(
            flex: portrait ? 8 : 14,
            child: ListView.builder(
              itemCount: widget.products.length,
              shrinkWrap: true,
              scrollDirection: portrait ? Axis.horizontal : Axis.horizontal,
              itemBuilder: (context, index) {
                return Container(
                  height: double.maxFinite,
                  width:
                      portrait ? (screen_width * 0.85) : (screen_width / 3.75),
                  child: ProductCatalogItem(
                    title: widget.products[index].name,
                    price: widget.products[index].price.toString(),
                    buy_text: widget.translation_text_list_array
                        .get(source_language_index)[2],
                    icon: Icons.shutter_speed,
                    text_color: widget.text_color,
                    image_url: widget.products[index].image_src,
                    linear_gradient: widget.linear_gradients[index],
                    coming_soon: !widget.products[index].enabled,
                    stripe_payment: Payment(
                      price_id: widget.products[index].price_id,
                      user_id: user_id,
                      product_id: widget.products[index].id,
                      customer_email: user_email,
                      success_url: widget.success_url,
                      cancel_url: widget.cancel_url,
                    ),
                    coming_soon_text: widget.translation_text_list_array
                        .get(source_language_index)[3],
                    button_color: widget.button_color,
                    use_iap: widget.use_iap,
                  ),
                );
              },
            ),
          ),
          portrait ? Container() : Spacer(flex: 2),
        ],
      ),
    );

    return LoadingContainer(
      loading: loading,
      background_color: Colors.white.withOpacity(0.75),
      progress_indicator_color: widget.topbar_color ?? Colors.blueGrey,
      child: widget.topbar_color != null
          ? Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: TopBar(
                context: context,
                background_color: widget.topbar_color!,
                has_back_button: true,
                actions: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: 20),
                    width: 150,
                    child: widget.language_picker_items_text_color != null
                        ? LanguagePicker(
                            translation_stream_list: translation_stream_list,
                            language_picker_items_text_color:
                                widget.language_picker_items_text_color!,
                            update_source_language: update_source_language,
                          )
                        : Container(),
                  ),
                ],
                custom_leading: null,
                logo_path: "assets/images/logo.png",
              ),
              body: body,
            )
          : body,
    );
  }
}

Future<bool> check_if_product_was_acquired({
  required String user_id,
  required String product_id,
}) async {
  DocumentSnapshot user_snap =
      await FirebaseFirestore.instance.collection("users").doc(user_id).get();
  Map user_snap_data = user_snap.data()! as Map;
  List products_acquired = user_snap_data["products_acquired"] ?? [];
  return products_acquired.contains(product_id);
}
