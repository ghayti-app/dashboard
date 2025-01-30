// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:admin_dashboard/pages/ride%20request/rider_in_ride_request.dart';
import 'package:http/http.dart' as http;
import 'package:admin_dashboard/pages/ride%20request/cash_helper.dart';
import 'package:admin_dashboard/pages/ride%20request/check_coupon.dart';
import 'package:admin_dashboard/pages/ride%20request/general_helper.dart';
import 'package:admin_dashboard/pages/ride%20request/map_navigation.dart';
import 'package:admin_dashboard/pages/ride%20request/search_on_rider.dart';
import 'package:admin_dashboard/pages/ride%20request/service_model.dart';
import 'package:admin_dashboard/routing/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../constants/controllers.dart';

class NewBookingScreen extends StatefulWidget {
  const NewBookingScreen({super.key});

  @override
  _NewBookingScreenState createState() => _NewBookingScreenState();
}

class _NewBookingScreenState extends State<NewBookingScreen> {
  TextEditingController newRiderNameController = TextEditingController();
  TextEditingController newRiderPhoneController = TextEditingController();
  final TextEditingController _riderController = TextEditingController();

  String? selectedRider;
  String? selectedDriver;
  String? selectedService;
  TextEditingController startAddressController = TextEditingController();
  TextEditingController endAddressController = TextEditingController();

  TextEditingController couponController = TextEditingController();
  TextEditingController isFreeRideController = TextEditingController();
  LatLng? startLocation;
  LatLng? endLocation;
  Directions? directions;
  bool isClicked = false;
  ServicesModel? servicesModel;
  String timeController = "";
  String distanceController = "";
  String costController = "";
  String riderPhone = "";
  String riderId = "";

  @override
  void dispose() {
    startAddressController.dispose();
    endAddressController.dispose();
    super.dispose();
  }

