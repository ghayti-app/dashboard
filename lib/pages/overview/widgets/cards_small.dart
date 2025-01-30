import 'package:admin_dashboard/constants/constants.dart';
import 'package:admin_dashboard/pages/overview/widgets/fetch_data_from_firebase.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'info_card_small.dart';

class OverviewCardsSmallScreen extends StatefulWidget {
  const OverviewCardsSmallScreen({super.key});

  @override
  State<OverviewCardsSmallScreen> createState() =>
      _OverviewCardsSmallScreenState();
}

class _OverviewCardsSmallScreenState extends State<OverviewCardsSmallScreen> {
  // final CustomersController customersController =
  //     Get.put(CustomersController());

  final ProductsController productsController = Get.put(ProductsController());

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return SizedBox(
      height: 400,
      child: Obx(
        () => Column(
          children: [
            InfoCardSmall(
              title: Constants.totaldrivers,
              value: productsController.drivers.length,
              onTap: () {},
            ),
            SizedBox(
              height: width / 64,
            ),
            InfoCardSmall(
              title: Constants.totalRider,
              value: productsController.users.length,
              onTap: () {},
            ),
            SizedBox(
              height: width / 64,
            ),
            InfoCardSmall(
              title: Constants.currentmoneyes,
              value: productsController.balance.isNotEmpty
                  ? productsController.balance[0]['currentBalance']
                  : 0,
              onTap: () {},
            ),
            SizedBox(
              height: width / 64,
            ),
            InfoCardSmall(
              title: Constants.totalRideRequest,
              value: productsController.balance.isNotEmpty
                  ? productsController.totalRides[0]['totalRides']
                  : 0,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
