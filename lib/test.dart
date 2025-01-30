// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:flutter/material.dart';
// import 'firebase_options.dart';
// import 'dart:io' show File;
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:uuid/uuid.dart';
// import 'package:oktoast/oktoast.dart';

// void main(List<String> args) async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: UploadPage(),
//     );
//   }
// }

// class UploadPage extends StatefulWidget {
//   const UploadPage({Key? key}) : super(key: key);

//   @override
//   _UploadPageState createState() => _UploadPageState();
// }

// class _UploadPageState extends State<UploadPage> {
//   List<Widget> itemPhotosWidgetList = <Widget>[];

//   final ImagePicker _picker = ImagePicker();
//   File? file;
//   List<XFile>? photo = <XFile>[];
//   List<XFile> itemImagesList = <XFile>[];

//   List<String> downloadUrl = <String>[];

//   bool uploading = false;

//   @override
//   Widget build(BuildContext context) {
//     double _screenwidth = MediaQuery.of(context).size.width,
//         _screenheight = MediaQuery.of(context).size.height;
//     return LayoutBuilder(
//         builder: (BuildContext context, BoxConstraints constraints) {
//       if (constraints.maxWidth < 480) {
//         return displayPhoneUploadFormScreen(_screenwidth, _screenheight);
//       } else {
//         return displayWebUploadFormScreen(_screenwidth, _screenheight);
//       }
//     });
//   }

//   displayPhoneUploadFormScreen(_screenwidth, _screenheight) {
//     return Container();
//   }

//   displayWebUploadFormScreen(_screenwidth, _screenheight) {
//     return OKToast(
//         child: Scaffold(
//       body: Column(
//         children: [
//           const SizedBox(
//             height: 100.0,
//           ),
//           Container(
//             height: 300,
//             width: 300,
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(12.0),
//                 color: Colors.white70,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.shade200,
//                     offset: const Offset(0.0, 0.5),
//                     blurRadius: 30.0,
//                   )
//                 ]),
//             // width: _screenwidth * 0.7,
//             // height: 300.0,
//             child: Center(
//               child: itemPhotosWidgetList.isEmpty
//                   ? Center(
//                       child: MaterialButton(
//                         onPressed: pickPhotoFromGallery,
//                         child: Container(
//                           alignment: Alignment.bottomCenter,
//                           child: Center(
//                             child: Image.network(
//                               "https://static.thenounproject.com/png/3322766-200.png",
//                               height: 100.0,
//                               width: 100.0,
//                             ),
//                           ),
//                         ),
//                       ),
//                     )
//                   : SingleChildScrollView(
//                       scrollDirection: Axis.vertical,
//                       child: Wrap(
//                         spacing: 5.0,
//                         direction: Axis.horizontal,
//                         children: itemPhotosWidgetList,
//                         alignment: WrapAlignment.spaceEvenly,
//                         runSpacing: 10.0,
//                       ),
//                     ),
//             ),
//           ),

//           // Row(
//           //   mainAxisAlignment: MainAxisAlignment.end,
//           //   children: [
//           //     Padding(
//           //       padding: const EdgeInsets.only(
//           //         top: 50.0,
//           //         left: 100.0,
//           //         right: 100.0,
//           //       ),
//           //       child: MaterialButton(
//           //           shape: RoundedRectangleBorder(
//           //             borderRadius: BorderRadius.circular(10),
//           //           ),
//           //           padding: const EdgeInsets.symmetric(
//           //               horizontal: 20.0, vertical: 15.0),
//           //           color: const Color.fromRGBO(0, 35, 102, 1),
//           //           onPressed: uploading ? null : () => upload(),
//           //           child: uploading
//           //               ? const SizedBox(
//           //                   child: CircularProgressIndicator(),
//           //                   height: 15.0,
//           //                 )
//           //               : const Text(
//           //                   "Add",
//           //                   style: TextStyle(
//           //                     color: Colors.white,
//           //                     fontSize: 20.0,
//           //                     fontWeight: FontWeight.bold,
//           //                   ),
//           //                 )),
//           //     ),
//           //   ],
//           // ),
//         ],
//       ),
//     ));
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

//   upload() async {
//     String driverId = await uplaodImageAndSaveItemInfo();
//     setState(() {
//       uploading = false;
//     });
//     ("Image Uploaded Successfully");
//   }

//   Future<String> uplaodImageAndSaveItemInfo() async {
//     setState(() {
//       uploading = true;
//     });
//     PickedFile? pickedFile;
//     String? driverId = const Uuid().v4();
//     for (int i = 0; i < itemImagesList.length; i++) {
//       file = File(itemImagesList[i].path);
//       pickedFile = PickedFile(file!.path);

//       await uploadImageToFirestore(pickedFile, driverId);
//     }
//     return driverId;
//   }

//   Future<void> uploadImageToFirestore(
//       PickedFile? pickedFile, String driverId) async {
//     String? pId = const Uuid().v4();
//     String fileName =
//         '${DateTime.now().millisecondsSinceEpoch}.jpg'; // Example filename format

//     Reference storageReference =
//         FirebaseStorage.instance.ref().child('image/$fileName');

//     await storageReference.putData(
//       await pickedFile!.readAsBytes(),
//       SettableMetadata(contentType: 'image/jpeg'),
//     );

//     String imageUrl = await storageReference.getDownloadURL();

//     await FirebaseFirestore.instance.collection("image").doc("image").set({
//       'image': imageUrl,
//     }, SetOptions(merge: true));

//     downloadUrl.add(imageUrl);
//   }
// }
// //             
// //          Container(
// //                         height: 300,
// //                         width: 300,
// //                         decoration:    const BoxDecoration(
// //                           color: Colors.grey,
// //                         ),
// //                         child: Column(
// //                           mainAxisAlignment: MainAxisAlignment.center, // Center the content vertically
// //                           children: [
// //                             if (_selectedImage == null) // Show "Choose Image" text if no image selected
// //                               GestureDetector(
// //                                 onTap: _pickImage, // Trigger image picker on tap
// //                                 child: Container(
// //                                     width: 150, height:150,
// //                                   decoration: BoxDecoration(
// //                                     borderRadius: BorderRadius.circular(50),
// //                                     color: Colors.grey[400],
// //                                   ),
// //                                   child:  Center(
// //                                     child: Text(
// //                                       'Choose Image'.tr,
// //                                       style: const TextStyle(color: Colors.white),
// //                                     ),
// //                                   ),
// //                                 ),
// //                               ),
// //                      if (_selectedImage!= null)
// //   kIsWeb
// //    ? WebImage(imagePath: _selectedImage!)
// //     : MobileImage(imageFile: File(_selectedImage!)) // تأكد من أن _selectedImage يحتوي على مسار الصورة الصحيحة
// // else
// //   GestureDetector(
// //     onTap: _pickImage,
// //     child: Container(
// //       // تفاصيل العرض
// //     ),
// //   )
// //                           ],
// //                         ),
// //                       ),
               