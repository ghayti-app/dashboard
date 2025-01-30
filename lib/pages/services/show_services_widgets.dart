import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:admin_dashboard/constants/controllers.dart';
import 'package:admin_dashboard/pages/services/edit_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../constants/style.dart';
import '../../../../widgets/custom_text.dart';

class ShowServiceScreen extends StatefulWidget {
  int ? indexPage;
    ShowServiceScreen({super.key, int? indexPage});

  @override
  State<ShowServiceScreen> createState() => _ClientsTableState();
}

class _ClientsTableState extends State<ShowServiceScreen> {
  Widget textofTableTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
          fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black54),
    );
  }

  List<QueryDocumentSnapshot<Map<String, dynamic>>> _allUsers = [];
  List<QueryDocumentSnapshot<Map<String, dynamic>>> _displayedUsers = [];
  String _searchQuery = '';
  int _currentPage = 1;
  final List<bool> _selectstate = [true, false];
  bool? _selectedVerfied;
  final int _itemsPerPage = 8;

  var searchController = TextEditingController();
  final _firestore = FirebaseFirestore.instance;
  bool _verficationController = false;

  Future<void> _updateVerificationStatus(
      bool newStatus, String driveridd, serviceName) async {
    try {
      await _firestore.collection('services').doc(driveridd).update({
        'status': newStatus,
      });

      String? adminId = FirebaseAuth.instance.currentUser?.uid;

      if (adminId != null) {
        await _firestore.collection('adminActions').add({
          'adminId': adminId,
          'adminEmail': FirebaseAuth.instance.currentUser?.email,
          'Name': serviceName,
          'Id': driveridd,
          'newState': newStatus,
          'type': 'change Servies State',
          'timestamp': FieldValue.serverTimestamp(),
        });
      } else {
        ('No admin is signed in.');
      }

      setState(() {
        newStatus != newStatus;
      });
    } catch (e) {
      ('Error updating verification status: $e'.tr);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating verification status: $e'.tr),
        ),
      );
    }
  }

  Widget searchBarWidgets() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: TextFormField(
            style: const TextStyle(fontSize: 17, color: Colors.blue),
            controller: searchController,
            decoration: InputDecoration(
              labelText: 'Name'.tr,
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
        const SizedBox(width: 50),
        Row(
          children: [
            textofTableTitle("Status :".tr),
            Material(
              child: DropdownButton<bool>(
                value: _selectedVerfied,
                hint: const Text('Filter by Status'),
                onChanged: (value) {
                  setState(() {
                    _selectedVerfied = value; // == true ? "online" : "offline";
                    _updateDisplayedUsers();
                  });
                },
                items: [
                  DropdownMenuItem<bool>(
                    value: null,
                    child: Text('All'.tr),
                  ),
                  ..._selectstate.map((state) {
                    return DropdownMenuItem<bool>(
                      value: state,
                      child: Text(state ? "online".tr : "offline".tr),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  ////////////////////////////////////////////////////////
  void _updateDisplayedUsers() {
    ("Updating displayed users with search query: $_searchQuery");

    _displayedUsers = _allUsers
        .where((user) =>
            user['name']
                .toString()
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) &&
            (_selectedVerfied == null || user['status'] == _selectedVerfied))
        .toList();

    ("Filtered users count: ${_displayedUsers.length}"); // Debugging: Check the count of filtered users

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
        _currentPage = widget.indexPage ?? 1;

    _fetchUsers(); // Fetch users on initialization
  }

  void _fetchUsers() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('services').orderBy("created_at", descending: true).get();
    ("Number of documents fetched: ${snapshot.docs.length}");
    _allUsers = snapshot.docs;
    _updateDisplayedUsers(); // Initial display of users
  }

  void _updateFirestoreDocument(String documentId, bool newValue) {
    FirebaseFirestore.instance.collection('services').doc(documentId).update({
      'status': newValue,
    });
  }

  // List<DropdownMenuItem<String>> itemsRegion = [
  //   DropdownMenuItem(value: 'Cairo ', child: Text('Cairo'.tr)),
  //   DropdownMenuItem(value: 'Nouakchott', child: Text('Nouakchott'.tr)),
  //   // ... other items
  // ];
  @override
  Widget build(BuildContext context) {
    var columns = [
      DataColumn(label: textofTableTitle('No'.tr)),
      DataColumn(label: textofTableTitle('name'.tr)),
      DataColumn(label: textofTableTitle('description'.tr)),
      // DataColumn(label: textofTableTitle('number Of Passengers'.tr)),
      DataColumn(label: textofTableTitle('Admin Commission'.tr)),
      DataColumn(label: textofTableTitle('region'.tr)),
      DataColumn(label: textofTableTitle('cost Per Kilo'.tr)),
      // DataColumn(label: textofTableTitle('Payment Method'.tr)),
      DataColumn(label: textofTableTitle('Status'.tr)),
      DataColumn(label: textofTableTitle('Created at'.tr)),
      DataColumn(label: textofTableTitle('Action'.tr)),
      // DataColumn(label: Text('Actions')),
    ];

    final verticalScrollController = ScrollController();
    final horizontalScrollController = ScrollController();

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('services').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong'.tr));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
              child: Text('No clients available'.tr,
                  style: const TextStyle(
                      color: Colors.red,
                      fontSize: 25,
                      fontWeight: FontWeight.bold)));
        }

        var customers = snapshot.data!.docs;

        if (_searchQuery.isNotEmpty) {
          customers = customers
              .where((customer) =>
                  customer['name']
                      .toString()
                      .toLowerCase()
                      .contains(_searchQuery.toLowerCase()) ||
                  customer['region']
                      .toString()
                      .toLowerCase()
                      .contains(_searchQuery.toLowerCase()))
              .toList();
        }

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: active.withOpacity(.4), width: .5),
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
                    "show Services".tr,
                    style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
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
                ],
              ),
              Expanded(
                child: AdaptiveScrollbar(
                  underColor: Colors.blueGrey.withOpacity(0.3),
                  sliderDefaultColor: active.withOpacity(0.7),
                  sliderActiveColor: active,
                  controller: verticalScrollController,
                  child: AdaptiveScrollbar(
                    controller: horizontalScrollController,
                    position: ScrollbarPosition.bottom,
                    underColor: lightGray.withOpacity(0.3),
                    sliderDefaultColor: active.withOpacity(0.7),
                    sliderActiveColor: active,
                    width: 13.0,
                    sliderHeight: 300,
                    child: SingleChildScrollView(
                      controller: verticalScrollController,
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        controller: horizontalScrollController,
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DataTable(
                            columns: columns,
                            rows: _displayedUsers.map(
                              (customer) {
                                // var customer = customers[index].data()
                                //     as Map<String, dynamic>;
                                // var customerid = customers[index];

                                final lastLoginTimestamp =
                                    customer['created_at'] as Timestamp;
                                final formattedLastLogin =
                                    lastLoginTimestamp != null
                                        ? DateFormat('MMM dd, yyyy hh:mm:ss a')
                                            .format(lastLoginTimestamp.toDate())
                                        : "N/A";
                                return DataRow(cells: [
                                  DataCell(Text(((_currentPage - 1) *
                                              _itemsPerPage +
                                          _displayedUsers.indexOf(customer) +
                                          1)
                                      .toString())),
                                  DataCell(CustomText(
                                    text: customer['name'].toString() ?? 'N/A',
                                  )),
                                  DataCell(SizedBox(
                                    width: 100,
                                    child: TextButton(
                                      child: Text(
                                        customer['description'].toString(),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text("description".tr),
                                              content: SingleChildScrollView(
                                                child: Text(
                                                    customer['description'].toString()),
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: const Text("Close"),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  )),
                                  // DataCell(CustomText(
                                  //   text: customer['numberOfPassengers']
                                  //           .toString() ??
                                  //       'N/A',
                                  // )),
                                  DataCell(CustomText(
                                    text: customer['adminCommission']
                                            .toString() ??
                                        'N/A',
                                  )),
                                  DataCell(CustomText(
                                    text:
                                        customer['region'].toString() ?? 'N/A',
                                  )),
                                  DataCell(CustomText(
                                    text: customer['costPerKilo'].toString() ??
                                        'N/A',
                                  )),
                                  // DataCell(CustomText(
                                  //   text:
                                  //       customer['paymentMethod'].toString() ??
                                  //           'N/A',
                                  // )),
                                  DataCell(
                                    Row(
                                      children: [
                                        DropdownButton<bool>(
                                          value: customer['status'],
                                          items: [
                                            DropdownMenuItem(
                                              value: true,
                                              child: Row(
                                                children: [
                                                  const Icon(Icons.verified,
                                                      color: Colors.green),
                                                  const SizedBox(width: 10),
                                                  Text("Verified".tr),
                                                ],
                                              ),
                                            ),
                                            DropdownMenuItem(
                                              value: false,
                                              child: Row(
                                                children: [
                                                  const Icon(Icons.close,
                                                      color: Colors.red),
                                                  const SizedBox(width: 10),
                                                  Text("Unverified".tr),
                                                ],
                                              ),
                                            ),
                                          ],
                                          onChanged: (value) {
                                            setState(() {
                                              customer.data()['status'] =
                                                  value!.toString();
                                              _verficationController = value;
                                              _updateVerificationStatus(
                                                  value,
                                                  customer.id,
                                                  customer['name']);
                                            });
                                            navigationController.navigateToServiceview(
                                                 index: _currentPage);
                                          },
                                        ),
                                      ],
                                    ),

                                    //   Container(
                                    //   height: 30,
                                    //   //  width: 100,
                                    //   width: double.infinity,
                                    //   padding: EdgeInsets.only(top: 3),

                                    //   decoration: BoxDecoration(
                                    //       color: customer['status'] == true
                                    //           ? Colors.green
                                    //           : Colors.red,
                                    //       borderRadius:
                                    //           BorderRadius.circular(10)),
                                    //   child: Center(
                                    //     child: Text(
                                    //       " ${customer['status'] ?? 'N/A'} ",
                                    //       style: TextStyle(
                                    //           fontWeight: FontWeight.bold,
                                    //           color: Colors.white),
                                    //     ),
                                    //   ),
                                    // )
                                  ),

                                  DataCell(
                                    Text(formattedLastLogin),
                                  ),
                                  DataCell(Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.edit_note,
                                          color: Colors.blue,
                                        ),
                                        onPressed: () {
                                          // Edit admin
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  EditServicesWidgets(
                                                servicesId: customer.id,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  )),
                                ]);
                              },
                            ).toList(),
                          ),
                        ),
                      ),
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
}
