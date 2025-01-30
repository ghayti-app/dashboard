import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:admin_dashboard/constants/controllers.dart';
import 'package:admin_dashboard/routing/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
 import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../constants/style.dart';
import '../../../../widgets/custom_text.dart';

class ShowAdminsTable extends StatefulWidget {
  const ShowAdminsTable({super.key});

  @override
  State<ShowAdminsTable> createState() => _ClientsTableState();
}

class _ClientsTableState extends State<ShowAdminsTable> {
  Widget textofTableTitle(String text) {
    return Text(
      "     $text    ",
      style: const TextStyle(
          fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black54),
    );
  }

  List<QueryDocumentSnapshot<Map<String, dynamic>>> _allUsers = [];
  List<QueryDocumentSnapshot<Map<String, dynamic>>> _displayedUsers = [];

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
              labelText: 'Email'.tr,
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
      ],
    );
  }

  ////////////////////////////////////////////////////////
  void _updateDisplayedUsers() {
    _displayedUsers = _allUsers
        .where((user) => user['email']
            .toString()
            .toLowerCase()
            .contains(_searchQuery.toLowerCase()))
        .toList();

    ("Filtered users count: ${_displayedUsers.length}"); // Debugging: Check the count of filtered users

    // Pagination logic remains the same
    int startIndex = (_currentPage - 1) * _itemsPerPage;
    int endIndex = startIndex + _itemsPerPage;

    if (endIndex > _displayedUsers.length) {
      endIndex = _displayedUsers.length;
    }

    _displayedUsers = _displayedUsers.sublist(startIndex, endIndex);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _fetchUsers(); // Fetch users on initialization
  }

  void _fetchUsers() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('admins')
        .orderBy('lastLogin', descending: true)
        .get();
    _allUsers = snapshot.docs;
    _updateDisplayedUsers(); // Initial display of users
  }

  @override
  Widget build(BuildContext context) {
    var columns = [
      DataColumn(label: textofTableTitle('No'.tr)),
      DataColumn(label: textofTableTitle('User Name'.tr)),
      DataColumn(label: textofTableTitle('Email'.tr)),
      // DataColumn(label: textofTableTitle('Phone'.tr)),
      DataColumn(label: textofTableTitle('Last Login'.tr)),
      DataColumn(label: textofTableTitle('Action'.tr)),
      // DataColumn(label: Text('Actions')),
    ];

    final verticalScrollController = ScrollController();
    final horizontalScrollController = ScrollController();

    // return StreamBuilder<QuerySnapshot>(
    //   stream: FirebaseFirestore.instance.collection('admins').snapshots(),
    //   builder: (context, snapshot) {
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       return const Center(child: CircularProgressIndicator());
    //     }
    //     if (snapshot.hasError) {
    //       return Center(child: Text('Something went wrong'.tr));
    //     }
    //     if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
    //       return Center(child: Text('No clients available'.tr));
    //     }

    //     // var customers = snapshot.data!.docs;

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
                "show Admins".tr,
                style:
                    const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
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
                width: 300,
                child: searchBarWidgets(),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: AdaptiveScrollbar(
                underColor: Colors.blueGrey.withOpacity(0.3),
                sliderDefaultColor: active.withOpacity(0.7),
                sliderActiveColor: active,
                controller: verticalScrollController,
                child: SingleChildScrollView(
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
                                final lastLoginTimestamp =
                                    customer['lastLogin'] as Timestamp;
                                final formattedLastLogin =
                                    DateFormat('MMM dd, yyyy hh:mm:ss a')
                                        .format(lastLoginTimestamp.toDate());

                                return DataRow(cells: [
                                  DataCell(Text(
                                      "     ${((_currentPage - 1) * _itemsPerPage + _displayedUsers.indexOf(customer) + 1)}")),
                                  DataCell(CustomText(
                                    text: "      ${customer['username']} ",
                                  )),
                                  DataCell(CustomText(
                                    text: "      ${customer['email']} ",
                                  )),
                                  // DataCell(CustomText(
                                  //   text: "      ${customer['phone']} " ,
                                  // )),
                                  DataCell(
                                    Text(formattedLastLogin),
                                  ),
                                  DataCell(Row(
                                    children: [
                                      // IconButton(
                                      //   icon: const Icon(
                                      //     Icons.remove_red_eye_outlined,
                                      //     color: Colors.blue,
                                      //   ),
                                      //   onPressed: () {
                                      //     // Edit admin
                                      //     Navigator.push(
                                      //       context,
                                      //       MaterialPageRoute(
                                      //         builder: (context) =>
                                      //             EditAdminWidgets(
                                      //           adminId: customer.id,
                                      //         ),
                                      //       ),
                                      //     );
                                      //   },
                                      // ),
                                      if (customer['email'] !=
                                              "admin@ghayti.app" &&
                                          FirebaseAuth.instance.currentUser
                                                  ?.email ==
                                              "admin@ghayti.app")
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                         onPressed: () async {
  bool? confirmDelete = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirm Deletion'.tr),
        content: Text('Are you sure you want to delete this account?'.tr),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // Return false
            },
            child: Text('Cancel'.tr),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true); // Return true
            },
            child: Text('Delete'.tr),
          ),
        ],
      );
    },
  );

  if (confirmDelete == true) {
    await FirebaseFirestore.instance
        .collection('admins')
        .doc(customer.id)
        .delete();
                   // if (FirebaseAuth.instance
                                            //         .currentUser?.email ==
                                            //     "admin@ghayti.app") {
                                              // Initialize secondary app to delete from FirebaseAuth
                                              // FirebaseApp app =
                                              //     await Firebase.initializeApp(
                                              //         name: customer['username'].toString(),
                                              //         options: Firebase.app()
                                              //             .options);
                                              // List<String> signInMethods =
                                              //     await FirebaseAuth
                                              //             .instanceFor(app: app)
                                              //         .fetchSignInMethodsForEmail( customer.id
                                              //           //  customer['email']
                                              //             );
                                              // if (signInMethods.isNotEmpty) {
                                              //   User? userToDelete =
                                              //       FirebaseAuth.instanceFor(
                                              //               app: app)
                                              //           .currentUser;
                                              //   if (userToDelete != null) {
                                              //     await userToDelete.delete();
                                              //   }
                                              // }

                                              // await app
                                              //     .delete(); // Ensure the secondary app is deleted

    String? adminId = FirebaseAuth.instance.currentUser?.uid;

    if (adminId != null) {
      await FirebaseFirestore.instance.collection('adminActions').add({
        'adminId': adminId,
        'adminEmail': FirebaseAuth.instance.currentUser?.email,
        'Name': customer['username'],
        'Id': customer.id,
        'newState': "active",
        'type': 'delete an Admin',
        'timestamp': FieldValue.serverTimestamp(),
      });
    } else {
     }

    navigationController.navigateTo(showAdminsPageRoute);
  }
}
                                       
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
                onPressed:
                    _currentPage < ((_allUsers.length / _itemsPerPage).ceil())
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
    //   },
    // );
  }
}
