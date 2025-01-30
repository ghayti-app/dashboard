import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:admin_dashboard/constants/controllers.dart';
import 'package:admin_dashboard/pages/ride%20request/ride_request_model.dart';
import 'package:admin_dashboard/pages/tickets/ticketsMessages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../constants/style.dart';
import '../../../../widgets/custom_text.dart';

class TicketsScreen extends StatefulWidget {
  int? indexPage;
  TicketsScreen({super.key, this.indexPage});

  @override
  State<TicketsScreen> createState() => _ShowUsersTableState();
}

class _ShowUsersTableState extends State<TicketsScreen> {
  Widget textofTableTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
          fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black54),
    );
  }

  String Active = "Active".tr; // State for the verification status
  final _firestore = FirebaseFirestore.instance;

  List<QueryDocumentSnapshot<Map<String, dynamic>>> _allUsers = [];
  List<QueryDocumentSnapshot<Map<String, dynamic>>> _displayedUsers = [];
  final List<String> state = ["open", "close"];
  final List<String> Role = ["driver", "rider"];
  String? _selectedstate;
  String? _selectedRole;
  String _searchQuery = '';
  int _currentPage = 1;
  final int _itemsPerPage = 8;

  var searchController = TextEditingController();

  void _updateVerificationStatus(newStatus, userid, phoneNumber) async {
    try {
      await _firestore.collection('supportTickets').doc(userid).update({
        'state': newStatus,
      });
      String? adminId = FirebaseAuth.instance.currentUser?.uid;

      if (adminId != null) {
        await _firestore.collection('adminActions').add({
          'adminId': adminId,
          'adminEmail': FirebaseAuth.instance.currentUser?.email,
          'Name': phoneNumber,
          'Id': userid,
          'newState': newStatus,
          'type': 'change Ticket State',
          'timestamp': FieldValue.serverTimestamp(),
        });
      } else {
        ('No admin is signed in.');
      }
      setState(() {
        // هنا يمكنك تحديث القيمة المحلية التي تمثل حالة التحقق من صحة الكupon
        // مثلاً: this.couponStatus = newStatus;

        newStatus != newStatus;
      });
    } catch (e) {
      ('Error updating  ttttttttttttttttttttttttttttttt verification status: $e'
          .tr);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Error updating aaaaaaaaaaaaaaaaaaaaaaaaaaaa verification status: $e'
                  .tr),
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
              labelText: 'Phone Number'.tr,
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
            textofTableTitle("status :".tr),
            Material(
              child: DropdownButton<String>(
                value: _selectedstate,
                hint: Text('Filter by Status'.tr),
                onChanged: (value) {
                  setState(() {
                    _selectedstate = value;
                    _updateDisplayedUsers();
                  });
                },
                items: [
                  DropdownMenuItem<String>(
                    value: null,
                    child: Text('All'.tr),
                  ),
                  ...state.map((rating) {
                    return DropdownMenuItem<String>(
                      value: rating, //.ceilToDouble(), //rating.toDouble(),

                      child: Text(rating.toString()),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(width: 50),
        Row(
          children: [
            textofTableTitle("Role :".tr),
            Material(
              child: DropdownButton<String>(
                value: _selectedRole,
                hint: Text('Filter by Role'.tr),
                onChanged: (value) {
                  setState(() {
                    _selectedRole = value;
                    _updateDisplayedUsers();
                  });
                },
                items: [
                  DropdownMenuItem<String>(
                    value: null,
                    child: Text('All'.tr),
                  ),
                  ...Role.map((role) {
                    return DropdownMenuItem<String>(
                      value: role, //.ceilToDouble(), //rating.toDouble(),

                      child: Text(role),
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
            user['phoneNumber']
                .toString()
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) &&
            (_selectedstate == null || user['state'] == _selectedstate) &&
            (_selectedRole == null || user['role'] == _selectedRole))
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
    final snapshot = await FirebaseFirestore.instance
        .collection('supportTickets')
        .orderBy("createdAt", descending: true)
        .get();
    ("Number of documents fetched: ${snapshot.docs.length}");
    _allUsers = snapshot.docs;
    _updateDisplayedUsers(); // Initial display of users
  }
  // void _updateVerificationStatus(String newStatus, userid) async {
  //   try {
  //     await _firestore.collection('coupons').doc(userid).update({
  //       'status': newStatus,
  //     });
  //     setState(() {
  //       Active = newStatus;
  //     });
  //   } catch (e) {
  //      ('Error updating verification status: $e'.tr);
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Error updating verification status: $e'.tr),
  //       ),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    var columns = [
      DataColumn(label: textofTableTitle('No'.tr)),
      DataColumn(label: textofTableTitle('Role'.tr)), //topic
      DataColumn(label: textofTableTitle('topic'.tr)), //topic
      DataColumn(label: textofTableTitle('ride Id'.tr)), //topic
      DataColumn(label: textofTableTitle('Phone Number'.tr)),
      DataColumn(label: textofTableTitle('created At'.tr)), //rideId
      DataColumn(label: textofTableTitle('State'.tr)),
      DataColumn(label: textofTableTitle('more Details'.tr)),
      DataColumn(label: textofTableTitle('Chat'.tr)),
    ];

    final verticalScrollController = ScrollController();
    final horizontalScrollController = ScrollController();

    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance.collection('supportTickets').snapshots(),
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
              child: Text('No Complains available'.tr,
                  style: const TextStyle(
                      color: Colors.red,
                      fontSize: 25,
                      fontWeight: FontWeight.bold)));
        }

        var users = snapshot.data!.docs;

        if (_searchQuery.isNotEmpty) {
          users = users
              .where((customer) => customer['phoneNumber']
                      .toString()
                      //  .replaceFirst("+", '')
                      .toLowerCase()
                      .contains(_searchQuery.toLowerCase())
                  //     ||
                  // customer['status']
                  //     .toString()
                  //     .toLowerCase()
                  //     .contains(_searchQuery.toLowerCase())
                  )
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
                    "ticket".tr,
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
                    width: 700,
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
                              (user) {
                                // var user =
                                //     users[index].data() as Map<String, dynamic>;
                                // var userId = users[index].id;
                                final lastLoginTimestamp =
                                    user['createdAt'] as Timestamp;
                                final formattedLastLogin =
                                    DateFormat('MMM dd, yyyy hh:mm:ss a')
                                        .format(lastLoginTimestamp.toDate());
                                ("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa${user['createdAt']}");
                                return DataRow(cells: [
                                  DataCell(Text(
                                      ((_currentPage - 1) * _itemsPerPage +
                                              _displayedUsers.indexOf(user) +
                                              1)
                                          .toString())),
                                  DataCell(CustomText(
                                    text: user['role'] ?? 'N/A',
                                  )),
                                  DataCell(CustomText(
                                    text: user['topic'] ?? 'N/A',
                                  )),
                                  DataCell(CustomText(
                                    text: user['rideId'] ?? 'N/A',
                                  )),
                                  DataCell(
                                    //   CustomText(
                                    //   text: user['phoneNumber'] ?? 'N/A',
                                    // )

                                    InkWell(
                                      onTap: () {
                                        Clipboard.setData(ClipboardData(
                                            text: user[
                                                'phoneNumber'])); // نسخ النص إلى الحافظة
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
                                          text: user['phoneNumber'] ?? 'N/A',
                                        ),
                                      ]),
                                    ),
                                  ),
                                  DataCell(CustomText(
                                    text: formattedLastLogin,
                                  )),
                                  DataCell(
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        if (user.data()['state'] == "open")
                                          DropdownButton<String>(
                                            value: user['state'].toString(),
                                            items: [
                                              DropdownMenuItem(
                                                value: "open",
                                                child: Row(
                                                  children: [
                                                    const Icon(Icons.verified,
                                                        color: Colors.green),
                                                    const SizedBox(width: 10),
                                                    Text(
                                                      "open".tr,
                                                      style: const TextStyle(
                                                          color: Colors.green),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              DropdownMenuItem(
                                                value: "close",
                                                child: Row(
                                                  children: [
                                                    const Icon(Icons.close,
                                                        color: Colors.red),
                                                    const SizedBox(width: 10),
                                                    Text("close".tr,
                                                        style: const TextStyle(
                                                            color: Colors.red)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                            onChanged: (value) {
                                              setState(() {
                                                ////////////////////////////////////////////////////////////////////////////////
                                                // var user =
                                                // users[index].data() as Map<String, dynamic>;
                                                //   user['status'] = value.toString();

                                                user.data()['state'] =
                                                    value!.toString();
                                                _updateVerificationStatus(
                                                    value,
                                                    user.id,
                                                    user['phoneNumber']);

                                                ////////////////////////////////////////////////////////////////////////////////
                                              });
                                              navigationController
                                                  .navigateToSupportview(
                                                      index: _currentPage);
                                            },
                                          ),
                                        if (user.data()['state'] == "close")
                                          Text(
                                            "completed".tr,
                                            style: const TextStyle(
                                                color: Colors.red),
                                          )
                                      ],
                                    ),
                                  ),
                                  DataCell(Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                            Icons.remove_red_eye_outlined,
                                            color: Colors.blue),
                                        onPressed: () async {
                                         
                                          var data = await FirebaseFirestore
                                              .instance
                                              .collection('rideRequest')
                                              .doc(user.data()['rideId'])
                                              .get();

                                          _showUserDetailsDialog(
                                              context,
                                              user['role'] == 'driver'
                                                  ? "Driver".tr
                                                  : 'user'.tr,
                                              RideRequestModel.fromMap(
                                                  data.data()
                                                      as Map<String, dynamic>));
                                          //  user.data()['id']
                                          //  navigationController.navigateTo(ticketMessagesPageRoute);
                                        },
                                      ),
                                    ],
                                  )),
                                  DataCell(Row(
                                    children: [
                                      //   if (user.data()['state'] == "open")
                                      IconButton(
                                        icon: const Icon(Icons.chat,
                                            color: Colors.blue),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ShowMessages(
                                                          state: user['state'],
                                                          role: user['role'],
                                                          ticketId: user.id,
                                                          phone: user[
                                                              "phoneNumber"],
                                                          userid: user["id"])));
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

void _showUserDetailsDialog(
  BuildContext context,
  String Role,
  RideRequestModel rideRequestModel,
) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Row(
          children: [
            Text("Sender of the complaint :".tr,
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
                Text(rideRequestModel.driverName,
                    style: const TextStyle(fontSize: 16, color: Colors.blue)),
              ],
            ),
            // Row(
            //   children: [
            //     Text("driver Id: ".tr,
            //         style: const TextStyle(fontSize: 20, color: Colors.black)),
            //     Text(rideRequestModel.driverId,
            //         style: const TextStyle(fontSize: 16, color: Colors.blue)),
            //   ],
            // ),
            Row(
              children: [
                Text("driver Phone Number: ".tr,
                    style: const TextStyle(fontSize: 20, color: Colors.black)),
                Text(rideRequestModel.driverPhoneNumber,
                    style: const TextStyle(fontSize: 16, color: Colors.blue)),
              ],
            ),
            Row(
              children: [
                Text("User Name: ".tr,
                    style: const TextStyle(fontSize: 20, color: Colors.black)),
                Text(rideRequestModel.userName,
                    style: const TextStyle(fontSize: 16, color: Colors.blue)),
              ],
            ),
            Row(
              children: [
                Text(" User Phone Number: ".tr,
                    style: const TextStyle(fontSize: 20, color: Colors.black)),
                Text(rideRequestModel.userPhoneNumber,
                    style: const TextStyle(fontSize: 16, color: Colors.blue)),
              ],
            ),
            Row(
              children: [
                Text("Service: ".tr,
                    style: const TextStyle(fontSize: 20, color: Colors.black)),
                Text(rideRequestModel.service,
                    style: const TextStyle(fontSize: 16, color: Colors.blue)),
              ],
            ),
            Row(
              children: [
                Text("Canceled By: ".tr,
                    style: const TextStyle(fontSize: 20, color: Colors.black)),
                Text(rideRequestModel.canceledBy,
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
