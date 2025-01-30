import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:admin_dashboard/pages/wallet%20request/ApproveMoneyTransformation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
 import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../widgets/custom_text.dart';
import '../../constants/style.dart';

class ShowWalletTable extends StatefulWidget {
  const ShowWalletTable({super.key});

  @override
  State<ShowWalletTable> createState() => _ClientsTableState();
}

class _ClientsTableState extends State<ShowWalletTable> {
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
  bool isTakeAction = false;
  final _firestore = FirebaseFirestore.instance;

  List<QueryDocumentSnapshot<Map<String, dynamic>>> _allUsers = [];
  List<QueryDocumentSnapshot<Map<String, dynamic>>> _displayedUsers = [];
  final List<bool> _selectstate = [true, false];
  bool? _selectedVerfied;
  String _searchQuery = '';
  int _currentPage = 1;
  final int _itemsPerPage = 8;

  var searchController = TextEditingController();

  Widget searchBarWidgets() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: TextFormField(
            style: const TextStyle(fontSize: 17, color: Colors.blue),
            controller: searchController,
            decoration: InputDecoration(
              labelText: 'by Role Or Type'.tr,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              counterText: '',
            ),
            onEditingComplete: () {
              setState(() {
                _searchQuery = searchController.text.trim();
                _updateDisplayedUsers();
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
                      child: Text(state == true ? "Approve".tr : "Decline".tr),
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
            (user['role']
                    .toString()
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase()) ||
                user['type']
                    .toString()
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase())) &&
            (_selectedVerfied == null ||
                user['isAccepted'] == _selectedVerfied))
        .toList();

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
        .collection('wallet')
        .orderBy("date", descending: true)
        .get();
    ("Number of documents fetched: ${snapshot.docs.length}");
    _allUsers = snapshot.docs;
    _updateDisplayedUsers(); // Initial display of users
  }

