// import 'dart:io';

// import 'package:admin_dashboard/helpers/authentication.dart';
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
// import '../../../constants/controllers.dart';
// import '../../../layout.dart';

// class EditDriversWidgetsInfo extends StatefulWidget {
//   final String driversId;

//   EditDriversWidgetsInfo({
//     Key? key,
//     required this.driversId,
//   }) : super(key: key);

//   @override
//   State<EditDriversWidgetsInfo> createState() => _EditDriversPageState();
// }

// class _EditDriversPageState extends State<EditDriversWidgetsInfo> {
//   final _formKey = GlobalKey<FormState>();
//   // final TextEditingController _ImageController = TextEditingController();
//   // final TextEditingController _firstNameController = TextEditingController();
//   // final TextEditingController _lastNameController = TextEditingController();
//   // final TextEditingController _emailController = TextEditingController();
//   // final TextEditingController _passwordController = TextEditingController();
//   // final TextEditingController _userNameController = TextEditingController();
//   // final TextEditingController _phoneNumberController = TextEditingController();
//   // final TextEditingController _balanceController = TextEditingController();
//   // final TextEditingController _carModelController = TextEditingController();
//   // final TextEditingController _carPlateNumberController =
//   //     TextEditingController();
//   // final TextEditingController _carProductionYearController =
//   //     TextEditingController();

//   bool _verficationController = false;
//   // List<Widget> itemPhotosWidgetList = <Widget>[];

//   // final ImagePicker _picker = ImagePicker();
//   // File? file;
//   // List<XFile>? photo = <XFile>[];
//   // List<XFile> itemImagesList = <XFile>[];

//   // List<String> downloadUrl = <String>[];

//   bool uploading = false;
//   bool _isLoading = false;
//   final _auth = FirebaseAuth.instance;
//   final _firestore = FirebaseFirestore.instance;

//   bool _isVerified = false;

