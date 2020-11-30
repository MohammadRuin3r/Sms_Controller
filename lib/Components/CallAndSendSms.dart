import 'dart:async';
import 'package:animated_dialog/AnimatedDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sendsms/sendsms.dart';
import '../constants.dart';
import 'ShowDialog.dart';


// Get number
callNumber(String phone) async {
  bool res = await FlutterPhoneDirectCaller.callNumber(phone);
}

// Send Sms to system 
sendSMS({String phoneNumber, String message}) async {
  await Sendsms.onGetPermission();

  if (await Sendsms.hasPermission()) {
    await Sendsms.onSendSMS(phoneNumber, message);
  }
}

// Show Alert SendingSMS
void sendingSmsDialog(
    {BuildContext context,
    int second = 4,
    String content = '. . . درحال ارسال پیام ، لطفا صبر کنید',
    String imgUrl = 'assets/images/sending_sms.svg'}) {
  Timer(Duration(seconds: second), () {
    Navigator.of(context).pop();
  });

  Size size = MediaQuery.of(context).size;
  showDialog(
    barrierDismissible: false,
    context: context,
    child: AnimatedDialog(
      height: size.height * 0.4,
      width: size.width * 0.8,
      color: kWhiteColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SvgPicture.asset(
            imgUrl,
            width: size.width * 0.35,
          ),
          SizedBox(
            height: size.height * 0.02,
          ),
          Text(
            content,
            style: TextStyle(fontSize: size.height * 0.019),
          )
        ],
      ),
    ),
  );
}

// Show Alert SmsDialog
void showAlertSendSMS(String title, BuildContext context, Function doThis,
    {Function noButton}) {
  showAlertDialog(
      context,
      Icons.message,
      kYellowColor,
      title,
      '.درخواست توسط پیامک انجام خواهد شد',
      'انصراف',
      'تایید',
      // This Method Run When You Click On * Yes Button *
      doThis,
      noButton);
}

void showMainSmsDialog(
    {BuildContext context, String title, String text, String phone}) {
  showAlertSendSMS(title, context, () async {
    Navigator.of(context).pop();
    sendSMS(message: text, phoneNumber: phone);
    sendingSmsDialog(context: context);
    print(' Title : $title ');
    print(' Text : $text ');
    print(' Phone : $phone ');
  }, noButton: () {
    Navigator.of(context).pop();
  });
}
