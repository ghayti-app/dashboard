import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  const CustomText(
      {super.key, required this.text, this.color, this.size, this.weight});

  final String text;
  final Color? color;
  final double? size;
  final FontWeight? weight;

  @override
  Widget build(BuildContext context) {
    return Text(
       " $text ",
      maxLines: 1,
      style: TextStyle(
        color: color ?? Colors.black,
        fontSize: size ?? 18,
        fontWeight: weight ?? FontWeight.normal,
      ),
    );
  }
}
 