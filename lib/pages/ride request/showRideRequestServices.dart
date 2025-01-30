import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:admin_dashboard/constants/controllers.dart';
import 'package:admin_dashboard/routing/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../../widgets/custom_text.dart';
import '../../constants/style.dart';

class RideRequestServicesWidgets extends StatefulWidget {
  const RideRequestServicesWidgets({super.key});

  @override
  State<RideRequestServicesWidgets> createState() => _ShowUsersTableState();
}

class _ShowUsersTableState extends State<RideRequestServicesWidgets> {
  // List<QueryDocumentSnapshot<Map<String, dynamic>>> _allUsers = [];
  // List<QueryDocumentSnapshot<Map<String, dynamic>>> _displayedUsers = [];
  List<DropdownMenuItem<String>> allItems = [];

  var searchController = TextEditingController();

  int _currentPage = 1;
  final int _itemsPerPage = 8;
  List<QueryDocumentSnapshot> _allUsers = [];
  List<QueryDocumentSnapshot> _displayedUsers = [];
  List<String> _services = [];
  String? _selectedgender;

  String _searchQuery = '';

  ////////////////////////////////////////////////////////'f
  void _updateDisplayedUsers() {
    ("Updating displayed users with search query: $_searchQuery");

    _displayedUsers = _allUsers
        .where((user) =>
            (user.id
                .toString()
                .toLowerCase()
                // user['userName']
                //       .toString()
                //       .toLowerCase()
                //       .contains(_searchQuery.toLowerCase()) ||
                //   user['driverName']
                //       .toString()
                //       .toLowerCase()
                .contains(_searchQuery.toLowerCase())) &&
            (_selectedgender == null || user['service'] == _selectedgender))
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

  void _fetchUsers() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('rideRequest')
        .orderBy('createdTime', descending: true)
        .get();
    ("Number of documents fetched: ${snapshot.docs.length}");
    _allUsers = snapshot.docs;

    // Get unique service names
    Set<String> uniqueServices = {};
    for (var doc in _allUsers) {
      uniqueServices.add(doc['service'].toString());
    }

    // Update service options for the dropdown
    setState(() {
      _services = uniqueServices.toList();
    });

    _updateDisplayedUsers(); // Initial display of users
  }

  @override
  void initState() {
    super.initState();
    _fetchUsers(); // Fetch users on initialization
  }

