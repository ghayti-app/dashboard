// import 'dart:io';

// import 'package:admin_dashboard/routing/routes.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/widgets.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl_phone_field/intl_phone_field.dart';
// import 'package:get/get.dart';
// import '../../../../layout.dart';

// class DriverUserProfilePage extends StatefulWidget {
//   final String driversId;

//     DriverUserProfilePage({
//     Key? key,
//     required this.driversId,
//   }) : super(key: key);

//   @override
//   State<DriverUserProfilePage> createState() => _EditDriversPageState();
// }

// class _EditDriversPageState extends State<DriverUserProfilePage> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _ImageController = TextEditingController();
//   final TextEditingController _firstNameController = TextEditingController();
//   final TextEditingController _lastNameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _userNameController = TextEditingController();
//   final TextEditingController _phoneNumberController = TextEditingController();
//   final TextEditingController _carModelController = TextEditingController();
//   final TextEditingController _carPlateNumberController =
//       TextEditingController();
//   final TextEditingController _carProductionYearController =
//       TextEditingController();
//   final TextEditingController _driverStatusController = TextEditingController();

//   final _auth = FirebaseAuth.instance;
//   final _firestore = FirebaseFirestore.instance;

//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     _loadDriversData();
//   }


//   Future<void> _loadDriversData() async {
//     try {
//       DocumentSnapshot DriversDoc =
//           await _firestore.collection('drivers').doc(widget.driversId).get();

//       if (DriversDoc.exists) {
//         Map<String, dynamic> data = DriversDoc.data() as Map<String, dynamic>;
//         _ImageController.text = data['profileImage'] ?? '';

//         _firstNameController.text = data['firstName'] ?? '';
//         _lastNameController.text = data['lastName'] ?? '';
//         _emailController.text = data['email'] ?? '';
//         _userNameController.text = data['username'] ?? '';
//         _phoneNumberController.text = data['phone'] ?? '';
//         _passwordController.text = data['password'] ?? '';
//         DocumentSnapshot vehicleDoc = await _firestore
//             .collection('drivers')
//             .doc(widget.driversId)
//             .collection('vehicle')
//             .doc(widget.driversId)
//             .get();
//         if (vehicleDoc.exists) {
//           Map<String, dynamic> vehicleData =
//               vehicleDoc.data() as Map<String, dynamic>;
//           _carModelController.text = vehicleData['carModel']?.toString() ?? '';
//           _carPlateNumberController.text =
//               vehicleData['carPlateNumber']?.toString() ?? '';
//           _carProductionYearController.text =
//               vehicleData['carProductionYear']?.toString() ?? '';
//         }
//       }
//     } catch (e) {
//        ('Error loading Drivers data: $e'.tr);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error loading Drivers data: $e'),
//         ),
//       );
//     }
//   }

