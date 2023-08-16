
import 'package:allergyp/events/reminderBloc.dart';
import 'package:allergyp/screens/homeScreen.dart';
import 'package:allergyp/screens/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:allergyp/screens/mainScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:allergyp/localization/languageConstants.dart';
import 'package:allergyp/localization/appLocalization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'events/reminderEvent.dart';

List sysSupportedLocales = [];

Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await dotenv.load(fileName: 'environment/.env');
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  

  Widget buildLoginScreen() {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (context, _) => Builder(
        builder: (context) => MaterialApp(
          title: 'Login UI',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: const Color(0xff4C53FB),
            textTheme: GoogleFonts.poppinsTextTheme(),
          ),
          home: const LoginScreen(),
        ),
      ),
    );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return buildLoginScreen();
  }
}

class Allergyp extends StatefulWidget {
  const Allergyp({super.key});


  static void setLocale(BuildContext context, Locale newLocale) {
    _AllergypState? state = context.findAncestorStateOfType<_AllergypState>();
    state?.setLocale(newLocale);
  }

  @override
  _AllergypState createState() => _AllergypState();
}

class _AllergypState extends State<Allergyp> {
  late Locale _locale = Locale("en");
  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      setState(() {
        _locale = locale;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {

    return BlocProvider<ReminderBloc>(
        create: (context) => ReminderBloc(),
        child: CupertinoApp(
            debugShowCheckedModeBanner: false,
            locale: _locale,
            supportedLocales: const [
              Locale("en", ""),
              Locale("cn", ""),
            ],

            localizationsDelegates: const [
              AppLocalization.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            localeResolutionCallback: (locale, supportedLocales) {
              sysSupportedLocales.add(locale?.languageCode);
              for (var supportedLocale in supportedLocales) {
                if (supportedLocale.languageCode == sysSupportedLocales.first) {
                  return supportedLocale;
                }
              }
              return supportedLocales.first;
            },
            title: "Allergyp",
            home: MyHomePage()));
  }
}
