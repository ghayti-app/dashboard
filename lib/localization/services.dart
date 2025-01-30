import 'package:admin_dashboard/controllers/navigation_controller.dart';
import 'package:admin_dashboard/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:admin_dashboard/controllers/menu_controller.dart'
    as menu_controller;

class MyServices extends GetxService {
  late SharedPreferences sharedPreferences;

  Future<MyServices> init() async {
    //  await Firebase.initializeApp();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    Get.put(menu_controller.MenuController());
    Get.put(NavigationController());
    sharedPreferences = await SharedPreferences.getInstance();

    return this;
  }
}

initialServices() async {
  await Get.putAsync(() => MyServices().init());
}
