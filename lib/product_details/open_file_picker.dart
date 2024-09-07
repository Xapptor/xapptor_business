// ignore_for_file: use_build_context_synchronously, invalid_use_of_protected_member

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:xapptor_ui/utils/check_permission.dart';
import 'package:file_picker/file_picker.dart' as file_picker;
import 'package:xapptor_ui/utils/get_platform_name.dart';
import 'package:xapptor_ui/utils/get_browser_name.dart';
import 'package:xapptor_business/product_details/product_details.dart';

extension StateExtension on ProductDetailsState {
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
}
