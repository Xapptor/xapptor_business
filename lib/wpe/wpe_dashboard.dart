import 'package:flutter/material.dart';
import 'package:xapptor_business/home_container.dart';
import 'package:xapptor_router/app_screens.dart';
import 'package:xapptor_ui/values/custom_colors.dart';
import 'package:xapptor_ui/widgets/card_holder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WPEDashboard extends StatefulWidget {
  final String base_path;
  final Color main_color;
  final String logo_path;

  WPEDashboard({
    required this.base_path,
    required this.main_color,
    required this.logo_path,
  });
  @override
  _WPEDashboardState createState() => _WPEDashboardState();
}

class _WPEDashboardState extends State<WPEDashboard> {
  final text_list_menu = [
    "Account",
  ];

  @override
  Widget build(BuildContext context) {
    return HomeContainer(
      topbar_color: widget.main_color,
      products_collection_name: "",
      cardholder_list_1: [
        CardHolder(
          image_src: "",
          title: 'Workplace Exam',
          subtitle: 'Identify Posible Risks',
          background_image_alignment: Alignment.center,
          icon: FontAwesomeIcons.clipboardList,
          icon_background_color: color_github,
          on_pressed: () {
            open_screen("${widget.base_path}/workplace_exam");
          },
          elevation: 3,
          border_radius: 20,
          is_focused: false,
        ),
        CardHolder(
          image_src: "",
          title: 'Analytics',
          subtitle: 'Examine Your Operations',
          background_image_alignment: Alignment.center,
          icon: FontAwesomeIcons.uncharted,
          icon_background_color: color_light_aqua,
          on_pressed: () {
            open_screen("${widget.base_path}/analytics");
          },
          elevation: 3,
          border_radius: 20,
          is_focused: false,
        ),
      ].whereType<CardHolder>().toList(),
      cardholder_list_2: [],
      dot_colors_active_1: [
        color_github,
        color_light_aqua,
      ],
      dot_colors_active_2: [],
      dot_color_inactive_1: color_dark_aqua,
      dot_color_inactive_2: color_dark_aqua,
      tile_list: [],
      text_list_menu: text_list_menu,
      tooltip_list: [],
      has_language_picker: false,
      base_url: '',
      logo_path: widget.logo_path,
      main_button_color: LinearGradient(colors: [
        widget.main_color,
      ]),
      update_payment_enabled: (new_value) {},
      has_back_button: true,
    );
  }
}
