// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class MapItemsPage extends StatelessWidget {
//   const MapItemsPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title:   Text('Map Items'.tr)),
//       body: GoogleMap(
//         mapType: MapType.hybrid,
//         initialCameraPosition: const CameraPosition(
//           target: LatLng(43.22326495922838, -94.3490369617939),
//           zoom: 15.5,
//         ),
//         polygons: {
          
//           Polygon(
//             polygonId:   PolygonId('polygonId'.tr),
//             points: const [
//               LatLng(43.22682131349118, -94.35395814478397),
//               LatLng(43.226887518297765, -94.34428777545689),
//               LatLng(43.21943572815587, -94.34409566223621),
//               LatLng(43.219487281322955, -94.35394775122406),
//             ],
//             strokeColor: const Color(0XFFFF0000),
//             strokeWidth: 1,
//             fillColor: const Color(0X77000000),

//             onTap: () {},
//           ),
//         },
//       ),
//     );
//   }
// }