  @override
  Widget build(BuildContext context) {
    var columns = [
      DataColumn(label: textofTableTitle('No'.tr)),
      DataColumn(label: textofTableTitle('id'.tr)),
      DataColumn(label: textofTableTitle('Role'.tr)),
      DataColumn(label: textofTableTitle('Type'.tr)),
      DataColumn(label: textofTableTitle('phone Number'.tr)),
      DataColumn(label: textofTableTitle('time'.tr)),
      // DataColumn(label: textofTableTitle('date'.tr)),
      DataColumn(label: textofTableTitle('bankily Number'.tr)),
      DataColumn(label: textofTableTitle('balance'.tr)),
      DataColumn(label: textofTableTitle('Transaction Image'.tr)),
      DataColumn(label: textofTableTitle('Status'.tr)),

      DataColumn(label: textofTableTitle('Action'.tr)),
      DataColumn(label: textofTableTitle('more Details'.tr)),

      // DataColumn(label: Text('Actions')),
    ];

    final verticalScrollController = ScrollController();
    final horizontalScrollController = ScrollController();

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('wallet').snapshots(),
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
                    "Show Wallet Request".tr,
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
                                return DataRow(cells: [
                                  DataCell(Text(((_currentPage - 1) *
                                              _itemsPerPage +
                                          _displayedUsers.indexOf(customer) +
                                          1)
                                      .toString())),
                                  DataCell(CustomText(
                                    text: customer['id'] ?? 'N/A',
                                  )),
                                  DataCell(CustomText(
                                    text: customer['role'] ?? 'N/A',
                                  )),
                                  DataCell(CustomText(
                                    text: customer['type'] ?? 'N/A',
                                  )),
                                  DataCell(CustomText(
                                    text: customer['pyPayCode'] ?? 'N/A',
                                  )),
                                  DataCell(CustomText(
                                    text: customer['time'] ?? 'N/A',
                                  )),
                                  // DataCell(CustomText(
                                  //   text: customer['date'] ?? 'N/A',
                                  // )),
                                  DataCell(CustomText(
                                    text: customer['bankilyNumber'] ?? 'N/A',
                                  )),
                                  DataCell(Directionality(
                                      textDirection: TextDirection.ltr,
                                      child: CustomText(
                                        text: customer['balance'] ?? 'N/A',
                                      ))),
                                  DataCell(
                                    IconButton(
                                      icon: const Icon(Icons.edit_document,
                                          color: Colors.green),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            // String imageUrl = _displayedUsers['image']?.toString() ?? '';
                                            return AlertDialog(
                                              content: SingleChildScrollView(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              content: customer[
                                                                          'image'] !=
                                                                      null
                                                                  ? Image
                                                                      .network(
                                                                      customer[
                                                                          'image'],
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      loadingBuilder: (BuildContext context,
                                                                          Widget
                                                                              child,
                                                                          ImageChunkEvent?
                                                                              loadingProgress) {
                                                                        if (loadingProgress ==
                                                                            null) {
                                                                          return child;
                                                                        }
                                                                        return Center(
                                                                          child:
                                                                              CircularProgressIndicator(
                                                                            value: loadingProgress.expectedTotalBytes != null
                                                                                ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                                                                                : null,
                                                                          ),
                                                                        );
                                                                      },
                                                                      errorBuilder: (context,
                                                                          error,
                                                                          stackTrace) {
                                                                        return const Icon(
                                                                            Icons.warning_amber);
                                                                      },
                                                                    )
                                                                  : Text(
                                                                      'Image not exist'
                                                                          .tr,
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              28),
                                                                    ),
                                                            );
                                                          },
                                                        );
                                                      },
                                                      child: customer[
                                                                  'image'] !=
                                                              null
                                                          ? Image.network(
                                                              customer['image'],
                                                              height: 300,
                                                              width: 300,
                                                              fit: BoxFit.cover,
                                                              loadingBuilder:
                                                                  (BuildContext
                                                                          context,
                                                                      Widget
                                                                          child,
                                                                      ImageChunkEvent?
                                                                          loadingProgress) {
                                                                if (loadingProgress ==
                                                                    null) {
                                                                  return child;
                                                                }
                                                                return Center(
                                                                  child:
                                                                      CircularProgressIndicator(
                                                                    value: loadingProgress.expectedTotalBytes !=
                                                                            null
                                                                        ? loadingProgress.cumulativeBytesLoaded /
                                                                            (loadingProgress.expectedTotalBytes ??
                                                                                1)
                                                                        : null,
                                                                  ),
                                                                );
                                                              },
                                                              errorBuilder:
                                                                  (context,
                                                                      error,
                                                                      stackTrace) {
                                                                return const Icon(
                                                                    Icons
                                                                        .warning_amber);
                                                              },
                                                            )
                                                          : Text(
                                                              'Image not exist'
                                                                  .tr,
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          28),
                                                            ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                  DataCell(Container(
                                    height: 30,
                                    //  width: 100,
                                    width: double.infinity,
                                    padding: const EdgeInsets.only(top: 3),

                                    decoration: BoxDecoration(
                                        color: customer['isAccepted'] == true
                                            ? Colors.green
                                            : Colors.red,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Center(
                                      child: Text(
                                        customer['isAccepted']
                                            ? '  Approve  '.tr
                                            : '  Decline  '.tr,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ),
                                  )),
                                  DataCell(Row(
                                    children: [
                                      if (customer['done'] == true)
                                        const Text(
                                          "  ",
                                        ),
                                      if (customer['done'] == false)
                                        IconButton(
                                            onPressed: () {
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                builder: (context) {
                                                  return ApproveMoneyTransformation(
                                                    walletID: customer.id,
                                                    customer: customer.data(),
                                                    //  isTakeAction: isTakeAction,
                                                  );
                                                },
                                              ));
                                            },
                                            icon: const Icon(
                                                Icons.verified_outlined))
                                    ],
                                  )),
                                  DataCell(Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                            Icons.remove_red_eye_outlined,
                                            color: Colors.blue),
                                        onPressed: () async {
                                  
                                          var userData = await FirebaseFirestore
                                              .instance
                                              .collection('users')
                                              .doc(customer.data()['id'])
                                              .get();
                                         var driverData =
                                              await FirebaseFirestore.instance
                                                  .collection('drivers')
                                                  .doc(customer.data()['id'])
                                                  .get();
                                      
 
                                          if (customer['role'] == "driver") {
                                       
                                            _driversMoreDetails(
                                                context,
                                                customer['role'] == 'driver'
                                                    ? "Driver".tr
                                                    : 'user'.tr,
                                                driverData.data()!['userName'],
                                                driverData
                                                    .data()!['phoneNumber'],
                                                customer['id']);
                                          }
                                      
                                          if (customer['role'] == "users") {
                                       
                                            _usersMoreDetails(
                                              context,
                                              customer['role'] == 'driver'
                                                  ? "Driver".tr
                                                  : 'user'.tr, 
                                                  userData.data()!['userName'],
                                                  userData.data()!['phoneNumber'],
                                                  customer['id']
                                                   
 
                                            );
                                          }
                                          //  user.data()['id']
                                          //  navigationController.navigateTo(ticketMessagesPageRoute);
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

void _driversMoreDetails(
  BuildContext context,
  String Role,
  String driverName,
  String driverphone,
  String driverID,
) {
 

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Row(
          children: [
            Text("Sender of the Request :".tr,
                style: const TextStyle(fontSize: 24, color: Colors.black)),
            Text(Role,
                style: const TextStyle(fontSize: 20, color: Colors.blue)),
          ],
        ),
        content: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text("Driver Name: ".tr,
                    style: const TextStyle(fontSize: 20, color: Colors.black)),
                Text(driverName,
                    style: const TextStyle(fontSize: 16, color: Colors.blue)),
              ],
            ),
            Row(
              children: [
                Text("driver Id: ".tr,
                    style: const TextStyle(fontSize: 20, color: Colors.black)),
                Text(driverID,
                    style: const TextStyle(fontSize: 16, color: Colors.blue)),
              ],
            ),
            Row(
              children: [
                Text("driver Phone Number: ".tr,
                    style: const TextStyle(fontSize: 20, color: Colors.black)),
                Text(driverphone,
                    style: const TextStyle(fontSize: 16, color: Colors.blue)),
              ],
            ),
          ],
        )),
        actions: <Widget>[
          TextButton(
            child: Text("Close".tr,
                style: const TextStyle(fontSize: 20)), // زيادة حجم الخط
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void _usersMoreDetails(
  BuildContext context,
  String Role,
  String userName,
  String userphone,
  String userID,
) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Row(
          children: [
            Text("Sender of the Request :".tr,
                style: const TextStyle(fontSize: 24, color: Colors.black)),
            Text(Role,
                style: const TextStyle(fontSize: 20, color: Colors.blue)),
          ],
        ),
        content: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text("User Name: ".tr,
                    style: const TextStyle(fontSize: 20, color: Colors.black)),
                Text(userName,
                    style: const TextStyle(fontSize: 16, color: Colors.blue)),
              ],
            ),
            Row(
              children: [
                Text(" User Phone Number: ".tr,
                    style: const TextStyle(fontSize: 20, color: Colors.black)),
                Text(userphone,
                    style: const TextStyle(fontSize: 16, color: Colors.blue)),
              ],
            ),
            Row(
              children: [
                Text("user Id ".tr,
                    style: const TextStyle(fontSize: 20, color: Colors.black)),
                Text(userID,
                    style: const TextStyle(fontSize: 16, color: Colors.blue)),
              ],
            ),
          ],
        )),
        actions: <Widget>[
          TextButton(
            child: Text("Close".tr,
                style: const TextStyle(fontSize: 20)), // زيادة حجم الخط
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
