import 'package:admin_dashboard/constants/constants.dart';
import 'package:admin_dashboard/pages/overview/widgets/fetch_data_from_firebase.dart';
import 'package:flutter/material.dart';
import 'package:admin_dashboard/pages/overview/widgets/info_card.dart';
import 'package:get/get.dart';

 
class OverviewCardsMediumScreen extends StatefulWidget {
  const OverviewCardsMediumScreen({super.key});

  @override
  State<OverviewCardsMediumScreen> createState() =>
      _OverviewCardsMediumScreenState();
}

class _OverviewCardsMediumScreenState extends State<OverviewCardsMediumScreen> {
  final ProductsController productsController = Get.put(ProductsController());

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Obx(() => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                InfoCard(
                  title: Constants.totaldrivers,
                  value: productsController.drivers.length.toDouble(),
                  onTap: () {},
                  topColor: Colors.orange,
                ),
                SizedBox(
                  width: width / 64,
                ),
                InfoCard(
                  title: Constants.totalRider,
                  value: productsController.users.length.toDouble(),
                  onTap: () {},
                  topColor: Colors.orange,
                )
              ],
            ),
            SizedBox(
              height: width / 64,
            ),
            Row(
              children: [
                InfoCard(
                  title: Constants.currentmoneyes,
                  value: productsController.balance.isNotEmpty
                      ? productsController.balance[0]['currentBalance']
                      : 0,
                  onTap: () {},
                  topColor: Colors.orange,
                ),
                SizedBox(
                  width: width / 64,
                ),
                InfoCard(
                  title: Constants.totalRideRequest,
                  value: productsController.balance.isNotEmpty
                      ? productsController.totalRides[0]['totalRides']
                      : 0,
                  onTap: () {},
                  topColor: Colors.orange,
                )
              ],
            ),
          ],
        ));
  }
}
