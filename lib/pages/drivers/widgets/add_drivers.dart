// import 'dart:io';
// import 'package:admin_dashboard/constants/controllers.dart';
// import 'package:admin_dashboard/routing/routes.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl_phone_field/intl_phone_field.dart';
// import 'package:path/path.dart' show basename;
// import 'dart:io' show File;
// import 'package:uuid/uuid.dart';

// class AddDriversWidgets extends StatefulWidget {
//   AddDriversWidgets({Key? key}) : super(key: key);

//   @override
//   State<AddDriversWidgets> createState() => _AddDriversPageState();
// }

// class _AddDriversPageState extends State<AddDriversWidgets> {
//   final _formKey = GlobalKey<FormState>();
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
//   final TextEditingController _balanceController = TextEditingController();

//   final bool isVerified = false;
//   List<Widget> itemPhotosWidgetList = <Widget>[];

//   final ImagePicker _picker = ImagePicker();
//   File? file;
//   List<XFile>? photo = <XFile>[];
//   List<XFile> itemImagesList = <XFile>[];

//   List<String> downloadUrl = <String>[];

//   bool uploading = false;
//   bool _isLoading = false;

//   @override
//   void dispose() {
//     _firstNameController.dispose();
//     _lastNameController.dispose();
//     _emailController.dispose();
//     _userNameController.dispose();
//     _phoneNumberController.dispose();
//     _carModelController.dispose();
//     _carPlateNumberController.dispose();
//     _carProductionYearController.dispose();
//     _balanceController.dispose();
//     //  _driverStatusController.dispose();

//     super.dispose();
//   }

//   void _addDriver() async {
//     if (_formKey.currentState!.validate()) {
//       DocumentReference driverRef =
//           await FirebaseFirestore.instance.collection('drivers').add({
//         //   "isOnline": _driverStatusController.toString(),
//         'firstName': _firstNameController.text,
//         'lastName': _lastNameController.text,
//         'email': _emailController.text,
//         'userName': _userNameController.text,
//         'rating': 0,
//         //'currentLocation': GeoPoint(29.9901077, 31.4298128), // Added current location
//         'phoneNumber': _phoneNumberController.text,
//         'isVerified': true,
//         'profileImage': '',
//         'balance': 0,
//         // 'profileImage': imageUrlDriver.toString(), // Use the uploaded image URL
//         'lastLog': DateTime.now(), //Timestamp.now(),
//       });
//       String driverId = driverRef.id;

//       await upload(driverId);

//       // Add vehicle data to Firestore
//       DocumentReference driverVhivlesRef = await FirebaseFirestore.instance
//           .collection('drivers')
//           .doc(driverRef.id)
//           .collection('vehicle')
//           .add({
//         'carModel': _carModelController.text,
//         'carPlateNumber': _carPlateNumberController.text,
//         'carProductionYear': _carProductionYearController.text,
//         'driverId': driverRef.id,
//       });

//       _formKey.currentState!.reset();
//       ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Driver added successfully')));
//       navigationController.navigateTo(showDriversPageRoute);
//     }
//   }

//   //}
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Add Drivers Information".tr),
//         actions: [
//           MaterialButton(
//             height: 50,
//             minWidth: 50,
//             color: Colors.blue,
//             child: Text(
//               " Back ".tr,
//               style: const TextStyle(
//                   color: Colors.white, fontWeight: FontWeight.bold),
//             ),
//             onPressed: () {
//               //  navigationController.navigateTo();

