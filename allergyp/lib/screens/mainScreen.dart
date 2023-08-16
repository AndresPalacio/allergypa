
import 'package:allergyp/localization/appLocalization.dart';
import 'package:allergyp/screens/homeScreen.dart';
import 'package:allergyp/screens/recordScreen.dart';
import 'package:flutter/cupertino.dart';

import 'airStatusScreen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    RecordMenu(),
    AirStatus()
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          currentIndex: _selectedIndex,
          onTap: (value) {
            setState(() {
              _selectedIndex = value;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: const Icon(CupertinoIcons.heart_fill),
              label: AppLocalization.of(context).translate('home_page'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(CupertinoIcons.doc_chart),
              label: AppLocalization.of(context).translate('function_page'),
            ),
            const BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.arrow_3_trianglepath),
              label: 'quality air')
          ],
        ),
        tabBuilder: (context, i) {
          return CupertinoPageScaffold(child: _widgetOptions[_selectedIndex]);
        });
  }
}

