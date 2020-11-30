import 'package:flutter/material.dart';

class AboutUS extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset(
            'assets/images/logo.png',
            width: size.width * 0.3,
            height: size.height * 0.3,
          ),
          InfoWidget(
            color: Colors.green,
            text: '09336952172',
            icon: Icons.phone,
          ),
          InfoWidget(
            color: Colors.blue,
            text: 'NH_Electronics@',
            icon: Icons.message,
          ),
          InfoWidget(
            color: Colors.yellow[600],
            text: 'Nh1936@Yahoo.Com',
            icon: Icons.email,
          ),
        ]),
      ),
    );
  }
}

class InfoWidget extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;

  InfoWidget({this.icon, this.text, this.color});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: color,
          size: size.width * 0.08,
        ),
        SizedBox(
          width: size.width * 0.03,
        ),
        Text(
          text,
          style: TextStyle(fontSize: size.width * 0.045),
          textDirection: TextDirection.rtl,
        ),
        SizedBox(
          height: size.height * 0.06,
        ),
      ],
    );
  }
}
