import 'dart:html';

import 'package:admin_dashboard/pages/coupon/show_coupon/show_coupon_widgets.dart';
import 'package:admin_dashboard/pages/services/show_services_widgets.dart';
import 'package:admin_dashboard/pages/tickets/tickets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../pages/drivers/widgets/show drivers/show_drivers_widgets.dart';

class NavigationController extends GetxController {
  static NavigationController instance = Get.find();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  Future<dynamic> navigateTo(String routeName ,  ) {
    return navigatorKey.currentState!.pushNamed(routeName,);
  }
    Future<dynamic> navigateToDriverview({ int? index}) {
    return navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) =>  ShowDriversTable(indexPage: index,)));
  }
    Future<dynamic> navigateToServiceview({ int? index}) {
    return navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) =>  ShowServiceScreen(indexPage: index,)));
  }
      Future<dynamic> navigateToCouponview({ int? index}) {
    return navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) =>  ShowCouponWidgets(indexPage: index,)));
  }    
    Future<dynamic> navigateToSupportview( { int? index}) {
    return navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) =>  TicketsScreen(indexPage: index,)));
  }    
//  goBack() => navigatorKey.currentState!.pop();
  // goBack() => navigatorKey.currentState!.pop();

//  goBack() =>  navigatorKey.currentState!.canPop()? navigatorKey.currentState!.pop() : null;

  void goBack() {
    if (navigatorKey.currentState!.canPop()) {
      navigatorKey.currentState!.pop();
      Get.back();
    } else {
      navigatorKey.currentState!.pop();
      Get.back();
      window.history.back();
    }
  }
}
