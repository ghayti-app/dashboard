import 'package:flutter/material.dart';
import 'package:admin_dashboard/widgets/custom_text.dart';
import 'package:get/get.dart';

class PageNotFound extends StatelessWidget {
  const PageNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/images/error.png", width: 350,),
          const SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:  [
              CustomText(
                text: "Page not found".tr, 
                size: 24, 
                weight: FontWeight.bold,
              ),
            ],
          )
        ],
      ),
    );
  }
}