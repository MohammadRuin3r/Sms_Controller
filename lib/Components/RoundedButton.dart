import 'package:flutter/material.dart';
import '../constants.dart';

class RoundedButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final Function onTap;

  RoundedButton({this.icon, this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Material(
      color: kLoginScreenBackground,
      borderRadius: BorderRadius.all(Radius.circular(size.width * 0.1)),
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(size.width * 0.1)),
        onTap: onTap,
        child: Container(
          width: size.width * 0.4,
          height: size.height * 0.07,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                text,
                style: TextStyle(color: kWhiteColor),
              ),
              SizedBox(
                width: size.width * 0.005,
              ),
              Icon(
                icon,
                color: kWhiteColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
