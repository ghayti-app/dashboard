import 'package:admin_dashboard/constants/style.dart';
import 'package:admin_dashboard/pages/users/widgets/tra_format.dart';
import 'package:admin_dashboard/widgets/custom_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class Transaction extends StatefulWidget {
  const Transaction({super.key});

  @override
  State<Transaction> createState() => _ClientsTableState();
}

class _ClientsTableState extends State<Transaction> {
  Widget textofTableTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 21,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  bool isAccepted = false;

  List<QueryDocumentSnapshot<Map<String, dynamic>>> _allUsers = [];
  List<QueryDocumentSnapshot<Map<String, dynamic>>> _displayedUsers = [];

  String _searchQuery = '';
  int _currentPage = 1;
  final int _itemsPerPage = 8;

  var searchController = TextEditingController();
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;

  // Function to pick the start date
  void _presentStartDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) return;
      setState(() {
        _selectedStartDate = pickedDate;
        _updateDisplayedUsers();
      });
    });
  }

  // .collection('payments').doc("paymentsTest").collection("TransactionTest")
  // Function to pick the end date
  void _presentEndDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) return;
      if (_selectedStartDate == null ||
          pickedDate.isBefore(_selectedStartDate ?? DateTime.now())) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'.tr),
              content: Text('End Date must be greater than Start Date.'.tr),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'.tr),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        setState(() {
          _selectedEndDate = pickedDate;
          _updateDisplayedUsers();
        });
      }
    });
  }

  Widget searchBarWidgets() {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: TextFormField(
            style: const TextStyle(fontSize: 17, color: Colors.blue),
            controller: searchController,
            decoration: InputDecoration(
              labelText: 'Driver Or Ride Id'.tr,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              counterText: '',
            ),
            onEditingComplete: () {
              setState(() {
                _searchQuery = searchController.text.trim();
                _updateDisplayedUsers(); // Update displayed users after search
              });
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 2,
          child: TextButton(
            onPressed: _presentStartDatePicker,
            child: Text(
              _selectedStartDate != null
                  ? 'Start Date: ${transFormat.format(_selectedStartDate!)}'.tr
                  : 'Choose Start Date'.tr,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
          flex: 2,
          child: TextButton(
            onPressed: _presentEndDatePicker,
            child: Text(
              _selectedEndDate != null
                  ? 'End Date: ${transFormat.format(_selectedEndDate!)}'.tr
                  : 'Choose End Date'.tr,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  ////////////////////////////////////////////////////////

  void _updateDisplayedUsers() {
    _displayedUsers = _allUsers.where((user) {
      final emailMatch = user['driverID']
              .toString()
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          user['rideID']
              .toString()
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());

      // Date range filter
      final timestamp = user['timestamp'].toDate();
      final startDateMatch =
          _selectedStartDate == null || timestamp.isAfter(_selectedStartDate!);
      final endDateMatch = _selectedEndDate == null ||
          timestamp.isBefore(DateTime(_selectedEndDate!.year,
              _selectedEndDate!.month, _selectedEndDate!.day, 23, 59, 59));

      return emailMatch && startDateMatch && endDateMatch;
    }).toList();

    // Pagination logic remains the same
    int startIndex = (_currentPage - 1) * _itemsPerPage;
    int endIndex = startIndex + _itemsPerPage;

    if (endIndex > _displayedUsers.length) {
      endIndex = _displayedUsers.length;
    }

    _displayedUsers = _displayedUsers.sublist(startIndex, endIndex);
    setState(() {
      ("Updated displayed users for UI"); // Ensure this is called to trigger UI update
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchUsers(); // Fetch users on initialization
  }

  void _fetchUsers() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('payments')
        .doc('paymentsTest')
        .collection('TransactionTest')
        .orderBy('timestamp', descending: true)
        .get();
    ("Number of documents fetched: ${snapshot.docs.length}");
    _allUsers = snapshot.docs;
    _updateDisplayedUsers(); // Initial display of users
  }

  @override
  Widget build(BuildContext context) {
    var columns = [
      DataColumn(label: textofTableTitle('No'.tr)),
      DataColumn(label: textofTableTitle('driver ID'.tr)),
      //    DataColumn(label: textofTableTitle('Driver Phone'.tr)),
      DataColumn(label: textofTableTitle('ride ID'.tr)),
      DataColumn(label: textofTableTitle('driver Wallet'.tr)),
      DataColumn(label: textofTableTitle('rider Wallet'.tr)),
      DataColumn(label: textofTableTitle('ride Fare'.tr)),
      DataColumn(label: textofTableTitle('cash Collected'.tr)),
      DataColumn(label: textofTableTitle('Created at'.tr)),
    ];

    final verticalScrollController = ScrollController();
    final horizontalScrollController = ScrollController();

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('payments')
          .doc('paymentsTest')
          .collection('TransactionTest')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
              child: Text('Something went wrong'.tr,
                  style: const TextStyle(
                      color: Colors.red,
                      fontSize: 25,
                      fontWeight: FontWeight.bold)));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
              child: Text('No Transactions available'.tr,
                  style: const TextStyle(
                      color: Colors.red,
                      fontSize: 25,
                      fontWeight: FontWeight.bold)));
        }

        var customers = snapshot.data!.docs;

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            //    border: Border.all(color: active.withOpacity(.4), width: .5),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 6),
                color: lightGray.withOpacity(.1),
                blurRadius: 12,
              ),
            ],
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 30),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "Transaction Page".tr,
                    style: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 90,
                    child: MaterialButton(
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
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  SizedBox(
                    height: 70,
                    width: 500,
                    child: searchBarWidgets(),
                  ),
                  const Spacer(),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => _selectDatesAndSaveToExcel(context),
                          child: Text('Export Data'.tr),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  controller: verticalScrollController,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: horizontalScrollController,
                    child: DataTable(
                      columns: columns,
                      rows: _displayedUsers.map((customer) {
                        return DataRow(cells: [
                          DataCell(Text(((_currentPage - 1) * _itemsPerPage +
                                  _displayedUsers.indexOf(customer) +
                                  1)
                              .toString())),

                          DataCell(
                            //   CustomText(
                            //   text: user['phoneNumber'] ?? 'N/A',
                            // )

                            InkWell(
                              onTap: () {
                                Clipboard.setData(ClipboardData(
                                    text: customer[
                                        'driverID'])); // نسخ النص إلى الحافظة
                                Get.snackbar(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 50),
                                  "Copied to clipboard!".tr,
                                  "Phone number copied to clipboard".tr,
                                  snackPosition: SnackPosition.TOP,
                                  backgroundColor: Colors.blue[300],
                                  duration: const Duration(seconds: 2),
                                );
                              },
                              child: Row(children: [
                                CustomText(
                                  text: customer['driverID'] ?? 'N/A',
                                ),
                              ]),
                            ),
                          ),

                          // DataCell(
                          //   Expanded(
                          //     child: FutureBuilder<QuerySnapshot>(
                          //       future: FirebaseFirestore.instance
                          //           .collection('drivers')
                          //           .where(FieldPath.documentId,
                          //               isEqualTo: customer['driverID'])
                          //           .get(),
                          //       builder: (context, snapshot) {
                          //         if (!snapshot.hasData) {
                          //           return const Center(
                          //             child: CircularProgressIndicator(),
                          //           );
                          //         }
                          //         var driver = snapshot.data!.docs.first;
                          //         if (driver == null) {
                          //           return Text('Driver not found');
                          //         }
                          //         return InkWell(
                          //           onTap: () {
                          //             Clipboard.setData(ClipboardData(
                          //                 text: driver['phoneNumber']
                          //                     .toString())); // نسخ النص إلى الحافظة
                          //             Get.snackbar(
                          //               padding: const EdgeInsets.symmetric(
                          //                   horizontal: 50),
                          //               "Copied to clipboard!".tr,
                          //               "Phone number copied to clipboard".tr,
                          //               snackPosition: SnackPosition.TOP,
                          //               backgroundColor: Colors.blue[300],
                          //               duration: const Duration(seconds: 2),
                          //             );
                          //           },
                          //           child: Row(children: [
                          //             CustomText(
                          //               text:
                          //                   driver['phoneNumber'].toString() ??
                          //                       'N/A',
                          //             ),
                          //           ]),
                          //         );
                          //       },
                          //     ),
                          //   ),
                          // ),

                          DataCell(
                            //   CustomText(
                            //   text: user['phoneNumber'] ?? 'N/A',
                            // )

                            InkWell(
                              onTap: () {
                                Clipboard.setData(
                                    ClipboardData(text: customer['rideID']));
                                Get.snackbar(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 50),
                                  "Copied to clipboard!".tr,
                                  "Phone number copied to clipboard".tr,
                                  snackPosition: SnackPosition.TOP,
                                  backgroundColor: Colors.blue[300],
                                  duration: const Duration(seconds: 2),
                                );
                              },
                              child: Row(children: [
                                CustomText(
                                  text: customer['rideID'] ?? 'N/A',
                                ),
                              ]),
                            ),
                          ),

                          DataCell(Directionality(
                              textDirection: TextDirection.ltr,
                              child:
                                  Text(customer['driverWallet'].toString()))),
                          DataCell(Directionality(
                              textDirection: TextDirection.ltr,
                              child: Text(customer['riderWallet'].toString()))),
                          DataCell(Directionality(
                              textDirection: TextDirection.ltr,
                              child: Text(customer['rideFare'].toString()))),
                          DataCell(Directionality(
                              textDirection: TextDirection.ltr,
                              child:
                                  Text(customer['cashCollected'].toString()))),
                          //  DataCell(Text(customer['cashCollected'].toString())),
                          DataCell(
                              Text(customer['timestamp'].toDate().toString())),
                        ]);
                      }).toList(),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ////////////////////////////////////////////////////////

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Previous Page Button
                  MaterialButton(
                    onPressed: _currentPage > 1
                        ? () {
                            setState(() {
                              _currentPage--;
                              _updateDisplayedUsers();
                            });
                          }
                        : null,
                    child: Column(
                      children: [
                        Text("Previous Page".tr),
                        const Icon(Icons.arrow_back_ios)
                      ],
                    ),
                  ),

                  // Page Number Display
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'Page $_currentPage of ${(_allUsers.length / _itemsPerPage).ceil()}'
                          .tr,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),

                  // Next Page Button
                  MaterialButton(
                    onPressed: _currentPage <
                            ((_allUsers.length / _itemsPerPage).ceil())
                        ? () {
                            setState(() {
                              _currentPage++;
                              _updateDisplayedUsers();
                            });
                          }
                        : null,
                    child: Column(
                      children: [
                        Text("Next Page".tr),
                        const Icon(Icons.arrow_forward_ios)
                      ],
                    ),
                  ),
                ],
              ),
