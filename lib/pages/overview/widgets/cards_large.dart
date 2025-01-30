import 'package:admin_dashboard/pages/overview/widgets/fetch_data_from_firebase.dart';
import 'package:flutter/material.dart';
import 'package:admin_dashboard/pages/overview/widgets/info_card.dart';
import 'package:get/get.dart';

class OverviewCardsLargeScreen extends StatefulWidget {
  const OverviewCardsLargeScreen({
    super.key,
  });

  @override
  State<OverviewCardsLargeScreen> createState() =>
      _OverviewCardsLargeScreenState();
}

class _OverviewCardsLargeScreenState extends State<OverviewCardsLargeScreen> {
  final ProductsController productsController = Get.put(ProductsController());

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Row(
      children: [
        Obx(() => InfoCard(
              title: "Total Drivers :".tr, 
              value: (productsController.drivers.length).toDouble(),
              onTap: () {},
              topColor: Colors.orange,
            )),
        SizedBox(
          width: width / 64,
        ),
        Obx(() => InfoCard(
              title: "Total Users :".tr,
              value: productsController.users.length.toDouble(),
              onTap: () {},
              topColor: Colors.orange,
            )),
        SizedBox(
          width: width / 64,
        ),
        Obx(() => InfoCard(
              title: "Current Balance :".tr,
              value: (productsController.balance.isNotEmpty
                  ? productsController.balance[0]['currentBalance']
                  : 0),
              onTap: () {},
              topColor: Colors.orange,
            )),
        SizedBox(
          width: width / 64,
        ),
        Obx(() => InfoCard(
              title: "Total Rides :".tr,
              value: productsController.balance.isNotEmpty
                  ? productsController.totalRides[0]['totalRides']
                  : 0,
              onTap: () {},
              topColor: Colors.orange,
            )),
      ],
      //)
    );
  }
}
