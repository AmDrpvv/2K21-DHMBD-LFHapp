import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lfh_app/checkConn.dart';
import 'package:lfh_app/util/AppEntity.dart';
import 'package:lfh_app/util/ThemeData.dart';
import 'package:lfh_app/util/const.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  var prefs = await getSharedPreferences();
  bool darkTheme = prefs[sharedPrefDarkTheme];
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,// transparent status bar
    systemNavigationBarColor: darkTheme ? Colors.black : Colors.white
  ));
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_){
          runApp(MyApp(darkTheme: darkTheme,));
      }
  );
}

class Test extends StatelessWidget {
  final bool darkTheme;
  Test({this.darkTheme});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Test'),
    );
  }
}

class MyApp extends StatelessWidget {
  final bool darkTheme;
  MyApp({this.darkTheme});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(
      darktheme: darkTheme,
      builder: (context, darkTheme){
        return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: Constants.appName,
        theme: darkTheme ? Constants.darkTheme : Constants.lightTheme,
        darkTheme: Constants.darkTheme,
        home: CheckConn(),
      );
      },
    );
  }
}