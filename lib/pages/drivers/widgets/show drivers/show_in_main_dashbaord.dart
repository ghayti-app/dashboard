import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:admin_dashboard/constants/controllers.dart';
import 'package:admin_dashboard/routing/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/style.dart';
import '../../../../widgets/custom_text.dart';

class ShowDriversTable2 extends StatefulWidget {
  const ShowDriversTable2({super.key});

  @override
  State<ShowDriversTable2> createState() => _ShowUsersTableState();
}

class _ShowUsersTableState extends State<ShowDriversTable2> {
  Widget textofTableTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
          fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black54),
    );
  }

  final int _displayedItems = 10;

  @override
  Widget build(BuildContext context) {
    var columns = [
      DataColumn(label: textofTableTitle('No'.tr)),
      DataColumn(label: textofTableTitle('Name'.tr)),
      DataColumn(label: textofTableTitle('balance'.tr)),
      DataColumn(label: textofTableTitle('service'.tr)),
      DataColumn(label: textofTableTitle('rating'.tr)),
      DataColumn(label: textofTableTitle('Phone'.tr)),
      DataColumn(label: textofTableTitle('is Online'.tr)),
      // DataColumn(label: textofTableTitle('Action'.tr)),
    ];

    final verticalScrollController = ScrollController();
    final horizontalScrollController = ScrollController();

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('drivers')
          .limit(_displayedItems).orderBy("createdAt", descending: true)
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
          return const Center(child: Text('No users available'));
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
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(
                    "Recent Drivers".tr,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 130,
                    child: MaterialButton(
                      height: 50,
                      color: Colors.blue,
                      child: Text(
                        "Show More".tr,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      onPressed: () {
                        navigationController.navigateTo(showDriversPageRoute);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              AdaptiveScrollbar(
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
                          rows: List<DataRow>.generate(
                            _displayedItems < users.length
                                ? _displayedItems
                                : users.length,
                            (index) {
                              var user =
                                  users[index].data() as Map<String, dynamic>;

                              var userId = users[index];
                              // var userId = snapshot.data!.docs[index];

                              // final lastLoginTimestamp =
                              //     user['lastLog'] as Timestamp;
                              // final formattedLastLogin =
                              //     lastLoginTimestamp != null
                              //         ? DateFormat('MMM dd, yyyy hh:mm:ss a')
                              //             .format(lastLoginTimestamp.toDate())
                              //         : "N/A";

                              return DataRow(cells: [
                                DataCell(Text((index + 1).toString())),
                                DataCell(CustomText(
                                  text: "  ${user['userName'] ?? 'N/A'}",
                                )),
                                DataCell(     Directionality( textDirection: TextDirection.ltr,
                                                          child: CustomText(
                                  text:
                                      "    ${user['balance'].toInt() ?? 'N/A'}     ",
                                ))),
                                DataCell(CustomText(
                                  text: "  ${user['service'] ?? 'N/A'}  ",
                                )),

                                DataCell(  Directionality( textDirection: TextDirection.ltr,
                                                          child: CustomText(
                                  text: "  ${user['rating'] ?? 'N/A'}  ",
                                ))),
                                DataCell(CustomText(
                                  text: "  ${user['phoneNumber'] ?? 'N/A'}  ",
                                )),
                                DataCell(Container(
                                  height: 30,
                                  //  width: 100,
                                  width: double.infinity,
                                  padding: const EdgeInsets.only(top: 3),

                                  decoration: BoxDecoration(
                                      color: user['isVerified'] == true
                                          ? Colors.green
                                          : Colors.red,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Center(
                                    child: Text(
                                      " ${user['isVerified'] == true ? "YES".tr : "NO".tr ?? 'N/A'} ",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                )),
                                // DataCell(
                                //   Text(
                                //       "${user['lastLog'].toString()}" ?? "N/A"),
                                //   //   CustomText(text: formattedLastLogin),
                                // ),
                              ]);
                            },
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
            ],
          ),
        );
      },
    );
  }
}
