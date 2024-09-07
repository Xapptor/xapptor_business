// ignore_for_file: invalid_use_of_protected_member

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:xapptor_business/product_catalog/product_catalog.dart';
import 'package:xapptor_business/product_catalog/register_payment.dart';
import 'package:xapptor_business/product_catalog/restore_purchase.dart';
import 'package:xapptor_business/product_catalog/show_purchase_result_banner.dart';
import 'package:xapptor_logic/random/random_number_with_range.dart';

extension StateExtension on ProductCatalogState {
  listen_to_purchase_updated(List<PurchaseDetails> purchase_details_list) async {
    int random_number_1 = random_number_with_range(1000, 2000);
    int random_number_2 = random_number_with_range(500, 1000);
    int random_number_3 = random_number_with_range(100, 500);

    int random_number_timer =
        ((random_number_1 + random_number_2 + random_number_3) * (random_number_with_range(1, 9) / 10)).toInt();

    debugPrint(random_number_timer.toString());

    for (var purchase_details in purchase_details_list) {
      if (purchase_details.status == PurchaseStatus.pending) {
        //debugPrint("payment process pending");
        loading = true;
        setState(() {});
      } else {
        if (purchase_details.status == PurchaseStatus.error) {
          //debugPrint("payment process error" + purchase_details.error!.toString());
          loading = false;
          setState(() {});

          show_purchase_result_banner(false, null);
        } else if (purchase_details.status == PurchaseStatus.purchased) {
          //debugPrint("payment process success");
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
    }
  }
}
