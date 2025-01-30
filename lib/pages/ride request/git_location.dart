// ignore_for_file: file_names

import 'dart:convert';

 
import 'package:http/http.dart' as http;
 
 
import 'dart:async';

class GoogleMapSearchModel {
  List<Prediction>? predictions;
  String? status;

  GoogleMapSearchModel({this.predictions, this.status});

  factory GoogleMapSearchModel.fromJson(Map<String, dynamic> json) {
    return GoogleMapSearchModel(
      predictions: json['predictions'] != null ? (json['predictions'] as List).map((i) => Prediction.fromJson(i)).toList() : null,
      status: json['status'],
    );
  }

 
 
 

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (predictions != null) {
      data['predictions'] = predictions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Prediction {
  String? description;
  String? placeId;
  String? reference;
  List<String>? types;

  Prediction({this.description, this.placeId, this.reference,  this.types});

  factory Prediction.fromJson(Map<String, dynamic> json) {
    return Prediction(
      description: json['description'],
      placeId: json['place_id'],
      reference: json['reference'],
      types: json['types'] != null ? List<String>.from(json['types']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['description'] = description;
    data['place_id'] = placeId;
    data['reference'] = reference;
    if (types != null) {
      data['types'] = types;
    }
    return data;
 }
}

 String GOOGLE_MAP_API_KEY =
    'AIzaSyBw2yjQlova1YwxnvA733FZ9PK7sn99jlU'; 


Future<GoogleMapSearchModel?> searchListAddress({required String value}) async {
  try {
    final response = await http.get(Uri.parse('https://dashboard.ghayti.app/proxy.php?input=$value&components=country:mr'));
    if (response.statusCode == 200) {
      return GoogleMapSearchModel.fromJson(json.decode(response.body));
    } else {
      return null;
    }
  } catch (e) {
    return null;
  }
}


 

 
 
// Future<GoogleMapSearchModel?> searchListAddress({required String value}) async {
//   try {
// final client = CorsMiddleware();
// // final response = await client.get(Uri.parse('https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$value&key=$GOOGLE_MAP_API_KEY&components=country:mr'));
//     final response = await http.get(Uri.parse('https://yourserver.com/proxy.php?input=$value&components=country:mr'));

//     if (response.statusCode == 200) {
//       final decodedResponse = json.decode(response.body);
//  //     if (decodedResponse['status'] == 'OK') {
//         return GoogleMapSearchModel.fromJson(decodedResponse);
//     //  } else {
//        //  return null;
//      // }
//     } else {
//        return null;
//     }
//   } catch (e, stackTrace) {
 
//     return null;
//   }


// Future<GoogleMapSearchModel?> searchListAddress(
//       {required String value}) async {
//     try {
//       Response response = await  DioFactory.getDio().get(
//           'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$value&key=$GOOGLE_MAP_API_KEY&components=country:mr');
//       if (response.statusCode == 200) {
//         return GoogleMapSearchModel.fromJson(response.data);
//       } else {
//         return null;
//       }
//     } catch (e) {
//        return null;
//     }}
