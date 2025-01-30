// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
//
// class SearchAndPaginationAndBack  extends StatefulWidget {
//
//
//   State<SearchAndPaginationAndBack> createState() => _SearchAndPaginationState();
// }
//
// class _SearchAndPaginationState extends State<SearchAndPaginationAndBack> {
//
//
//   @override
//   Widget build(BuildContext context) {
//     return  Row(
//       children: [
//
//  SizedBox(height: 70, width: 300,
//    child: Padding(
//               padding: const EdgeInsets.all(13.0),
//               child: TextField(
//                 style: TextStyle(fontSize: 17 , color: Colors.blue),
//                 controller: searchController,
//                 decoration: InputDecoration(
//                   labelText: 'Search',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8.0),
//                   ),
//                   counterText: '',
//                 ),
//
//
//                 onEditingComplete: () {
//                   setState(() {
//
//                     _searchQuery = searchController.text;
//                   });
//                 },
//               ),
//             ),
//  ),
//         Spacer(),
//         SizedBox( width: 90,
//           child: MaterialButton(
//             height: 45,
//             color: Colors.blue,
//             child: Text(" Back",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold ,fontSize: 20),),
//             onPressed: () {
//               Navigator.pop(context);
//
//             },
//           ),
//         ),
//       ],
//     ) ;
//
//     }
//
//
// }
