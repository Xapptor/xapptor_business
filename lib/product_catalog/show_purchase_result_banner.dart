import 'dart:async';
import 'package:flutter/material.dart';
import 'package:xapptor_business/product_catalog/product_catalog.dart';

extension StateExtension on ProductCatalogState {
  show_purchase_result_banner(
    bool purchase_success,
    String? custom_message,
  ) {
    ScaffoldMessenger.of(context).hideCurrentMaterialBanner();

    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        content: Text(
          custom_message ?? (purchase_success ? "Purchase Successful" : "Purchase Failed"),
          style: const TextStyle(
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

    Timer(const Duration(seconds: 3), () {
      ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
    });
  }
}