//               Navigator.pop(context);
//             },
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 100),
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
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(12.0),
//                             color: Colors.white70,
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.grey.shade200,
//                                 offset: const Offset(0.0, 0.5),
//                                 blurRadius: 30.0,
//                               )
//                             ]),
//                         // width: _screenwidth * 0.7,
//                         // height: 300.0,
//                         child: Center(
//                           child: itemPhotosWidgetList.isEmpty
//                               ? Center(
//                                   child: MaterialButton(
//                                     onPressed: pickPhotoFromGallery,
//                                     child: Container(
//                                       alignment: Alignment.bottomCenter,
//                                       child: Center(
//                                         child: Image.network(
//                                           "https://static.thenounproject.com/png/3322766-200.png",
//                                           height: 100.0,
//                                           width: 100.0,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 )
//                               : SingleChildScrollView(
//                                   scrollDirection: Axis.vertical,
//                                   child: Wrap(
//                                     spacing: 5.0,
//                                     direction: Axis.horizontal,
//                                     children: itemPhotosWidgetList,
//                                     alignment: WrapAlignment.spaceEvenly,
//                                     runSpacing: 10.0,
//                                   ),
//                                 ),
//                         ),
//                       ),
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
//                       const SizedBox(height: 16),
//                       _buildUsernameField(),
//                       const SizedBox(height: 16),
//                       _buildEmailAndPasswordFields(),
//                       const SizedBox(height: 16),
//                       _buildPhoneFields(),
//                       const SizedBox(height: 16),
//                       _CarModelDetails(),
//                       const SizedBox(height: 16),
//                       _CarYearProductionDetails(),
//                       const SizedBox(height: 30),
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
//           controller: _userNameController,
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
//             controller: _phoneNumberController,
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

//   Widget _CarModelDetails() {
//     return Row(
//       children: [
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('Car Model'.tr),
//               TextFormField(
//                 controller: _carModelController,
//                 decoration: InputDecoration(
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
//         const SizedBox(width: 16),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('Car Plate Number'.tr),
//               TextFormField(
//                 controller: _carPlateNumberController,
//                 decoration: InputDecoration(
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
//         Text('Car Production Year'.tr),
//         TextFormField(
//           controller: _carProductionYearController,
//           decoration: InputDecoration(
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
//           color: Colors.blue,
//         ),
//         height: 50,
//         width: 250,
//         child: TextButton(
//           onPressed: _isLoading
//               ? null
//               : () {
//                   if (_formKey.currentState!.validate()) {
//                     _addDriver();
//                     // upload(driverId);
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

//   addImage() {
//     for (var bytes in photo!) {
//       itemPhotosWidgetList.add(Padding(
//         padding: const EdgeInsets.all(1.0),
//         child: SizedBox(
//           height: 90.0,
//           child: AspectRatio(
//             aspectRatio: 16 / 9,
//             child: Container(
//               child: kIsWeb
//                   ? Image.network(File(bytes.path).path)
//                   : Image.file(
//                       File(bytes.path),
//                     ),
//             ),
//           ),
//         ),
//       ));
//     }
//   }

//   pickPhotoFromGallery() async {
//     photo = await _picker.pickMultiImage();
//     if (photo != null) {
//       setState(() {
//         itemImagesList = itemImagesList + photo!;
//         addImage();
//         photo!.clear();
//       });
//     }
//   }

//   upload(String driverId) async {
//     setState(() {
//       uploading = true;
//     });
//     for (int i = 0; i < itemImagesList.length; i++) {
//       file = File(itemImagesList[i].path);
//       PickedFile pickedFile = PickedFile(file!.path);

//       await uploadImageToFirestore(pickedFile, driverId);
//     }
//     setState(() {
//       uploading = false;
//     });
//     ("Image Uploaded Successfully");
//     setState(() {
//       uploading = false;
//     });
//     ("Image Uploaded Successfully");
//   }

//   Future<void> uploadImageToFirestore(
//       PickedFile? pickedFile, String driverId) async {
//     String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
//     Reference storageReference =
//         FirebaseStorage.instance.ref().child('drivers/$fileName');

//     await storageReference.putData(await pickedFile!.readAsBytes(),
//         SettableMetadata(contentType: 'image/jpeg'));

//     String imageUrlDriver = await storageReference.getDownloadURL();

//     await FirebaseFirestore.instance
//         .collection("drivers")
//         .doc(driverId)
//         .update({
//       'profileImage': imageUrlDriver,
//     });

//     downloadUrl.add(imageUrlDriver);
//   }
// }
