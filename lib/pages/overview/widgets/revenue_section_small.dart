import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:admin_dashboard/constants/style.dart';
import 'package:admin_dashboard/pages/overview/widgets/revenue_info.dart';
import 'package:get/get.dart';

class RevenueSectionSmall extends StatelessWidget {
  const RevenueSectionSmall({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('payments').snapshots(),
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

          return Container(
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.symmetric(vertical: 30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                    offset: const Offset(0, 6),
                    color: lightGray.withOpacity(.1),
                    blurRadius: 12)
              ],
              border: Border.all(color: lightGray, width: .5),
            ),
            child: Column(
              children: [
                // SizedBox(
                //   height: 260,
                //   child: Column(
                //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //     children: [
                //       CustomText(
                //         text: "Revenue Chart",
                //         size: 20,
                //         weight: FontWeight.bold,
                //         color: lightGray,
                //       ),
                //        SizedBox(
                //           width: 600,
                //           height: 200,
                //           child: Chart()
                //       ),
                //     ],
                //   ),
                // ),
                SizedBox(
                  height: 260,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          RevenueInfo(
                            title: "total Earned Comm".tr,
                            amount: snapshot.data!.docs[0]["totalEarnedComm"]
                                .round(),
                          ),
                          RevenueInfo(
                            title: "total Driver Earned".tr,
                            amount: snapshot.data!.docs[0]["totalDriverEarned"]
                                .round(),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          RevenueInfo(
                            title: "riders Wallets Balance".tr,
                            amount: snapshot
                                .data!.docs[0]["ridersWalletsBalance"]
                                .round(),
                          ),
                          RevenueInfo(
                            title: "Drivers Wallets Balance".tr,
                            amount: snapshot
                                .data!.docs[0]["DriversWalletsBalance"]
                                .round(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
