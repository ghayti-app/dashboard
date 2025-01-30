import 'dart:io';

import 'package:admin_dashboard/constants/controllers.dart';
import 'package:admin_dashboard/pages/services/date_format.dart';
import 'package:admin_dashboard/routing/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:html' as html;

class EditServicesWidgets extends StatefulWidget {
  final String servicesId;

  const EditServicesWidgets({
    super.key,
    required this.servicesId,
  });

  @override
  State<EditServicesWidgets> createState() => _EditDriversPageState();
}

class _EditDriversPageState extends State<EditServicesWidgets> {
  Widget textofTableTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
          fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black54),
    );
  }

  List<Map<String, dynamic>> _serviceTime = [];

  final _formKey = GlobalKey<FormState>();
  final _firestore = FirebaseFirestore.instance;
  List<DropdownMenuItem<bool>> itemsStatus = [
    DropdownMenuItem(value: true, child: Text("Approved".tr)),
    DropdownMenuItem(value: false, child: Text("Not Approved".tr)),
    //... other items
  ];

  List<DropdownMenuItem<String>> itemsRegion = [
    DropdownMenuItem(value: "Cairo,القاهرة,Le Caire", child: Text('Cairo'.tr)),
    DropdownMenuItem(value: "Giza,الجيزة,Le Giza", child: Text('Giza'.tr)),
    DropdownMenuItem(
        value: "Nouakchott,نواكشوط,Nouakchott", child: Text('Nouakchott'.tr)),
    // ... other items
  ];

  final bool isVerified = false;
