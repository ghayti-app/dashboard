import 'package:admin_dashboard/constants/controllers.dart';
import 'package:admin_dashboard/routing/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Import for date formatting

class AddCouponScreen extends StatefulWidget {
  const AddCouponScreen({super.key});

  @override
  _AddCouponScreenState createState() => _AddCouponScreenState();
}

class _AddCouponScreenState extends State<AddCouponScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _usageLimitPerPersonController =
      TextEditingController();
  //final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _discountAmountController =
      TextEditingController();
  final TextEditingController _totalUsageLimitController =
      TextEditingController();
  final TextEditingController _minimumDiscountController =
      TextEditingController();
  String? selectedService;
  final TextEditingController _statusController = TextEditingController();

  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;
  List<DropdownMenuItem<String>> items = [
    DropdownMenuItem(value: 'Active', child: Text('Active'.tr)),
    DropdownMenuItem(value: 'Expire', child: Text('Expire'.tr)),
    // ... other items
  ];
  final String _couponType = 'All';
  String _discountType = 'Fixed';
  String _status = 'Active';

  // Function to save the coupon
  void _saveCoupon() async {
    DateTime startDate = _selectedStartDate ?? DateTime.now();
    DateTime endDate = _selectedEndDate ?? DateTime.now();

    String formattedStartDate = DateFormat('yyyy-MM-dd').format(startDate);
    String formattedEndDate = DateFormat('yyyy-MM-dd').format(endDate);

    if (_formKey.currentState!.validate()) {
      if (DateTime.parse(formattedEndDate)
          .isAfter(DateTime.parse(formattedStartDate))) {
        Map<String, dynamic> couponData = {
          'code': _codeController.text,
          'title': _titleController.text,
          'serviceIdDiscount': selectedService.toString(),
          'usageLimitPerPerson': int.parse(_usageLimitPerPersonController.text),
          'totalUsageLimit': int.parse(_totalUsageLimitController.text),
          'discountAmount': int.parse(_discountAmountController.text),
          'createdDate': DateTime.now().toIso8601String(),
          'totalActualUsed': 0, // Initialize to 0
          'startDate': formattedStartDate,
          'endDate': formattedEndDate,
          'minimumDiscount': int.parse(_minimumDiscountController.text),
          'couponType': _couponType,
          'status': _status,
          "riderIdsList": [],
        };
        String? adminId = FirebaseAuth.instance.currentUser?.uid;

        if (adminId != null) {
          await FirebaseFirestore.instance.collection('adminActions').add({
            'adminId': adminId,
            'adminEmail': FirebaseAuth.instance.currentUser?.email,
            'Name': _codeController.text,
            'Id': selectedService.toString(),
            'newState': _status,
            'type': 'Add New Coupon',
            'timestamp': FieldValue.serverTimestamp(),
          });
        }

        await FirebaseFirestore.instance.collection('coupons').add(couponData);

        // _formKey.currentState!.reset();

        if (mounted) {
          setState(() {
            _selectedStartDate = null;
            _selectedEndDate = null;
            _discountType = 'Fixed';
            _status = 'Active';
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Coupon added successfully'.tr)),
          );

          navigationController.navigateTo(showcouponPageRoute);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Invalid start and end dates. End date must be after start date.'
                      .tr)),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Invalid start and end dates. End date must be after start date.'
                    .tr)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( automaticallyImplyLeading: false,
        title: Text('Add Coupon'.tr),
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
              //  navigationController.navigateTo();

              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _codeController,
                        decoration: InputDecoration(
                          labelText: 'Coupon Code'.tr,
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a coupon code'.tr;
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          labelText: 'Coupon Title'.tr,
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a coupon title'.tr;
                          }
                          return null;
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
                        controller: _usageLimitPerPersonController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                          labelText: 'Usage Limit Per Person'.tr,
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a usage limit per person'.tr;
                          }
                          if (int.tryParse(value) == null) {
                            return 'Please enter a valid number'.tr;
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _totalUsageLimitController,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Total Usage Limit'.tr,
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a total usage limit'.tr;
                          }
                          if (int.tryParse(value) == null) {
                            return 'Please enter a valid number'.tr;
                          }
                          return null;
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
                        controller: _discountAmountController,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Discount Amount'.tr,
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a discount amount'.tr;
                          }
                          if (int.tryParse(value) == null) {
                            return 'Please enter a valid number'.tr;
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: FutureBuilder<QuerySnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('services')
                            .get(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          var services = snapshot.data!.docs;

                          // Create a list to hold all dropdown menu items
                          List<DropdownMenuItem<String>> allItems = [];

                          // Add the "All" option as the first item
                          allItems.add(
                            DropdownMenuItem(
                              value: 'All',
                              child: Text('All'.tr),
                            ),
                          );

                          // Add dropdown menu items for each service
                          allItems.addAll(
                            services.map((service) {
                              return DropdownMenuItem<String>(
                                value: service.id,
                                child: Text(service['name']),
                              );
                            }).toList(),
                          );

                          return DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                                labelText: 'Services Discount'.tr,
                                border: const OutlineInputBorder()),
                            items: allItems,
                            onChanged: (value) {
                              setState(() {
                                selectedService = value;
                              });
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
                        controller: _minimumDiscountController,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Minimum Discount'.tr,
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a minimum discount'.tr;
                          }
                          if (int.tryParse(value) == null) {
                            return 'Please enter a valid number'.tr;
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Coupon Status'.tr,
                          border: const OutlineInputBorder(),
                        ),
                        items: items,
                        onChanged: (value) {
                          setState(() {
                            _statusController.text = value!;
                            // customer['region'] = value;
                          });
                        },
                      ),

                      //  DropdownButtonFormField<String>(
                      //   value: _couponType,
                      //   onChanged: (value) {
                      //     setState(() {
                      //       _couponType = value!;
                      //     });
                      //   },
                      //   items: <String>[
                      //     'All',
                      //     'First Rider',
                      //     'Region Wise',
                      //   ].map((String value) {
                      //     return DropdownMenuItem<String>(
                      //       value: value,
                      //       child: Text(value),
                      //     );
                      //   }).toList(),
                      //   decoration: InputDecoration(
                      //     labelText: 'Coupon Type'.tr,
                      //     border: OutlineInputBorder(),
                      //   ),
                      // ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text('Start Date:'.tr),
                    ),
                    TextButton(
                      onPressed: () {
                        _selectStartDate(context);
                      },
                      child: Text(
                        _selectedStartDate != null
                            ? DateFormat('yyyy-MM-dd')
                                .format(_selectedStartDate!)
                            : 'Select Start Date'.tr,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text('End Date:'.tr),
                    ),
                    TextButton(
                      onPressed: () {
                        _selectEndDate(context);
                      },
                      child: Text(
                        _selectedEndDate != null 
                            ? DateFormat('yyyy-MM-dd').format(_selectedEndDate!)
                            : 'Select End Date'.tr,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  width: 200,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10)),
                  child: MaterialButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _saveCoupon();
                      }
                    },
                    child: Text(
                      'Create Coupon'.tr,
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
        ),
      ),
    );
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedStartDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedStartDate) {
      setState(() {
        _selectedStartDate = picked;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedEndDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedEndDate) {
      setState(() {
        _selectedEndDate = picked;
      });
    }
  }
}
