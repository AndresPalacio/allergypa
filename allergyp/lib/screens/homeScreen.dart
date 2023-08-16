

import 'package:allergyp/localization/appLocalization.dart';
import 'package:allergyp/screens/aboutScreen.dart';
import 'package:flutter/cupertino.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {

  // KeepAliveHandle _keepAliveHandle;
  @override
  bool get wantKeepAlive => false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              CupertinoSliverNavigationBar(
                largeTitle:
                    Text(AppLocalization.of(context).translate('home_page')!),
                trailing: CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: Icon(CupertinoIcons.person_crop_circle,size: 32,),
                    onPressed: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => AboutScreen()));
                    }),
              )
            ];
          },
          body: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: Container(
              padding: EdgeInsets.all(5.0),
              child: ListView(
                children: const [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text("Charts")
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
