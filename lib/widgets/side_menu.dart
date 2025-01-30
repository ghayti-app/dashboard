import 'package:admin_dashboard/constants/controllers.dart';
import 'package:admin_dashboard/constants/style.dart';
import 'package:admin_dashboard/helpers/responsiveness.dart';
import 'package:admin_dashboard/routing/routes.dart';
import 'package:admin_dashboard/widgets/custom_text.dart';
import 'package:admin_dashboard/widgets/side_menu_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});
  static MenuController instance = Get.find();

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  var activeItem = overViewPageDisplayName.obs;
  var hoverItem = ''.obs;

  changeActiveItemTo(String itemName) {
    activeItem.value = itemName;
  }

  onHover(String itemName) {
    if (!isActive(itemName)) hoverItem.value = itemName;
  }

 
  bool isActive(String itemName) => activeItem.value == itemName;

  bool isHovering(String itemName) => hoverItem.value == itemName;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      color: light,
      child: ListView(
        children: [
          if (ResponsiveWidget.isSmallScreen(context))
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 40,
                ),
                Row(
                  children: [
                    SizedBox(width: width / 48),
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Image.asset(
                        "assets/images/logo.jpg",
                        height: 25,
                        width: 25,
                      ),
                    ),
                    Flexible(
                      child: CustomText(
                        text: "Admin Panel".tr,
                        size: 20,
                        weight: FontWeight.bold,
                        color: active,
                      ),
                    ),
                    SizedBox(width: width / 48),
                  ],
                ),
              ],
            ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: sideMenuItems.map((item) {
              if (item.name == adminsName) {
                return Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: ExpansionTile(
                    leading: const Icon(
                      Icons.admin_panel_settings,
                    ),
                    title: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Admins".tr),
                    ),
                    children: <Widget>[
                      ListTile(
                        title: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("show Admins".tr),
                        ),
                        onTap: () {
                          navigationController.navigateTo(showAdminsPageRoute);
                        },
                      ),
                      ListTile(
                        title: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("add Admins".tr),
                        ),
                        onTap: () {
                          navigationController.navigateTo(addAdminPageRoute);
                        },
                      ),
                      ListTile(
                        title: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Admins Actions".tr),
                        ),
                        onTap: () {
                          navigationController
                              .navigateTo(showAdminHistoryPageRoute);
                        },
                      ),
                    ],
                  ),
                );
              }
              if (item.name == driversName) {
                return Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: ExpansionTile(
                    leading: const Icon(Icons.drive_eta),
                    title: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Drivers".tr),
                    ),
                    children: <Widget>[
                      ListTile(
                        title: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("show Drivers".tr),
                        ),
                        onTap: () {
                          navigationController.navigateTo(showDriversPageRoute);
                        },
                      ),
                    ],
                  ),
                );
              }
              if (item.name == usersName) {
                return Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: ExpansionTile(
                    leading: const Icon(Icons.supervised_user_circle_rounded),
                    title: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Users".tr),
                    ),
                    children: <Widget>[
                      ListTile(
                        title: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("show Riders".tr),
                        ),
                        onTap: () {
                          navigationController.navigateTo(showusersPageRoute);
                        },
                      ),
                    ],
                  ),
                );
              }
              if (item.name == servicesName) {
                return Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: ExpansionTile(
                    leading: const Icon(Icons.car_crash_outlined),
                    title: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("services".tr),
                    ),
                    children: <Widget>[
                      ListTile(
                        title: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("show Services".tr),
                        ),
                        onTap: () {
                          navigationController
                              .navigateTo(showServicesPageRoute);
                        },
                      ),
                      ListTile(
                        title: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("add Service".tr),
                        ),
                        onTap: () {
                          navigationController.navigateTo(addServicesPageRoute);
                        },
                      ),
                    ],
                  ),
                );
              }

              if (item.name == couponName) {
                return Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: ExpansionTile(
                    leading: const Icon(Icons.discount_outlined),
                    title: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Coupons".tr),
                    ),
                    children: <Widget>[
                      ListTile(
                        title: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("show Coupons".tr),
                        ),
                        onTap: () {
                          navigationController.navigateTo(showcouponPageRoute);
                        },
                      ),
                      ListTile(
                        title: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("add Coupons".tr),
                        ),
                        onTap: () {
                          navigationController.navigateTo(addcouponPageRoute);
                        },
                      ),
                    ],
                  ),
                );
              }

              if (item.name == rideRequestName) {
                return Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: ExpansionTile(
                    leading: const Icon(
                      Icons.electric_rickshaw_rounded,
                    ),
                    title: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Ride Request".tr),
                    ),
                    children: <Widget>[
                      ListTile(
                        title: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Show Ride Requests".tr),
                        ),
                        onTap: () {
                          navigationController.navigateTo(showRidePageRoute);
                        },
                      ),
                      ListTile(
                        title: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("New Ride Requests".tr),
                        ),
                        onTap: () {
                          navigationController.navigateTo(newBookingPageRoute);
                        },
                      ),
                    ],
                  ),
                );
              }

              // if (item.name == showWalletName) {
              //   return Padding(
              //     padding: const EdgeInsets.only(left: 20),
              //     child: StreamBuilder<QuerySnapshot>(
              //       stream: FirebaseFirestore.instance
              //           .collection("wallet").where("done", isEqualTo: false)
              //           .snapshots(),
              //       builder: (context, snapshot) {

              //         // bool hasNewRequest = false;
              //         // if (snapshot.hasData) {
              //         //   for (var change in snapshot.data!.docChanges) {
              //         //     if (change.type == DocumentChangeType.added&& change.doc.get("done") == false ) {
              //         //     hasNewRequest = true;

              //         //     }
              //         //   }
              //         // }
              //         return ExpansionTile(
              //           leading: Icon(
              //               Icons.account_balance_wallet_outlined,
              //               color: snapshot.data!.docs.isNotEmpty
              //                   ? Colors.red
              //                   : const Color.fromARGB(255, 156, 160, 156),
              //             ),

              //           title: Align(
              //             alignment: Alignment.centerLeft,
              //             child: Text("Wallet Request".tr),
              //           ),
              //           children: <Widget>[
              //             ListTile(
              //               title: Align(
              //                 alignment: Alignment.centerLeft,
              //                 child: Text("Show Wallet Requests".tr),
              //               ),
              //               onTap: () {
              //                 // hasNewRequest = false;
              //                 // setState(() {});
              //                 navigationController
              //                     .navigateTo(showWalletPageRoute);
              //                 setState(() {
              //             //      hasNewRequest = false;
              //                 });
              //               },
              //             ),
              //           ],
              //         );
              //       },
              //     ),
              //   );
              // }

              if (item.name == showWalletName) {
                return Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child:
                   StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("wallet")
                        .where("done", isEqualTo: false)
                        .snapshots(),
                    builder: (context, snapshot) {
                      bool hasNewRequest = false;
                      if (snapshot.hasData) {
                        for (var change in snapshot.data!.docChanges) {
                          if (change.type == DocumentChangeType.added) {
                            hasNewRequest = true;
                         
                            break;
                          }
                        }
                      }
                      return
                       ExpansionTile(
                        leading: Badge(
                          backgroundColor: hasNewRequest
                              ? Colors.red
                              : const Color.fromARGB(66, 230, 186, 14),
                          largeSize: 30,
                          child: Icon(
                            Icons.account_balance_wallet_outlined,
                            color: hasNewRequest == true
                                ? Colors.red
                                : const Color.fromARGB(255, 156, 160, 156),
                          ),
                        ),
                        title: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Wallet Request".tr),
                        ),
                        children: <Widget>[
                          ListTile(
                            title: Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Show Wallet Requests".tr),
                            ),
                            onTap: () {
                              hasNewRequest = false;
                              setState(() {});
                              navigationController
                                  .navigateTo(showWalletPageRoute);
                              setState(() {
                                hasNewRequest = false;
                              });
                            },
                          ),
                        ],
                      );
                    },
                  ),
                );
              }

              return SideMenuItem(
                itemName: item.name.tr,
                onTap: () {
                  if (item.name != adminsName.tr) {
                    navigationController.navigateTo(item.route);
                    Get.forceAppUpdate();
                  }
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
