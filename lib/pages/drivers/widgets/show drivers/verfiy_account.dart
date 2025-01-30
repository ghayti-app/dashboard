// import 'package:admin_dashboard/constants/controllers.dart';
// import 'package:admin_dashboard/layout.dart';
// import 'package:admin_dashboard/routing/routes.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// import 'package:flutter/material.dart';

// import 'package:get/get.dart';

// class VerfiyAccount extends StatefulWidget {
//   final String driversId;

//   VerfiyAccount({
//     Key? key,
//     required this.driversId,
//   }) : super(key: key);

//   @override
//   State<VerfiyAccount> createState() => _EditDriversPageState();
// }

// class _EditDriversPageState extends State<VerfiyAccount> {
//   final _formKey = GlobalKey<FormState>();

//   bool _verficationController = false;

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
//       // await _firestore.collection('Documents').doc(widget.driversId).update({
//       //   'status': newStatus,
//       // });
//       setState(() {
//         _isVerified = newStatus;
//       });

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
//       ('Error updating verification status: $e'.tr);
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

//       Map<String, dynamic> data = DriversDoc.data() as Map<String, dynamic>;

//       _verficationController = data['isVerified'] ?? '';
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
//         body: Center(
//           child: SingleChildScrollView(
//               child: Form(
//                   key: _formKey,
//                   child: Center(
//                     child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const SizedBox(
//                             height: 25,
//                           ),
//                           Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Text(
//                                 "Are You Want To Activate Driver Account".tr,
//                                 style: const TextStyle(
//                                     fontSize: 30, fontWeight: FontWeight.bold),
//                               ),
//                               const SizedBox(
//                                 height: 20,
//                               ),
//                               DropdownButton<bool>(
//                                 value: _verficationController,
//                                 items: [
//                                   DropdownMenuItem(
//                                     value: true,
//                                     child: Row(
//                                       children: [
//                                         const Icon(Icons.verified,
//                                             color: Colors.green),
//                                         const SizedBox(width: 10),
//                                         Text("Verified".tr),
//                                       ],
//                                     ),
//                                   ),
//                                   DropdownMenuItem(
//                                     value: false,
//                                     child: Row(
//                                       children: [
//                                         const Icon(Icons.close,
//                                             color: Colors.red),
//                                         const SizedBox(width: 10),
//                                         Text("Unverified".tr),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                                 onChanged: (value) {
//                                   setState(() {
//                                     _verficationController = value!;
//                                     _updateVerificationStatus(value);
//                                   });
//                                 },
//                               ),
//                             ],
//                           )
//                         ]),
//                   ))),
//         ));
//   }

//   Future<void> _updateDriversAccount() async {
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       await _firestore.collection('drivers').doc(widget.driversId).update({
//         'isVerified': _verficationController,
//       });
//       navigationController.navigateTo(showDriversPageRoute);


//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Drivers account updated successfully!'.tr),
//         ),
//       );
//     } catch (e) {
//       ('Error updating Drivers account: $e');
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
// }
