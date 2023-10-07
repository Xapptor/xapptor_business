import 'package:flutter/material.dart';
import 'package:xapptor_auth/sign_out.dart';
import 'package:xapptor_business/home_container/home_container.dart';
import 'package:xapptor_router/app_screens.dart';

extension StateExtension on HomeContainerState {
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
                  title: Text(widget.text_list_menu[widget.text_list_menu.length - 2]),
                  onTap: () async {
                    open_screen("home/privacy_policy");
                  },
                ),
                ListTile(
                  title: Text(widget.text_list_menu[widget.text_list_menu.length - 1]),
                  onTap: () async {
                    sign_out(context: context);
                  },
                ),
              ],
        ),
      ),
    );
  }
}
