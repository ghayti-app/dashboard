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
// import '../../constants/controllers.dart ';

// class EditRideRequest extends StatefulWidget {
//   final String driversId;

//   EditRideRequest({
//     Key? key,
//     required this.driversId,
//   }) : super(key: key);

//   @override
//   State<EditRideRequest> createState() => _EditDriversPageState();
// }

// class _EditDriversPageState extends State<EditRideRequest> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController Rider = TextEditingController();
//   final TextEditingController Driver = TextEditingController();
//   final TextEditingController Adress = TextEditingController();
//   final TextEditingController Distance = TextEditingController();
//   final TextEditingController Duration = TextEditingController();
//   final TextEditingController Cost = TextEditingController();
//   final TextEditingController service = TextEditingController();
//   final TextEditingController Status = TextEditingController();

//   bool _verficationController = false;

//   final _auth = FirebaseAuth.instance;
//   final _firestore = FirebaseFirestore.instance;

//   bool _isLoading = false;
//   // bool _isVerified = false; // State for the verification status

//   // void _updateVerificationStatus(bool newStatus) async {
//   //   try {
//   //     // await _firestore.collection('rideRequest').doc(widget.driversId).update({
//   //     //   'isVerified': newStatus,
//   //     // });
//   //     // await _firestore.collection('Documents').doc(widget.driversId).update({
//   //     //   'status': newStatus,
//   //     // });
//   //     // setState(() {
//   //     //   _isVerified = newStatus;
//   //     // });
//   //     // ScaffoldMessenger.of(context).showSnackBar(
//   //     //   SnackBar(
//   //     //     content: Text(newStatus ? 'Driver Verified' : 'Driver Unverified'),
//   //     //   ),
//   //         showDialog(
//   //           context: context,
//   //           builder: (BuildContext context) {
//   //             return AlertDialog(
//   //               title: Text('Verification Account' ,style: TextStyle(fontSize: 20),),
//   //               content: SingleChildScrollView(
//   //                 child: Text(newStatus ? 'Driver Verified' : 'Driver Unverified' , style: TextStyle(fontSize: 20),),
//   //               ),
//   //               actions: <Widget>[
//   //                 TextButton(
//   //                   child: Text('Close'),
//   //                   onPressed: () {
//   //                     Navigator.of(context).pop();
//   //                   },
//   //                 ),
//   //               ],
//   //             );
//   //           },
//   //     );
//   //   } catch (e) {
//   //      ('Error updating verification status: $e');
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       SnackBar(
//   //         content: Text('Error updating verification status: $e'),
//   //       ),
//   //
//   //     );
//   //   }
//   // }
//   //

//   @override
//   void initState() {
//     super.initState();
//     _loadDriversData();
//   }

//   Future<void> _loadDriversData() async {
//     try {
//       DocumentSnapshot DriversDoc = await _firestore
//           .collection('rideRequest')
//           .doc(widget.driversId)
//           .get();

//       if (DriversDoc.exists) {
//         Map<String, dynamic> data = DriversDoc.data() as Map<String, dynamic>;
//         Rider.text = data['userName'] ?? 'N/AAAAAAAAA';
//         Driver.text = data['driverName'] ?? '';
//         Adress.text = data['endAddress'] ?? '';
//         Distance.text = data['distance'] ?? '';
//         Duration.text = data['duration'] ?? '';
//         Cost.text = data['cost'] ?? '';
//         service.text = data['service'] ?? '';
//       }
//     } catch (e) {
//       ('Error loading Drivers data: $e'.tr);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error loading Drivers data: $e'.tr),
//         ),
//       );
//     }
//   }

//   @override
//   void dispose() {
//     Rider.dispose();
//     Driver.dispose();
//     Adress.dispose();
//     Distance.dispose();
//     Duration.dispose();
//     Cost.dispose();
//     service.dispose();
//     Status.dispose();

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: Text('Edit Ride Request Information'.tr),
//         actions: [
//           MaterialButton(
//             height: 50,
//             minWidth: 50,
//             color: Colors.blue,
//             child: Text(
//               " Back ".tr,
//               style:
//                   const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
//                   flex: 2,
//                   child: Column(
//                     children: [
//                       _buildNameFields(),
//                       const SizedBox(height: 16),
//                       _buildUsernameField(),
//                       const SizedBox(height: 16),
//                       _buildEmailAndPasswordFields(),
//                       const SizedBox(height: 16),
//                       _CarModelDetails(),
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
//           child: FutureBuilder<QuerySnapshot>(
//             future: FirebaseFirestore.instance.collection('users').get(),
//             builder: (context, snapshot) {
//               if (!snapshot.hasData) {
//                 return const Center(child: CircularProgressIndicator());
//               }
//               var riders = snapshot.data!.docs;
//               return DropdownButtonFormField<String>(
//                 hint: Rider.text == '' ? Text('Rider'.tr) : Text(Rider.text),
//                 decoration: InputDecoration(
//                   labelText: 'Rider'.tr,
//                   border: const OutlineInputBorder(),
//                 ),
//                 items: riders.map((rider) {
//                   return DropdownMenuItem<String>(
//                     value: rider.id,
//                     child: Text(rider['userName']),
//                   );
//                 }).toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     Rider.text = value!;
//                   });
//                 },
//               );
//             },
//           ),
//         ),
//         const SizedBox(width: 16),
//         Expanded(
//           child: FutureBuilder<QuerySnapshot>(
//             future: FirebaseFirestore.instance.collection('drivers').get(),
//             builder: (context, snapshot) {
//               if (!snapshot.hasData) {
//                 return const Center(child: CircularProgressIndicator());
//               }
//               var drivers = snapshot.data!.docs;
//               return DropdownButtonFormField<String>(
//                 hint: Driver.text == '' ? Text('Driver'.tr) : Text(Driver.text),
//                 decoration: InputDecoration(
//                   labelText: 'Driver'.tr,
//                   border: const OutlineInputBorder(),
//                 ),
//                 items: drivers.map((driver) {
//                   return DropdownMenuItem<String>(
//                     value: driver.id,
//                     child: Text(driver['userName']),
//                   );
//                 }).toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     Driver.text = value!;
//                   });
//                 },
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildUsernameField() {
//     return FutureBuilder<QuerySnapshot>(
//       future: FirebaseFirestore.instance.collection('services').get(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return const Center(child: CircularProgressIndicator());
//         }
//         var services = snapshot.data!.docs;
//         return DropdownButtonFormField<String>(
//           hint: service.text == '' ? Text('Services'.tr) : Text(service.text),
//           decoration: InputDecoration(
//             labelText: 'Services'.tr,
//             border: const OutlineInputBorder(),
//           ),
//           items: services.map((service) {
//             return DropdownMenuItem<String>(
//               value: service.id,
//               child: Text(service['name']),
//             );
//           }).toList(),
//           onChanged: (value) {
//             setState(() {
//               service.text = value!;
//             });
//           },
//         );
//       },
//     );
//   }

//   Widget _buildEmailAndPasswordFields() {
//     return Row(
//       children: [
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('Distance'.tr),
//               TextFormField(
//                 controller: Distance,
//                 decoration: InputDecoration(
//                   border: const OutlineInputBorder(),
//                   hintText: 'Enter Distance'.tr,
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter Distance'.tr;
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
//               Text('Duration'.tr),
//               TextFormField(
//                 controller: Duration,
//                 decoration: InputDecoration(
//                   border: const OutlineInputBorder(),
//                   hintText: 'Enter Duration'.tr,
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter Duration'.tr;
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
//               Text('Cost'.tr),
//               TextFormField(
//                 controller: Cost,
//                 decoration: InputDecoration(
//                   border: const OutlineInputBorder(),
//                   hintText: 'Enter Cost'.tr,
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter Cost'.tr;
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
//               Text('Adress'.tr),
//               TextFormField(
//                 controller: Adress,
//                 decoration: InputDecoration(
//                   border: const OutlineInputBorder(),
//                   hintText: 'Enter Adress'.tr,
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter Adress'.tr;
//                   }
//                   return null;
//                 },
//               ),
//             ],
//           ),
//         )
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
//                     _updateDriversAccount();
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

//   Future<void> _updateDriversAccount() async {
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       await _firestore.collection('rideRequest').doc(widget.driversId).update({
//         'userName': Rider.text.trim(),
//         'driverName': Driver.text.trim(),
//         'endAddress': Adress.text.trim(),
//         'distance': Distance.text.trim(),
//         'duration': Duration.text,
//         'cost': Cost.text.trim(),
//         'service': service.text,
//         //  'isVerified': _verficationController,
//         //  'balance': 60,
//         //'profileImage': imageUrl, // Use the uploaded image URL
//         //   'lastlog': Timestamp.now(),
//         //   'lastLogin': FieldValue.serverTimestamp(),
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Ride Request account updated successfully!'.tr),
//         ),
//       );
//       navigationController.navigateTo(rideRequestPageRoute);
//     } catch (e) {
//       ('Error updating Ride Request account: $e'.tr);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error updating Ride Request account: $e'.tr),
//         ),
//       );
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
// }

// class WebImage extends StatelessWidget {
//   final String imagePath;

//   WebImage({required this.imagePath});

//   @override
//   Widget build(BuildContext context) {
//     return Image.network(imagePath);
//   }
// }

// // Mobile version
// class MobileImage extends StatelessWidget {
//   final File imageFile;

//   const MobileImage({required this.imageFile});

//   @override
//   Widget build(BuildContext context) {
//     return Image.file(imageFile);
//   }
// }