// Add these variables to the _EditDriversPageState class in edit_services.dart
  XFile? _selectedImage; // To store the selected image
  String? _imageUrl; // To store the download URL

  bool uploading = false;
  bool _isLoading = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _arabicNameController = TextEditingController();
  final TextEditingController _frenchNameController = TextEditingController();

  final TextEditingController _regionController = TextEditingController();
  final TextEditingController _paymentMethodController =
      TextEditingController();
  final TextEditingController _adminCommissionController =
      TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _costPerKiloController = TextEditingController();
  final TextEditingController _numberOfPassengersController =
      TextEditingController();
  bool _statusController = false;
  final TextEditingController _startingTime = TextEditingController();
  final TextEditingController _endingTime = TextEditingController();
  final TextEditingController _costPerKiloInTime = TextEditingController();
  final TextEditingController _initialDistance = TextEditingController();
  final TextEditingController _finalDistance = TextEditingController();
  final TextEditingController _costForDistance = TextEditingController();
  final TextEditingController _menemumFareController = TextEditingController();
  final TextEditingController _driverMinBalance = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadDriversData();
  }

  Future<void> _loadDriversData() async {
    try {
      DocumentSnapshot serviceDoc =
          await _firestore.collection('services').doc(widget.servicesId).get();
      if (serviceDoc.exists) {
        _nameController.text = serviceDoc['name'] ?? '';
        _statusController = serviceDoc['status'] ?? '';
        _regionController.text = serviceDoc['region'] ?? '';
        _serviceTime = List.from(serviceDoc['serviceTimeList'] ?? []);
        _arabicNameController.text = serviceDoc['arabicName'] ?? '';
        _frenchNameController.text = serviceDoc["frenchName"] ?? "";
        // Load image URL
        _imageUrl = serviceDoc['profileImage'];
        _paymentMethodController.text = serviceDoc['paymentMethod'] ?? '';
        _adminCommissionController.text =
            serviceDoc['adminCommission'].toString() ?? '';
        _menemumFareController.text = serviceDoc['minimumFare'].toString() ?? '';
        _driverMinBalance.text = serviceDoc['driverMinBalance'].toString() ?? '';
        _descriptionController.text = serviceDoc['description'] ?? '';
        _costPerKiloController.text =
            (serviceDoc['costPerKilo'].toString()) ?? '';
        _numberOfPassengersController.text =
            serviceDoc['numberOfPassengers'].toString() ?? '';
      } else {
        ('Service not found');
      }
    } catch (e) {
      ('Error loading Services data: $e');
      SnackBar(
        content: Text('Error loading Services data: $e'),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();

    _regionController.dispose();

    _paymentMethodController.dispose();
    _adminCommissionController.dispose();
    _descriptionController.dispose();
    _costPerKiloController.dispose();
    _numberOfPassengersController.dispose();
    // _imageURLController.dispose();

    // _balanceController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Edit Services Information'.tr),
        actions: [
          MaterialButton(
            height: 50,
            minWidth: 50,
            color: Colors.blue,
            child: const Text(
              " Back ",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              navigationController.navigateTo(showServicesPageRoute);

              // Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 100),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Row(
              children: [
                const SizedBox(
                  height: 25,
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              readOnly: true,
                              controller: _nameController,
                              decoration: InputDecoration(
                                labelText: 'Name by English'.tr,
                                border: const OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a name'.tr;
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: _arabicNameController,
                              decoration: InputDecoration(
                                labelText: 'Name by Arabic'.tr,
                                border: const OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a name'.tr;
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _frenchNameController,
                              decoration: InputDecoration(
                                labelText: 'Name by French'.tr,
                                border: const OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a name'.tr;
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              hint: Text(_regionController.text == "Nouakchott"
                                  ? "Nouakchott".tr
                                  : "Cairo".tr),
                              decoration: InputDecoration(
                                  labelText: 'region '.tr,
                                  border: const OutlineInputBorder()),
                              items: itemsRegion,
                              onChanged: (value) {
                                setState(() {
                                  if (value == null || value.isEmpty) {
                                    _regionController.text = "Nouakchott";
                                  } else {
                                    _regionController.text = value;
                                  }
                                });
                              },
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<bool>(
                              hint: Text(_statusController == true
                                  ? "Approved".tr
                                  : "Not Approved".tr),
                              decoration: InputDecoration(
                                  labelText: 'Status'.tr,
                                  hintText: _statusController.toString(),
                                  border: const OutlineInputBorder()),
                              items: itemsStatus,
                              onChanged: (value) {
                                setState(() {
                                  if (value == null) {
                                    _statusController == true
                                        ? "Approved".tr
                                        : "Not Approved".tr;
                                  } else {
                                    _statusController = value;
                                  }
                                });
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: _adminCommissionController,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: InputDecoration(
                                labelText: 'Admin Commission by percentage'.tr,
                                border: const OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter an admin commission '.tr;
                                }
                                if (double.parse(value) < -1 ||
                                    double.parse(value) >= 101) {
                                  return 'Please enter an admin commission between 0 to 100'
                                      .tr;
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              controller: _numberOfPassengersController,
                              decoration: InputDecoration(
                                labelText: 'Number of Passengers '.tr,
                                border: const OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the number of passengers '
                                      .tr;
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: TextFormField(
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              controller: _costPerKiloController,
                              decoration: InputDecoration(
                                labelText: 'Cost Per Kilo '.tr,
                                border: const OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a cost per kilo '.tr;
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _menemumFareController,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: InputDecoration(
                                labelText: 'minimum Fare'.tr,
                                border: const OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter an minimum Fare'.tr;
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: _driverMinBalance,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: InputDecoration(
                                labelText: 'driver Min Balance'.tr,
                                border: const OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter an driver Min Balance'
                                      .tr;
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Directionality(
                              textDirection: TextDirection.ltr,
                              child: Expanded(
                                child: TextFormField(
                                  controller: _startingTime,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    labelText: 'Starting Time'.tr,
                                    border: const OutlineInputBorder(),
                                  ),
                                  onTap: () async {
                                    TimeOfDay? pickedTime =
                                        await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    );
                                    if (pickedTime != null) {
                                      final now = DateTime.now();
                                      final dt = DateTime(
                                          now.year,
                                          now.month,
                                          now.day,
                                          pickedTime.hour,
                                          pickedTime.minute);
                                      final formattedTime = aa.format(dt);
                                      _startingTime.text = formattedTime;
                                    }
                                  },
                                  validator: (value) {
                                    // if (value == null || value.isEmpty) {
                                    //   return 'Please enter a Starting Time'.tr;
                                    // }
                                    try {
                                      var startTime = aa.parse(value!);
                                      if (startTime.hour < 0 ||
                                          startTime.hour > 23) {
                                        return 'Starting Time must be between 0 and 23'
                                            .tr;
                                      }
                                    } catch (_) {
                                      // return 'Please enter a valid time for Starting Time'
                                      //     .tr;
                                    }
                                    return null;
                                  },
                                ),
                              )),
                          const SizedBox(
                            width: 20,
                          ),
                          Directionality(
                              textDirection: TextDirection.ltr,
                              child: Expanded(
                                child: TextFormField(
                                  controller: _endingTime,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    labelText: 'Ending Time'.tr,
                                    border: const OutlineInputBorder(),
                                  ),
                                  onTap: () async {
                                    TimeOfDay? pickedTime =
                                        await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    );
                                    if (pickedTime != null) {
                                      final now = DateTime.now();
                                      final dt = DateTime(
                                          now.year,
                                          now.month,
                                          now.day,
                                          pickedTime.hour,
                                          pickedTime.minute);
                                      final formattedTime = aa.format(dt);
                                      _endingTime.text = formattedTime;
                                    }
                                  },
                                  validator: (value) {
                                    // if (value == null || value.isEmpty) {
                                    //   return 'Please enter an Ending Time'.tr;
                                    // }
                                    try {
                                      var endTime = aa.parse(value!);
                                      var startTime =
                                          aa.parse(_startingTime.text);
                                      if (endTime.hour < 0 ||
                                          endTime.hour > 23) {
                                        return 'Ending Time must be between 0 and 23'
                                            .tr;
                                      }
                                      if (startTime.isAfter(endTime) ||
                                          startTime.isAtSameMomentAs(endTime)) {
                                        return 'Starting Time must be less than Ending Time'
                                            .tr;
                                      }
                                    } catch (_) {
                                      // return 'Please enter a valid time for Ending Time'
                                      //     .tr;
                                    }
                                    return null;
                                  },
                                ),
                              )),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _costPerKiloInTime,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: InputDecoration(
                                labelText: 'Cost Per Kilo '.tr,
                                border: const OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                // if ((value == null || value.isEmpty)
                                //     //&& (double.parse(value!) >= 1 && double.parse(value) <= 24) && double.parse(value) > double.parse(_startingTime.text)
                                //     ) {
                                //   return value = "Cost Per Kilo".tr;
                                // }
                                return null;
                              },
                            ),
                          ),
                          const Spacer(),
                          SizedBox(
                              width: 150,
                              child: MaterialButton(
                                  height: 45,
                                  color: Colors.blue,
                                  child: Text(
                                    " Add ".tr,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      var startTime =
                                          double.tryParse(_startingTime.text);
                                      var endTime =
                                          double.tryParse(_endingTime.text);

                                      // if (startTime != null &&
                                      //     endTime != null &&
                                      //     startTime < endTime) {
                                      setState(() {
                                        _serviceTime.add({
                                          'startingTime': _startingTime.text,
                                          'endingTime': _endingTime.text,
                                          'costPerKiloInTime': double.parse(
                                              _costPerKiloInTime.text),
                                          "listOfKilos": []
                                        });

                                        _startingTime.clear();
                                        _endingTime.clear();
                                        _costPerKiloInTime.clear();
                                      });
                                    } else {}
                                  }
                                  // }
                                  )),
                          const SizedBox(
                            width: 15,
                          ),
                          SizedBox(
                            width: 150,
                            child: MaterialButton(
                                height: 45,
                                color: Colors.blue,
                                child: Text(
                                  "Show Period".tr,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      content: SizedBox(
                                        height: 600,
                                        width: 400,
                                        child: ListView.separated(
                                            itemBuilder: (context, index) {
                                              return Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          textofTableTitle(
                                                              'starting Time :'
                                                                  .tr),
                                                          const SizedBox(
                                                            width: 20,
                                                          ),
                                                          Directionality(
                                                            textDirection:
                                                                TextDirection
                                                                    .ltr,
                                                            child: Text(
                                                              '${_serviceTime[index]['startingTime']}',
                                                              style: const TextStyle(
                                                                  fontSize: 18,
                                                                  color: Colors
                                                                      .blue),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          textofTableTitle(
                                                              'ending Time :'
                                                                  .tr),
                                                          const SizedBox(
                                                            width: 20,
                                                          ),
                                                          Directionality(
                                                              textDirection:
                                                                  TextDirection
                                                                      .ltr,
                                                              child: Text(
                                                                '${_serviceTime[index]['endingTime']}',
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    color: Colors
                                                                        .blue),
                                                              )),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          textofTableTitle(
                                                              'cost Per Kilo In Time :'
                                                                  .tr),
                                                          const SizedBox(
                                                            width: 20,
                                                          ),
                                                          Text(
                                                            '${_serviceTime[index]['costPerKiloInTime']}',
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    color: Colors
                                                                        .blue),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        children: [
                                                          SizedBox(
                                                              width: 150,
                                                              child:
                                                                  MaterialButton(
                                                                height: 45,
                                                                color:
                                                                    Colors.blue,
                                                                child: Text(
                                                                  "Add price per kilo"
                                                                      .tr,
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          20),
                                                                ),
                                                                onPressed: () {
                                                                  showDialog(
                                                                      context:
                                                                          context,
                                                                      builder: (context) =>
                                                                          AlertDialog(
                                                                              content: SizedBox(
                                                                                  child: ListOfKiloesPrice(
                                                                            index,
                                                                          ))));
                                                                },
                                                              )),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          SizedBox(
                                                            width: 150,
                                                            child:
                                                                MaterialButton(
                                                                    height: 45,
                                                                    color: Colors
                                                                        .blue,
                                                                    child: Text(
                                                                      "Show Price"
                                                                          .tr,
                                                                      style: const TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              20),
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                      showDialog(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (context) =>
                                                                                AlertDialog(
                                                                          content:
                                                                              SizedBox(
                                                                            height:
                                                                                600,
                                                                            width:
                                                                                400,
                                                                            child: ListView.separated(
                                                                                itemBuilder: (context, i) {
                                                                                  return Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                                    children: [
                                                                                      Column(
                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                          Row(
                                                                                            children: [
                                                                                              textofTableTitle('Initial Distance :'.tr),
                                                                                              const SizedBox(
                                                                                                width: 20,
                                                                                              ),
                                                                                              Directionality(
                                                                                                textDirection: TextDirection.ltr,
                                                                                                child: Text(
                                                                                                  '${_serviceTime[index]['listOfKilos'][i]['initialDistance']}',
                                                                                                  style: const TextStyle(fontSize: 18, color: Colors.blue),
                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                          Row(
                                                                                            children: [
                                                                                              textofTableTitle('final Distance :'.tr),
                                                                                              const SizedBox(
                                                                                                width: 20,
                                                                                              ),
                                                                                              Directionality(
                                                                                                  textDirection: TextDirection.ltr,
                                                                                                  child: Text(
                                                                                                    '${_serviceTime[index]['listOfKilos'][i]['finalDistance']}',
                                                                                                    style: const TextStyle(fontSize: 18, color: Colors.blue),
                                                                                                  )),
                                                                                            ],
                                                                                          ),
                                                                                          Row(
                                                                                            children: [
                                                                                              textofTableTitle('cost of Trip:'.tr),
                                                                                              const SizedBox(
                                                                                                width: 20,
                                                                                              ),
                                                                                              Text(
                                                                                                '${_serviceTime[index]['listOfKilos'][i]['costForDistance']}',
                                                                                                style: const TextStyle(fontSize: 18, color: Colors.blue),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                      const Spacer(),
                                                                                      TextButton(
                                                                                        child: Row(
                                                                                          children: [
                                                                                            Text(
                                                                                              'Delete'.tr,
                                                                                              style: const TextStyle(color: Colors.red, fontSize: 20),
                                                                                            ),
                                                                                            const Icon(
                                                                                              Icons.delete,
                                                                                              color: Colors.red,
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                        onPressed: () {
                                                                                          setState(() {
                                                                                            _serviceTime[index]['listOfKilos'].removeAt(index);
                                                                                            Navigator.pop(context);
                                                                                          });
                                                                                        },
                                                                                      )
                                                                                    ],
                                                                                  );
                                                                                  //    _serviceTime[index];
                                                                                },
                                                                                separatorBuilder: (context, index) => const Text(
                                                                                      "----------------------------------",
                                                                                      style: TextStyle(color: Colors.blue),
                                                                                    ),
                                                                                itemCount: _serviceTime[index]['listOfKilos'].length),
                                                                          ),
                                                                        ),
                                                                      );
                                                                    }),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                  const Spacer(),
                                                  TextButton(
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          'Delete'.tr,
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .red,
                                                                  fontSize: 20),
                                                        ),
                                                        const Icon(
                                                          Icons.delete,
                                                          color: Colors.red,
                                                        ),
                                                      ],
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        _serviceTime
                                                            .removeAt(index);
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                  )
                                                ],
                                              );
                                              //    _serviceTime[index];
                                            },
                                            separatorBuilder:
                                                (context, index) => const Text(
                                                      "----------------------------------",
                                                      style: TextStyle(
                                                          color: Colors.blue),
                                                    ),
                                            itemCount: _serviceTime.length),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _descriptionController,
                              decoration: InputDecoration(
                                labelText: 'Description '.tr,
                                border: const OutlineInputBorder(),
                              ),
                              maxLines: 5,
                              maxLength: 500,
                              cursorHeight: 40,
                              // validator: (value) {
                              //   if (value == null || value.isEmpty) {
                              //     return 'Please enter a description '.tr;
                              //   }
                              //   return null;
                              // },
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: SizedBox(
                              height: 270,
                              width: 600,
                              child: FutureBuilder<String?>(
                                future:
                                    _getImageUrl(), // Function to get image URL from Firebase
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return const Center(
                                        child: Icon(Icons.error));
                                  } else if (snapshot.hasData &&
                                      snapshot.data != null) {
                                    // Initial image URL from Firebase
                                    _imageUrl ??= snapshot.data;
                                    return _buildImageContainer(); // Separate function to rebuild
                                  } else {
                                    return _buildImageContainer(); // Use _buildImageContainer here as well
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildSaveButton()
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _admin() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('admin Commission'.tr),
              TextFormField(
                controller: _adminCommissionController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Enter admin Commission'.tr,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter admin Commission'.tr;
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('cost Per Kilo'.tr),
              TextFormField(
                controller: _costPerKiloController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Enter cost Per Kilo'.tr,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter cost Per Kilo'.tr;
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.cyan,
        ),
        height: 50,
        width: 150,
        child: TextButton(
          onPressed: _isLoading
              ? null
              : () {
                  if (_formKey.currentState!.validate()) {
                    _updateDriversAccount();
                    navigationController.navigateTo(showServicesPageRoute);
                  }
                },
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.white))
              : Text(
                  'Update'.tr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildImageContainer() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: 250,
        height: 250,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue),
          borderRadius: BorderRadius.circular(8),
        ),
        child: _selectedImage != null
            ? kIsWeb
                ? Image.network(_selectedImage!.path)
                : Image.file(File(_selectedImage!.path))
            : _imageUrl != null
                ? CachedNetworkImage(
                    imageUrl: _imageUrl!,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  )
                : const Icon(Icons.add_a_photo, color: Colors.grey),
      ),
    );
  }

  Future<String?> _getImageUrl() async {
    try {
      DocumentSnapshot serviceDoc = await FirebaseFirestore.instance
          .collection('services')
          .doc(widget.servicesId)
          .get();

      if (serviceDoc.exists) {
        return serviceDoc['profileImage'];
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<void> _updateDriversAccount() async {
    setState(() {
      _isLoading = true;
    });

    try {
      String? newImageUrl = _imageUrl;

      if (_selectedImage != null) {
        await _uploadImage();
        newImageUrl = _imageUrl;
      }

      // String serviceId = widget.servicesId;

      await _firestore.collection('services').doc(widget.servicesId).update({
        // widget.servicesId: _nameController.text,
        // 'name': _nameController.text,
        'paymentMethod': _paymentMethodController.text,

        'adminCommission': double.parse(_adminCommissionController.text),
        'status': _statusController,
        'region': _regionController.text,
        'arabicName': _arabicNameController.text,
        'frenchName': _frenchNameController.text,
        'description': _descriptionController.text,
        'costPerKilo': double.parse(_costPerKiloController.text),
        'numberOfPassengers': double.parse(_numberOfPassengersController.text),
        'driverMinBalance': double.parse(_driverMinBalance.text),
        "minimumFare": double.parse(_menemumFareController.text),
// 'imageURL': _imageURLController.text, // إذا كنت ترغب في تحديث الصورة أيضًا
        'created_at': DateTime.now(),
        'serviceTimeList': _serviceTime,
        'profileImage': newImageUrl, // Use the updated imageUrl here
      });

      String? adminId = FirebaseAuth.instance.currentUser?.uid;

      if (adminId != null) {
        await _firestore.collection('adminActions').add({
          'adminId': adminId,
          'adminEmail': FirebaseAuth.instance.currentUser?.email,
          'Name': _nameController.text,
          'Id': widget.servicesId,
          'newState': _statusController,
          'type': 'Edit The service',
          'timestamp': FieldValue.serverTimestamp(),
        });
      } else {
        ('No admin is signed in.'); // Consider showing a user-friendly message instead
      }
      const SnackBar(
        content: Text('Services updated successfully'),
      );
    } catch (e) {
      ('Error updating Services : $e');
      SnackBar(
        content: Text('Error updating Services : $e'),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _uploadImage() async {
    if (kIsWeb) {
      final Uint8List uploadedFile = await _selectedImage!.readAsBytes();

      final firebase_storage.Reference ref = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('service_images/${_selectedImage!.name}');
      try {
        await ref.putBlob(html.Blob([uploadedFile])).whenComplete(() async {
          _imageUrl = await ref.getDownloadURL();
          setState(() {});
        });
      } catch (error) {
        // Handle any errors that occur during the upload process
        ('Failed to upload image: $error');
      }
    } else {
      final Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('service_images/${basename(_selectedImage!.path)}');
      firebase_storage.UploadTask uploadTask =
          ref.putFile(File(_selectedImage!.path));

      await uploadTask.whenComplete(() async {
        _imageUrl = await ref.getDownloadURL();
        setState(() {});
      }).catchError((error) {
        ('Failed to upload image: $error');
      });
    }
  }

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery); // Or use ImageSource.camera for camera
    if (pickedFile != null) {
      setState(() {
        _selectedImage = pickedFile;
        _imageUrl =
            null; // Assuming you'll set this to the uploaded image URL later
      });
    } else {
      ('No image selected.');
    }
  }

  Widget ListOfKiloesPrice(int index) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      TextFormField(
        controller: _initialDistance,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(
          labelText: 'initial distance'.tr,
          border: const OutlineInputBorder(),
        ),
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "this field Cant be Empty".tr;
          }

          // }
          return null;
        },
      ),
      const SizedBox(
        height: 10,
      ),
      TextFormField(
        controller: _finalDistance,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(
          labelText: 'final distance'.tr,
          border: const OutlineInputBorder(),
        ),
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "this field Cant be Empty".tr;
          } else if (double.parse(_initialDistance.text.trim()) >=
              double.parse(value)) {
            return "initial distance should be less than final distance".tr;
          }
          return null;
        },
      ),
      const SizedBox(
        height: 10,
      ),
      TextFormField(
        controller: _costForDistance,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(
          labelText: 'Cost of Trip'.tr,
          border: const OutlineInputBorder(),
        ),
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "this field Cant be Empty".tr;
          }
          return null;
        },
      ),
      const SizedBox(
        height: 25,
      ),
      MaterialButton(
        onPressed: () {
          setState(() {
            _serviceTime[index]['listOfKilos'].add({
              "initialDistance": double.parse(_initialDistance.text),
              "finalDistance": double.parse(_finalDistance.text),
              "costForDistance": double.parse(_costForDistance.text),
            });
            _initialDistance.clear();
            _finalDistance.clear();
            _costForDistance.clear();
          });
          Get.back();
        },
        color: Colors.blue,
        child: Text(
          "Add Price".tr,
          style: const TextStyle(color: Colors.white),
        ),
      )
    ]);
  }
}
