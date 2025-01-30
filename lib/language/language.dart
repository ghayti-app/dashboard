import 'package:admin_dashboard/constants/controllers.dart';
import 'package:admin_dashboard/language/custombuttomlang.dart';
import 'package:admin_dashboard/localization/changelocal.dart';
import 'package:admin_dashboard/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Language extends GetView<LocaleController> {
  const Language({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Text("1".tr, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: CustomButtonLang(
                        textbutton: "Arabic".tr,
                        onPressed: () {
                          controller.changeLang("ar");
                          navigationController.navigateTo(overViewPageRoute);
                        }),
                  ),
                  Expanded(
                    child: CustomButtonLang(
                        textbutton: "English".tr,
                        onPressed: () {
                          controller.changeLang("en");
                          navigationController.navigateTo(overViewPageRoute);
                        }),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              CustomButtonLang(
                  textbutton: "France".tr,
                  onPressed: () {
                    controller.changeLang("fr");
                    navigationController.navigateTo(overViewPageRoute);
                  }),
            ],
          )),
    );
  }
}
