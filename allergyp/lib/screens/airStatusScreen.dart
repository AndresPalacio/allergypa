import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../providers/air_quaity_provider.dart';
import '../providers/air_quality.dart';
import 'airQualityStatus.dart';

class AirStatus extends StatefulWidget {
  @override
  _AirStatusState createState() => _AirStatusState();
}

class _AirStatusState extends State<AirStatus> {
  AirQualityProvider airQualityProvider = AirQualityProvider();
  double iaqiPm25 = -1;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    setState(() {
      isLoading = true;
    });

    AirQuality? airQuality = airQualityProvider.airQuality;
    if(airQuality == null){
      await airQualityProvider.dataFromLatLng(6.2908651, -75.5835862);
    }
    setState(() {
      iaqiPm25 = airQualityProvider.iaqiPm25!;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Air Status'),
      ),
      child: isLoading
          ? const Center(
              child: CupertinoActivityIndicator(),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                          'IAQI PM2.5',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          iaqiPm25.toString(),
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    color: Colors.grey[200],
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: AirQualityStatus(iaqiPm25: iaqiPm25),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}