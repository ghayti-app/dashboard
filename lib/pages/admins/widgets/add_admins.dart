// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:admin_dashboard/constants/controllers.dart';
import 'package:admin_dashboard/routing/routes.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:get/get.dart';

class AddAdminsWidgets extends StatefulWidget {
  const AddAdminsWidgets({super.key});

  @override
  State<AddAdminsWidgets> createState() => _AddAdminsPageState();
}

class _AddAdminsPageState extends State<AddAdminsWidgets> {
  // final storage = const FlutterSecureStorage();


  final _emailController = TextEditingController();
  final _firestore = FirebaseFirestore.instance;
  final _formKe = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscureText = true;
  // final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  final _usernameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    // _phoneController.dispose();

    super.dispose();
  }

  String generateToken(int length) {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#%^&*()_+-={}[]:;"\'<>,.?/123456789-*-/+';
    final random = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  }

  Widget _buildUsernameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Username'.tr),
        TextFormField(
          controller: _usernameController,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: 'Enter Username'.tr,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter Username'.tr;
            }
            return null;
          },
        ),
      ],
    );
  }

  // Widget _buildPhoneFields() {
  //   return Row(
  //     children: [
  //       Expanded(
  //         child: IntlPhoneField(
  //           controller: _phoneController,
  //           //  style:TextStyle(color:),
  //           decoration: InputDecoration(
  //             labelStyle: Theme.of(context)
  //                 .textTheme
  //                 .bodyLarge, // جعل النص يظهر في أقصى اليسار

  //             labelText: 'Phone Number'.tr,
  //             border: const OutlineInputBorder(
  //               borderSide: BorderSide(),
  //             ),
  //           ),
  //           onChanged: (phone) {
  //             (phone.completeNumber);
  //           },
  //           onCountryChanged: (country) {
  //             ('Country changed to: '.tr + country.name);
  //           },
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildEmailAndPasswordFields() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Password'.tr),
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
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Email'.tr),
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
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.cyan,
        ),
        height: 50,
        width: 150,
        child: TextButton(
          onPressed: _isLoading
              ? null
              : () {
                  if (_formKe.currentState!.validate()) {
                    _createAdminAccount();
                  }
                },
          child: _isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : Text(
                  'Save'.tr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
        ),
      ),
    );
  }
Future<void> _createAdminAccount() async {
  setState(() {
    _isLoading = true;
  });

  try {
    final String passwordHashed = BCrypt.hashpw(
      _passwordController.text.trim(),
      BCrypt.gensalt(),
    );

    FirebaseApp app = await Firebase.initializeApp(
      name: _emailController.toString(),
      options: Firebase.app().options,
    );

    await FirebaseAuth.instanceFor(app: app).createUserWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    String uuid = FirebaseAuth.instanceFor(app: app).currentUser!.uid;

    await app.delete(); 

    String token = generateToken(200);

    await _firestore.collection('admins').doc(uuid).set({
      'email': _emailController.text.trim(),
      'username': _usernameController.text.trim(),
      'password': passwordHashed,
      'lastLogin': FieldValue.serverTimestamp(),
      'uid': uuid,
      'token': token,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Admin account created successfully'.tr),
      ),
    );

    String? adminId = FirebaseAuth.instance.currentUser?.uid;

    if (adminId != null) {
      await _firestore.collection('adminActions').add({
        'adminId': adminId,
        'adminEmail': FirebaseAuth.instance.currentUser?.email,
        'Name': _usernameController.text.trim(),
        'Id': uuid,
        'newState': "active",
        'type': 'Create an Admin',
        'timestamp': FieldValue.serverTimestamp(),
      });
    } else {
     }

    navigationController.navigateTo(showAdminsPageRoute);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Admin account created successfully'.tr),
      ),
    );
  } catch (e) {
 
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error creating admin account: ${e.toString()}'.tr),
      ),
    );
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          excludeHeaderSemantics: true,
          forceMaterialTransparency: true,
          automaticallyImplyLeading: false,
          title: Text('Add Admin Information'.tr),
          actions: [
            MaterialButton(
              height: 50,
              minWidth: 50,
              color: Colors.blue,
              child: Text(
                " Back".tr,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                //  navigationController.navigateTo();

                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 100),
            child: SingleChildScrollView(
              child: Form(
                key: _formKe,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    _buildUsernameField(),
                    const SizedBox(height: 16),
                    _buildEmailAndPasswordFields(),
                    //    const SizedBox(height: 16),
                    // _buildPhoneFields(),
                    const SizedBox(height: 16),
                    // _buildNameFields(),
                    // const SizedBox(height: 16),
                    // _buildEmailAndPhoneFields(),
                    // const SizedBox(height: 16),
                    // _buildPasswordAndGenderFields(),
                    const SizedBox(height: 30),
                    _buildSaveButton(),
                  ],
                ),
              ),
            )));
  }
}
