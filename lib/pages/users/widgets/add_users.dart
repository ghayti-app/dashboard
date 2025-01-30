import 'package:admin_dashboard/constants/controllers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../../../routing/routes.dart';

class AddUsersWidgets extends StatefulWidget {
  const AddUsersWidgets({super.key});

  @override
  State<AddUsersWidgets> createState() => _AddAdminsPageState();
}

class _AddAdminsPageState extends State<AddUsersWidgets> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _userNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  final _genderController = TextEditingController();
  final _phoneController = TextEditingController();

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  bool _isLoading = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _userNameController.dispose();
    _passwordController.dispose();
    _phoneNumberController.dispose();
    _genderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Users Information'.tr),
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
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 100),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildNameFields(),
                const SizedBox(height: 16),
                _buildUsernameField(),
                const SizedBox(height: 16),
                _buildEmailAndPasswordFields(),
                const SizedBox(height: 16),
                _buildPhoneFields(),
                const SizedBox(height: 16),
                // _buildNameFields(),
                //   SizedBox(height: 16),
                // _buildEmailAndPhoneFields(),
                //   SizedBox(height: 16),
                // _buildPasswordAndGenderFields(),
                const SizedBox(height: 30),
                _buildSaveButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneFields() {
    return Row(
      children: [
        Expanded(
          child: IntlPhoneField(
            controller: _phoneController,
            //  style:TextStyle(color:),
            decoration: InputDecoration(
              labelStyle: Theme.of(context)
                  .textTheme
                  .bodyLarge, // جعل النص يظهر في أقصى اليسار

              labelText: 'Phone Number'.tr,
              border: const OutlineInputBorder(
                borderSide: BorderSide(),
              ),
            ),
            onChanged: (phone) {
              (phone.completeNumber);
            },
            onCountryChanged: (country) {
              ('Country changed to: '.tr + country.name);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNameFields() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('First Name'.tr),
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Enter First Name'.tr,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter First Name'.tr;
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
              Text('Last Name'.tr),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Enter Last Name'.tr,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Last Name'.tr;
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

  Widget _buildUsernameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Username'.tr),
        TextFormField(
          controller: _userNameController,
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
                ),
                obscureText: true,
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
        // Expanded(
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //         Text('Gender'),
        //       DropdownButtonFormField<String>(
        //         decoration:   InputDecoration(
        //           border: OutlineInputBorder(),
        //         ),
        //         isExpanded: true,
        //         value: .text.isEmpty
        //             ? null
        //             : _genderController.text,
        //         items:   [
        //           DropdownMenuItem(
        //             value: 'Male',
        //             child: Text('Male'),
        //           ),
        //           DropdownMenuItem(
        //             value: 'Female',
        //             child: Text('Female'),
        //           ),
        //         ],
        //         onChanged: (value) {
        //           setState(() {
        //             _genderController.text = value!;
        //           });
        //         },
        //       ),
        //     ],
        //   ),
        // ),
      ],
    );
  }

  Widget _buildPasswordAndGenderFields() {
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
                ),
                obscureText: true,
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
              Text('Gender'.tr),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                isExpanded: true,
                value: _genderController.text.isEmpty
                    ? null
                    : _genderController.text,
                items: [
                  DropdownMenuItem(
                    value: 'Male',
                    child: Text('Male'.tr),
                  ),
                  DropdownMenuItem(
                    value: 'Female',
                    child: Text('Female'.tr),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _genderController.text = value!;
                  });
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
                  if (_formKey.currentState!.validate()) {
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
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final String? uid = userCredential.user?.uid;
      await _firestore.collection('users').doc(uid).set({
        'firstName': _firstNameController.text.trim(),
        'lastName': _lastNameController.text.trim(),
        'email': _emailController.text.trim(),
        'username': _firstNameController.text + _lastNameController.text,
        'phone': _phoneNumberController.text,
        'password': _passwordController.text.trim(),
        'gender': _genderController.text.trim(),
        'lastLogin': FieldValue.serverTimestamp(),
        'uid': uid,
      });

 
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User account created successfully!'.tr),
        ),
      );
      navigationController.navigateTo(showusersPageRoute);
    } on FirebaseAuthException catch (e) {
      ('Error creating user: ${e.code}'.tr);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error creating admin account: ${e.message}'.tr),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
