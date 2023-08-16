import 'package:flutter/material.dart';

class AirQualityStatus extends StatelessWidget {
  final double iaqiPm25;

  AirQualityStatus({required this.iaqiPm25});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.grey[400]!,
              width: 4,
            ),
            color: getStatusColor(),
          ),
          child: Center(
            child: Text(
              iaqiPm25.toString(),
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(height: 16),
        Text(
          getStatusText(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Color getStatusColor() {
    if (iaqiPm25 < 50) {
      return Colors.green;
    } else if (iaqiPm25 < 100) {
      return Colors.yellow;
    } else if (iaqiPm25 < 150) {
      return Colors.orange;
    } else if (iaqiPm25 < 200) {
      return Colors.red;
    } else if (iaqiPm25 < 300) {
      return Colors.purple;
    } else {
      return Colors.brown;
    }
  }

  String getStatusText() {
    if (iaqiPm25 < 50) {
      return 'Good';
    } else if (iaqiPm25 < 100) {
      return 'Moderate';
    } else if (iaqiPm25 < 150) {
      return 'Unhealthy for\nSensitive Groups';
    } else if (iaqiPm25 < 200) {
      return 'Unhealthy';
    } else if (iaqiPm25 < 300) {
      return 'Very Unhealthy';
    } else {
      return 'Hazardous';
    }
  }
}