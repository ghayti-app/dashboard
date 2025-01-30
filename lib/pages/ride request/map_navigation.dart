import 'package:admin_dashboard/pages/ride%20request/general_helper.dart';
import 'package:admin_dashboard/pages/ride%20request/git_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_maps_webservices/places.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MapSelectionScreen extends StatefulWidget {
  final bool isItStart;
  const MapSelectionScreen({super.key, required this.isItStart});

  @override
  _MapSelectionScreenState createState() => _MapSelectionScreenState();
}

final TextEditingController _searchController = TextEditingController();
String GOOGLE_MAP_API_KEY = 'AIzaSyBw2yjQlova1YwxnvA733FZ9PK7sn99jlU';

class _MapSelectionScreenState extends State<MapSelectionScreen> {
  LatLng? selectedLocation;
  List predictions = [];
  final GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: GOOGLE_MAP_API_KEY);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Location'.tr)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              // controller: _searchController,

              decoration: InputDecoration(
                hintText: 'Search address'.tr,
                border: const OutlineInputBorder(),
              ),
              //    onChanged: _onSearchChanged,

              onChanged: (value) {
                if (value.isNotEmpty) {
                  _searchPlaces(value);
                } else {
                  setState(() {
                    predictions = [];
                  });
                }
              },
            ),
          ),
          Expanded(
            child: predictions.isNotEmpty
                ? ListView.builder(
                    itemCount: predictions.length,
                    itemBuilder: (context, index) => ListTile(
                        title: Text(
                            predictions[index]['description'].toString() ?? ''),
                        onTap: () async {
                          //  final a = await searchAddressRequestPlaceId(
                          //     placeId: predictions[index]['place_id']);

                          // _returnLocation(
                          //     predictions[index]['description'].toString(),
                          //     LatLng(a!.result!.geometry!.location!.lat!,
                          //         a!.result!.geometry!.location!.lng!));
                          await _selectPrediction(
                              predictions[index]['description'].toString(),
                              predictions[index]['place_id']);
                        }
                        //   _searchPlaces(    predictions[index]['description'].toString()),
                        ),
                  )
                : GoogleMap(
                    initialCameraPosition: const CameraPosition(
                      target: LatLng(18.0747176, -15.9528449),
                      zoom: 12,
                    ),
                    onTap: _onMapTap,
                    markers: selectedLocation != null
                        ? {
                            Marker(
                              markerId: const MarkerId('selected-location'),
                              position: selectedLocation!,
                            ),
                          }
                        : {},
                  ),
          ),
        ],
      ),
    );
  }

  void _onSearchChanged(String input) async {
    if (input.isNotEmpty) {
      final response = await http.get(
        Uri.parse(
            'https://dashboard.ghayti.app/proxy.php?input=$input&components=country:mr'),
      );
      if (response.statusCode == 200) {
        final placesResponse =
            GoogleMapSearchModel.fromJson(json.decode(response.body));
        setState(() {
          predictions = placesResponse.predictions ?? [];
        });
      }
    } else {
      setState(() {
        predictions = [];
      });
    }
  }

  void _searchPlaces(String input) async {
    final url =
        'https://dashboard.ghayti.app/proxy.php?type=autocomplete&input=$input&components=country:mr';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        predictions = data['predictions'];
      });
    } else {
      Get.snackbar('Error', 'Failed to load search results');
    }
  }

// Future<List<String>> getAddressFromLatLng(
//       double latitude, double longitude) async {
//     final url =
//         'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$GOOGLE_MAP_API_KEY';
//     List<String> listAddress = [];
//     final response = await dio.get(url);

//     if (response.statusCode == 200) {
//       final data = response.data;

//       if (data['results'].isNotEmpty) {
//         for (int i = 0; i < data['results'].length; i++) {
//           listAddress.add(data['results'][i]['formatted_address']);
//         }
//         return listAddress;
//       } else {
//         throw Exception('No results found for the specified location');
//       }
//     } else {
//       throw Exception('Failed to load address');
//     }
//   }

  Future<void> _selectPrediction(String name, String prediction) async {
    final url =
        'https://dashboard.ghayti.app/proxy.php?type=details&place_id=$prediction';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final details = json.decode(response.body);
      if (details['result'] != null && details['result']['geometry'] != null) {
        LatLng location = LatLng(
          details['result']['geometry']['location']['lat'],
          details['result']['geometry']['location']['lng'],
        );

        // String placeName = details['result']['formatted_address'];
        Get.snackbar('Success', 'Location selected successfully');

        // إرجاع   إلى الشاشة السابقة
        Navigator.pop(context, {
          'location': name,
          'latitude': location.latitude,
          'longitude': location.longitude,
        });
      } else {
        Get.snackbar('Error', 'Invalid place details');
      }
    } else {
      Get.snackbar(
          'Failed to load place details', 'Error: ${response.statusCode}');
    }
  }

  // Future<GooglePlaceIdModel?> searchAddressRequestPlaceId(
  //     {String? placeId}) async {
  //   try {
  //     var response = await http.get(Uri.parse(
  //         'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$GOOGLE_MAP_API_KEY'));
  //     final details = json.decode(response.body);
  //     if (response.statusCode == 200) {
  //       return GooglePlaceIdModel.fromJson(details);
  //     }
  //     return null;
  //   } catch (e) {
  //     return null;
  //   }
  // }

  void _onMapTap(LatLng location) async {
    setState(() => selectedLocation = location);
    // String placeName =
    //     await getAddressFromLatLng(location.latitude, location.longitude);
   String placeName= GeneralHelper.getBestAddress(await getAddressFromLatLng(location.latitude, location.longitude));
    _returnLocation(placeName, location);
  }

  void _returnLocation(String placeName, LatLng location) {
    setState(() {
      Navigator.pop(context, {
        'location': placeName,
        'latitude': location.latitude,
        'longitude': location.longitude,
      });
    });
  }

  Future<String> getPlaceNameFromCoordinates(LatLng location) async {
    final response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${location.latitude},${location.longitude}&key=$GOOGLE_MAP_API_KEY'));

    //            'https://dashboard.ghayti.app/proxy.php?input=$input&components=country:mr'),

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'] as List;
      if (results.isNotEmpty) {
        return results[0]['formatted_address'];
      }
    }
    return 'Unknown location';
  }

  Future<List<String>> getAddressFromLatLng(
      double latitude, double longitude) async {
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$GOOGLE_MAP_API_KEY';
    List<String> listAddress = [];
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['results'].isNotEmpty) {
        for (int i = 0; i < data['results'].length; i++) {
          listAddress.add(data['results'][i]['formatted_address']);
        }
        return listAddress;
      } else {
        throw Exception('No results found for the specified location');
      }
    } else {
      throw Exception('Failed to load address');
    }
  }
}
