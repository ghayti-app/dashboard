import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:admin_dashboard/pages/services/date_format.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
 
import '../../../../constants/style.dart';
import '../../../../widgets/custom_text.dart';

class ShowUsersTable extends StatefulWidget {
  const ShowUsersTable({super.key});

  @override
  State<ShowUsersTable> createState() => _ClientsTableState();
}

class _ClientsTableState extends State<ShowUsersTable> {
  Widget textofTableTitle(String text) {
    return Text(
      "  $text  ",
      style: const TextStyle(
          fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black54),
    );
  }

  List<QueryDocumentSnapshot<Map<String, dynamic>>> _allUsers = [];
  List<QueryDocumentSnapshot<Map<String, dynamic>>> _displayedUsers = [];
  final List<double> _ratingOptions = [0, 1, 2, 3, 4, 5];
  double? _selectedRating;
  String _searchQuery = '';
  int _currentPage = 1;
  final int _itemsPerPage = 8;

  var searchController = TextEditingController();

  Widget searchBarWidgets() {
    return Row(
      children: [
        Expanded(
          flex: 3,
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
                _updateDisplayedUsers(); // Update displayed users after search
              });
            },
          ),
        ),
        //  const SizedBox(width: 10),
        const Spacer(),
        Row(
          children: [
            Text("Rate :".tr),
            Material(
              child: DropdownButton<double>(
                value: _selectedRating,
                hint: const Text('Filter by Rating'),
                onChanged: (value) {
                  setState(() {
                    _selectedRating = value;
                    _updateDisplayedUsers();
                  });
                },
                items: [
                  DropdownMenuItem<double>(
                    value: null,
                    child: Text('All'.tr),
                  ),
                  ..._ratingOptions.map((rating) {
                    return DropdownMenuItem<double>(
                      value: rating, //.ceilToDouble(), //rating.toDouble(),

                      child: Text(rating.toString()),
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
            (_selectedRating == null ||
                (user['rating'].toDouble() >= _selectedRating &&
                    user['rating'].toDouble() < _selectedRating! + 1)))
        // (_selectedRating == null || user['rating'] == _selectedRating))
        .toList();
    ("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" "$_selectedRating");

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
    _fetchUsers(); // Fetch users on initialization
  }

  void _fetchUsers() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .orderBy('createTime', descending: true)
        .get();
    ("Number of documents fetched: ${snapshot.docs.length}");
    _allUsers = snapshot.docs;
    _updateDisplayedUsers(); // Initial display of users
  }

  @override
  Widget build(BuildContext context) {
    var columns = [
      DataColumn(label: textofTableTitle('No'.tr)),
      DataColumn(label: textofTableTitle('User Name'.tr)),
      DataColumn(label: textofTableTitle('Balance'.tr)),
      // DataColumn(label: textofTableTitle('Phone'.tr)),
      DataColumn(label: textofTableTitle('Rating'.tr)),
      DataColumn(label: textofTableTitle('Phone Number'.tr)),
      DataColumn(label: textofTableTitle('Account Status'.tr)),

      DataColumn(label: textofTableTitle('Action'.tr)),

      // DataColumn(label: Text('Actions')),
    ];

    final verticalScrollController = ScrollController();
    final horizontalScrollController = ScrollController();

    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
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

          // if (_searchQuery.isNotEmpty) {
          //   customers = customers
          //       .where((customer) => customer['userName']
          //           .toString()
          //           .toLowerCase()
          //           .contains(_searchQuery.toLowerCase()))
          //       .toList();
          // }

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
                      "show Riders".tr,
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
                        width: 25.0,
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
                                    return DataRow(cells: [
                                      DataCell(Text(
                                          '      ${((_currentPage - 1) * _itemsPerPage + _displayedUsers.indexOf(user) + 1).toString()}')),
                                      DataCell(CustomText(
                                        text: "      ${user['userName']}  " ??
                                            'N/A',
                                      )),
                                      DataCell(CustomText(
                                        text:
                                            "      ${user['balance']}  " ?? 'N/A',
                                      )),
                                      DataCell(  Directionality( textDirection: TextDirection.ltr,
                                                            child:CustomText(
                                        text: "      ${user['rating']}  ",
                                      ))),
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
                                              "Phone number copied to clipboard"
                                                  .tr,
                                              snackPosition: SnackPosition.TOP,
                                              backgroundColor: Colors.blue[300],
                                              duration:
                                                  const Duration(seconds: 2),
                                            );
                                          },
                                          child: Row(children: [
                                            CustomText(
                                              text: user['phoneNumber'] ?? 'N/A',
                                            ),
                                          ]),
                                        ),
                                      ),
                                      DataCell(Container(
                                        height: 30,
                                        //  width: 100,
                                        width: double.infinity,
                                        padding: const EdgeInsets.only(top: 3),
                  
                                        decoration: BoxDecoration(
                                            color: user['isDeleted'] == false
                                                ? Colors.green
                                                : Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Center(
                                          child: Text(
                                            " ${user['isDeleted'] == true ? "Deleted".tr : "Exist".tr ?? 'N/A'} ",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ),
                                      )),
                                      DataCell(Row(children: [
                                        IconButton(
                                          icon: const Icon(
                                              Icons.remove_red_eye_outlined),
                                          onPressed: () {
                                            _showUserDetailsDialog(
                                              context,
                                              user['userName'],
                                              user['rating'],
                                              user['phoneNumber'],
                                              user['role'],
                                              user['state'],
                                              user['createTime'],
                                              user['lastLogin'],
                                              user['balance'],
                                              user['totalRides'],
                                            );
                                          },
                                        ),
                                        // IconButton(
                                        //     onPressed: () {
                                        //       Navigator.push(context,
                                        //           MaterialPageRoute(
                                        //         builder: (context) {
                                        //           return EditUsersWidgets(
                                        //               UsersId: user.id);
                                        //         },
                                        //       ));
                                        //     },
                                        //     icon: const Icon(Icons.edit_outlined))
                                      ]))
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
                const SizedBox(height: 20),
                // Pagination
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
        });
  }
}

void _showUserDetailsDialog(
  BuildContext context,
  String userName,
  double rating,
  String phoneNumber,
  String role,
  String state,
  Timestamp createTime,
  Timestamp lastLogin,
  double balance,
  int totalRide,
) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Row(
          children: [
            Text("User Name: ".tr,
                style: const TextStyle(fontSize: 24, color: Colors.black)),
            Text(userName,
                style: const TextStyle(fontSize: 20, color: Colors.blue)),
          ],
        ),
        content: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text("Rating: ".tr,
                    style: const TextStyle(fontSize: 20, color: Colors.black)),
                Text("$rating",
                    style: const TextStyle(fontSize: 16, color: Colors.blue)),
              ],
            ),
            Row(
              children: [
                Text("Phone Number: ".tr,
                    style: const TextStyle(fontSize: 20, color: Colors.black)),
                Text(phoneNumber,
                    style: const TextStyle(fontSize: 16, color: Colors.blue)),
              ],
            ),
            Row(
              children: [
                Text("Role: ".tr,
                    style: const TextStyle(fontSize: 20, color: Colors.black)),
                Text(role,
                    style: const TextStyle(fontSize: 16, color: Colors.blue)),
              ],
            ),
            Row(
              children: [
                Text("State: ".tr.tr,
                    style: const TextStyle(fontSize: 20, color: Colors.black)),
                Text(state,
                    style: const TextStyle(fontSize: 16, color: Colors.blue)),
              ],
            ),
            Row(
              children: [
                Text("Create Time: ".tr,
                    style: const TextStyle(fontSize: 20, color: Colors.black)),
                Text(
                    aa
                        .format(createTime.toDate()),
                    style: const TextStyle(fontSize: 16, color: Colors.blue)),
              ],
            ),
            Row(
              children: [
                Text("Last Login: ".tr,
                    style: const TextStyle(fontSize: 20, color: Colors.black)),
                Text(
                    aa
                        .format(lastLogin.toDate()),
                    style: const TextStyle(fontSize: 16, color: Colors.blue)),
              ],
            ),
            Row(
              children: [
                Text("Balance: ".tr,
                    style: const TextStyle(fontSize: 20, color: Colors.black)),
                Text(balance.toString(),
                    style: const TextStyle(fontSize: 16, color: Colors.blue)),
              ],
            ),
            Row(
              children: [
                Text("Total Ride: ".tr,
                    style: const TextStyle(fontSize: 20, color: Colors.black)),
                Text("$totalRide",
                    style: const TextStyle(fontSize: 16, color: Colors.blue)),
              ],
            )
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
