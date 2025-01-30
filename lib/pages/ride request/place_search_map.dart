// import 'package:admin_dashboard/pages/ride%20request/git_location.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
 
// class PlaceSearchMap extends StatefulWidget {
//   final String apiKey;

//   const PlaceSearchMap({Key? key, required this.apiKey}) : super(key: key);

//   @override
//   _PlaceSearchMapState createState() => _PlaceSearchMapState();
// }

// class _PlaceSearchMapState extends State<PlaceSearchMap> {
//   GoogleMapController? _mapController;
//   final TextEditingController _searchController = TextEditingController();
//   List<Prediction> _predictions = [];
//   late GoogleMapsPlaces _places;
//   Set<Marker> _markers = {};

//   @override
//   void initState() {
//     super.initState();
//     _places = GoogleMapsPlaces(apiKey: widget.apiKey);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Place Search Map')),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               controller: _searchController,
//               decoration: InputDecoration(
//                 hintText: 'Search for a place',
//                 suffixIcon: Icon(Icons.search),
//               ),
//               onChanged: (value) => _onSearchChanged(value),
//             ),
//           ),
//           if (_predictions.isNotEmpty)
//             Container(
//               height: 200,
//               child: ListView.builder(
//                 itemCount: _predictions.length,
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     title: Text(_predictions[index].description ?? ''),
//                     onTap: () => _handlePredictionSelected(_predictions[index]),
//                   );
//                 },
//               ),
//             ),
//           Expanded(
//             child: GoogleMap(
//               initialCameraPosition: CameraPosition(
//                 target: LatLng(18.0735, -15.9582), // Nouakchott, Mauritania
//                 zoom: 10.0,
//               ),
//               onMapCreated: (GoogleMapController controller) {
//                 _mapController = controller;
//               },
//               markers: _markers,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _onSearchChanged(String value) async {
//     if (value.isEmpty) {
//       setState(() => _predictions = []);
//       return;
//     }

//     final result = await _places.autocomplete(
//       value,

//       components: [Component(ComponentFilter.country, "mr")], // Mauritania      language: "ar", // Arabic language
//     );

//     if (result.isOkay) {
//       setState(() => _predictions = result.predictions);
//     }
//   }

//   void _handlePredictionSelected(Prediction prediction) async {
//     final detail = await _places.getDetailsByPlaceId(prediction.placeId!);

//     if (detail.result.geometry != null && detail.result.geometry!.location != null) {
//       final lat = detail.result.geometry!.location!.lat;
//       final lng = detail.result.geometry!.location!.lng;

//       setState(() {
//         _markers.clear();
//         _markers.add(Marker(
//           markerId: MarkerId(prediction.placeId!),
//           position: LatLng(lat, lng),
//           infoWindow: InfoWindow(title: prediction.description),
//         ));
//       });

//       _mapController?.animateCamera(
//         CameraUpdate.newLatLngZoom(LatLng(lat, lng), 15),
//       );

//       _searchController.clear();
//       setState(() => _predictions = []);
//     }
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     _mapController?.dispose();
//     super.dispose();
//   }
// }
