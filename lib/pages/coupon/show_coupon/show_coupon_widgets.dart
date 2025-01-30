import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:admin_dashboard/constants/controllers.dart';
 import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/style.dart';
import '../../../../widgets/custom_text.dart';

class ShowCouponWidgets extends StatefulWidget {
  int ? indexPage;    ShowCouponWidgets({super.key, this. indexPage});

  @override
  State<ShowCouponWidgets> createState() => _ShowUsersTableState();
}

class _ShowUsersTableState extends State<ShowCouponWidgets> {
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
  final List<String> gender = ["Active", "Expire"];
  String? _selectedgender;
  String _searchQuery = '';
  int _currentPage = 1;
  final int _itemsPerPage =8;

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
              labelText: 'code'.tr,
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
            Text("status :".tr),
            Material(
              child: DropdownButton<String>(
                value: _selectedgender,
                hint: Text('Filter by Status'.tr),
                onChanged: (value) {
                  setState(() {
                    _selectedgender =
                        value ;
                    _updateDisplayedUsers();
                  });
                },
                items: [
                  DropdownMenuItem<String>(
                    value: null,
                    child: Text('All'.tr),
                  ),
                  ...gender.map((rating) {
                    return DropdownMenuItem<String>(
                      value: rating , //.ceilToDouble(), //rating.toDouble(),

                      child: Text(rating.toString()== "Active" ? "Active".tr : "Expire".tr),
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
            user['code']
                .toString()
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) &&
            (_selectedgender == null || user['status'] == _selectedgender))
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
        await FirebaseFirestore.instance.collection('coupons').orderBy('createdDate', descending: true).get();
    ("Number of documents fetched: ${snapshot.docs.length}");
    _allUsers = snapshot.docs;
    _updateDisplayedUsers(); // Initial display of users
  }

  void _updateVerificationStatus(newStatus, userid, couponName) async {
    try {
      await _firestore.collection('coupons').doc(userid).update({
        'status': newStatus,
      });

      String? adminId = FirebaseAuth.instance.currentUser?.uid;

      if (adminId != null) {
        await _firestore.collection('adminActions').add({
          'adminId': adminId,
          'adminEmail': FirebaseAuth.instance.currentUser?.email,
          'Name': couponName,
          'Id': userid,
          'newState': newStatus,
          'type': 'change Coupon State',
          'timestamp': FieldValue.serverTimestamp(),
        });
      } else {}
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

  @override
  Widget build(BuildContext context) {
    var columns = [
      DataColumn(label: textofTableTitle('No'.tr)),
      DataColumn(label: textofTableTitle('code'.tr)),
      DataColumn(label: textofTableTitle('title'.tr)),
      DataColumn(label: textofTableTitle('start Date'.tr)),
      DataColumn(label: textofTableTitle('end Date'.tr)),
      DataColumn(label: textofTableTitle('Status'.tr)),
      DataColumn(label: textofTableTitle('Action'.tr)),
    ];

    final verticalScrollController = ScrollController();
    final horizontalScrollController = ScrollController();

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('coupons').snapshots(),
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
              child: Text('No clients available'.tr,
                  style: const TextStyle(
                      color: Colors.red,
                      fontSize: 25,
                      fontWeight: FontWeight.bold)));
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
                    "show Coupons".tr,
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
                              (user) {
                                //  var user =
                                //     users.data() as Map<String, dynamic>;
                                // var userId = users[index].id;

                                return DataRow(cells: [
                                  DataCell(Text(
                                      ((_currentPage - 1) * _itemsPerPage +
                                              _displayedUsers.indexOf(user) +
                                              1)
                                          .toString())),
                                  DataCell(CustomText(
                                    text: user['code'] ?? 'N/A',
                                  )),
                                  DataCell(CustomText(
                                    text: user['title'] ?? 'N/A',
                                  )),
                                  DataCell(CustomText(
                                    text: user['startDate'] ?? 'N/A',
                                  )),
                                  DataCell(CustomText(
                                    text: user['endDate'] ?? 'N/A',
                                  )),
                                  DataCell(
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        DropdownButton<String>(
                                          value: user['status'].toString(),
                                          items: [
                                            DropdownMenuItem(
                                              value: "Active",
                                              child: Row(
                                                children: [
                                                  const Icon(Icons.verified,
                                                      color: Colors.green),
                                                  const SizedBox(width: 10),
                                                  Text(
                                                    "Active".tr,
                                                    style: const TextStyle(
                                                        color: Colors.green),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            DropdownMenuItem(
                                              value: "Expire",
                                              child: Row(
                                                children: [
                                                  const Icon(Icons.close,
                                                      color: Colors.red),
                                                  const SizedBox(width: 10),
                                                  Text("Expire".tr,
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

                                              user.data()['status'] =
                                                  value!.toString();
                                              _updateVerificationStatus(
                                                  value, user.id, user['code']);

                                              ////////////////////////////////////////////////////////////////////////////////
                                            });
                                            navigationController.navigateToCouponview(
                                                   index: _currentPage);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  DataCell(Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                            Icons.remove_red_eye_outlined,
                                            color: Colors.blue),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title:
                                                    Text('Coupon Details'.tr),
                                                content: SingleChildScrollView(
                                                  child: Column(
                                                    children: [
                                                      ListTile(
                                                        title: Text('Code'.tr),
                                                        trailing: CustomText(
                                                            text: user['code']),
                                                      ),
                                                      ListTile(
                                                        title: Text('Title'.tr),
                                                        trailing: CustomText(
                                                            text:
                                                                user['title']),
                                                      ),
                                                      ListTile(
                                                        title: Text(
                                                            'Service ID Discount'
                                                                .tr),
                                                        trailing: CustomText(
                                                            text: user[
                                                                'serviceIdDiscount']),
                                                      ),
                                                      ListTile(
                                                        title: Text(
                                                            'Usage Limit Per Person'
                                                                .tr),
                                                        trailing: CustomText(
                                                            text: user[
                                                                    'usageLimitPerPerson']
                                                                .toString()),
                                                      ),
                                                      ListTile(
                                                        title: Text(
                                                            'Total Usage Limit'
                                                                .tr),
                                                        trailing: CustomText(
                                                            text: user[
                                                                    'totalUsageLimit']
                                                                .toString()),
                                                      ),
                                                      ListTile(
                                                        title: Text(
                                                            'Discount Amount'
                                                                .tr),
                                                        trailing: CustomText(
                                                            text: user[
                                                                    'discountAmount']
                                                                .toString()),
                                                      ),
                                                      ListTile(
                                                        title: Text(
                                                            'Created Date'.tr),
                                                        trailing: CustomText(
                                                            text: user[
                                                                'createdDate']),
                                                      ),
                                                      ListTile(
                                                        title: Text(
                                                            'Total Actual Used'
                                                                .tr),
                                                        trailing: CustomText(
                                                            text: user[
                                                                    'totalActualUsed']
                                                                .toString()),
                                                      ),
                                                      ListTile(
                                                        title: Text(
                                                            'Start Date'.tr),
                                                        trailing: CustomText(
                                                            text: user[
                                                                'startDate']),
                                                      ),
                                                      ListTile(
                                                        title:
                                                            Text('End Date'.tr),
                                                        trailing: CustomText(
                                                            text: user[
                                                                'endDate']),
                                                      ),
                                                      ListTile(
                                                        title: Text(
                                                            'Minimum Discount'
                                                                .tr),
                                                        trailing: CustomText(
                                                            text: user[
                                                                    'minimumDiscount']
                                                                .toString()),
                                                      ),
                                                      ListTile(
                                                        title: Text(
                                                            'Coupon Type'.tr),
                                                        trailing: CustomText(
                                                            text: user[
                                                                'couponType']),
                                                      ),
                                                      ListTile(
                                                        title:
                                                            Text('Status'.tr),
                                                        trailing: CustomText(
                                                            text:
                                                                user['status']),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () => Navigator.pop(
                                                        context), // Close dialog
                                                    child: Text('Close'.tr),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                      ),
                                      // IconButton(
                                      //   icon: const Icon(
                                      //     Icons.delete,
                                      //     color: Colors.red,
                                      //   ),
                                      //   onPressed: () {
                                      //     // Delete user
                                      //     FirebaseFirestore.instance
                                      //         .collection('rideRequest')
                                      //         .doc(user.id)
                                      //         .delete();
                                      //   },
                                      // ),
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