  Future<void> _selectLocation(
      TextEditingController controller, bool isStart) async {
     dynamic result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MapSelectionScreen(isItStart: isStart)),
    );
    print("=====================================");
    print(result);
    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        String location = result['location'] ?? '';
        int delimiterIndex = location.indexOf(RegExp(r'[٬,]'));
        if (delimiterIndex != -1) {
          controller.text = location.substring(0, delimiterIndex).trim();
        } else {
          controller.text = (result['location']?.split(',').first) ?? ''; 
        }
        LatLng location1 = LatLng(result['latitude'], result['longitude']);
        if (isStart) {
          startLocation = location1;
        } else {
          endLocation = location1;
        }
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('New Booking'.tr),
        actions: [
          MaterialButton(
            height: 50,
            minWidth: 50,
            color: Colors.blue,
            child: Text(
              " Back ".tr,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _riderController,
                    decoration: InputDecoration(
                      labelText: 'Rider'.tr,
                      border: const OutlineInputBorder(),
                    ),
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchRiderScreen(
                            onRiderSelected: (id, phone, name) {},
                          ),
                        ),
                      );

                      if (result != null) {
                        setState(() {
                          riderId = result['id'];
                          riderPhone = result['phone'];
                          selectedRider = result['name'];
                          _riderController.text = result[
                              'name']; // تعيين اسم الراكب في TextFormField
                        });
                      }
                    },
                  ),
                ),
 
                const SizedBox(width: 16),
                Expanded(
                  child: MaterialButton(
                    height: 50,
                    color: Colors.cyan,
                    child: Text(
                      'Create New Rider'.tr,
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Create New Rider'.tr),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFormField(
                                  controller: newRiderNameController,
                                  decoration: InputDecoration(
                                      labelText: 'Rider Name'.tr),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter rider name'.tr;
                                    }
                                    return null;
                                  },
                                ),
                                TextFormField(
                                  controller: newRiderPhoneController,
                                  decoration: InputDecoration(
                                    labelText: 'Rider Phone'.tr,
                                    prefixText: '+222 ',
                                    counterText: '',
                                  ),
                                  keyboardType: TextInputType.phone,
                                  maxLength: 8,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter phone number'.tr;
                                    }
                                    if (value.length != 8 ||
                                        !RegExp(r'^\d{8}$').hasMatch(value)) {
                                      return 'Please enter 8 digits'.tr;
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    final newValue =
                                        value.replaceAll(RegExp(r'[^\d]'), '');
                                    if (newValue != value) {
                                      newRiderPhoneController.value =
                                          TextEditingValue(
                                        text: newValue,
                                        selection: TextSelection.collapsed(
                                            offset: newValue.length),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                child: Text('Cancel'.tr),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text('Create New Rider'.tr),
                                onPressed: () async {
                                  String fullPhoneNumber =
                                      '+222${newRiderPhoneController.text}';
                                  final rr = await FirebaseFirestore.instance
                                      .collection('users')
                                      .where('phoneNumber',
                                          isEqualTo: fullPhoneNumber)
                                      .get();
                                  if (rr.docs.isNotEmpty) {
                                    Get.snackbar(
                                      'Alert'.tr,
                                      'Rider Already Exist'.tr,
                                    );
                                    return;
                                  }

                                  if (newRiderNameController.text.isNotEmpty &&
                                      newRiderPhoneController.text.isNotEmpty) {
                                    DocumentReference newRiderRef =
                                        await FirebaseFirestore.instance
                                            .collection('users')
                                            .add({
                                      'userName': newRiderNameController.text,
                                      'phoneNumber': fullPhoneNumber,
                                      'balance': 0,
                                      'rating': 0,
                                      'totalRides': 0,
                                      'role': 'rider',
                                      'state': 'active',
                                      'isDeleted': false,
                                      'createTime':
                                          FieldValue.serverTimestamp(),
                                      'lastLogin': FieldValue.serverTimestamp(),
                                    });

                                    setState(() {
                                      selectedRider =
                                          newRiderNameController.text;
                                      riderId = newRiderRef.id;
                                      riderPhone = fullPhoneNumber;
                                    });

                                    Navigator.of(context).pop();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'New rider created successfully'
                                                  .tr)),
                                    );

                                    String? adminId =
                                        FirebaseAuth.instance.currentUser?.uid;

                                    if (adminId != null) {
                                      await FirebaseFirestore.instance
                                          .collection('adminActions')
                                          .add({
                                        'adminId': adminId,
                                        'adminEmail': FirebaseAuth
                                            .instance.currentUser?.email,
                                        'Name': newRiderNameController.text,
                                        'Id': newRiderRef.id,
                                        'newState': "active",
                                        'type': 'Create New Rider By Admin',
                                        'timestamp':
                                            FieldValue.serverTimestamp(),
                                      });
                                    } else {
                                      ('No admin is signed in.'.tr);
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Please fill the name and phone fields'
                                                  .tr)),
                                    );
                                  }
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Start Address'.tr,
                      border: const OutlineInputBorder(),
                    ),
                    controller: startAddressController,
                    readOnly: true,
                    onTap: () => _selectLocation(startAddressController, true),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'End Address'.tr,
                      border: const OutlineInputBorder(),
                    ),
                    controller: endAddressController,
                    readOnly: true,
                    onTap: () => _selectLocation(endAddressController, false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: FutureBuilder<QuerySnapshot>(
                    future:
                        FirebaseFirestore.instance.collection('services').get(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      var services = snapshot.data!.docs;
                      return DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Services',
                          border: OutlineInputBorder(),
                        ),
                        items: services.map((service) {
                          return DropdownMenuItem<String>(
                            value: service.id,
                            child: Text(service['name']),
                          );
                        }).toList(),
                        ////////////////////////////////////////////////////////////
                        onChanged: (value) {
                          setState(() {
                            selectedService = value;
                            for (var ser in services) {
                              if (ser.id == selectedService) {
                                servicesModel = ServicesModel.fromMap(
                                    ser.data() as Map<String, dynamic>);
                              }
                            }
                          });
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                    child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Coupon Name'.tr,
                    border: const OutlineInputBorder(),
                  ),
                  controller: couponController,
                  keyboardType: TextInputType.number,
                )),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text("Cost: ".tr,
                        style:
                            const TextStyle(fontSize: 20, color: Colors.black)),
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Text(costController,
                          style: const TextStyle(
                              fontSize: 20, color: Colors.blue)),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text("Distance: ".tr,
                        style:
                            const TextStyle(fontSize: 20, color: Colors.black)),
                    Directionality(
                        textDirection: TextDirection.ltr,
                        child: Text(distanceController,
                            style: const TextStyle(
                                fontSize: 20, color: Colors.blue))),
                  ],
                ),
                Row(
                  children: [
                    Text("Time: ".tr,
                        style:
                            const TextStyle(fontSize: 20, color: Colors.black)),
                    Directionality(
                        textDirection: TextDirection.ltr,
                        child: Text(timeController,
                            style: const TextStyle(
                                fontSize: 20, color: Colors.blue))),
                  ],
                ),
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                MaterialButton(
                  height: 50,
                  minWidth: 100,
                  color: Colors.blue,
                  onPressed: () async {
                    if (riderId != "") {
                      print("=======================================================");
                      print(await chickRideRequest(riderId.toString().trim()));
                      if (await chickRideRequest(riderId.toString().trim())) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Rider  Already in Ride'.tr)),
                        );
                        return;
                      }
                    }
                    if (distanceController.isEmpty ||
                        selectedRider == null ||
                        selectedService == null ||
                        startLocation == null ||
                        endLocation == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                'Please fill all required fields and show info first'
                                    .tr)),
                      );
                      return;
                    }
                    if (distanceController != '') {
                      if (couponController.text.isNotEmpty) {
                        bool ok = await checkCoupon(context,
                            coupon: couponPageRoute.toString().trim(),
                            cost: GeneralHelper.calculationTotalCashDouble(    isFreeRide: false,
                                cost: servicesModel!.minimumFare.toDouble(),
                                totalDistance: distanceController,
                                serviceTimeList: servicesModel!.serviceTimeList,
                                minimumFare: servicesModel!.minimumFare),
                            serviceName: selectedService.toString().trim(),
                            riderid: selectedRider.toString().trim());
                        if (!ok) {
                          return;
                        }
                      }
                      if (servicesModel == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text('Please select a service first'.tr)),
                        );
                        return;
                      }

                      if (servicesModel == null ||
                          startLocation == null ||
                          endLocation == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  'Please select a service and locations'.tr)),
                        );
                        return;
                      }

                      if (selectedRider != null &&
                          // selectedDriver != null &&
                          selectedService != null &&
                          startAddressController.text.isNotEmpty &&
                          endAddressController.text.isNotEmpty &&
                          startLocation != null &&
                          endLocation != null) {
                        // Add the booking data to Firestore
                        await FirebaseFirestore.instance
                            .collection('rideRequest')
                            // .doc(

                            // FirebaseFirestore.instance
                            //   .collection('rideRequest')
                            //   .doc()
                            //   .id

                            //   )
                            .add({
                          'driverToken': "none",
                          'userToken': 'none',
                          'finalCostPerKilo':
                              GeneralHelper.calculationCostPerKilo(totalDistance:double.parse( distanceController.split(" ").first),  isFreeRide: false,
                                      cost:
                                          servicesModel!.costPerKilo.toDouble(),
                                      serviceTimeList:
                                          servicesModel!.serviceTimeList) +
                                  0.0001,
                          'driverPhoneNumber': "",
                          'userPhoneNumber': riderPhone,
                          'isFreeRide': false,
                          'couponID':
                              CashHelper.getString(key: Keys.couponID) ??
                                  "none",
                          'discountAmount':
                              CashHelper.getDouble(key: Keys.couponAmount) ??
                                  0.1,
                          "canceledBy": "none",
                          'driverLat': 0.1,
                          'driverLng': 0.1,
                          "userName": selectedRider.toString().trim(),
                          "userId": riderId,
                          'startLat': startLocation!.latitude,
                          'startLng': startLocation!.longitude,
                          'endLat': endLocation!.latitude,
                          'endLng': endLocation!.longitude,
                          'startAddress': startAddressController.text,
                          'endAddress': endAddressController.text,
                          "driverName": "none",
                          "driverId": "none",
                          "carModel": "none",
                          "carPlateNumber": "none",
                          "state": "new_ride_request",
                          'duration': timeController,
                          'distance': distanceController,
                          'service': selectedService.toString().trim(),
                          "cost": GeneralHelper.calculationTotalCash(  isFreeRide: false,
                              cost: servicesModel!.costPerKilo.toInt(),
                              totalDistance: distanceController,
                              serviceTimeList: servicesModel!.serviceTimeList,
                              minimumFare: servicesModel!.minimumFare),
                          'createdTime': DateTime.now().toString(),
                          "driverRating": 0.1,
                          "userRating": 0.1,
                          "driverComment": "none",
                          "userComment": "none",
                          "pending": false,
                          "bannedDrivers": [],
                        }).then((value) async {
                          await timerForRequest(value.id);
                          navigationController.navigateTo(rideRequestPageRoute);
                          startAddressController.clear();
                          endAddressController.clear();
                        });
                        String? adminId =
                            FirebaseAuth.instance.currentUser?.uid;

                        if (adminId != null) {
                          await FirebaseFirestore.instance
                              .collection('adminActions')
                              .add({
                            'adminId': adminId,
                            'adminEmail':
                                FirebaseAuth.instance.currentUser?.email,
                            'Name': selectedRider.toString().trim(),
                            'Id': riderId,
                            'newState': "active",
                            'type': 'Create New Ride Request by Admin',
                            'timestamp': FieldValue.serverTimestamp(),
                          });
                        } else {}
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Please fill all the fields'.tr)),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please enter on show Info'.tr)),
                      );
                    }
                  },
                  child: Text(
                    '  Book Now  '.tr,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 100),
                MaterialButton(
                  //show info
                  onPressed: () async {
                     

                    if (selectedService == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please select a service'.tr)),
                      );
                      return;
                    }
                    if (startLocation == null || endLocation == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                'Please select both start and end locations'
                                    .tr)),
                      );
                      return;
                    }

                    if (selectedService == null ||
                        startLocation == null ||
                        endLocation == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                'Please select a service and both locations'
                                    .tr)),
                      );
                      return;
                    }

                    try {
                      final directions = await getDirections(
                        origin: startLocation!,
                        destination: endLocation!,
                      );

                      if (directions != null) {
                        setState(() {
                          distanceController = directions.totalDistance;
                          timeController = directions.totalDuration;
                          costController = GeneralHelper.calculationTotalCash(  isFreeRide: false,
                            cost: servicesModel!.costPerKilo.toInt(),
                            totalDistance: distanceController,
                            serviceTimeList: servicesModel!.serviceTimeList,
                            minimumFare: servicesModel!.minimumFare,
                          );
                        });
                      } else {
                        throw Exception('Unable to calculate route');
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                'An error occurred while calculating the route. Please try again.'
                                    .tr)),
                      );
                    }

                   },
                  height: 50,
                  minWidth: 100,
                  color: Colors.blue,
                  child: Text(
                    "Show Info".tr,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 100),
                MaterialButton(
                  onPressed: () async {
                    if (riderId != "") {
                      if (await chickRideRequest(riderId.toString().trim())) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Rider  Already in Ride'.tr)),
                        );
                        return;
                      }
                    }
                    if (selectedService != null &&
                        startAddressController.text.isNotEmpty) {
                      await getDirections(
                              origin: startLocation!,
                              destination: startLocation!)
                          .then((onValue) {
                        distanceController = onValue!.totalDistance;
                        timeController = onValue.totalDuration;
                        costController = GeneralHelper.calculationTotalCash(isFreeRide: true,
                            cost: servicesModel!.costPerKilo.toInt(),
                            totalDistance: distanceController.toString(),
                            serviceTimeList: servicesModel!.serviceTimeList,
                            minimumFare: servicesModel!.minimumFare);
                      });
                      if (distanceController != '') {
                        if (couponController.text.isNotEmpty) {
                          bool ok = await checkCoupon(context,
                              coupon: couponPageRoute.toString().trim(),
                              cost: GeneralHelper.calculationTotalCashDouble( isFreeRide: true,
                                  cost: servicesModel!.minimumFare.toDouble(),
                                   
                                  totalDistance: distanceController,
                                   
                                  serviceTimeList:
                                      servicesModel!.serviceTimeList,
                                  minimumFare: servicesModel!.minimumFare),
                              serviceName: selectedService.toString().trim(),
                              riderid: selectedRider.toString().trim());
                          if (!ok) {
                            return;
                          }
                        }

                        if (selectedRider != null &&
                            // selectedDriver != null &&
                            selectedService != null &&
                            startAddressController.text.isNotEmpty &&
                            startLocation != null) {
                          // Add the booking data to Firestore
                          FirebaseFirestore.instance
                              .collection('rideRequest')
                              // .doc(FirebaseFirestore.instance
                              //     .collection('rideRequest')
                              //     .doc()
                              //     .id)
                              .add({
                            'driverToken': "none",
                            'userToken': 'none',
                            'finalCostPerKilo':
                                GeneralHelper.calculationCostPerKilo(totalDistance:double.parse( distanceController.split(" ").first), isFreeRide: true,
                                        cost: servicesModel!.costPerKilo
                                            .toDouble(),
                                        serviceTimeList:
                                            servicesModel!.serviceTimeList) +
                                    0.0001,
                            'driverPhoneNumber': "",
                            'userPhoneNumber': riderPhone,
                            'isFreeRide': true,
                            'couponID':
                                CashHelper.getString(key: Keys.couponID) ??
                                    "none",
                            'discountAmount':
                                CashHelper.getDouble(key: Keys.couponAmount) ??
                                    0.1,
                            "canceledBy": "none",
                            'driverLat': 0.1,
                            'driverLng': 0.1,
                            "userName": selectedRider.toString().trim(),
                            "userId": riderId,
                            'startLat': startLocation!.latitude,
                            'startLng': startLocation!.longitude,
                            'endLat': startLocation!.latitude,
                            'endLng': startLocation!.longitude,
                            'startAddress': startAddressController.text,
                            'endAddress': startAddressController.text,
                            "driverName": "none",
                            "driverId": "none",
                            "carModel": "none",
                            "carPlateNumber": "none",
                            "state": "new_ride_request",
                            'duration': timeController,
                            'distance': distanceController,
                            'service': selectedService.toString().trim(),
                            "cost": GeneralHelper.calculationTotalCash( isFreeRide: true,
                                cost: servicesModel!.costPerKilo.toInt(),
                                totalDistance: distanceController,
                                serviceTimeList: servicesModel!.serviceTimeList,
                                minimumFare: servicesModel!.minimumFare),
                            'createdTime': DateTime.now().toString(),
                            "driverRating": 0.1,
                            "userRating": 0.1,
                            "driverComment": "none",
                            "userComment": "none",
                            "pending": false,
                            "bannedDrivers": [],
                          }).then((value) async {
                             await timerForRequest(value.id);
                            navigationController
                                .navigateTo(rideRequestPageRoute);
                            startAddressController.clear();
                            endAddressController.clear();
                          });
                        }
                      }
                      String? adminId = FirebaseAuth.instance.currentUser?.uid;

                      if (adminId != null) {
                        await FirebaseFirestore.instance
                            .collection('adminActions')
                            .add({
                          'adminId': adminId,
                          'adminEmail':
                              FirebaseAuth.instance.currentUser?.email,
                          'Name': selectedRider.toString().trim(),
                          'Id': riderId,
                          'newState': "active",
                          'type': 'Create a Free Ride Request',
                          'timestamp': FieldValue.serverTimestamp(),
                        });
                      } else {}
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                'Please fill the start address and service fields'
                                    .tr)),
                      );
                    }
                  },
                  height: 50,
                  minWidth: 100,
                  color: Colors.blue,
                  child: Text(
                    "Free Ride".tr,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
 
 

Future<Map<String, dynamic>?> timerForRequest(String id) async {
  const urlForTimer = 'https://requesttimeout-f25leahmia-uc.a.run.app';

  try {
    final response = await http.post(
      Uri.parse(urlForTimer),
      body: {'id': id},
       headers: {
        'Content-Type': 'application/json',
        'Origin': 'https://dashboard.ghayti.app',
        'Accept': 'application/json',
        'Access-Control-Allow-Credentials': 'true',
        'Access-Control-Max-Age': '86400',
        'Access-Control-Allow-Origin': 'https://dashboard.ghayti.app',
        'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
        'Access-Control-Allow-Headers':
            'Origin, X-Requested-With, Content-Type, Accept, Authorization',
        'Access-Control-Expose-Headers': 'Content-Length, X-Custom-Header'
      },
    );

  //  if (response.statusCode == 200) {
      return jsonDecode(response.body);
    // } else {
    //   throw Exception("Request failed with status: ${response.statusCode}");
    // }
  } catch (e) {
   
   // Get.snackbar("Error fetching timer data: $e" , "" , duration:Duration(seconds: 15));
    return null;
  }
}
}

