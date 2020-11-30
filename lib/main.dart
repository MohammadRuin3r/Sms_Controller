import 'package:flutter/material.dart';
import 'package:smscontroller/Screens/SplashScreen/SplashScreen.dart';
import 'package:flutter/services.dart' as service;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    service.SystemChrome.setPreferredOrientations([
      service.DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      theme: ThemeData(fontFamily: "iranSans"),
      debugShowCheckedModeBanner: false,
      title: 'SMS Controller',
      home: SplashScreen(),
    );
  }
}