//   void _updateVerificationStatus(bool newStatus) async {
//     try {
//       await _firestore.collection('drivers').doc(widget.driversId).update({
//         'isVerified': newStatus,
//       });
//       await _firestore.collection('Documents').doc(widget.driversId).update({
//         'status': newStatus,
//       });
//       setState(() {
//         _isVerified = newStatus;
//       });
//       // ScaffoldMessenger.of(context).showSnackBar(
//       //   SnackBar(
//       //     content: Text(newStatus ? 'Driver Verified' : 'Driver Unverified'),
//       //   ),
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text(
//               'Verification Account'.tr,
//               style: const TextStyle(fontSize: 20),
//             ),
//             content: SingleChildScrollView(
//               child: Text(
//                 newStatus ? 'Driver Verified'.tr : 'Driver Unverified'.tr,
//                 style: const TextStyle(fontSize: 20),
//               ),
//             ),
//             actions: <Widget>[
//               TextButton(
//                 child: Text('Close'.tr),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ],
//           );
//         },
//       );
//     } catch (e) {
//        ('Error updating verification status: $e'.tr);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error updating verification status: $e'.tr),
//         ),
//       );
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     _loadDriversData();
//   }

//   Future<void> _loadDriversData() async {
//     try {
//       DocumentSnapshot DriversDoc =
//           await _firestore.collection('drivers').doc(widget.driversId).get();

//       // String driverId = DriversDoc.id;

//       // await upload(driverId);

//       // if (DriversDoc.exists) {
//       // String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';

//       // Reference storageReference =
//       //     FirebaseStorage.instance.ref().child('drivers/$fileName');

//       // String imageUrlDriver = await storageReference.getDownloadURL();
//       Map<String, dynamic> data = DriversDoc.data() as Map<String, dynamic>;
//       // _ImageController.text = data['profileImage'] ?? '';
//       // _firstNameController.text = data['firstName'] ?? ''; //
//       // _balanceController.text = data['balance'] ?? "";
//       // _lastNameController.text = data['lastName'] ?? '';
//       // _emailController.text = data['email'] ?? '';
//       // _userNameController.text = data['userName'] ?? '';
//       // _phoneNumberController.text = data['phoneNumber'] ?? '';
//       // _passwordController.text = data['password'] ?? '';
//       _verficationController = data['isVerified'] ?? '';
//       //  imageUrlDriver = data['profileImage'] ?? '';

//       // var customers = snapshot.data!.docs;
//       //  var customerid = customers[index];
//       // var vehicleDoc = await _firestore
//       //     .collection('drivers')
//       //     .doc(widget.driversId)
//       //     .collection('vehicle')
//       //     .get();

//       // if (vehicleDoc.docs[0].exists) {
//       //   Map<String, dynamic> vehicleData = vehicleDoc.docs[0].data();
//       //   //   vehicleDoc  as Map<String, dynamic>;
//       //   // _carModelController.text = vehicleData['carModel']?.toString() ?? '';
//       //   // _carPlateNumberController.text =
//       //   //     vehicleData['carPlateNumber']?.toString() ?? '';
//       //   // _carProductionYearController.text =
//       //   //     vehicleData['carProductionYear']?.toString() ?? '';
//       // }
//       // }
//     } catch (e) {
//        ('Error loading Drivers data: $e'.tr);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error loading Drivers data: $e'.tr),
//         ),
//       );
//     }
//   }

//   @override
//   void dispose() {
//     // _ImageController.dispose();
//     // _firstNameController.dispose();
//     // _lastNameController.dispose();
//     // _emailController.dispose();
//     // _userNameController.dispose();
//     // _phoneNumberController.dispose();
//     // _carModelController.dispose();
//     // _carPlateNumberController.dispose();
//     // _carProductionYearController.dispose();
//     // _balanceController.dispose();

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           automaticallyImplyLeading: false,
//           title: Text('Verfication Driver Account'.tr),
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
//                 navigationController.navigateTo(showDriversPageRoute);

//                 // Navigator.pop(context);
//               },
//             ),
//           ],
//         ),
//         body: Padding(
//             padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 100),
//             child: SingleChildScrollView(
//                 child: Form(
//                     key: _formKey,
//                     child: Center(
//                       child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const SizedBox(
//                               height: 25,
//                             ),

//                             // Expanded(
//                             //   flex: 1,
//                             //   child: Column(
//                             //     children: [
//                             //       Container(
//                             //         height: 300,
//                             //         width: 300,
//                             //         decoration: const BoxDecoration(
//                             //           color: Colors.grey,
//                             //         ),
//                             //         child: Column(
//                             //           mainAxisAlignment: MainAxisAlignment
//                             //               .center, // Center the content vertically
//                             //           children: [
//                             //             Container(
//                             //               height: 300,
//                             //               width: 300,
//                             //               decoration: BoxDecoration(
//                             //                   borderRadius: BorderRadius.circular(12.0),
//                             //                   color: Colors.white70,
//                             //                   boxShadow: [
//                             //                     BoxShadow(
//                             //                       color: Colors.grey.shade200,
//                             //                       offset: const Offset(0.0, 0.5),
//                             //                       blurRadius: 30.0,
//                             //                     )
//                             //                   ]),
//                             //               // width: _screenwidth * 0.7,
//                             //               // height: 300.0,
//                             //               child: Center(
//                             //                 child: itemPhotosWidgetList.isEmpty
//                             //                     ? Center(
//                             //                         child: MaterialButton(
//                             //                           onPressed: pickPhotoFromGallery,
//                             //                           child: Container(
//                             //                             alignment: Alignment.bottomCenter,
//                             //                             child: Center(
//                             //                               child: Image.network(
//                             //                                 "https://static.thenounproject.com/png/3322766-200.png",
//                             //                                 height: 100.0,
//                             //                                 width: 100.0,
//                             //                               ),
//                             //                             ),
//                             //                           ),
//                             //                         ),
//                             //                       )
//                             //                     : SingleChildScrollView(
//                             //                         scrollDirection: Axis.vertical,
//                             //                         child: Wrap(
//                             //                           spacing: 5.0,
//                             //                           direction: Axis.horizontal,
//                             //                           children: itemPhotosWidgetList,
//                             //                           alignment: WrapAlignment.spaceEvenly,
//                             //                           runSpacing: 10.0,
//                             //                         ),
//                             //                       ),
//                             //               ),
//                             //             ),
//                             //           ],
//                             //         ),
//                             //       ),
//                             //       const SizedBox(
//                             //         height: 20,
//                             //       ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 DropdownButton<bool>(
//                                   value: _verficationController,
//                                   items: [
//                                     DropdownMenuItem(
//                                       value: true,
//                                       child: Row(
//                                         children: [
//                                           const Icon(Icons.verified,
//                                               color: Colors.green),
//                                           const SizedBox(width: 10),
//                                           Text("Verified".tr),
//                                         ],
//                                       ),
//                                     ),
//                                     DropdownMenuItem(
//                                       value: false,
//                                       child: Row(
//                                         children: [
//                                           const Icon(Icons.close,
//                                               color: Colors.red),
//                                           const SizedBox(width: 10),
//                                           Text("Unverified".tr),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                   onChanged: (value) {
//                                     setState(() {
//                                       _verficationController = value!;
//                                       _updateVerificationStatus(value);
//                                     });
//                                   },
//                                 ),
//                               ],
//                             )
//                           ]),
//                     )))));

//     // const SizedBox(
//     //   width: 30,
//     // ),

//     //         Expanded(
//     //           flex: 2,
//     //           child: Column(
//     //             children: [
//     //               // _buildNameFields(),
//     //               // const SizedBox(height: 16),
//     //               // _buildUsernameField(),
//     //               // const SizedBox(height: 16),
//     //               // _buildEmailAndPasswordFields(),
//     //               // const SizedBox(height: 16),
//     //               // _buildPhoneFields(),
//     //               // const SizedBox(height: 16),
//     //               // _CarModelDetails(),
//     //               // const SizedBox(height: 16),
//     //               // _CarYearProductionDetails(),
//     //               // const SizedBox(height: 30),
//     //               _buildSaveButton(),
//     //             ],
//     //           ),
//     //         ),
//     //         //    _buildAddressField(),
//     //     //   ],
//     //     // ),
//     //   ),
//     // ),
//     //   ),
//   }

//   // Widget _buildNameFields() {
//   //   return Row(
//   //     children: [
//   //       Expanded(
//   //         child: Column(
//   //           crossAxisAlignment: CrossAxisAlignment.start,
//   //           children: [
//   //             Text('First Name'.tr),
//   //             TextFormField(
//   //               controller: _firstNameController,
//   //               decoration: InputDecoration(
//   //                 border: const OutlineInputBorder(),
//   //                 hintText: 'Enter First Name'.tr,
//   //               ),
//   //               validator: (value) {
//   //                 if (value == null || value.isEmpty) {
//   //                   return 'Please enter First Name'.tr;
//   //                 }
//   //                 return null;
//   //               },
//   //             ),
//   //           ],
//   //         ),
//   //       ),
//   //       const SizedBox(width: 16),
//   //       Expanded(
//   //         child: Column(
//   //           crossAxisAlignment: CrossAxisAlignment.start,
//   //           children: [
//   //             Text('Last Name'.tr),
//   //             TextFormField(
//   //               controller: _lastNameController,
//   //               decoration: InputDecoration(
//   //                 border: const OutlineInputBorder(),
//   //                 hintText: 'Enter Last Name'.tr,
//   //               ),
//   //               validator: (value) {
//   //                 if (value == null || value.isEmpty) {
//   //                   return 'Please enter Last Name'.tr;
//   //                 }
//   //                 return null;
//   //               },
//   //             ),
//   //           ],
//   //         ),
//   //       ),
//   //     ],
//   //   );
//   // }

//   // Widget _buildUsernameField() {
//   //   return Column(
//   //     crossAxisAlignment: CrossAxisAlignment.start,
//   //     children: [
//   //       Text('Username'.tr),
//   //       TextFormField(
//   //         controller: _userNameController,
//   //         decoration: InputDecoration(
//   //           border: const OutlineInputBorder(),
//   //           hintText: 'Enter Username'.tr,
//   //         ),
//   //         validator: (value) {
//   //           if (value == null || value.isEmpty) {
//   //             return 'Please enter Username'.tr;
//   //           }
//   //           return null;
//   //         },
//   //       ),
//   //     ],
//   //   );
//   // }

//   // Widget _buildPhoneFields() {
//   //   return Row(
//   //     children: [
//   //       Expanded(
//   //         child: IntlPhoneField(
//   //           controller: _phoneNumberController,
//   //           //  style:TextStyle(color:),
//   //           decoration: InputDecoration(
//   //             labelStyle: Theme.of(context)
//   //                 .textTheme
//   //                 .bodyLarge, // جعل النص يظهر في أقصى اليسار

//   //             labelText: 'Your Phone Number'.tr,
//   //             border: const OutlineInputBorder(
//   //               borderSide: BorderSide(),
//   //             ),
//   //           ),
//   //           onChanged: (phone) {
//   //              (phone.completeNumber);
//   //           },
//   //           onCountryChanged: (country) {
//   //              ('Country changed to: '.tr + country.name);
//   //           },
//   //         ),
//   //       ),
//   //     ],
//   //   );
//   // }

//   // Widget _buildEmailAndPasswordFields() {
//   //   return Row(
//   //     children: [
//   //       Expanded(
//   //         child: Column(
//   //           crossAxisAlignment: CrossAxisAlignment.start,
//   //           children: [
//   //             Text('Password'.tr),
//   //             TextFormField(
//   //               controller: _passwordController,
//   //               decoration: InputDecoration(
//   //                 border: const OutlineInputBorder(),
//   //                 hintText: 'Enter Password'.tr,
//   //               ),
//   //               obscureText: true,
//   //               validator: (value) {
//   //                 if (value == null || value.isEmpty) {
//   //                   return 'Please enter Password'.tr;
//   //                 }
//   //                 if (value.length < 6) {
//   //                   return 'Password must be at least 6 characters'.tr;
//   //                 }
//   //                 return null;
//   //               },
//   //             ),
//   //           ],
//   //         ),
//   //       ),
//   //       const SizedBox(width: 16),
//   //       Expanded(
//   //         child: Column(
//   //           crossAxisAlignment: CrossAxisAlignment.start,
//   //           children: [
//   //             Text('Email'.tr),
//   //             TextFormField(
//   //               controller: _emailController,
//   //               decoration: InputDecoration(
//   //                 border: const OutlineInputBorder(),
//   //                 hintText: 'Enter Email'.tr,
//   //               ),
//   //               validator: (value) {
//   //                 if (value == null || value.isEmpty) {
//   //                   return 'Please enter Email'.tr;
//   //                 }
//   //                 if (!value.contains('@')) {
//   //                   return 'Please enter a valid Email'.tr;
//   //                 }
//   //                 return null;
//   //               },
//   //             ),
//   //           ],
//   //         ),
//   //       ),
//   //       // Expanded(
//   //       //   child: Column(
//   //       //     crossAxisAlignment: CrossAxisAlignment.start,
//   //       //     children: [
//   //       //        Text('Gender'),
//   //       //       DropdownButtonFormField<String>(
//   //       //         decoration:  InputDecoration(
//   //       //           border: OutlineInputBorder(),
//   //       //         ),
//   //       //         isExpanded: true,
//   //       //         value: .text.isEmpty
//   //       //             ? null
//   //       //             : _genderController.text,
//   //       //         items:  [
//   //       //           DropdownMenuItem(
//   //       //             value: 'Male',
//   //       //             child: Text('Male'),
//   //       //           ),
//   //       //           DropdownMenuItem(
//   //       //             value: 'Female',
//   //       //             child: Text('Female'),
//   //       //           ),
//   //       //         ],
//   //       //         onChanged: (value) {
//   //       //           setState(() {
//   //       //             _genderController.text = value!;
//   //       //           });
//   //       //         },
//   //       //       ),
//   //       //     ],
//   //       //   ),
//   //       // ),
//   //     ],
//   //   );
//   // }

//   // Widget _CarModelDetails() {
//   //   return Row(
//   //     children: [
//   //       Expanded(
//   //         child: Column(
//   //           crossAxisAlignment: CrossAxisAlignment.start,
//   //           children: [
//   //             Text('Car Model'.tr),
//   //             TextFormField(
//   //               controller: _carModelController,
//   //               decoration: InputDecoration(
//   //                 border: const OutlineInputBorder(),
//   //                 hintText: 'Enter Car Model'.tr,
//   //               ),
//   //               validator: (value) {
//   //                 if (value == null || value.isEmpty) {
//   //                   return 'Please enter Car Model'.tr;
//   //                 }
//   //                 return null;
//   //               },
//   //             ),
//   //           ],
//   //         ),
//   //       ),
//   //       const SizedBox(width: 16),
//   //       Expanded(
//   //         child: Column(
//   //           crossAxisAlignment: CrossAxisAlignment.start,
//   //           children: [
//   //             Text('Car Plate Number'.tr),
//   //             TextFormField(
//   //               controller: _carPlateNumberController,
//   //               decoration: InputDecoration(
//   //                 border: const OutlineInputBorder(),
//   //                 hintText: 'Enter Car Plate Number'.tr,
//   //               ),
//   //               validator: (value) {
//   //                 if (value == null || value.isEmpty) {
//   //                   return 'Please enter Car Plate Number'.tr;
//   //                 }
//   //                 return null;
//   //               },
//   //             ),
//   //           ],
//   //         ),
//   //       ),
//   //     ],
//   //   );
//   // }

//   // Widget _CarYearProductionDetails() {
//   //   return Column(
//   //     crossAxisAlignment: CrossAxisAlignment.start,
//   //     children: [
//   //       Text('Car Production Year'.tr),
//   //       TextFormField(
//   //         controller: _carProductionYearController,
//   //         decoration: InputDecoration(
//   //           border: const OutlineInputBorder(),
//   //           hintText: 'Enter Car Production Year'.tr,
//   //         ),
//   //         validator: (value) {
//   //           if (value == null || value.isEmpty) {
//   //             return 'Please enter Car Production Year'.tr;
//   //           }
//   //           return null;
//   //         },
//   //       ),
//   //     ],
//   //   );
//   // }

//   // Widget _buildSaveButton() {
//   //   return Center(
//   //     child: Container(
//   //       decoration: BoxDecoration(
//   //         borderRadius: BorderRadius.circular(10),
//   //         color: Colors.cyan,
//   //       ),
//   //       height: 50,
//   //       width: 150,
//   //       child: TextButton(
//   //         onPressed: _isLoading
//   //             ? null
//   //             : () {
//   //                 if (_formKey.currentState!.validate()) {
//   //                   _updateDriversAccount();
//   //                 }
//   //               },
//   //         child: _isLoading
//   //             ? const CircularProgressIndicator(color: Colors.white)
//   //             : Text(
//   //                 'Save'.tr,
//   //                 style: const TextStyle(
//   //                   color: Colors.white,
//   //                   fontWeight: FontWeight.bold,
//   //                   fontSize: 20,
//   //                 ),
//   //               ),
//   //       ),
//   //     ),
//   //   );
//   // }

//   Future<void> _updateDriversAccount() async {
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       await _firestore.collection('drivers').doc(widget.driversId).update({
//         // 'firstName': _firstNameController.text.trim(),
//         // 'lastName': _lastNameController.text.trim(),
//         // 'email': _emailController.text.trim(),
//         // 'userName': _userNameController.text.trim(),
//         // 'phone': _phoneNumberController.text,
//         // 'password': _passwordController.text.trim(),
//         'isVerified': _verficationController,
//         // 'balance': _balanceController.text,
//         // 'profileImage': imageUrl,
//         // 'lastlog': Timestamp.now(),
//         // 'lastLogin': FieldValue.serverTimestamp(),
//       });
//       //  var   vehicleDoc = await _firestore
//       //     .collection('drivers')
//       //     .doc(widget.driversId)
//       //     .collection('vehicle')
//       //     .get();
//       // if (vehicleDoc.docs[0].exists) {
//       //   Map<String, dynamic> vehicleData =
//       //       vehicleDoc.docs[0].data();
//       //    //   vehicleDoc  as Map<String, dynamic>;
//       //   _carModelController.text = vehicleData['carModel']?.toString() ?? '';
//       // await FirebaseFirestore.instance
//       //     .collection('drivers')
//       //     .doc(widget.driversId)
//       //     .collection('vehicle')
//       //     .doc()
//       //     .update({
//       //   'carModel': _carModelController.text,
//       //   'carPlateNumber': _carPlateNumberController.text,
//       //   'carProductionYear': _carProductionYearController.text,
//       // });
 
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Drivers account updated successfully!'.tr),
//         ),
//       );
//     } catch (e) {
//        ('Error updating Drivers account: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error updating Drivers account: $e'.tr),
//         ),
//       );
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   } 

//   // addImage() {
//   //   for (var bytes in photo!) {
//   //     itemPhotosWidgetList.add(Padding(
//   //       padding: const EdgeInsets.all(1.0),
//   //       child: SizedBox(
//   //         height: 90.0,
//   //         child: AspectRatio(
//   //           aspectRatio: 16 / 9,
//   //           child: Container(
//   //             child: kIsWeb
//   //                 ? Image.network(File(bytes.path).path)
//   //                 : Image.file(
//   //                     File(bytes.path),
//   //                   ),
//   //           ),
//   //         ),
//   //       ),
//   //     ));
//   //   }
//   // }

//   // pickPhotoFromGallery() async {
//   //   photo = await _picker.pickMultiImage();
//   //   if (photo != null) {
//   //     setState(() {
//   //       itemImagesList = itemImagesList + photo!;
//   //       addImage();
//   //       photo!.clear();
//   //     });
//   //   }
//   // }

//   // upload(String driverId) async {
//   //   setState(() {
//   //     uploading = true;
//   //   });
//   //   for (int i = 0; i < itemImagesList.length; i++) {
//   //     file = File(itemImagesList[i].path);
//   //     PickedFile pickedFile = PickedFile(file!.path);

//   //     await uploadImageToFirestore(pickedFile, driverId);
//   //   }
//   //   setState(() {
//   //     uploading = false;
//   //   });
//   //    ("Image Uploaded Successfully");
//   //   setState(() {
//   //     uploading = false;
//   //   });
//   //    ("Image Uploaded Successfully");
//   // }

//   // Future<void> uploadImageToFirestore(
//   //     PickedFile? pickedFile, String driverId) async {
//   //   String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
//   //   Reference storageReference =
//   //       FirebaseStorage.instance.ref().child('drivers/$fileName');

//   //   await storageReference.putData(await pickedFile!.readAsBytes(),
//   //       SettableMetadata(contentType: 'image/jpeg'));

//   //   String imageUrlDriver = await storageReference.getDownloadURL();

//   //   await FirebaseFirestore.instance
//   //       .collection("drivers")
//   //       .doc(driverId)
//   //       .update({
//   //     'profileImage': imageUrlDriver,
//   //   });

//   //   downloadUrl.add(imageUrlDriver);
//   // }
// }
