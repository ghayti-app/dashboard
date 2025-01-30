// // ignore_for_file: use_build_context_synchronously

// import 'package:cloud_firestore/cloud_firestore.dart';
//  import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl_phone_field/intl_phone_field.dart';

// class EditAdminWidgets extends StatefulWidget {
//   final String adminId;

//   const EditAdminWidgets({super.key, required this.adminId});

//   @override
//   State<EditAdminWidgets> createState() => _EditAdminPageState();
// }

// class _EditAdminPageState extends State<EditAdminWidgets> {
//   final _formKey = GlobalKey<FormState>();
//   final _firstNameController = TextEditingController();
//   final _lastNameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _usernameController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _passwordController = TextEditingController();

//   final _firestore = FirebaseFirestore.instance;

//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     _loadAdminData();
//   }

//   Future<void> _loadAdminData() async {
//     try {
//       DocumentSnapshot adminDoc =
//           await _firestore.collection('admins').doc(widget.adminId).get();
//       if (adminDoc.exists) {
//         Map<String, dynamic> data = adminDoc.data() as Map<String, dynamic>;
//         _firstNameController.text = data['firstName'] ?? ''.tr;
//         _lastNameController.text = data['lastName'] ?? ''.tr;
//         _emailController.text = data['email'] ?? ''.tr;
//         _usernameController.text = data['username'] ?? ''.tr;
//         _phoneController.text = data['phone'] ?? ''.tr;
//         _passwordController.text = data['password'] ?? ''.tr;
//       }
//     } catch (e) {
//        ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error loading admin data: $e'.tr),
//         ),
//       );
//     }
//   }

//   @override
//   void dispose() {
//     _firstNameController.dispose();
//     _lastNameController.dispose();
//     _emailController.dispose();
//     _usernameController.dispose();
//     _passwordController.dispose();
//     _phoneController.dispose();

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           automaticallyImplyLeading: false,
//           title: Text('Edit Admin Information'.tr),
//           actions: [
//             MaterialButton(
//               height: 50,
//               minWidth: 50,
//               color: Colors.blue,
//               child: Text(
//                 " Back ".tr,
//                 style: const TextStyle(
//                     color: Colors.white, fontWeight: FontWeight.bold),
//               ),
//               onPressed: () {
//                 //  navigationController.navigateTo();

//                 Navigator.pop(context);
//               },
//             ),
//           ],
//         ),
//         body: Padding(
//             padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 100),
//             child: SingleChildScrollView(
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     _buildNameFields(),
//                     const SizedBox(height: 16),
//                     _buildUsernameField(),
//                     const SizedBox(height: 16),
//                     _buildEmailAndPasswordFields(),
//                     const SizedBox(height: 16),
//                     _buildPhoneFields(),
//                     const SizedBox(height: 16),
//                     const SizedBox(height: 30),
//                     _buildSaveButton(),
//                   ],
//                 ),
//               ),
//             )));
//   }

//   Widget _buildNameFields() {
//     return Row(
//       children: [
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('First Name'.tr),
//               TextFormField(
//                 controller: _firstNameController,
//                 decoration: InputDecoration(
//                   border: const OutlineInputBorder(),
//                   hintText: 'Enter First Name'.tr,
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter First Name'.tr;
//                   }
//                   return null;
//                 },
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(width: 16),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('Last Name'.tr),
//               TextFormField(
//                 controller: _lastNameController,
//                 decoration: InputDecoration(
//                   border: const OutlineInputBorder(),
//                   hintText: 'Enter Last Name'.tr,
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter Last Name'.tr;
//                   }
//                   return null;
//                 },
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildUsernameField() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text('Username'.tr),
//         TextFormField(
//           controller: _usernameController,
//           decoration: InputDecoration(
//             border: const OutlineInputBorder(),
//             hintText: 'Enter Username'.tr,
//           ),
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return 'Please enter Username'.tr;
//             }
//             return null;
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildPhoneFields() {
//     return Row(
//       children: [
//         Expanded(
//           child: IntlPhoneField(
//             controller: _phoneController,
//             //  style:TextStyle(color:),
//             decoration: InputDecoration(
//               labelStyle: Theme.of(context).textTheme.bodyLarge,
//               labelText: 'Your Phone Number'.tr,
//               border: const OutlineInputBorder(
//                 borderSide: BorderSide(),
//               ),
//             ),
//             onChanged: (phone) {
//               (phone.completeNumber);
//             },
//             onCountryChanged: (country) {
//               ('Country changed to: '.tr + country.name);
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildEmailAndPasswordFields() {
//     return Row(
//       children: [
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('Password'.tr),
//               TextFormField(
//                 controller: _passwordController,
//                 decoration: InputDecoration(
//                   border: const OutlineInputBorder(),
//                   hintText: 'Enter Password'.tr,
//                 ),
//                 obscureText: true,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter Password'.tr;
//                   }
//                   if (value.length < 6) {
//                     return 'Password must be at least 6 characters'.tr;
//                   }
//                   return null;
//                 },
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(width: 16),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('Email'.tr),
//               TextFormField(
//                 controller: _emailController,
//                 decoration: InputDecoration(
//                   border: const OutlineInputBorder(),
//                   hintText: 'Enter Email'.tr,
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter Email'.tr;
//                   }
//                   if (!value.contains('@')) {
//                     return 'Please enter a valid Email'.tr;
//                   }
//                   return null;
//                 },
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildSaveButton() {
//     return Center(
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           color: Colors.cyan,
//         ),
//         height: 50,
//         width: 150,
//         child: TextButton(
//           onPressed: _isLoading
//               ? null
//               : () {
//                   if (_formKey.currentState!.validate()) {
//                     _updateAdminAccount();
//                   }
//                 },
//           child: _isLoading
//               ? const CircularProgressIndicator(color: Colors.white)
//               : Text(
//                   'Save'.tr,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 20,
//                   ),
//                 ),
//         ),
//       ),
//     );
//   }

//   Future<void> _updateAdminAccount() async {
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       await _firestore.collection('admins').doc(widget.adminId).update({
//         'firstName': _firstNameController.text.trim(),
//         'lastName': _lastNameController.text.trim(),
//         'email': _emailController.text.trim(),
//         'username': _usernameController.text.trim(),
//         'phone': _phoneController.text,
//         'password': _passwordController.text.trim(),
//         'lastLogin': FieldValue.serverTimestamp(),
//       });

 
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Admin account updated successfully!'.tr),
//         ),
//       );
//     } catch (e) {
//       ('Error updating admin account: $e'.tr);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error updating admin account: $e'.tr),
//         ),
//       );
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
// }
