import 'package:flutter/material.dart';
import 'package:admin_dashboard/constants/controllers.dart';
import 'package:get/get.dart';
import 'package:admin_dashboard/constants/style.dart';
import 'custom_text.dart';

class VerticalMenuItem extends StatelessWidget {
  const VerticalMenuItem({
    super.key, 
    required this.itemName, 
    required this.onTap,
    // this.color = Colors.blue, // إضافة خاصية color بdefaultValue
  });

  final String itemName;
  final VoidCallback onTap;
  // final Color color;

  @override
  Widget build(BuildContext context) {

    return InkWell(
        onTap: onTap,
        onHover: (value) {
          value
              ? menuController.onHover(itemName)
              : menuController.onHover("not hovering".tr);
        },
        child: Obx(() => AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                // color: color, 
                borderRadius: BorderRadius.circular(8), 
              ),
              child: Row(
                children: [
                  Visibility(
                    visible: menuController.isHovering(itemName) ||
                        menuController.isActive(itemName),
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    child: Container(
                      width: 3,
                      height: 72,
                      color: dark,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: menuController.returnIconFor(itemName),
                        ),
                        if (!menuController.isActive(itemName))
                          Flexible(
                              child: CustomText(
                            text: itemName,
                            color: menuController.isHovering(itemName)
                                ? dark
                                : lightGray,
                          ))
                        else
                          Flexible(
                              child: CustomText(
                            text: itemName,
                            color: dark,
                            size: 18,
                            weight: FontWeight.bold,
                          ))
                      ],
                    ),
                  ),
                ],
              ),
            )));
  }
}
