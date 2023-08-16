import 'dart:ffi';

import 'package:allergyp/components/iconContent.dart';
import 'package:allergyp/components/resusableCard.dart';
import 'package:allergyp/components/buttonButton.dart';
import 'package:allergyp/components/constants.dart';
import 'package:allergyp/localization/appLocalization.dart';
import 'package:allergyp/providers/air_quaity_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/qualityAirModel.dart';
import '../../providers/air_quality.dart';
import '../../util/cognito/auth_util.dart';

bool flag = true;

enum Quality {
  bad,
  good,
}

enum OptionSelected{
  yes,
  not
}

class QualityAirStatusScreen extends StatefulWidget {
  @override
  _QualityAirStatusScreenState createState() => _QualityAirStatusScreenState();
}

class _QualityAirStatusScreenState extends State<QualityAirStatusScreen> {
  late final TextEditingController _voiceInputController = TextEditingController();

  AirQualityProvider airQualityProvider = AirQualityProvider();
  double iaqiPm25 = -1;

  double sleepTime = 7.0;
  int _selectedTimeInt = 7;
  int _selectedTimeFloat = 0;

  String _voiceInput = '';

  Future<void> getData() async {

    AirQuality? airQuality = airQualityProvider.airQuality;
    if(airQuality == null){
      await airQualityProvider.dataFromLatLng(6.2908651, -75.5835862);
    }

    setState(() {
      iaqiPm25 = airQualityProvider.iaqiPm25 ?? -1;
    });
  }


  create() async {

    var tokenResult  = await CognitoService.getAuthToken();
    print(tokenResult);
    await getData();
    QualityAirDB qualityAirDB = QualityAirDB(
      generalStatus: _voiceInput,
      status: optionSelectedState.name,
      inhaler: getInhaler(optionSelectedState),
      percentage: sleepTime,
      pm25: iaqiPm25
    );

  }

  getInhaler(OptionSelected optionSelected){
    if(optionSelected.index == 1){
      return true;
    }else{
      return false;
    }
  }

  List checkBS(String text) {

    List<dynamic> bsData = [];
    if (text.contains("Me siento mal")) {
      bsData.add(0);
      RegExp c = new RegExp(r'([0-9]{1,2}?)+(\.[0-9]{1,2})');
      Iterable<Match> matches = c.allMatches(text);
      for (Match m in matches) {
        double match = double.parse(m[0]!);
        bsData.add(match);
      }
    } else if (text.contains("Me siento muy mal")) {
      bsData.add(1);
      RegExp c = new RegExp(r'([0-9]{1,2}?)+(\.[0-9]{1,2})');
      Iterable<Match> matches = c.allMatches(text);
      for (Match m in matches) {
        double match = double.parse(m[0]!);
        bsData.add(match);
      }
    }
    if (bsData.length == 2) {
      bsData.insert(0, true);
      return bsData;
    } else {
      bsData.insert(0, false);
      return bsData;
    }
  }

