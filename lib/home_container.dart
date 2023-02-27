import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:xapptor_auth/account_view/account_view.dart';
import 'package:xapptor_auth/model/xapptor_user.dart';
import 'package:xapptor_business/product_catalog.dart';
import 'package:xapptor_logic/check_if_payments_are_enabled.dart';
import 'package:xapptor_business/models/product.dart';
import 'package:xapptor_translation/translation_stream.dart';
import 'package:xapptor_auth/auth_form_type.dart';
import 'package:xapptor_auth/translation_text_values.dart';
import 'package:xapptor_ui/screens/privacy_policy/privacy_policy.dart';
import 'package:xapptor_ui/screens/privacy_policy/privacy_policy_model.dart';
import 'package:xapptor_ui/widgets/card_holder.dart';
import 'package:xapptor_translation/language_picker.dart';
import 'package:xapptor_ui/widgets/loading.dart';
import 'package:xapptor_ui/widgets/topbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:xapptor_router/app_screen.dart';
import 'package:xapptor_router/app_screens.dart';
import 'package:xapptor_ui/widgets/widgets_carousel.dart';
import 'package:xapptor_ui/widgets/is_portrait.dart';
import 'package:xapptor_auth/sign_out.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeContainer extends StatefulWidget {
  final Color topbar_color;
  final String products_collection_name;
  final ProductCatalog? product_catalog;
  final List<CardHolder> cardholder_list_1;
  final List<CardHolder> cardholder_list_2;
  final List<Color> dot_colors_active_1;
  final List<Color> dot_colors_active_2;
  final Color dot_color_inactive_1;
  final Color dot_color_inactive_2;
  final List<ListTile> tile_list;
  final List<String> text_list_menu;
  final List<TranslationStream>? translation_stream_list;
  final List<Tooltip> tooltip_list;
  final bool has_language_picker;
  final String base_url;
  final String logo_path;
  final String? logo_path_white;
  final LinearGradient main_button_color;
  final Function(bool new_value) update_payment_enabled;
  final Function({required int new_source_language_index})?
      update_source_language;
  final PrivacyPolicyModel? privacy_policy_model;
  final bool has_back_button;

  const HomeContainer({
    required this.topbar_color,
    required this.products_collection_name,
    this.product_catalog,
    required this.cardholder_list_1,
    required this.cardholder_list_2,
    required this.dot_colors_active_1,
    required this.dot_colors_active_2,
    required this.dot_color_inactive_1,
    required this.dot_color_inactive_2,
    required this.tile_list,
    required this.text_list_menu,
    this.translation_stream_list,
    required this.tooltip_list,
    required this.has_language_picker,
    required this.base_url,
    required this.logo_path,
    this.logo_path_white,
    required this.main_button_color,
    required this.update_payment_enabled,
    this.update_source_language,
    this.privacy_policy_model,
    this.has_back_button = false,
  });

  @override
  _HomeContainerState createState() => _HomeContainerState();
}

class _HomeContainerState extends State<HomeContainer> {
  late SharedPreferences prefs;
  final GlobalKey<ScaffoldState> scaffold_key = GlobalKey<ScaffoldState>();
  bool auto_scroll = true;

  bool loading = true;

