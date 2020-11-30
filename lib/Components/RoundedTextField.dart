import 'package:flutter/material.dart';
import '../constants.dart';

class RoundedTextField extends StatefulWidget {
  final String hintText;
  final IconData suffixIcon;
  final bool isPasswordField;
  final TextEditingController controller;
  final ValueChanged<String> value;
  RoundedTextField({
    this.hintText,
    this.suffixIcon,
    this.isPasswordField = false,
    this.controller,
    this.value,
  });

  @override
  _RoundedTextFieldState createState() => _RoundedTextFieldState();
}

class _RoundedTextFieldState extends State<RoundedTextField> {
  bool isVisibility = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: size.height * 0.04, vertical: size.width * 0.02),
      child: TextField(
        onChanged: widget.value,
        controller: widget.controller,
        obscureText: isVisibility,
        textAlign: TextAlign.center,
        style: TextStyle(color: kWhiteColor),
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: BorderSide(color: Colors.white)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: BorderSide(color: Colors.white)),
          suffixIcon: Icon(
            widget.suffixIcon,
            color: kWhiteColor,
          ),
          prefixIcon: IconButton(
            onPressed: () {
              setState(() {
                isVisibility = !isVisibility;
              });
            },
            icon: widget.isPasswordField
                ? isVisibility
                    ? Icon(
                        Icons.visibility,
                        color: kWhiteColor,
                      )
                    : Icon(
                        Icons.visibility_off,
                        color: kWhiteColor,
                      )
                : Container(),
          ),
          hintText: widget.hintText,
          hintStyle: TextStyle(
            fontSize: size.height * 0.02,
            color: kWhiteColor,
          ),
        ),
      ),
    );
  }
}
