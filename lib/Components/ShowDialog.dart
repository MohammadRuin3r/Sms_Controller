import 'package:flutter/material.dart';
import '../constants.dart';

class ChildrenAlertDialog extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final String content;
  final String textYesButton;
  final String textNoButton;
  final Function functionYesButton;
  final Function functionNoButton;

  ChildrenAlertDialog(
      {this.title,
      this.icon,
      this.iconColor,
      this.content,
      this.textYesButton,
      this.textNoButton,
      this.functionYesButton,
      this.functionNoButton});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.27,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size.height * 0.02),
          color: kWhiteColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
                top: size.height * 0.01,
                left: size.height * 0.01,
                right: size.height * 0.03),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // Icon

                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Container(
                    width: size.width * 0.1,
                    height: size.height * 0.1,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: iconColor,
                    ),
                    child: Icon(
                      icon,
                      color: Colors.white,
                    ),
                  ),
                ),

                // Title

                Text(
                  title,
                  style: TextStyle(fontSize: size.width * 0.035),
                ),
              ],
            ),
          ),

          // Content

          Container(
            margin: EdgeInsets.only(right: size.width * 0.03),
            height: size.height * 0.05,
            child: Text(
              content,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: size.width * 0.035),
            ),
          ),

          // Bottom Buttons

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FlatButton(
                child: Text(textYesButton),
                onPressed: functionNoButton,
              ),
              FlatButton(
                child: Text(textNoButton),
                onPressed: functionYesButton,
              ),
            ],
          )
        ],
      ),
    );
  }
}

void showAlertDialog(
    BuildContext context,
    IconData _icon,
    Color _iconColor,
    String _title,
    String _content,
    String _textYesButton,
    String _textNoButton,
    Function _functionYesButton,
    Function _functionNoButton) {
  Size size = MediaQuery.of(context).size;
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (_) => new Dialog(
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(size.height * 0.02),
      ),
      child: ChildrenAlertDialog(
        icon: _icon,
        iconColor: _iconColor,
        title: _title,
        content: _content,
        textYesButton: _textYesButton,
        textNoButton: _textNoButton,
        functionYesButton: _functionYesButton,
        functionNoButton: _functionNoButton,
      ),
    ),
  );
}
