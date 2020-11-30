import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:simple_splashscreen/simple_splashscreen.dart';
import 'package:smscontroller/Screens/LoginScreen/LoginScreen.dart';
import '../../constants.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Simple_splashscreen(
      context: context,
      gotoWidget: LoginScreen(),
      splashscreenWidget: Body(),
      timerInSeconds: 2,
    );
  }
}

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kSplashScreenBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Spacer(),
            SvgPicture.asset(
              'assets/images/SplashScreen_Character.svg',
              width: size.width * 0.8,
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            Text(
              'کنترل لوازم خانگی با تلفن همراه',
              style: TextStyle(color: kWhiteColor, fontSize: size.width * 0.045),
            ),
            Spacer(),
            Container(
              height: size.height * 0.04,
              width: size.width * 0.08,
              margin: EdgeInsets.only(bottom: size.height * 0.05),
              child: CircularProgressIndicator(
                backgroundColor: kWhiteColor,
                valueColor:
                AlwaysStoppedAnimation<Color>(kSplashScreenBackground),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
