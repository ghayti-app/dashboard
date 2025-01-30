import 'dart:convert';

 
// ignore_for_file: public_member_api_docs, sort_constructors_first
class ServicesModel {
  String name;
  String arabicName;
  String frenchName;
  num costPerKilo;
  num numberOfPassengers;
  num adminCommission;
  String region;
  List<dynamic> serviceTimeList;
  String profileImage;
  num minimumFare;
  ServicesModel({
    required this.frenchName,
    required this.arabicName,
    required this.name,
    required this.costPerKilo,
    required this.numberOfPassengers,
    required this.adminCommission,
    required this.region,
    required this.serviceTimeList,
    required this.minimumFare,
    required this.profileImage
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "frenchName":frenchName,
      "arabicName":arabicName,
      'name': name,
      'costPerKilo': costPerKilo,
      'numberOfPassengers': numberOfPassengers,
      'adminCommission': adminCommission,
      'region': region,
      'serviceTimeList': serviceTimeList,
      'minimumFare': minimumFare,
      "profileImage":profileImage
    };
  }

  factory ServicesModel.fromMap(Map<String, dynamic> map) {
     return ServicesModel(
      frenchName: map['frenchName'],
      arabicName: map["arabicName"],
      name: map['name'] as String,
      costPerKilo: map['costPerKilo'] as num,
      numberOfPassengers: map['numberOfPassengers'] as num,
      adminCommission: map['adminCommission'] as num,
      region: map['region'] as String,
      serviceTimeList: map['serviceTimeList'],
      minimumFare: map['minimumFare'],
        profileImage  : map['profileImage']
    );
  }

  String toJson() => json.encode(toMap());

  factory ServicesModel.fromJson(String source) => ServicesModel.fromMap(json.decode(source) as Map<String, dynamic>);
}