////////////////////////////////////////////////////////
            ],
          ),
        );
      },
    );
  }

  DateTime? _startDate;
  DateTime? _endDate;
  void _selectDatesAndSaveToExcel(BuildContext context) async {
    DateTime? startDate = await _showDatePicker(context, isStart: true);
    if (startDate != null) {
      setState(() {
        _startDate = startDate;
      });

      DateTime? endDate = await _showDatePicker(context, isStart: false);
      if (endDate != null) {
        setState(() {
          _endDate = endDate;
        });

        if (_startDate != null && _endDate != null) {
          _exportDataToExcel(startDate, endDate);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('please Select Start Date And End Date'.tr),
          ));
        }
      }
    }
  }

  Future<DateTime?> _showDatePicker(BuildContext context,
      {required bool isStart}) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      if (isStart) {
        setState(() {
          _startDate = pickedDate;
        });
      } else {
        setState(() {
          _endDate = pickedDate;
        });
      }
      _updateDisplayedUsers();
    }

    return pickedDate;
  }

  void _exportDataToExcel(DateTime startDate, DateTime endDate) async {
    if (startDate.isAfter(endDate)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Start Date must be before End Date'.tr),
      ));
      return;
    }
    // Adjust endDate to include the entire day
    DateTime adjustedEndDate =
        DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);

    final snapshot = await FirebaseFirestore.instance
        .collection('payments')
        .doc('paymentsTest')
        .collection('TransactionTest')
        .where('timestamp', isGreaterThanOrEqualTo: startDate)
        .where('timestamp', isLessThanOrEqualTo: adjustedEndDate)
        .get();

    final excel = Excel.createExcel();
    final sheet = excel['Sheet1'];

    // Add headers
    sheet.appendRow([
      const TextCellValue("Driver ID"),
      const TextCellValue('Ride ID'),
      const TextCellValue('Driver Wallet'),
      const TextCellValue('Rider Wallet'),
      const TextCellValue('Ride Fare'),
      const TextCellValue('cash Collected'),
      const TextCellValue('Timestamp')
    ]);

    for (var user in snapshot.docs) {
      final data = user.data();
      sheet.appendRow([
        TextCellValue(data['driverID'].toString()),
        TextCellValue(data['rideID'].toString()),
        TextCellValue(data['driverWallet'].toString()),
        TextCellValue(data['riderWallet'].toString()),
        TextCellValue(data['rideFare'].toString()),
        TextCellValue(data['cashCollected'].toString()),
        TextCellValue(data['timestamp'].toDate().toString()),
      ]);
    }

    try {
      excel.save();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Data are Saved'.tr),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Problem in saving File'.tr),
      ));
    }
  }
}
