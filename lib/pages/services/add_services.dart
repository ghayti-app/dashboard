import 'dart:io';

import 'package:admin_dashboard/pages/services/date_format.dart';
import 'package:admin_dashboard/routing/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../constants/controllers.dart';

class AddServiceScreen extends StatefulWidget {
  const AddServiceScreen({super.key});

  @override
  _AddServiceScreenState createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firestore = FirebaseFirestore.instance;
  final List<Map<String, dynamic>> _serviceTime = [];

  Widget textofTableTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
          fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black54),
    );
  }

  List<DropdownMenuItem<bool>> itemsStatus = [
    DropdownMenuItem(value: true, child: Text('Approved'.tr)),
    DropdownMenuItem(value: false, child: Text('Not Approved'.tr)),
  ];
  List<DropdownMenuItem<String>> itemsRegion = [
    DropdownMenuItem(value: "Cairo,القاهرة,Le Caire", child: Text('Cairo'.tr)),
    DropdownMenuItem(value: "Giza,الجيزة,Le Giza", child: Text('Giza'.tr)),
    DropdownMenuItem(
        value: "Nouakchott,نواكشوط,Nouakchott", child: Text('Nouakchott'.tr)),
    // ... other items
  ];

  final bool isVerified = false;
  List<Widget> itemPhotosWidgetList = <Widget>[];

  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage; // To store the selected image
  String? _imageUrl; // To store the download URL
  bool _isUploading = false;
  bool _isLoading = false;

  bool uploading = false;
  final TextEditingController _initialDistance = TextEditingController();
  final TextEditingController _finalDistance = TextEditingController();
  final TextEditingController _costForDistance = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _arabicNameController = TextEditingController();
  final TextEditingController _frenchNameController = TextEditingController();

  final TextEditingController _regionController = TextEditingController();

  final TextEditingController _startingTime = TextEditingController();
  final TextEditingController _endingTime = TextEditingController();
  final TextEditingController _costPerKiloInTime = TextEditingController();

  final TextEditingController _adminCommissionController =
      TextEditingController();
  bool _statusController = false;
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _DefauiltcostPerKiloController =
      TextEditingController();
  final TextEditingController _driverMinBalance = TextEditingController();
  final TextEditingController _numberOfPassengersController =
      TextEditingController();
  final TextEditingController _menemumFareController = TextEditingController();
  // final TextEditingController _imageURLController = TextEditingController();
  // Image Selection Function (modified for single image)
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImage = pickedFile;
      });
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

  // Image Upload Function
  Future<void> _uploadImage() async {
    if (_selectedImage != null) {
      setState(() {
        _isUploading = true;
      });

      try {
        final ref = FirebaseStorage.instance
            .ref()
            .child('service_images/${DateTime.now()}.jpg');

        if (kIsWeb) {
          // Web upload
          await ref.putData(await _selectedImage!.readAsBytes());
        } else {
          // Mobile upload
          await ref.putFile(File(_selectedImage!.path));
        }

        _imageUrl = await ref.getDownloadURL();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image uploaded successfully'.tr)),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading image'.tr)),
        );
      } finally {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  // Function to validate image selection (mandatory)
  String? _validateImage() {
    if (_selectedImage == null) {
      return 'Please select an image'.tr; // Error message
    }
    return null; // No error
  }

  void _addService() async {
    if (_formKey.currentState!.validate() && _validateImage() == null) {
      setState(() {
        _isLoading = true;
      });
      try {
        await _uploadImage(); // Upload the image first

        // DocumentReference serviceRef =
        await _firestore.collection('services').doc(_nameController.text).set({
          'name': _nameController.text,
          'arabicName': _arabicNameController.text,
          'frenchName': _frenchNameController.text,
          'region': _regionController.text,
          'currency': "UM".toString(),
          'paymentMethod': "cash".toString(),
          'adminCommission': double.parse(_adminCommissionController.text),
          'status': _statusController,
          'description': _descriptionController.text,
          'costPerKilo': double.parse(_DefauiltcostPerKiloController.text),
          'driverMinBalance': double.parse(_driverMinBalance.text),
          "serviceTimeList": _serviceTime,
          "minimumFare": double.parse(_menemumFareController.text),
          'numberOfPassengers':
              double.parse(_numberOfPassengersController.text),
          'created_at': DateTime.now(),
          'profileImage': _imageUrl, // Store the single image URL
        });
        String? adminId = FirebaseAuth.instance.currentUser?.uid;
        if (adminId != null) {
          await _firestore.collection('adminActions').add({
            'adminId': adminId,
            'adminEmail': FirebaseAuth.instance.currentUser?.email,
            'Name': _nameController.text,
            'Id': _nameController.text,
            'newState': _statusController,
            'type': 'Add service',
            'timestamp': FieldValue.serverTimestamp(),
          });
        } else {
          ('No admin is signed in.'.tr);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Service added successfully'.tr)),
        );
        navigationController.navigateTo(showServicesPageRoute);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add service: $e'.tr)),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      // Form or image validation failed
      if (_validateImage() != null) {
        // Show the image error (if any)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_validateImage()!)),
        );
      }
      // You might want to display other form validation errors here as well
    }
  }

  @override
  void initState() {
    super.initState();
    _regionController.text = "Nouakchott";
    _statusController = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "add Service".tr,
          style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        actions: [
          MaterialButton(
            height: 45,
            color: Colors.blue,
            child: Text(
              " Back".tr,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
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
                              decoration: InputDecoration(
                                  labelText: 'region'.tr,
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
                              decoration: InputDecoration(
                                  labelText: 'Status'.tr,
                                  border: const OutlineInputBorder()),
                              items: itemsStatus,
                              onChanged: (value) {
                                setState(() {
                                  if (value == null) {
                                    _regionController.text = "Approved";
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
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _numberOfPassengersController,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
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
                              controller: _DefauiltcostPerKiloController,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: InputDecoration(
                                labelText: 'Default Cost Per Kilo '.tr,
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
                                  TimeOfDay? pickedTime = await showTimePicker(
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
                            ),
                          ),
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
                                            return Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    textofTableTitle(
                                                        'starting Time :'.tr),
                                                    const SizedBox(
                                                      width: 20,
                                                    ),
                                                    Directionality(
                                                      textDirection:
                                                          TextDirection.ltr,
                                                      child: Text(
                                                        '${_serviceTime[index]['startingTime']}',
                                                        style: const TextStyle(
                                                            fontSize: 18,
                                                            color: Colors.blue),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    textofTableTitle(
                                                        'ending Time :'.tr),
                                                    const SizedBox(
                                                      width: 20,
                                                    ),
                                                    Directionality(
                                                        textDirection:
                                                            TextDirection.ltr,
                                                        child: Text(
                                                          '${_serviceTime[index]['endingTime']}',
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 18,
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
                                                      style: const TextStyle(
                                                          fontSize: 18,
                                                          color: Colors.blue),
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
                                                        child: MaterialButton(
                                                          height: 45,
                                                          color: Colors.blue,
                                                          child: Text(
                                                            "Add price per kilo"
                                                                .tr,
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 20),
                                                          ),
                                                          onPressed: () {
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder: (context) =>
                                                                    AlertDialog(
                                                                        content:
                                                                            SizedBox(
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
                                                      child: MaterialButton(
                                                          height: 45,
                                                          color: Colors.blue,
                                                          child: Text(
                                                            "Show Price".tr,
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 20),
                                                          ),
                                                          onPressed: () {
                                                            showDialog(
                                                              context: context,
                                                              builder:
                                                                  (context) =>
                                                                      AlertDialog(
                                                                content:
                                                                    SizedBox(
                                                                  height: 600,
                                                                  width: 400,
                                                                  child: ListView
                                                                      .separated(
                                                                          itemBuilder:
                                                                              (context,
                                                                                  i) {
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
                                                                          separatorBuilder: (context, index) =>
                                                                              const Text(
                                                                                "----------------------------------",
                                                                                style: TextStyle(color: Colors.blue),
                                                                              ),
                                                                          itemCount:
                                                                              _serviceTime[index]['listOfKilos'].length),
                                                                ),
                                                              ),
                                                            );
                                                          }),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            );

                                            //    _serviceTime[index];
                                          },
                                          separatorBuilder: (context, index) =>
                                              const Text(
                                                "----------------------------------",
                                                style: TextStyle(
                                                    color: Colors.blue),
                                              ),
                                          itemCount: _serviceTime.length),
                                    ),
                                  ),
                                );
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
                          const SizedBox(width: 20),
                          Expanded(
                            child: SizedBox(
                              height: 270,
                              width: 600,
                              child: GestureDetector(
                                onTap: _pickImage,
                                child: Card(
                                  elevation: 5,
                                  child: _isUploading
                                      ? const Center(
                                          child: CircularProgressIndicator())
                                      : _selectedImage != null
                                          ? kIsWeb
                                              ? Image.network(_selectedImage!
                                                  .path) // Display from local path on Web
                                              : Image.file(File(_selectedImage!
                                                  .path)) // Display from File path on mobile
                                          : Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.image,
                                                    size: 100,
                                                    color: Colors.grey[400],
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Text(
                                                    'Tap to select an image'.tr,
                                                    style: TextStyle(
                                                      color: Colors.grey[600],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                ),
                              ),
                            ),
                          ),
                          if (_isLoading) // Loading indicator for form submission
                            const Center(
                              child: CircularProgressIndicator(),
                            ),
                        ],
                      ),
                      Container(
                        width: 200,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10)),
                        child: MaterialButton(
                          onPressed: _addService,
                          child: Text(
                            'Add Service '.tr,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 25),
                          ),
                        ),
                      ),
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
}