  Widget drawer() {
    return SafeArea(
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: Icon(
                      Icons.close,
                      color: widget.topbar_color,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                ListTile(
                  title: Text(widget.text_list_menu[0]),
                  onTap: () {
                    open_screen("home/account");
                  },
                ),
              ] +
              widget.tile_list +
              [
                ListTile(
                  title: Text(
                      widget.text_list_menu[widget.text_list_menu.length - 2]),
                  onTap: () async {
                    open_screen("home/privacy_policy");
                  },
                ),
                ListTile(
                  title: Text(
                      widget.text_list_menu[widget.text_list_menu.length - 1]),
                  onTap: () async {
                    sign_out(context: context);
                  },
                ),
              ],
        ),
      ),
    );
  }

  List<Widget> widgets_action(bool portrait) {
    return [
      widget.has_language_picker &&
              widget.translation_stream_list != null &&
              widget.update_source_language != null
          ? Container(
              width: 150,
              child: LanguagePicker(
                translation_stream_list: widget.translation_stream_list!,
                language_picker_items_text_color: widget.topbar_color,
                update_source_language: widget.update_source_language!,
              ),
            )
          : Container(),
      portrait || widget.tooltip_list.isEmpty
          ? Container()
          : Row(
              children: [
                    Tooltip(
                      message: widget.text_list_menu[0],
                      child: TextButton(
                        onPressed: () {
                          open_screen("home/account");
                        },
                        child: const Icon(
                          FontAwesomeIcons.user,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ] +
                  widget.tooltip_list,
            ),
      widget.tile_list.isEmpty
          ? Container()
          : IconButton(
              icon: const Icon(
                Icons.menu,
                color: Colors.white,
              ),
              onPressed: () {
                scaffold_key.currentState!.openEndDrawer();
              },
            ),
    ];
  }

  check_permissions() async {
    if (await Permission.storage.isDenied) Permission.storage.request();
  }

  add_screens() {
    add_new_app_screen(
      AppScreen(
        name: "home/account",
        child: AccountView(
          text_list: account_values,
          tc_and_pp_text: RichText(text: const TextSpan()),
          gender_values: gender_values,
          country_values: const [
            'United States',
            'Mexico',
            'Canada',
            'Brazil',
          ],
          text_color: widget.topbar_color,
          first_button_color: widget.main_button_color,
          second_button_color: widget.topbar_color,
          logo_path: widget.logo_path,
          has_language_picker: widget.has_language_picker,
          topbar_color: widget.topbar_color,
          custom_background: null,
          auth_form_type: AuthFormType.edit_account,
          outline_border: true,
          first_button_action: null,
          second_button_action: null,
          has_back_button: true,
          text_field_background_color: null,
        ),
      ),
    );

    if (widget.privacy_policy_model != null) {
      add_new_app_screen(
        AppScreen(
          name: "home/privacy_policy",
          child: PrivacyPolicy(
            privacy_policy_model: widget.privacy_policy_model!,
            use_topbar: true,
            topbar_color: widget.topbar_color,
            logo_path: widget.logo_path_white ?? widget.logo_path,
          ),
        ),
      );
    }
  }

  check_login() {
    if (FirebaseAuth.instance.currentUser != null) {
      loading = false;
      //print("User is sign");
      add_screens();
      check_user_fields();
    } else {
      Timer(const Duration(milliseconds: 3000), () {
        loading = false;
        if (FirebaseAuth.instance.currentUser != null) {
          //print("User is sign");
          add_screens();
        } else {
          //print("User is not sign");
          open_screen("login");
        }
      });
    }
  }

  get_products_for_product_catalog() async {
    List<Product> products = [];
    var query = await FirebaseFirestore.instance
        .collection(widget.products_collection_name)
        .orderBy("price")
        .get();

    query.docs.forEach((course) {
      products.add(
        Product.from_snapshot(
          course.id,
          course.data(),
        ),
      );
    });
    widget.product_catalog!.products = products;
    add_new_app_screen(
      AppScreen(
        name: "home/products",
        child: widget.product_catalog!,
      ),
    );
  }

  bool payment_enabled = false;

  check_payments() async {
    payment_enabled = await check_if_payments_are_enabled();
    widget.update_payment_enabled(payment_enabled);
    setState(() {});
    if (payment_enabled) {
      if (widget.product_catalog != null) {
        get_products_for_product_catalog();
      }
    }
  }

  check_user_fields() async {
    if (FirebaseAuth.instance.currentUser != null) {
      User auth_user = FirebaseAuth.instance.currentUser!;
      DocumentSnapshot user = await FirebaseFirestore.instance
          .collection("users")
          .doc(auth_user.uid)
          .get();

      Map<String, dynamic> user_data = user.data() as Map<String, dynamic>;

      XapptorUser xapptor_user = XapptorUser.from_snapshot(
          auth_user.uid, auth_user.email ?? '', user_data);

      bool firstname_is_empty = xapptor_user.firstname.isEmpty;
      bool lastname_is_empty = xapptor_user.lastname.isEmpty;
      bool country_is_empty = xapptor_user.country.isEmpty;

      if (firstname_is_empty || lastname_is_empty || country_is_empty) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("You need to complete your profile"),
              actions: <Widget>[
                TextButton(
                  child: Text("Logout"),
                  onPressed: () async {
                    sign_out(context: context);
                  },
                ),
                TextButton(
                  child: Text("Ok"),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    open_screen("home/account");
                  },
                ),
              ],
            );
          },
        );
      } else {
        check_user_roles(user_data);
      }
    }
  }

  check_user_roles(Map<String, dynamic> user_data) async {
    if (user_data['roles'] != null) {
      List<String> roles = user_data['roles'].cast<String>();
      if (roles.contains('supervisor') || roles.contains('shift_participant')) {
        open_screen("home/business_solutions");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    check_payments();
    check_login();

    if (UniversalPlatform.isAndroid || UniversalPlatform.isIOS)
      check_permissions();
  }

  int current_page_1 = 1;
  int current_page_2 = 1;

  @override
  Widget build(BuildContext context) {
    bool portrait = is_portrait(context);
    int first_carousel_flex = 1;
    if (widget.cardholder_list_2.isEmpty) {
      if (portrait) {
        first_carousel_flex = 2;
      } else {
        first_carousel_flex = 4;
      }
    }

    return WillPopScope(
      onWillPop: () async => false,
      child: LoadingContainer(
        loading: loading,
        background_color: Colors.white,
        progress_indicator_color: widget.topbar_color,
        child: Scaffold(
          key: scaffold_key,
          endDrawer: widget.tooltip_list.isEmpty ? null : drawer(),
          appBar: TopBar(
            context: context,
            background_color: widget.topbar_color,
            has_back_button: widget.has_back_button,
            actions: widgets_action(portrait),
            custom_leading: widget.has_back_button
                ? IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(FontAwesomeIcons.angleLeft),
                  )
                : null,
            logo_path: widget.logo_path_white ?? widget.logo_path,
          ),
          body: Column(
            children: [
              widget.cardholder_list_2.isEmpty
                  ? Expanded(
                      flex: 1,
                      child: Container(),
                    )
                  : Container(),
              Expanded(
                flex: first_carousel_flex,
                child: FractionallySizedBox(
                  heightFactor: 0.9,
                  child: WidgetsCarousel(
                    update_current_page: (current_page) {
                      if (!UniversalPlatform.isWeb || portrait) {
                        widget.cardholder_list_1.forEach((element) {
                          element.is_focused = false;
                        });
                        widget.cardholder_list_1[current_page].is_focused =
                            true;
                        setState(() {});
                      }
                    },
                    auto_scroll: auto_scroll,
                    dot_colors_active: widget.dot_colors_active_1,
                    dot_color_inactive: widget.dot_color_inactive_1,
                    children: widget.cardholder_list_1,
                  ),
                ),
              ),
              widget.cardholder_list_2.isEmpty
                  ? Expanded(
                      flex: 1,
                      child: Container(),
                    )
                  : Expanded(
                      flex: 1,
                      child: FractionallySizedBox(
                        heightFactor: 0.9,
                        child: WidgetsCarousel(
                          update_current_page: (current_page) {
                            if (!UniversalPlatform.isWeb || portrait) {
                              widget.cardholder_list_2.forEach((element) {
                                element.is_focused = false;
                              });
                              widget.cardholder_list_2[current_page]
                                  .is_focused = true;
                              setState(() {});
                            }
                          },
                          auto_scroll: auto_scroll,
                          dot_colors_active: widget.dot_colors_active_2,
                          dot_color_inactive: widget.dot_color_inactive_2,
                          children: widget.cardholder_list_2,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
