import 'package:flutter/material.dart';
import 'package:xapptor_business/home_container/check_login.dart';
import 'package:xapptor_business/home_container/check_payments.dart';
import 'package:xapptor_business/home_container/drawer.dart';
import 'package:xapptor_business/home_container/widgets_action.dart';
import 'package:xapptor_business/product_catalog.dart';
import 'package:xapptor_translation/translation_stream.dart';
import 'package:xapptor_ui/screens/privacy_policy/privacy_policy_model.dart';
import 'package:xapptor_ui/widgets/card_holder.dart';
import 'package:xapptor_ui/widgets/loading.dart';
import 'package:xapptor_ui/widgets/topbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:xapptor_ui/widgets/widgets_carousel.dart';
import 'package:xapptor_ui/widgets/is_portrait.dart';
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
  final double image_border_radius;
  final LinearGradient main_button_color;
  final Function(bool new_value) update_payment_enabled;
  final Function({required int new_source_language_index})? update_source_language;
  final PrivacyPolicyModel? privacy_policy_model;
  final bool has_back_button;
  final FloatingActionButton? fab;

  const HomeContainer({
    super.key,
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
    required this.image_border_radius,
    this.logo_path_white,
    required this.main_button_color,
    required this.update_payment_enabled,
    this.update_source_language,
    this.privacy_policy_model,
    this.has_back_button = false,
    this.fab,
  });

  @override
  State<HomeContainer> createState() => HomeContainerState();
}

class HomeContainerState extends State<HomeContainer> {
  late SharedPreferences prefs;
  final GlobalKey<ScaffoldState> scaffold_key = GlobalKey<ScaffoldState>();
  bool auto_scroll = true;

  bool loading = true;

  check_permissions() async {
    if (await Permission.storage.isDenied) Permission.storage.request();
  }

  bool payment_enabled = false;

  @override
  void initState() {
    super.initState();
    check_payments();
    check_login();

    if (UniversalPlatform.isMobile) {
      check_permissions();
    }
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

    return PopScope(
      canPop: false,
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
                    icon: const Icon(
                      FontAwesomeIcons.angleLeft,
                      color: Colors.white,
                    ),
                  )
                : null,
            logo_path: widget.logo_path_white ?? widget.logo_path,
          ),
          floatingActionButton: widget.fab,
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
                        for (var element in widget.cardholder_list_1) {
                          element.is_focused = false;
                        }
                        widget.cardholder_list_1[current_page].is_focused = true;
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
                              for (var element in widget.cardholder_list_2) {
                                element.is_focused = false;
                              }
                              widget.cardholder_list_2[current_page].is_focused = true;
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
