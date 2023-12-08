import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:xapptor_auth/model/xapptor_user.dart';
import 'package:xapptor_business/home_container/home_container.dart';
import 'package:xapptor_business/wpe/model/supervisor.dart';
import 'package:xapptor_business/shift/shift_participants_selection.dart';
import 'package:xapptor_business/wpe/workplace_exam_view.dart';
import 'package:xapptor_business/wpe/wpe_list.dart';
import 'package:xapptor_ui/utils/show_alert.dart';
import 'package:xapptor_router/app_screen.dart';
import 'package:xapptor_router/app_screens.dart';
import 'package:xapptor_ui/widgets/card_holder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WPEDashboard extends StatefulWidget {
  final String base_path;
  final Color main_color;
  final String logo_path;
  final List<Color> background_colors;

  const WPEDashboard({
    super.key,
    required this.base_path,
    required this.main_color,
    required this.logo_path,
    required this.background_colors,
  });
  @override
  State<WPEDashboard> createState() => _WPEDashboardState();
}

class _WPEDashboardState extends State<WPEDashboard> {
  final text_list_menu = [
    "Account",
  ];

  @override
  void initState() {
    super.initState();
    check_if_is_supervisor();
  }

  late Supervisor supervisor;

  check_if_is_supervisor() async {
    User auth_user = FirebaseAuth.instance.currentUser!;
    DocumentSnapshot user_snap = await FirebaseFirestore.instance.collection("users").doc(auth_user.uid).get();

    Map user_data = user_snap.data() as Map;

    XapptorUser user = XapptorUser.from_snapshot(auth_user.uid, auth_user.email ?? '', user_data);

    if (user.roles.isNotEmpty) {
      bool is_supervisor = false;

      for (var element in user.roles) {
        if (element.value == "supervisor") {
          is_supervisor = true;
        }
      }

      if (is_supervisor) {
        supervisor = Supervisor.from_snapshot(user.id, user_data);
        //open_workplace_exam();
      } else {
        //open_workplace_exam();
      }
    }
  }

  open_shift_participants_selection(Supervisor supervisor) async {
    await add_new_app_screen(
      AppScreen(
        name: "${widget.base_path}/shift_participants_selection",
        child: ShiftParticipantsSelection(
          main_color: widget.main_color,
        ),
      ),
    );
    open_screen("${widget.base_path}/shift_participants_selection");
  }

  open_workplace_exam() async {
    await add_new_app_screen(
      AppScreen(
        name: "${widget.base_path}/workplace_exam",
        child: WorkplaceExamView(
          main_color: widget.main_color,
        ),
      ),
    );
    open_screen("${widget.base_path}/workplace_exam");
  }

  open_workplace_exam_list() async {
    await add_new_app_screen(
      AppScreen(
        name: "${widget.base_path}/workplace_exam_list",
        child: const WpeList(),
      ),
    );
    open_screen("${widget.base_path}/workplace_exam_list");
  }

  open_analytics() async {
    await add_new_app_screen(
      AppScreen(
        name: "${widget.base_path}/analytics",
        child: const WpeList(),
      ),
    );
    open_screen("${widget.base_path}/analytics");
  }

  @override
  Widget build(BuildContext context) {
    return HomeContainer(
      fab: FloatingActionButton(
        onPressed: () {
          open_workplace_exam();
        },
        tooltip: 'Add Workplace Exam',
        backgroundColor: widget.background_colors[1],
        child: const Icon(
          FontAwesomeIcons.clipboardList,
          color: Colors.white,
        ),
      ),
      topbar_color: widget.main_color,
      products_collection_name: "",
      cardholder_list_1: [
        CardHolder(
          image_src: "",
          title: 'Shift Participants Selection',
          subtitle: 'Select Participants For Shift',
          background_image_alignment: Alignment.center,
          icon: FontAwesomeIcons.peopleGroup,
          icon_background_color: widget.background_colors[0],
          on_pressed: () {
            open_shift_participants_selection(supervisor);
          },
          elevation: 3,
          border_radius: 20,
          is_focused: false,
        ),
        CardHolder(
          image_src: "",
          title: 'Workplace Exam History',
          subtitle: 'Identify Posible Risks',
          background_image_alignment: Alignment.center,
          icon: FontAwesomeIcons.clipboardList,
          icon_background_color: widget.background_colors[1],
          on_pressed: () {
            open_workplace_exam_list();
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
          icon_background_color: widget.background_colors[2],
          on_pressed: () {
            //open_analytics();

            show_neutral_alert(
              context: context,
              message: "This feature is coming soon.",
            );
          },
          elevation: 3,
          border_radius: 20,
          is_focused: false,
        ),
      ].whereType<CardHolder>().toList(),
      cardholder_list_2: const [],
      dot_colors_active_1: [
        widget.background_colors[0],
        widget.background_colors[1],
      ],
      dot_colors_active_2: const [],
      dot_color_inactive_1: Colors.blueGrey,
      dot_color_inactive_2: Colors.blueGrey,
      tile_list: const [],
      text_list_menu: text_list_menu,
      tooltip_list: const [],
      has_language_picker: false,
      base_url: '',
      logo_path: widget.logo_path,
      image_border_radius: 0,
      main_button_color: LinearGradient(colors: [
        widget.main_color,
      ]),
      update_payment_enabled: (new_value) {},
      has_back_button: true,
    );
  }
}
