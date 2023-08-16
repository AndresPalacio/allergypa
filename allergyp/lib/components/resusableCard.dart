import 'package:flutter/material.dart';

class ReusableCard extends StatelessWidget {
  ReusableCard({
    required this.color,
    required this.cardChild,
    required this.onPressed,
    required this.onLongPressed,
  });
  final Color color;
  final Widget cardChild;
  final VoidCallback onPressed;
  final VoidCallback onLongPressed;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      onLongPress: onLongPressed,
      child: Container(
        child: cardChild,
        margin: EdgeInsets.all(5.0),
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: color, //颜色为传递进来的颜色
          borderRadius: BorderRadius.circular(15.0),
        ), //设置圆角矩形的形状
      ),
    );
  }
}