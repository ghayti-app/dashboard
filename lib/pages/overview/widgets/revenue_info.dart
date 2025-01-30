import 'package:flutter/material.dart';
import 'package:admin_dashboard/constants/style.dart';

class RevenueInfo extends StatelessWidget {
  const RevenueInfo({super.key, required this.title, required this.amount});

  final String title;
  final double amount;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(children: [
            TextSpan(
                text: "$title \n",
                style: TextStyle(color: lightGray, fontSize: 16)),
            TextSpan(
                text: " ${amount.round()}",
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ])),
    );
  }
}
