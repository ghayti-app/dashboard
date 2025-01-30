// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class RideRequestModel {
  String userName;
  String userId;
  double startLat;
  double startLng;
  String startAddress;
  String endAddress;
  double endLat;
  double endLng;
  String driverName;
  String driverId;
  double driverLat;
  double driverLng;
  String carModel;
  String carPlateNumber;
  String state;
  String? createdTime;
  String duration;
  String distance;
  String service;
  String cost;
  String canceledBy;
  double driverRating;
  double userRating;
  String driverComment;
  String userComment;
  double discountAmount;
  String couponID;
  bool isFreeRide;
  String driverPhoneNumber;
  String userPhoneNumber;
  double finalCostPerKilo;
  bool pending;
  List<dynamic> bannedDrivers;
  String userToken ;
  String driverToken;
  RideRequestModel(
      {
        required this.driverToken,
        required this.userToken,
        required this.userName,
      required this.userId,
      required this.startLat,
      required this.startLng,
      required this.startAddress,
      required this.endAddress,
      required this.endLat,
      required this.endLng,
      required this.driverName,
      required this.driverId,
      required this.driverLat,
      required this.driverLng,
      required this.carModel,
      required this.carPlateNumber,
      required this.state,
      this.createdTime,
      required this.duration,
      required this.distance,
      required this.service,
      required this.cost,
      required this.canceledBy,
      required this.driverRating,
      required this.userRating,
      required this.driverComment,
      required this.userComment,
      required this.discountAmount,
      required this.couponID,
      required this.isFreeRide,
      required this.driverPhoneNumber,
      required this.userPhoneNumber,
      required this.finalCostPerKilo,
      required this.pending,
      required this.bannedDrivers});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "driverToken":driverToken,
      'userToken':userToken,
      'userName': userName,
      'userId': userId,
      'startLat': startLat,
      'startLng': startLng,
      'startAddress': startAddress,
      'endAddress': endAddress,
      'endLat': endLat,
      'endLng': endLng,
      'driverName': driverName,
      'driverId': driverId,
      'driverLat': driverLat,
      'driverLng': driverLng,
      'carModel': carModel,
      'carPlateNumber': carPlateNumber,
      'state': state,
      'createdTime': createdTime,
      'duration': duration,
      'distance': distance,
      'service': service,
      'cost': cost,
      'canceledBy': canceledBy,
      'driverRating': driverRating,
      'userRating': userRating,
      'driverComment': driverComment,
      'userComment': userComment,
      'discountAmount': discountAmount,
      'couponID': couponID,
      'isFreeRide': isFreeRide,
      'driverPhoneNumber': driverPhoneNumber,
      'userPhoneNumber': userPhoneNumber,
      'finalCostPerKilo': finalCostPerKilo,
      "pending": pending,
      "bannedDrivers": bannedDrivers
    };
  }

  factory RideRequestModel.fromMap(Map<String, dynamic> map) {
    return RideRequestModel(
      driverToken:map["driverToken"] as String ,
      userToken:map['userToken'] as String,
        userName: map['userName'] as String,
        userId: map['userId'] as String,
        startLat: map['startLat'] as double,
        startLng: map['startLng'] as double,
        startAddress: map['startAddress'] as String,
        endAddress: map['endAddress'] as String,
        endLat: map['endLat'] as double,
        endLng: map['endLng'] as double,
        driverName: map['driverName'] as String,
        driverId: map['driverId'] as String,
        driverLat: map['driverLat'] as double,
        driverLng: map['driverLng'] as double,
        carModel: map['carModel'] as String,
        carPlateNumber: map['carPlateNumber'] as String,
        state: map['state'] as String,
        createdTime:
            map['createdTime'] != null ? map['createdTime'] as String : null,
        duration: map['duration'] as String,
        distance: map['distance'] as String,
        service: map['service'] as String,
        cost: map['cost'] as String,
        canceledBy: map['canceledBy'] as String,
        driverRating: map['driverRating'] as double,
        userRating: map['userRating'] as double,
        driverComment: map['driverComment'] as String,
        userComment: map['userComment'] as String,
        discountAmount: map['discountAmount'] as double,
        couponID: map['couponID'] as String,
        isFreeRide: map['isFreeRide'] as bool,
        driverPhoneNumber: map['driverPhoneNumber'] as String,
        userPhoneNumber: map['userPhoneNumber'] as String,
        finalCostPerKilo: map['finalCostPerKilo'] as double,
        bannedDrivers: map["bannedDrivers"],
        pending: map["pending"]);
  }

  String toJson() => json.encode(toMap());

  factory RideRequestModel.fromJson(String source) =>
      RideRequestModel.fromMap(json.decode(source) as Map<String, dynamic>);
}