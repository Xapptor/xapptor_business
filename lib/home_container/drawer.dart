import 'package:flutter/material.dart';
import 'package:xapptor_auth/sign_out.dart';
import 'package:xapptor_business/home_container/home_container.dart';
import 'package:xapptor_router/V2/app_screens_v2.dart';
import 'package:xapptor_ui/widgets/app_version_container.dart';

extension StateExtension on HomeContainerState {
  Widget drawer() {
    return SafeArea(
      child: Drawer(
        child: Column(
          children: [
                Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(
                    top: 12,
                    right: 12,
                  ),
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
                    open_screen_v2("home/account");
                  },
                ),
              ] +
              widget.tile_list +
              [
                ListTile(
                  title: Text(widget.text_list_menu[widget.text_list_menu.length - 2]),
                  onTap: () async {
                    open_screen_v2("home/privacy_policy");
                  },
                ),
                ListTile(
                  title: Text(widget.text_list_menu[widget.text_list_menu.length - 1]),
                  onTap: () async {
                    sign_out(context: context);
                  },
                ),
                const Spacer(flex: 1),
                Container(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: AppVersionContainer(
                    text_color: widget.topbar_color,
                    background_color: null,
                  ),
                ),
              ],
        ),
      ),
    );
  }
}