  Widget textofTableTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
          fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black54),
    );
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
              labelText: 'ride ID'.tr,
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
        const SizedBox(width: 20),
        Expanded(
          child: Row(
            children: [
              Text("Services :".tr),
              Material(
                child: DropdownButton<String>(
                  value: _selectedgender,
                  hint: const Text('Filter by services'),
                  onChanged: (value) {
                    setState(() {
                      _selectedgender = value;
                      _updateDisplayedUsers();
                    });
                  },
                  items: [
                    const DropdownMenuItem<String>(
                      value: null,
                      child: Text('All'),
                    ),
                    for (final service in _services)
                      DropdownMenuItem<String>(
                        value: service,
                        child: Text(service),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var columns = [
      DataColumn(label: textofTableTitle('No'.tr)),
      DataColumn(label: textofTableTitle('ride ID'.tr)),
      DataColumn(label: textofTableTitle('Rider'.tr)),
      DataColumn(label: textofTableTitle('Rider Phone'.tr)),
      DataColumn(label: textofTableTitle('Driver'.tr)),
      DataColumn(label: textofTableTitle('Driver Phone'.tr)),
      DataColumn(label: textofTableTitle('Enter Adress'.tr)),
      DataColumn(label: textofTableTitle('End Adress'.tr)),
      DataColumn(label: textofTableTitle('Distance'.tr)),
      DataColumn(label: textofTableTitle('Duration'.tr)),
      DataColumn(label: textofTableTitle('Cost'.tr)),
      DataColumn(label: textofTableTitle('service'.tr)),
      DataColumn(label: textofTableTitle('Status'.tr)),
      DataColumn(label: textofTableTitle('Remove Ride'.tr)),
      // DataColumn(label: Text('Action'.tr)),
    ];

    final verticalScrollController = ScrollController();
    final horizontalScrollController = ScrollController();

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('rideRequest').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          // Show error message in a dialog
          return Center(
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Error'.tr),
                      content: Text(snapshot.error.toString()),
                      actions: <Widget>[
                        TextButton(
                          child: Text('Close'.tr),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Show Error'.tr),
            ),
          );
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
              child: Text(
            'No Rides available'.tr,
            style: const TextStyle(fontSize: 30),
          ));
        }

        var users = snapshot.data!.docs;

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
                    "Show Ride Requests".tr,
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
                    width: 550,
                    child: searchBarWidgets(),
                  ),
                  // const Spacer(),
                  // SizedBox(
                  //   width: 90,
                  //   child: MaterialButton(
                  //     height: 45,
                  //     color: Colors.blue,
                  //     child: Text(
                  //       "New Booking".tr,
                  //       style: const TextStyle(
                  //           color: Colors.white,
                  //           fontWeight: FontWeight.bold,
                  //           fontSize: 20),
                  //     ),
                  //     onPressed: () {
                  //       navigationController.navigateTo(newBookingPageRoute);

                  //       //  Get.to(const NewBookingScreen());
                  //     },
                  //   ),
                  // ),
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
                              (user) {
                                // var user =
                                //     users[index].data() as Map<String, dynamic>;
                                // var userId = users[index];
                                // final lastLoginTimestamp =
                                //     user['lastlog'] as Timestamp;
                                // final formattedLastLogin =
                                //     DateFormat('MMM dd, yyyy hh:mm:ss a')
                                //         .format(lastLoginTimestamp.toDate());
                                return DataRow(cells: [
                                  DataCell(Text(
                                      ((_currentPage - 1) * _itemsPerPage +
                                              _displayedUsers.indexOf(user) +
                                              1)
                                          .toString())),
                                  DataCell(
                                    InkWell(
                                      onTap: () {
                                        Clipboard.setData(ClipboardData(
                                          text: user.id,
                                        ));
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
                                        CustomText(text: user.id),
                                      ]),
                                    ),
                                  ),
                                  DataCell(CustomText(
                                    text: user['userName'] ?? 'N/A',
                                  )),
                                  DataCell(
                                    InkWell(
                                      onTap: () {
                                        Clipboard.setData(ClipboardData(
                                            text: user['userPhoneNumber']));
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
                                          text:
                                              user['userPhoneNumber'] ?? 'N/A',
                                        ),
                                      ]),
                                    ),
                                  ),
                                  DataCell(CustomText(
                                    text: user['driverName'] ?? 'N/A',
                                  )),
                                  DataCell(
                                    InkWell(
                                      onTap: () {
                                        Clipboard.setData(ClipboardData(
                                            text: user['driverPhoneNumber']));
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
                                          text: user['driverPhoneNumber'] ??
                                              'N/A',
                                        ),
                                      ]),
                                    ),
                                  ),
                                  DataCell(SizedBox(
                                    width: 170,
                                    child: TextButton(
                                      child: Text(
                                        user['endAddress'] ?? 'N/A',
                                        style: const TextStyle(
                                            color: Colors.black),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text('Full Address'),
                                              content: SingleChildScrollView(
                                                child: Text(
                                                    user['endAddress'] ??
                                                        'N/A'),
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: const Text('Close'),
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
                                    // TextButton(
                                    //   child: Text(user['endAddress'] ?? 'N/A', style: TextStyle(color: Colors.black),
                                    //     maxLines: 2,
                                    //     overflow: TextOverflow.ellipsis,),
                                    //   onPressed: () =>
                                    //       //Center(child: AlertDialog( title: Text(user['endAddress'] ?? 'N/A'),)),
                                    //
                                    //
                                    //
                                    // ),
                                  )),
                                  DataCell(SizedBox(
                                    width: 170,
                                    child: TextButton(
                                      child: Text(
                                        user['startAddress'] ?? 'N/A',
                                        style: const TextStyle(
                                            color: Colors.black),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text('Full Address'),
                                              content: SingleChildScrollView(
                                                child: Text(
                                                    user['startAddress'] ??
                                                        'N/A'),
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: const Text('Close'),
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
                                    // TextButton(
                                    //   child: Text(user['startAddress'] ?? 'N/A', style: TextStyle(color: Colors.black),
                                    //     maxLines: 2,
                                    //     overflow: TextOverflow.ellipsis,),
                                    //   onPressed: () =>
                                    //       //Center(child: AlertDialog( title: Text(user['startAddress'] ?? 'N/A'),)),
                                    //
                                    //
                                    //
                                    // ),
                                  )),
                                  DataCell(Directionality(
                                      textDirection: TextDirection.ltr,
                                      child: CustomText(
                                        text: user['distance'] ?? 'N/A',
                                      ))),
                                  DataCell(Directionality(
                                      textDirection: TextDirection.ltr,
                                      child: CustomText(
                                        text: user['duration'] ?? 'N/A',
                                      ))),
                                  DataCell(Directionality(
                                      textDirection: TextDirection.ltr,
                                      child: CustomText(
                                        text: user['cost'] ?? 'N/A',
                                      ))),
                                  DataCell(Container(
                                    height: 30,
                                    //  width: 100,
                                    width: double.infinity,
                                    padding: const EdgeInsets.only(top: 3),

                                    decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Center(
                                      child: Text(
                                        " ${user['service'] ?? 'N/A'} ",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ),
                                  )),
                                  DataCell(Container(
                                    height: 30,
                                    //  width: 100,
                                    width: double.infinity,

                                    padding: const EdgeInsets.only(top: 3),

                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Center(
                                        child: Text(
                                            " ${user['state']} " ?? 'N/A',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white))),
                                  )),
                                  DataCell(Row(
                                    children: [
                                      // IconButton(
                                      //   icon:
                                      //         Icon(Icons.remove_red_eye_outlined),
                                      //   onPressed: () {
                                      //     // View user details
                                      //     Navigator.push(
                                      //       context,
                                      //       MaterialPageRoute(
                                      //         builder: (context) =>
                                      //             EditRideRequest(
                                      //               driversId: userId.id,
                                      //         ),
                                      //       ),
                                      //     );
                                      //   },
                                      // ),
                                      // IconButton(
                                      //   icon: Icon(Icons.edit_note_rounded),
                                      //   onPressed: () {
                                      //     // View user details
                                      //     Navigator.push(
                                      //       context,
                                      //       MaterialPageRoute(
                                      //         builder: (context) =>
                                      //             EditRideRequest(
                                      //           driversId: user.id,
                                      //         ),
                                      //       ),
                                      //     );
                                      //   },
                                      // ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: () async {
                                          //  print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa ${user.id}");
                                          // AlertDialog(
                                          //   title: Text(
                                          //       "Are You Want To Exist This Ride"),
                                          //     actions: [

                                          //     ],
                                          // );

                                          Get.defaultDialog(
                                            // barrierDismissible: false,
                                            title: 'Confirm Exit'.trArgs(),
                                            middleText:
                                                'Are You Want To Exist This Ride'
                                                    .tr,
                                            textConfirm: 'YES'.tr,
                                            textCancel: 'no'.tr,
                                            onConfirm: () async {
                                              await FirebaseFirestore.instance
                                                  .collection('rideRequest')
                                                  .doc(user.id)
                                                  .delete();
                                              Get.back();
                                              navigationController.navigateTo(
                                                  showRidePageRoute);
                                            },
                                            onCancel: () {
                                              Get.back();
                                            },
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
