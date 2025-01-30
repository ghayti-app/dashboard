import 'package:admin_dashboard/widgets/horizontal_menu_item.dart';
import 'package:admin_dashboard/widgets/vertical_menu_item.dart';
import 'package:flutter/material.dart';
import '../helpers/responsiveness.dart';

class SideMenuItem extends StatelessWidget {
  const SideMenuItem(
      {super.key,
      required this.itemName,
      required this.onTap,
      List<SideMenuItem>? subMenuItems
      });

  final String itemName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    if (ResponsiveWidget.isCustomScreen(context)) {
    
      return VerticalMenuItem(
        itemName: itemName,
        onTap: onTap,
      );
    } else {
      return HorizontalMenuItem(
        itemName: itemName,
        onTap: onTap,
      );
      
      
    }
    
  }
}

class SubSideMenuItem extends StatelessWidget {
  const SubSideMenuItem(
      {super.key,
      required this.itemName,
      required this.onTap,
      });

  final String itemName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    if (ResponsiveWidget.isCustomScreen(context)) {
    
      return VerticalMenuItem(
        itemName: itemName,
        onTap: onTap,
      );
    } else {
      return HorizontalMenuItem(
        itemName: itemName,
        onTap: onTap,
      );
      
      
    }
    
  }
}
