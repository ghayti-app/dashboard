import 'dart:ui';
import 'package:admin_dashboard/constants/style.dart';
import 'package:admin_dashboard/custom_error_screen.dart';
import 'package:admin_dashboard/layout.dart';
import 'package:admin_dashboard/localization/changelocal.dart';
import 'package:admin_dashboard/localization/services.dart';
import 'package:admin_dashboard/localization/translation.dart';
import 'package:admin_dashboard/pages/authentication/login_as_admin.dart';
import 'package:admin_dashboard/pages/overview/overview.dart';
import 'package:admin_dashboard/pages/ride%20request/cash_helper.dart';
import 'package:admin_dashboard/routing/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_maps_webservices/places.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  customErrorScreen();
  await CashHelper.init();
  await initialServices();
   runApp(const MyApp());
}

final places =
    GoogleMapsPlaces(apiKey: "AIzaSyBw2yjQlova1YwxnvA733FZ9PK7sn99jlU");

 

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    LocaleController controller = Get.put(LocaleController());

    return GetMaterialApp(
      scrollBehavior: MyCustomScrollBehavior(),
      navigatorKey: NavigationService.navigatorKey,

      translations: MyTranslation(),
      locale: controller.language,

      // initialRoute:  rootRoute,
      //  initialRoute:  rootRoute,
      //لو عاوزة يبدأ من الاوث علطول
      //initialRoute: authenticationPageRoute,
      //currently, unknownRoute does not work as expected

      //you need to NOT use '/' as your home route
      //you can use for example '/home' or '/dashboard' or '/overview'
      //as your home route. This is a bug with the GetX package
      unknownRoute: GetPage(
          name: authenticationPageRoute,
          page: () => FirebaseAuth.instance.currentUser != null
              ? const Material(child: SiteLayout())
              : const AuthenticationPage()),
      defaultTransition: Transition.leftToRightWithFade,
      getPages: [
        GetPage(name: overViewPageRoute, page: () => const OverviewPage()),
        GetPage(
            name: authenticationPageRoute,
            page: () => const AuthenticationPage()),
      ],
      //  navigatorKey: NavigationController.instance.navigatorKey,

      // navigatorKey: NavigationController().navigatorKey,

      debugShowCheckedModeBanner: false,

      // title: "GHYTI Panel",
      theme: ThemeData(
        scaffoldBackgroundColor: light,
        textTheme: GoogleFonts.mulishTextTheme(
          Theme.of(context).textTheme,
        ).apply(
          bodyColor: Colors.black,
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
            //   TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
          },
        ),
        primarySwatch: Colors.indigo,
      ),
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // عشان اخليه يقدر يحرك الموقع بالماوس
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}
