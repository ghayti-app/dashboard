import 'package:admin_dashboard/helpers/responsiveness.dart';
import 'package:admin_dashboard/widgets/large_screen.dart';
import 'package:admin_dashboard/widgets/side_menu.dart';
import 'package:admin_dashboard/widgets/small_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'widgets/top_nav.dart';

class SiteLayout extends StatefulWidget {
  const SiteLayout({super.key});

  @override
  State<SiteLayout> createState() => _SiteLayoutState();
}

class _SiteLayoutState extends State<SiteLayout> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   // getNot();
  }

  @override
  Widget build(BuildContext context) {
    // Get.put(LoggedUserController());
    return Scaffold(
        key: scaffoldKey,
        appBar: topNavigationBar(context, scaffoldKey),
        drawer: const Drawer(child: SideMenu()),
        body: const ResponsiveWidget(
          largeScreen: LargeScreen(),
          mediumScreen: LargeScreen(),
          smallScreen: SmallScreen(),
        ));
  }
}
  getNot() {

         if(first ==0) {
           FirebaseFirestore.instance
        .collection("wallet")
     .where("done", isEqualTo: false)
        .snapshots()
        .listen((valuee) {
       for (var changee in valuee.docChanges ) {
      if (changee.type == DocumentChangeType.added && FirebaseAuth.instance.currentUser!=null ) { 
        Get.snackbar("Have a new Wallet Request".tr,
            "Go To a Show Wallet Request Page".tr);
          break; // Exit the loop after showing the first notification
      }
       }
      // if(value.docs.isNotEmpty  && FirebaseAuth.instance.currentUser != null){
      // Get.snackbar("Have a new Wallet Request".tr,
      //     "Go To a Show Wallet Request Page".tr);
      //     }
    });
        }
  first = 1;
  }
  int first = 0;