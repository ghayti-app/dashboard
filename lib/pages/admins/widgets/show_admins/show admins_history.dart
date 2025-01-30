import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
 import 'package:admin_dashboard/pages/users/widgets/tra_format.dart';
 import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../constants/style.dart';
import '../../../../widgets/custom_text.dart';

class LanguageController extends GetxController {
  String selectedLanguage = 'en';

  void changeLanguage(String newLanguage) {
    selectedLanguage = newLanguage;
    update();
  }
}

class ShowAdminsHistory extends StatefulWidget {
  const ShowAdminsHistory({super.key});

  @override
  State<ShowAdminsHistory> createState() => _ClientsTableState();
}

class _ClientsTableState extends State<ShowAdminsHistory> {
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
              labelText: 'Admin Email'.tr,
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
                  ? 'End Date: ${transFormat.format(_selectedEndDate!)}'.tr.tr
                  : 'Choose End Date'.tr,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  ////////////////////////////////////////////////////////
  ///
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

  void _updateDisplayedUsers() {
    _displayedUsers = _allUsers.where((user) {
      final emailMatch = user['adminEmail']
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
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _fetchUsers(); // Fetch users on initialization
  }

  void _fetchUsers() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('adminActions')
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
      DataColumn(label: textofTableTitle('Admin Id'.tr)),
      DataColumn(label: textofTableTitle('Admin Email'.tr)),
      DataColumn(label: textofTableTitle('User Info'.tr)),
      DataColumn(label: textofTableTitle('Id'.tr)),
      DataColumn(label: textofTableTitle('newState'.tr)),
      DataColumn(label: textofTableTitle('type'.tr)),
      DataColumn(label: textofTableTitle('Time of Operation'.tr)),
      // DataColumn(label: textofTableTitle('Action'.tr)),
      // DataColumn(label: Text('Actions')),
    ];

    final verticalScrollController = ScrollController();
    final horizontalScrollController = ScrollController();

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
                "Admins Actions".tr,
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
                width: 470,
                child: searchBarWidgets(),
              ),
            ],
          ),
          // Directionality(
            // textDirection: LanguageController().selectedLanguage == "ar"
            //     ? TextDirection.rtl
            //     : TextDirection.ltr,
            //child: 
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
                      sliderHeight: 400,
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
                                      customer['timestamp'] as Timestamp;
                                  final formattedLastLogin =
                                      ForTime  
                                          .format(lastLoginTimestamp.toDate());

                                  return DataRow(cells: [
                                    DataCell(Text(((_currentPage - 1) *
                                                _itemsPerPage +
                                            _displayedUsers.indexOf(customer) +
                                            1)
                                        .toString())),

                                    DataCell(GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onLongPress: () {
                                        Clipboard.setData(ClipboardData(
                                            text: customer['adminId']));
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text("Copied")));
                                      },
                                      child: CustomText(
                                        size: 16,
                                        text: customer['adminId'] ?? 'N/A',
                                      ),
                                    )),
                                    DataCell(GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onLongPress: () {
                                        Clipboard.setData(ClipboardData(
                                            text: customer['adminEmail']));
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text("Copied")));
                                      },
                                      child: CustomText(
                                        size: 16,
                                        text: customer['adminEmail'] ?? 'N/A',
                                      ),
                                    )),
                                    DataCell(CustomText(
                                      size: 16,
                                      text: customer['Name'] ?? 'N/A',
                                    )),
                                    DataCell(CustomText(
                                      size: 14,
                                      text: customer['Id'] ?? 'N/A',
                                    )),
                                    DataCell(CustomText(
                                      size: 16,
                                      text: customer['newState'].toString(),
                                    )),
                                    DataCell(CustomText(
                                      size: 16,
                                      text: customer['type'] ?? 'N/A',
                                    )),
                                    DataCell(CustomText(
                                      size: 16,
                                      text: formattedLastLogin,
                                    )),

                                    // DataCell(Row(
                                    //   children: [
                                    //     // IconButton(
                                    //     //   icon: const Icon(
                                    //     //     Icons.remove_red_eye_outlined,
                                    //     //     color: Colors.blue,
                                    //     //   ),
                                    //     //   onPressed: () {
                                    //     //     // Edit admin
                                    //     //     Navigator.push(
                                    //     //       context,
                                    //     //       MaterialPageRoute(
                                    //     //         builder: (context) =>
                                    //     //             EditAdminWidgets(
                                    //     //           adminId: customer.id,
                                    //     //         ),
                                    //     //       ),
                                    //     //     );
                                    //     //   },
                                    //     // ),
                                    //   //   IconButton(
                                    //   //     icon: const Icon(
                                    //   //       Icons.delete,
                                    //   //       color: Colors.red,
                                    //   //     ),
                                    //   //     onPressed: () {
                                    //   //       // Delete admin
                                    //   //       FirebaseAuth.instance.currentUser
                                    //   //           ?.delete();
                                    //   //       FirebaseFirestore.instance
                                    //   //           .collection('admins')
                                    //   //           .doc(customer.id)
                                    //   //           .delete();
                                    //   //     },
                                    //   //   ),
                                    //    ],
                                    // )),
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
          //  ),
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
    // },
    // );
  }
}