  Widget _voiceInputTextField() {
    return CupertinoTextField(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0)), //,
      controller: _voiceInputController,
      maxLines: 4,
      placeholder:
      AppLocalization.of(context).translate('quality_air_screen_textfield_title'),
      onChanged: (String value) {
        _voiceInput = value;
      },
    );
  }

  late Quality selectedState = Quality.bad;
  late OptionSelected optionSelectedState = OptionSelected.not;
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: CupertinoNavigationBar(
        middle: Text(AppLocalization.of(context).translate('input_statistics')!),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(5),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: double.infinity),
            child: Column(
              children: <Widget>[
                Container(
                  child: ReusableCard(
                    cardChild: _voiceInputTextField(),
                    color:
                    CupertinoDynamicColor.resolve(backGroundColor, context),
                     onPressed: () {
                    },
                    onLongPressed: () {
                    },
                  ),
                ),
                Container(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: ReusableCard(
                            onPressed: () {
                              setState(() {
                                HapticFeedback.mediumImpact();
                                selectedState = Quality.bad;
                              });
                            },
                            color: selectedState == Quality.bad
                                ? kActiveCardColour
                                : CupertinoDynamicColor.resolve(
                                backGroundColor, context),
                            cardChild: IconFont(
                              icon: CupertinoIcons.battery_25,
                              lable: AppLocalization.of(context).translate("quality_air_input_button1")!,
                              textStyle: selectedState == Quality.bad
                                  ? kSelctedTextStyle
                                  : kLabelTextStyle,
                              colorStyle: selectedState == Quality.bad
                                  ? const Color(0xFFFFFFFF)
                                  : const Color(0xFFDFDDF0),
                            ),
                             onLongPressed: () {},
                          )),
                      Expanded(
                          child: ReusableCard(
                            onPressed: () {
                              setState(() {
                                HapticFeedback.mediumImpact();
                                selectedState = Quality.good;
                              });
                            },
                            color: selectedState == Quality.good
                                ? kActiveCardColour
                                : CupertinoDynamicColor.resolve(
                                backGroundColor, context),
                            cardChild: IconFont(
                              icon: CupertinoIcons.bandage,
                              lable: AppLocalization.of(context).translate("quality_air_input_button2")!,
                              textStyle: selectedState == Quality.good
                                  ? kSelctedTextStyle
                                  : kLabelTextStyle,
                              colorStyle: selectedState == Quality.good
                                  ? const Color(0xFFFFFFFF)
                                  : const Color(0xFFDFDDF0),
                            ),
                            onLongPressed: () {},

                          ))
                    ],
                  ),
                ), //HealthCare
                Container(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: ReusableCard(
                            onPressed: () {
                              setState(() {
                                HapticFeedback.mediumImpact();
                                optionSelectedState = OptionSelected.not;
                              });
                            },
                            color: optionSelectedState == OptionSelected.not
                                ? kActiveCardColour
                                : CupertinoDynamicColor.resolve(
                                backGroundColor, context),
                            cardChild: IconFont(
                              icon: CupertinoIcons.clear_circled_solid,
                              lable: AppLocalization.of(context).translate("quality_air_input_button3")!,
                              textStyle: optionSelectedState ==OptionSelected.not
                                  ? kSelctedTextStyle
                                  : kLabelTextStyle,
                              colorStyle: optionSelectedState == OptionSelected.not
                                  ? const Color(0xFFFFFFFF)
                                  : const Color(0xFFDFDDF0),
                            ),
                             onLongPressed: () {},

                          )),
                      Expanded(
                          child: ReusableCard(
                            onPressed: () {
                              setState(() {
                                HapticFeedback.mediumImpact();
                                optionSelectedState = OptionSelected.yes;
                              });
                            },
                            color: optionSelectedState == OptionSelected.yes
                                ? kActiveCardColour
                                : CupertinoDynamicColor.resolve(
                                backGroundColor, context),
                            cardChild: IconFont(
                              icon: CupertinoIcons.check_mark_circled_solid,
                              lable: AppLocalization.of(context).translate("quality_air_input_button4")!,
                              textStyle: optionSelectedState ==  OptionSelected.yes
                                  ? kSelctedTextStyle
                                  : kLabelTextStyle,
                              colorStyle: optionSelectedState ==  OptionSelected.yes
                                  ? const Color(0xFFFFFFFF)
                                  : const Color(0xFFDFDDF0),
                            ),
                           onLongPressed: () {},

                          ))
                    ],
                  ),
                ), //Inhaler
                Container(
                  child: ReusableCard(
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              height: 350.0,
                              color: CupertinoDynamicColor.resolve(
                                  backGroundColor, context),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        CupertinoButton(
                                          child: Text(
                                              AppLocalization.of(context)
                                                  .translate('cancel')!),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        CupertinoButton(
                                          child: Text(
                                              AppLocalization.of(context)
                                                  .translate('done')!),
                                          onPressed: () {
                                            setState(() {
                                              sleepTime = _selectedTimeInt +
                                                  _selectedTimeFloat / 10;
                                              Navigator.of(context).pop();
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    height: 0,
                                    thickness: 1,
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: CupertinoPicker(
                                              scrollController:
                                              new FixedExtentScrollController(
                                                  initialItem:
                                                  sleepTime.truncate()),
                                              itemExtent: 45.0,
                                              backgroundColor:
                                              CupertinoDynamicColor.resolve(
                                                  backGroundColor, context),
                                              onSelectedItemChanged:
                                                  (int index) {
                                                _selectedTimeInt = index;
                                              },
                                              children:
                                              new List<Widget>.generate(100,
                                                      (int index) {
                                                    return new Center(
                                                      child: new Text(
                                                        '$index',
                                                        style: TextStyle(
                                                            color: kDarkColour),
                                                      ),
                                                    );
                                                  })),
                                        ),
                                        Expanded(
                                          child: CupertinoPicker(
                                              scrollController:
                                              new FixedExtentScrollController(
                                                  initialItem:
                                                  _selectedTimeFloat),
                                              itemExtent: 45.0,
                                              backgroundColor:
                                              CupertinoDynamicColor.resolve(
                                                  backGroundColor, context),
                                              onSelectedItemChanged:
                                                  (int index) {
                                                _selectedTimeFloat = index;
                                              },
                                              children:
                                              new List<Widget>.generate(10,
                                                      (int index) {
                                                    return new Center(
                                                      child: new Text('$index',
                                                          style: TextStyle(
                                                              color: kDarkColour)),
                                                    );
                                                  })),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          });
                    },
                    color:
                    CupertinoDynamicColor.resolve(backGroundColor, context),
                    cardChild: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text(
                          AppLocalization.of(context).translate("percentage_input_title")!,
                          style: kLabelTextStyle,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: <Widget>[
                            Text(
                              sleepTime.toString(),
                              style: kNumberTextStyle,
                            ),
                            Text(
                              AppLocalization.of(context).translate("percentage")!,
                              style: kNumberTextStyle,
                            )
                          ],
                        ),
                        Text(
                          AppLocalization.of(context).translate('tap_to_set')!,
                          style: kLabelTextStyle,
                        ),
                      ],
                    ),
                    onLongPressed: () {},
                  ),
                ),//Percentage
                ButtonButton(
                  onTap: (){
                    create();
                    Navigator.of(context).pop();
                  },
                  buttonTitle: AppLocalization.of(context).translate('submit')!,
                ),
                const SizedBox(
                  height: 4,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
