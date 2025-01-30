//import 'package:admin_dashboard/constants/controllers.dart';
//import 'package:admin_dashboard/helpers/responsiveness.dart';
import 'package:admin_dashboard/pages/users/widgets/show%20users/show_users_widgets.dart';
//import 'package:admin_dashboard/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
//import 'package:get/get.dart';

class ShowUsersWidgets extends StatelessWidget {
  const ShowUsersWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("show Riders List".tr),
          actions: [
            MaterialButton(
              height: 50,
              minWidth: 50,
              color: Colors.blue,
              child: Text(
                " Back ".tr,
                style:
                    const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                //  navigationController.navigateTo();

                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 170),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                            onPressed: () => Get.back(),
                            icon: const Icon(Icons.arrow_back)),
                        Text(
                          "show Riders ".tr,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const ShowUsersTable(),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
