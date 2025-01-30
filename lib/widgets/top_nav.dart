// ignore_for_file: use_build_context_synchronously

import 'package:admin_dashboard/constants/style.dart';
import 'package:admin_dashboard/helpers/responsiveness.dart';
import 'package:admin_dashboard/language/custombuttomlang.dart';
import 'package:admin_dashboard/localization/services.dart';
import 'package:admin_dashboard/pages/authentication/login_as_admin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../localization/changelocal.dart';
import 'custom_text.dart';

LocaleController controller = Get.put(LocaleController());

AppBar topNavigationBar(BuildContext context, GlobalKey<ScaffoldState> key) =>
    AppBar(
      leading: !ResponsiveWidget.isSmallScreen(context)
          ? Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Image.asset(
                    "assets/images/logo.jpg",
                    width: 35,
                  ),
                ),
              ],
            )
          : IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                key.currentState!.openDrawer();
              },
            ),
      title: Row(
        children: [
          Visibility(
              visible: !ResponsiveWidget.isSmallScreen(context),
              child: CustomText(
                text: "Admin Panel".tr,
                color: lightGray,
                size: 20,
                weight: FontWeight.bold,
              )),
          Expanded(child: Container()),
          ElevatedButton(
            child: Row(
              children: [
                const Icon(
                  Icons.language_outlined,
                  color: Colors.blue,
                ),
                Text('Select Language'.tr)
              ],
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Center(
                        child: Text(
                      'Select Language'.tr,
                      style: const TextStyle(fontSize: 15),
                    )),
                    content: SizedBox(
                      height: 180,
                      width: 300,
                      child: Column(
                        children: [
                          CustomButtonLang(
                            textbutton: "Arabic".tr,
                            onPressed: () {
                              controller.changeLang("ar");
                              // Navigator.of(context).pop();
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomButtonLang(
                            textbutton: "English".tr,
                            onPressed: () {
                              controller.changeLang("en");
                              // Navigator.of(context)
                              //     .pop();
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomButtonLang(
                            textbutton: "France".tr,
                            onPressed: () {
                              controller.changeLang("fr");
                              Get.appUpdate();
                              // Navigator.of(context)
                              //     .pop();
                            },
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
          const SizedBox(
            width: 5,
          ),
          Stack(
            children: [
              ElevatedButton(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.logout_outlined,
                        color: Colors
                            .blue, // Assuming 'dark' is not defined, use a default color like blue
                      ),
                      SizedBox(
                        child: Text(
                          "Log Out".tr,
                          style: const TextStyle(fontSize: 15),
                        ),
                      )
                    ],
                  ),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AuthenticationPage(),
                      ),
                      (route) => false,
                    );
                  }),
              Positioned(
                top: 7,
                right: 7,
                child: Container(
                  width: 7,
                  height: 12,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      color: active,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: light, width: 2)),
                ),
              )
            ],
          ),
          Container(
            width: 1,
            height: 22,
            color: lightGray,
          ),
          const SizedBox(
            width: 24,
          ),
          if (!ResponsiveWidget.isSmallScreen(context))
            StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection("admins")
                  .doc(FirebaseAuth.instance.currentUser?.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.exists) {
                  final adminData = snapshot.data!.data()!;
                  ("Document Found! Data: ${snapshot.data}"); // Debug log
                  return CustomText(
                    text: "${adminData['username'] ?? "N/A"}",
                    color: Colors.black87,
                    size: 18,
                  );
                } else if (snapshot.hasError) {
                  ("Error fetching document: ${snapshot.error}"); // Debug log
                  return CustomText(
                    text: "Loading",
                    color: lightGray,
                  );
                } else {
                  return CustomText(
                    text: "Loading",
                    color: lightGray,
                  );
                }
              },
            ),
          const SizedBox(
            width: 16,
          ),
          Container(
            decoration: BoxDecoration(
                color: active.withOpacity(.5),
                borderRadius: BorderRadius.circular(30)),
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30)),
                padding: const EdgeInsets.all(2),
                margin: const EdgeInsets.all(2),
                child: // Obx(() =>
                    CircleAvatar(
                        backgroundColor: light,
                        child: Icon(
                          Icons.person_outline,
                          color: dark,
                        )

                        //)
                        )),
          ),
        ],
      ),
      iconTheme: IconThemeData(color: dark),
      elevation: 0,
      backgroundColor: Colors.transparent,
    );

class LangDirectionController extends GetxController {

 String? lang; 
   MyServices myServices = Get.find();

 @override
  void onInit() {
        lang = myServices.sharedPreferences.getString("lang");

    super.onInit();
  }

}
