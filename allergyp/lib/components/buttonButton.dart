import 'package:flutter/material.dart';
import 'package:allergyp/components/constants.dart';

class ButtonButton extends StatelessWidget {
  ButtonButton({required this.onTap, required this.buttonTitle});
  final VoidCallback onTap;
  final String buttonTitle;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: Center(
          child: Text(
            buttonTitle,
            style: kButtonLabelTextStyle,
          ),
        ),
        margin: EdgeInsets.all(5.0),
        padding: EdgeInsets.only(bottom: 5.0),
        width: double.infinity,
        height: kBottomContainerHeight,
        decoration: BoxDecoration(
          color: kBottomContainerColour, //颜色
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
    );
  }
}