Future<Directions?> getDirections({
  required LatLng origin,
  required LatLng destination,
}) async {
  const proxyUrl = 'https://dashboard.ghayti.app/directions-proxy.php';
  try {
    // final a = http.Request('POST', Uri.parse(proxyUrl));
    //  final streamedResponse = await client.send(a);
    //   final response = await http.Response.fromStream(streamedResponse);
    final response = await http.post(
      Uri.parse(proxyUrl),
      body: json.encode({
        'origin': '${origin.latitude},${origin.longitude}',
        'destination': '${destination.latitude},${destination.longitude}',
      }),
      headers: {
        'Content-Type': 'application/json',
        'Origin': 'https://dashboard.ghayti.app',
        'Accept': 'application/json',
        'Access-Control-Allow-Credentials': 'true',
        'Access-Control-Max-Age': '86400',
        'Access-Control-Allow-Origin': 'https://dashboard.ghayti.app',
        'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
        'Access-Control-Allow-Headers':
            'Origin, X-Requested-With, Content-Type, Accept, Authorization',
        'Access-Control-Expose-Headers': 'Content-Length, X-Custom-Header'
      },
    );
    if (response.statusCode == 200) {
      return Directions.fromMap(json.decode(response.body));
    } else {}
    
  } catch (e) {}
  return null;
}

class Directions {
  final String totalDistance;
  final String totalDuration;

  Directions({
    required this.totalDistance,
    required this.totalDuration,
  });

  factory Directions.fromMap(Map<String, dynamic> map) {
    final data = map['routes'][0];
    final leg = data['legs'][0];
    return Directions(
      totalDistance: leg['distance']['text'],
      totalDuration: leg['duration']['text'],
    );
  }
}
