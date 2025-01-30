import 'package:admin_dashboard/constants/controllers.dart';
import 'package:admin_dashboard/routing/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import 'package:intl/intl.dart';

class EditUsersWidgets extends StatefulWidget {
  final String UsersId;

  const EditUsersWidgets({super.key, required this.UsersId});

  @override
  State<EditUsersWidgets> createState() => _EditUsersPageState();
}

class _EditUsersPageState extends State<EditUsersWidgets> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  var _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _genderController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _ratingController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _addressController = TextEditingController();
  final _balanceController = TextEditingController();
  final _birthdayController = TextEditingController();
  final _contactController = TextEditingController();
  final _createTimeController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUsersData();
  }

  Future<void> _loadUsersData() async {
    try {
      DocumentSnapshot UsersDoc =
          await _firestore.collection('users').doc(widget.UsersId).get();
      if (UsersDoc.exists) {
        Map<String, dynamic> data = UsersDoc.data() as Map<String, dynamic>;
        _firstNameController.text = data['firstName'] ?? '';
        _lastNameController.text = data['lastName'] ?? '';
        _emailController.text = data['email'] ?? '';
        _usernameController.text = data['userName'] ?? '';
        _phoneController.text = data['phoneNumber'] ?? '';
        _passwordController.text = data['password'] ?? '';
        _accountNumberController.text = data['accountNumber'] ?? '';
        _addressController.text = data['address'] ?? '';
        _balanceController.text = (data['balance'] as int?)?.toString() ??
            '0'; // Assuming balance is an integer
        _birthdayController.text =
            data['birthday'] ?? ''; // Assuming birthday is a string
        _contactController.text =
            (data['contact'] as List<dynamic>?)?.join(', ') ??
                ''; // Convert array to string
        _createTimeController.text = DateFormat('MMMM d, yyyy h:mm a')
            .format(data['createTime'].toDate()); // Format timestamp
        _ratingController.text =
            (data['rating'] as double?)?.toStringAsFixed(1) ??
                '0'; // Assuming rating is a double
      }
    } catch (e) {
      ('Error loading Users data: $e'.tr);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading Users data: $e'.tr),
        ),
      );
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _genderController.dispose();
    _bankNameController.dispose();
    _accountNumberController.dispose();
    _addressController.dispose();
    _addressController.dispose();
    _balanceController.dispose();
    _birthdayController.dispose();
    _contactController.dispose();
    _createTimeController.dispose();
    _ratingController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Users Information'.tr),
        actions: [
          MaterialButton(
            height: 50,
            minWidth: 50,
            color: Colors.blue,
            child: Text(
              " Back ".tr,
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
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildNameFields(),
                const SizedBox(height: 16),
                _buildUserNameFields(),
                const SizedBox(height: 16),
                _buildPasswordAndGenderFields(),
                const SizedBox(height: 16),
                _buildBalanceBirthdayContactFields(),
                const SizedBox(height: 16),
                _buildEmailAndPhoneFields(),
                const SizedBox(height: 16),
                Row(
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
                          _phoneController = phone as TextEditingController;
                        },
                        onCountryChanged: (country) {
                          ('Country changed to: '.tr + country.name);
                        },
                        validator: (value) {
                          if (value == null || value.isValidNumber()) {
                            return 'Please enter Phone'.tr;
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                _buildSaveButton(),
              ],
            ),
          ),
        ),
      ),
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

  Widget _buildUserNameFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('User Name'.tr),
        TextFormField(
          controller: _usernameController,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: 'Enter User Name'.tr,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter User Name'.tr;
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildEmailAndPhoneFields() {
    return Row(
      children: [
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
        const SizedBox(width: 16),
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

  Widget _buildBalanceBirthdayContactFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Balance'.tr),
        TextFormField(
          controller: _balanceController,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: 'Enter Balance'.tr,
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter Balance'.tr;
            }
            return null;
          },
        ),
        Text('Birthday'.tr),
        TextFormField(
          controller: _birthdayController,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: 'Enter Birthday'.tr,
          ),
          keyboardType: TextInputType.datetime,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter Birthday'.tr;
            }
            return null;
          },
        ),
        Text('Contacts'.tr),
        TextFormField(
          controller: _contactController,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: 'Enter Contacts'.tr,
          ),
          readOnly: true, // Make it read-only since contacts are auto-filled
        ),
        // Add similar widgets for other fields...
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
                    _updateUsersAccount();
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

  Future<void> _updateUsersAccount() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _firestore.collection('users').doc(widget.UsersId).update({
        'firstName': _firstNameController.text.trim(),
        'lastName': _lastNameController.text.trim(),
        'email': _emailController.text.trim(),
        'userName': _usernameController.text.trim(),
        'phoneNumber': _phoneController.text,
        'password': _passwordController.text.trim(),
        'gender': _genderController.text.trim(),
        'address': _addressController.text.trim(),
        'lastLogin': FieldValue.serverTimestamp(),
        'balance': int.parse(_balanceController.text),
        'birthday': _birthdayController.text,
        'contact':
            List.from(_contactController.text.split(', ').map((e) => e.trim())),
        'createTime': FieldValue.serverTimestamp(),
        'rating': double.parse(_ratingController.text),
      });
      navigationController.navigateTo(showusersPageRoute);

 
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Users account updated successfully!'.tr),
        ),
      );
    } catch (e) {
      ('Error updating Users account: $e'.tr);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating Users account: $e'.tr),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
