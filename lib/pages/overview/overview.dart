import 'package:admin_dashboard/helpers/responsiveness.dart';
import 'package:admin_dashboard/layout.dart';
import 'package:admin_dashboard/pages/drivers/widgets/show%20drivers/show_in_main_dashbaord.dart';
import 'package:admin_dashboard/pages/overview/widgets/cards_large.dart';
import 'package:admin_dashboard/pages/overview/widgets/cards_medium.dart';
import 'package:admin_dashboard/pages/overview/widgets/cards_small.dart';
import 'package:admin_dashboard/pages/overview/widgets/revenue_section_large.dart';
import 'package:admin_dashboard/pages/overview/widgets/revenue_section_small.dart';
import 'package:admin_dashboard/pages/users/show_in_main_dashbaord.dart';
import 'package:flutter/material.dart';


class OverviewPage extends StatefulWidget {
  const OverviewPage({super.key});

  @override
  _OverviewPageState createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  @override
  void initState() {
    super.initState();
    getNot();
   }

  @override
  void dispose() {
    super.dispose();
  }
 
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              if (ResponsiveWidget.isLargeScreen(context))
                const OverviewCardsLargeScreen(),
              if (ResponsiveWidget.isCustomScreen(context))
                const OverviewCardsMediumScreen(),
              if (ResponsiveWidget.isSmallScreen(context) ||
                  ResponsiveWidget.isMediumScreen(context))
                const OverviewCardsSmallScreen(),
              if (!ResponsiveWidget.isSmallScreen(context))
                const RevenueSectionLarge(),
              if (ResponsiveWidget.isSmallScreen(context))
                const RevenueSectionSmall(),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                width: double.infinity,
                child: ShowDriversTable2(),
              ),
              const SizedBox(
                height: 20,
              ),
              const SizedBox(
                width: double.infinity,
                child: ShowUsersTable2(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