//   @override
//   void dispose() {
//     _ImageController.dispose();
//     _firstNameController.dispose();
//     _lastNameController.dispose();
//     _emailController.dispose();
//     _userNameController.dispose();
//     _phoneNumberController.dispose();
//     _carModelController.dispose();
//     _carPlateNumberController.dispose();
//     _carProductionYearController.dispose();
//     // _balanceController.dispose();

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title:   const Text('Edit Drivers Information'),
//       ),
//       body: Padding(
//         padding:   const EdgeInsets.symmetric(vertical: 20, horizontal: 100),
//         child: SingleChildScrollView(
//           child: Form(
//             key: _formKey,
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(
//                   height: 25,
//                 ),

//                 Expanded(
//                   flex: 1,
//                   child: Column(
//                     children: [
//                       Container(
//                         height: 300,
//                         width: 300,
//                         decoration: const BoxDecoration(
//                           color: Colors.grey,
//                         ),
//                         child: const Column(
//                           mainAxisAlignment: MainAxisAlignment
//                               .center, // Center the content vertically
//                           children: [
                        
//                             // if (_selectedImage ==
//                             //     null) // Show "Choose Image" text if no image selected
//                             //   GestureDetector(
//                             //     onTap:
//                             //         _pickImage, // Trigger image picker on tap
//                             //     child: Container(
//                             //       width: 150,
//                             //       height: 150,
//                             //       decoration: BoxDecoration(
//                             //         borderRadius: BorderRadius.circular(50),
//                             //         color: Colors.grey[400],
//                             //       ),
//                             //       child: const Center(
//                             //         child: Text(
//                             //           'Choose Image',
//                             //           style: TextStyle(color: Colors.white),
//                             //         ),
//                             //       ),
//                             //     ),
//                             //   ),
//                             // if (_selectedImage != null)
//                             //   (kIsWeb
//                             //       ? Image.network(_selectedImage!.path,
//                             //           width: 285, height: 285)
//                             //       : Image.file(_selectedImage!,
//                             //           width: 285, height: 285)),
//                             // //     else {Text("No image selected")}
                         
//                           ],
//                         ),
//                       ),

//                       //  Column(
//                       //    children: [
//                       //      SizedBox(height: 50,),
//                       //
//                       //      CircleAvatar(backgroundImage:
//                       //      // _selectedImage != null ?
//                       //      // FileImage(_selectedImage!):AssetImage("assets/images/logo.jpg") as ImageProvider, radius: 80,
//                       //      ),
//                       //
//                       // SizedBox(height: 16),
//                       //      ElevatedButton(
//                       //        onPressed: _pickImage,
//                       //        child: Text('Pick Image'),
//                       //      ),
//                       //      //       if (_selectedImage != null) {
//                       //      // if (kIsWeb) {
//                       //      // return WebImage(imagePath: _selectedImage!.path);
//                       //      // } else {
//                       //      // return MobileImage(imageFile: _selectedImage!);
//                       //      // }
//                       //      // } else {
//                       //      // // Return a placeholder widget if no image selected
//                       //      // return   SizedBox(); // Or another placeholder
//                       //      // }
//                       //    ],
//                       //  )),
//                     ],
//                   ),
//                 ),

//                 const SizedBox(
//                   width: 20,
//                 ),

//                 Expanded(
//                   flex: 2,
//                   child: Column(
//                     children: [
//                       _buildNameFields(),
//                         const SizedBox(height: 16),
//                       _buildUsernameField(),
//                         const SizedBox(height: 16),
//                       _buildEmailAndPasswordFields(),
//                         const SizedBox(height: 16),
//                       _buildPhoneFields(),
//                         const SizedBox(height: 16),
//                       _CarModelDetails(),
//                         const SizedBox(height: 16),
//                       _CarYearProductionDetails(),
//                         const SizedBox(height: 30),
//                       _buildSaveButton(),
//                     ],
//                   ),
//                 ),
//                 //    _buildAddressField(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildNameFields() {
//     return Row(
//       children: [
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//                 Text('First Name'.tr),
//               TextFormField(
//                 controller: _firstNameController,
//                 decoration:   InputDecoration(
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
//           const SizedBox(width: 16),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//                 Text('Last Name'.tr),
//               TextFormField(
//                 controller: _lastNameController,
//                 decoration:   InputDecoration(
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
//           Text('Username'.tr),
//         TextFormField(
//           controller: _userNameController,
//           decoration:   InputDecoration(
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
//             controller: _phoneNumberController,
//             //  style:TextStyle(color:),
//             decoration: InputDecoration(
//               labelStyle: Theme.of(context)
//                   .textTheme
//                   .bodyLarge, // جعل النص يظهر في أقصى اليسار

//               labelText: 'Your Phone Number'.tr,
//               border: const OutlineInputBorder(
//                 borderSide: BorderSide(),
//               ),
//             ),
//             onChanged: (phone) {
//                (phone.completeNumber);
//             },
//             onCountryChanged: (country) {
//                ('Country changed to: '.tr + country.name);
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
//                 Text('Password'.tr),
//               TextFormField(
//                 controller: _passwordController,
//                 decoration:   InputDecoration(
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
//           const SizedBox(width: 16),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//                 Text('Email'.tr),
//               TextFormField(
//                 controller: _emailController,
//                 decoration:   InputDecoration(
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

//   Widget _CarModelDetails() {
//     return Row(
//       children: [
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//                 Text('Car Model'.tr),
//               TextFormField(
//                 controller: _carModelController,
//                 decoration:   InputDecoration(
//                   border: const OutlineInputBorder(),
//                   hintText: 'Enter Car Model'.tr,
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter Car Model'.tr;
//                   }
//                   return null;
//                 },
//               ),
//             ],
//           ),
//         ),
//           const SizedBox(width: 16),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//                 Text('Car Plate Number'.tr),
//               TextFormField(
//                 controller: _carPlateNumberController,
//                 decoration:   InputDecoration(
//                   border: const OutlineInputBorder(),
//                   hintText: 'Enter Car Plate Number'.tr,
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter Car Plate Number'.tr;
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

//   Widget _CarYearProductionDetails() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//           Text('Car Production Year'.tr),
//         TextFormField(
//           controller: _carProductionYearController,
//           decoration:   InputDecoration(
//             border: const OutlineInputBorder(),
//             hintText: 'Enter Car Production Year'.tr,
//           ),
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return 'Please enter Car Production Year'.tr;
//             }
//             return null;
//           },
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
//                     _loadDriversData();
//                   }
//                 },
//           child: _isLoading
//               ? const CircularProgressIndicator(color: Colors.white)
//               :   Text(
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

//   // Future<void> _updateDriversAccount() async {
//   //   setState(() {
//   //     _isLoading = true;
//   //   });

//   //   try {
//   //     await _firestore.collection('drivers').doc(widget.driversId).update({
//   //       'firstName': _firstNameController.text.trim(),
//   //       'lastName': _lastNameController.text.trim(),
//   //       'email': _emailController.text.trim(),
//   //       'username': _userNameController.text.trim(),
//   //       'phone': _phoneNumberController.text,
//   //       'password': _passwordController.text.trim(),
//   //       'phoneNumber': _phoneNumberController.text,
//   //       'isVerified': true,
//   //       //  'balance': 60,
//   //       //  'profileImage': imageUrl, // Use the uploaded image URL
//   //       'lastlog': Timestamp.now(),
//   //       'lastLogin': FieldValue.serverTimestamp(),
//   //     });
//   //     await FirebaseFirestore.instance
//   //         .collection('drivers')
//   //         .doc(widget.driversId)
//   //         .collection('vehicle')
//   //         .doc(widget.driversId)
//   //         .update({
//   //       'carModel': _carModelController.text,
//   //       'carPlateNumber': _carPlateNumberController.text,
//   //       'carProductionYear': _carProductionYearController.text,
//   //     });
 
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //         SnackBar(
//   //         content: Text('Drivers account updated successfully!'),
//   //       ),
//   //     );
//   //   } catch (e) {
//   //      ('Error updating Drivers account: $e');
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       SnackBar(
//   //         content: Text('Error updating Drivers account: $e'),
//   //       ),
//   //     );
//   //   } finally {
//   //     setState(() {
//   //       _isLoading = false;
//   //     });
//   //   }
//   // }
// }
