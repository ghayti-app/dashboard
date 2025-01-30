// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:uuid/uuid.dart'; // For generating session tokens

// class AuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FlutterSecureStorage _storage = const FlutterSecureStorage();

//   Future<void> signInWithEmailAndPassword() async {
//     // ... (Your existing code)

//     if (user != null && userExistsInFirestore) {
//       // Generate session token
//       String sessionToken = Uuid().v4(); 

//       // Store session token on client-side
//       await _storage.write(key: 'sessionToken', value: sessionToken);

//       // Store session in Firestore
//       await _firestore.collection('sessions').doc(user.uid).set({
//         'userId': user.uid,
//         'createdAt': Timestamp.now(),
//         'lastActive': Timestamp.now(),
//         'token': sessionToken,
//       });

//       Get.off(SiteLayout());
//     } 

//     // ... (Your existing code)
//   }

//   Future<bool> checkSession() async {
//     String? token = await _storage.read(key: 'sessionToken');

//     if (token != null) {
//       // Check if session exists in Firestore
//       DocumentSnapshot sessionDoc = await _firestore
//           .collection('sessions')
//           .doc(FirebaseAuth.instance.currentUser!.uid)
//           .get();

//       if (sessionDoc.exists) {
//         // Check if token is valid and session hasn't timed out
//         return sessionDoc.data()!['token'] == token &&
//             sessionDoc.data()!['lastActive'].toDate().isAfter(
//               DateTime.now().subtract(const Duration(minutes: 30)),
//             );
//       }
//     }
//     return false;
//   }

//   Future<void> logout() async {
//     // ... (Your existing logout logic)

//     // Invalidate session
//     await _firestore
//         .collection('sessions')
//         .doc(FirebaseAuth.instance.currentUser!.uid)
//         .delete();

//     // Remove token from client-side
//     await _storage.delete(key: 'sessionToken');
//   }

//   // ... (Other methods)
// }