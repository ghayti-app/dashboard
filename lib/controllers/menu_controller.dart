 
import 'package:admin_dashboard/constants/style.dart';
import 'package:admin_dashboard/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MenuController extends GetxController {
  static MenuController instance = Get.find();
  var activeItem = overViewPageDisplayName.obs;
  var hoverItem = ''.obs;
  var hasNewRequest = false.obs;

  changeActiveItemTo(String itemName) {
    activeItem.value = itemName;
  }

  onHover(String itemName) {
    if (!isActive(itemName)) hoverItem.value = itemName;
  }

  bool isActive(String itemName) => activeItem.value == itemName;
  bool isHovering(String itemName) => hoverItem.value == itemName;

  Widget returnIconFor(String itemName) {
    switch (itemName.tr) {
      case rideRequestPageRoute:
        return customIcon(Icons.railway_alert_rounded, itemName);
      case  showWalletPageRoute:
        return customIcon(Icons.account_balance_wallet_outlined, itemName); //showRidePageRoute
             case  showRidePageRoute:
        return customIcon(Icons.account_balance_wallet_outlined, itemName); //showRidePageRoute
      case driversPageRoute:
        return customIcon(Icons.drive_eta, driversName);
      case ticketPageRoute:
        return customIcon(Icons.airplane_ticket_outlined, ticketName);
      case ticketMessagesPageRoute:
        return customIcon(Icons.airplane_ticket_outlined, ticketMessagesName);
      case showUserLocationsPageRoute:
        return customIcon(Icons.location_on_outlined, showUserLocationsName);
      default:
        if (itemName.contains("ticket".tr)) {
          return customIcon(Icons.airplane_ticket, ticketName.tr);
        } else if (itemName.contains("Show Online Users Location".tr)) {
          return customIcon(Icons.location_on_outlined, itemName.tr);
        } else if (itemName.contains("Ride Requests".tr)) {
          return customIcon(Icons.directions_railway_filled_sharp, itemName.tr);
        } else if (itemName.contains("Show Wallet Request".tr)) {
          return Obx(() => customIcon(
              Icons.attach_money_sharp,
              itemName.tr,
              hasNewRequest.value ? Colors.red : null));
        } else if (itemName.contains("Transaction Page".tr)) {
          return customIcon(Icons.money_rounded, itemName.tr);
        } else {
          return customIcon(Icons.add_moderator_outlined, itemName.tr);
        }
    }
  }

  Widget customIcon(IconData icon, String itemName, [Color? color]) {
    if (isActive(itemName.tr)) {
      return Icon(icon,
          size: 22, color: isHovering(itemName) ? Colors.amber : (color ?? Colors.blue));
    }
    return Icon(icon,
        size: 22, color: isHovering(itemName) ? Colors.amber : (color ?? lightGray));
  }
}