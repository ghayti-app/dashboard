// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:math';

import 'package:admin_dashboard/layout.dart';
import 'package:admin_dashboard/pages/authentication/forgetpassword.dart';
import 'package:admin_dashboard/widgets/custom_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key});

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/logo.jpg",
                    height: 90,
                    width: 90,
                  ),
                  const SizedBox(height: 30),
                  Text(
                    "Login".tr,
                    style: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _buildEmailAndPasswordFields(),
                  const SizedBox(
                    height: 15,
                  ),
                  const SizedBox(height: 10),
                    isloading
                          ? const Center(child: CircularProgressIndicator())
                          : MaterialButton(
                    onPressed: () {
                    _signInWithEmailAndPassword();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(20)),
                      alignment: Alignment.center,
                      width: double.maxFinite,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: CustomText(
                        text: "Login".tr,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  MaterialButton(
                    onPressed: () {
                      // Navigate to Forget Password Page
                      Get.off(const ForgetPassword());
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => const ForgetPassword(),
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
                        text: "Forget Password".tr,
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

  Widget _buildEmailAndPasswordFields() {
    return Column(
      children: [
        const SizedBox(width: 16),
        Column(
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
          ],
        ),
        const SizedBox(height: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Password'.tr),
            const SizedBox(height: 5),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: 'Enter Password'.tr,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
              ),
              obscureText: _obscureText,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Password'.tr;
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters'.tr;
                }
                return null;
              },
            ),
          ],
        ),
      ],
    );
  }

  Future<bool> checkUserExistsInFirestore(String userId) async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('admins')
          .doc(userId)
          .get();
      return docSnapshot.exists;
    } catch (e) {
      return false;
    }
  }

  String generateToken(int length) {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#%^&*()_+-={}[]:;"\'<>,.?/123456789-*-/+';
    final random = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  }

  bool isloading = false;
  Future<void> _signInWithEmailAndPassword() async {
    try {
      isloading = true;
      setState(() {});
      if (_formKey.currentState!.validate()) {
        final userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        final user = userCredential.user;

        if (user != null) {
          final userExistsInFirestore =
              await checkUserExistsInFirestore(user.uid);

          if (userExistsInFirestore) {
            final docSnapshot = await FirebaseFirestore.instance
                .collection('admins')
                .doc(user.uid)
                .get();

            await createSession(user.uid);

            Timer.periodic(const Duration(hours: 5), (Timer t) async {
              await FirebaseAuth.instance.signOut();
              await Get.off(const AuthenticationPage());
            });
          } else {
            AwesomeDialog(
              width: 450,
              context: context,
              dialogType: DialogType.error,
              title: 'Error'.tr,
              desc: 'This account is not authorized to log in.'.tr,
            ).show();
          }
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        AwesomeDialog(
          width: 450,
          context: context,
          dialogType: DialogType.error,
          title: 'Error'.tr,
          desc: 'No user found for that email.'.tr,
        ).show();
      } else if (e.code == 'too-many-requests') {
        AwesomeDialog(
          width: 450,
          context: context,
          dialogType: DialogType.error,
          title: 'Error'.tr,
          desc: 'Wrong password provided for that user.'.tr,
        ).show();
      }
    } finally {
      isloading = false;
      setState(() {});
    }
  }

  Future<void> createSession(String userId) async {
    try {
      // String sessionToken = const Uuid().v4();
      // ("Session token: $sessionToken");

      // await _storage.write(key: 'sessionToken', value: sessionToken);
      String sessionToken = generateToken(200);

      await _firestore.collection('admins').doc(userId).update({
        // 'userId': userId,
        'SessionCreatedAt': Timestamp.now(),
        'token': sessionToken,
      }).then((value) => ("Session created successfully"));

      final docSnapshot = await FirebaseFirestore.instance
          .collection('admins')
          .doc(userId)
          .get();
      final String storedJwt = docSnapshot.data()!['token'];

      if (sessionToken == storedJwt) {
        ("Tokens match, navigating to SiteLayout");

        Get.offAll(const SiteLayout());
      } else {
        ("Tokens do not match");
      }
    } catch (error) {
      ("Failed to create session: $error");
    }
  }
}
