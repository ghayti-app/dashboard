import 'package:admin_dashboard/pages/authentication/login_as_admin.dart';
import 'package:admin_dashboard/widgets/custom_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
 
class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final TextEditingController _emailController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form( key: _formKey,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Email'.tr),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: 'Enter Email'.tr,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Email'.tr;
                      }
                      if (!value.contains('@')) {
                        return 'Please enter a valid Email'.tr;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 50),
                  MaterialButton(
                    onPressed: () async {
                      await resetPassword();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(20)),
                      alignment: Alignment.center,
                      width: double.maxFinite,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: CustomText(
                        text: "Reset Password".tr,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  MaterialButton(
                    onPressed: () {
                      Get.off(const AuthenticationPage());
        
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => const AuthenticationPage(),
                      //     ));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(20)),
                      alignment: Alignment.center,
                      width: double.maxFinite,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: CustomText(
                        text: "Back".tr,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> resetPassword() async {
    if (_formKey.currentState!.validate()) {
      try {
        auth.sendPasswordResetEmail(email: _emailController.text);
        if (mounted) {
          // showToast("email sent to your email account".tr);
          AwesomeDialog(
            width: 450,
            context: context,
            dialogType: DialogType.success,
            animType: AnimType.rightSlide,
            title: 'Error'.tr,
            desc: "Password sent to your email account".tr,
          ).show();
        }
      } on FirebaseAuthException catch (e) {
        if (mounted) {
          // showToast(
          //   e.code,
          // );
          AwesomeDialog(
            width: 450,
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.rightSlide,
            title: 'Error'.tr,
            desc: e.code,
          ).show();
        }
      }
    }
  }

  // final FocusNode emailFocus = FocusNode();
  // final FocusNode passwordFocus = FocusNode();
  // final FocusNode usernameFocus = FocusNode();

  // bool isLoginScreen = true;
  // bool isEditingEmail = false;
  // bool isEditingPassword = false;
  // bool isEditingUsername = false;
  // bool isRegistering = false;
  // bool isLoggingIn = false;
  // bool passwordIsVisible = false;

  // String? validateEmail(String value) {
  //   value = value.trim();
  //   if (_emailController.text.isNotEmpty) {
  //     if (value.isEmpty) {
  //       return 'Email can\'t be empty'.tr;
  //     } else if (!value.contains(RegExp(
  //         r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))) {
  //       return 'Enter a correct email address'.tr;
  //     }
  //   }
  //   return null;
  // }
}
