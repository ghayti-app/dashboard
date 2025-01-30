// ignore_for_file: use_build_context_synchronously

import 'package:admin_dashboard/pages/ride%20request/cash_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
 

void showToast({required String message, Color? color}) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: color ?? Colors.blue,
      textColor: Colors.white,
      fontSize: 15);
}


Future<bool> checkCoupon(BuildContext context,
    {required String coupon,
    required double cost,
    required String serviceName, required String riderid}) async {
  final timeNow = DateTime.now();
  final value = await FirebaseFirestore.instance
      .collection("coupons")
      .where("code", isEqualTo: coupon)
      .get();
  if (value.docs.isEmpty) {
    showToast(message: "coupon Not Exist", color: Colors.redAccent);
    return false;
  }
  await CashHelper.putString(key: Keys.couponID, value: value.docs[0].id);
  await CashHelper.putDouble(
      key: Keys.couponAmount,
      value: value.docs[0].data()["discountAmount"].toDouble());
  final service = await FirebaseFirestore.instance
      .collection("services")
      .where("name", isEqualTo: serviceName)
      .get();
  if (service.docs.isEmpty) {
    return false;
  }
  final serviceId = service.docs[0].id;

  if (value.docs.isEmpty) {
    showToast(message: "coupon Not Exist", color: Colors.redAccent);
    return false;
  }

  if (value.docs[0].data()["serviceIdDiscount"] != serviceId &&
      value.docs[0].data()["serviceIdDiscount"] != "All") {
    showToast(
        message: "coupon Doesnt Work In The Service",
        color: Colors.redAccent);
    return false;
  } else if (value.docs[0].data()["status"] != "Active") {
    showToast(
        message: "coupon Is Not Active", color: Colors.redAccent);
    return false;
  } else if (value.docs[0].data()["totalActualUsed"] >=
      value.docs[0].data()["totalUsageLimit"]) {
    showToast(message: "Expiry Coupon", color: Colors.redAccent);
    return false;
  } else if (value.docs[0].data()["minimumDiscount"] >= cost) {
    showToast(
        message: "lower The Minimum Discount",
        color: Colors.redAccent);
    return false;
  } else if (timeNow.isAfter(
      DateTime.parse("${value.docs[0].data()["endDate"]} 00:00:00.000"))) {
    showToast(message: "Expiry Coupon", color: Colors.redAccent);
    return false;
  } else if (timeNow
      .isBefore(DateTime.parse(value.docs[0].data()["startDate"]))) {
    showToast(
        message: "coupon Is Not Active", color: Colors.redAccent);
    return false;
  } else if (value.docs[0]
      .data()["riderIdsList"]
      .contains(riderid)) {
    showToast(
        message: "coupon Already Used", color: Colors.redAccent);
    return false;
  }

  return true;
}

 