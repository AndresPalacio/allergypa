import 'package:allergyp/localization/appLocalization.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:allergyp/components/constants.dart';

import 'FunctionScreen/qualityAirScreen.dart';
import 'FunctionScreen/sleepScreen.dart';


const List<Icon> icons = [
  Icon(
    FontAwesomeIcons.heartbeat,
    color: Color(0xFFFF284B),
  ),
  Icon(
    FontAwesomeIcons.vial,
    color: Color(0xFFFF4000),
  ),
  Icon(
    FontAwesomeIcons.calculator,
    color: Color(0xFF4E4CD0),
  ),
  Icon(
    FontAwesomeIcons.bed,
    color: Color(0xFF4E4CD0),
  ),
  Icon(
    FontAwesomeIcons.allergies,
    color: Color(0xFF4E4CD0),
  ),
];

List<Widget> pageRoutes = [
  SleepScreen(),
  QualityAirStatusScreen()
];

class RecordMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List tittleTexts = [
      AppLocalization.of(context).translate('sleep_record'),
      AppLocalization.of(context).translate('allergy_quality_gate')
    ];
    return CupertinoPageScaffold(
      backgroundColor: CupertinoDynamicColor.resolve(
          CupertinoColors.systemGroupedBackground, context),
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            CupertinoSliverNavigationBar(
              largeTitle:
                  Text(AppLocalization.of(context).translate('record_title')!),
            ),
          ];
        },
        body: MediaQuery.removePadding(
            removeTop: true,
            context: context,
            child: Container(
                padding: EdgeInsets.all(5.0),
                child: ListView.builder(
                  itemCount: pageRoutes.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                        child: Column(
                      children: <Widget>[
                        Card(
                            color: CupertinoDynamicColor.resolve(
                                backGroundColor, context),
                            // elevation: 4.0, //Card的阴影
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: ListTile(
                              leading: icons[index],
                              title: Text(tittleTexts[index],style: TextStyle(color: CupertinoDynamicColor.resolve(textColor, context),fontSize: 18),),
                              trailing:
                                  const Icon(CupertinoIcons.chevron_forward,color: Color(0xFF505054),),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) =>
                                            pageRoutes[index]));
                              },
                            ))
                      ],
                    ));
                  },
                ))),
      ),
    );
  }
}
