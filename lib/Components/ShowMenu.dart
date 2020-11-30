import 'package:animated_dialog/AnimatedDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sms/sms.dart';
import 'package:smscontroller/Components/CallAndSendSms.dart';
import 'package:smscontroller/Components/MainDialog.dart';
import 'package:smscontroller/Controller/LoginPasswordController.dart';
import 'package:smscontroller/Controller/SystemNumberController.dart';
import 'package:smscontroller/Controller/SystemStateController.dart';
import 'package:smscontroller/Screens/AboutScreen/AboutUs_Screen.dart';
import 'package:smscontroller/Screens/HelpScreen/HelpScreen.dart';
import 'package:smscontroller/Screens/MainScreen/MainScreen.dart';
import 'package:smscontroller/Screens/UsersScreen/UsersScreen.dart';
import '../constants.dart';

class Item extends StatelessWidget {
  final String imgUrl;
  final String text;
  final Function onTap;
  final double imageWidth;
  final double imageHeight;

  Item({this.imgUrl, this.text, this.onTap, this.imageWidth, this.imageHeight});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      children: <Widget>[
        Material(
          borderRadius: BorderRadius.circular(20.0),
          child: InkWell(
            splashColor: kSplashScreenBackground,
            borderRadius: BorderRadius.circular(20.0),
            onTap: onTap,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: kSilverColor,
              ),
              width: size.width * 0.25,
              height: size.height * 0.15,
              child: Center(
                child: SvgPicture.asset(
                  imgUrl,
                  width: imageWidth,
                  height: imageHeight,
                ),
              ),
            ),
          ),
        ),
        Text(text),
      ],
    );
  }
}

void showDialogItems(BuildContext context) {
  String phone = '';
  //List Phones
  List<SystemNumberController> numbers = [];
  //Create DB Object
  SystemPhoneHelper _phoneDB = SystemPhoneHelper();
  //Get Phone Number
  Future getPhone() async {
    numbers = await _phoneDB.getPhoneNumber();
    phone = numbers.length > 0 ? numbers[0].phone : '';
  }

  SystemNumberController systemPhoneNumber;
  List<SystemNumberController> phoneNumbers = [];
  SystemPhoneHelper _phoneNumberDB = SystemPhoneHelper();

  SmsReceiver receiver = new SmsReceiver();

  LoginPasswordController user;
  List<LoginPasswordController> users = [];
  LoginPasswordHelper _db = LoginPasswordHelper();

  TextEditingController _txtController = TextEditingController();
  Size size = MediaQuery.of(context).size;

  String systemState = '';

  SystemStatusHelper _statusDB = SystemStatusHelper();
  // State Controller
  SystemStatusController statusController;

  SmsReceiver smsReceiver = new SmsReceiver();

  void refreshList(bool send) {
    smsReceiver.onSmsReceived.listen((msg) async {
      print(msg.address);

      String result = "";
      for (int i = 0; i < msg.body.length; i++) {
        if ("0123456789".contains(msg.body[i])) result += msg.body[i];
      }

      systemState = result.replaceAllMapped(
          new RegExp(r'(\d{1,1})(?=(\d{1})+(?!\d))'), (Match m) => '${m[1]},');

      print('In Natijas $systemState');

      if (msg.sender == phone && msg.body.contains("REL:")) {
        statusController = SystemStatusController(id: 1, status: systemState);
        _statusDB.setStatus(statusController);

        print(' Update Sucessfuly !');

        if (send) {
          sendingSmsDialog(
            context: context,
            content: 'عملیات با موفقیت انجام شد',
            imgUrl: 'assets/images/successfuly_sent.svg',
          );
        }
        if (!send) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => MainScreen()));
        }
      } else {
        print('Error !');
      }
    });
  }

  showDialog(
      context: context,
      child: AnimatedDialog(
        width: size.width * 0.98,
        height: size.height * 0.65,
        animationTime: Duration(milliseconds: 500),
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(20.0),
        child: Center(
          child: SingleChildScrollView(
                      child: Wrap(
              spacing: 15.0,
              children: <Widget>[
                Item(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => UsersScreen()));
                  },
                  imgUrl: 'assets/images/team.svg',
                  text: 'کاربران',
                  imageWidth: size.width * 0.06,
                  imageHeight: size.height * 0.06,
                ),
                Item(
                  onTap: () async {
                    await getPhone();
                    showMainDialog(
                        maxLength: 10,
                        controller: _txtController,
                        title: 'ثبت شماره سیمکارت سیستم',
                        context: context,
                        hintText:
                            phone.length > 0 ? phone.substring(3) : '9012345678',
                        btnOk: () async {
                          _txtController.text == ''
                              ? print('Error')
                              : systemPhoneNumber = SystemNumberController(
                                  phone: '+98' + _txtController.text);
                          phoneNumbers = await _phoneNumberDB.getPhoneNumber();
                          print(phoneNumbers.length);
                          print(systemPhoneNumber.phone);
                          if (phoneNumbers.length == 0) {
                            _phoneNumberDB.createDatabase();
                            print('DB Created');
                          }
                          _phoneNumberDB.setPhoneNumber(systemPhoneNumber);

                          Navigator.of(context).pop();
                        });
                  },
                  imgUrl: 'assets/images/Simcard.svg',
                  text: 'سیمکارت',
                  imageWidth: size.width * 0.09,
                  imageHeight: size.height * 0.09,
                ),
                Item(
                  onTap: () async {
                    await getPhone();
                    showMainSmsDialog(
                        context: context,
                        phone: phone,
                        text: '(MANDEH)',
                        title: 'مانده');
                    receiver.onSmsReceived.listen((SmsMessage msg) {
                      if (msg.address == phone && msg.body.contains('MANDEH:')) {
                        sendingSmsDialog(
                            context: context,
                            content: msg.body.substring(0, 40),
                            imgUrl: 'assets/images/Money.svg');
                      } else if (msg.address == phone) {
                        sendingSmsDialog(
                            context: context,
                            content: 'عملیات با خطا مواجه شد',
                            imgUrl: 'assets/images/cancel.svg');
                      } else {
                        print('Error !');
                      }
                    });
                  },
                  imgUrl: 'assets/images/Money.svg',
                  text: 'اعتبار',
                  imageWidth: size.width * 0.15,
                  imageHeight: size.height * 0.15,
                ),
                Item(
                  onTap: () {
                    showMainDialog(
                        controller: _txtController,
                        btnOk: () async {
                          await getPhone();
                          showMainSmsDialog(
                              context: context,
                              phone: phone,
                              title: 'شارژ',
                              text: '(SH ${_txtController.text})');
                          receiver.onSmsReceived.listen((SmsMessage msg) {
                            print(msg.body);
                            if (msg.address == phone) {
                              sendingSmsDialog(
                                  context: context,
                                  content: msg.body
                                          .contains('Ramz e Sharj Nadorost ast!')
                                      ? 'رمز شارژ نادرست است'
                                      : 'دستگاه با موفقیت شارژ شد',
                                  imgUrl: 'assets/images/Charge.svg');
                            } else {
                              print('Error !');
                            }
                          });
                        },
                        context: context,
                        title: 'شارژ سیمکارت اعتباری سیستم',
                        hintText: 'رمز شارژ را وارد نمایید');
                  },
                  imgUrl: 'assets/images/Charge.svg',
                  text: 'شارژ',
                  imageWidth: size.width * 0.15,
                  imageHeight: size.height * 0.15,
                ),
                Item(
                  onTap: () {
                    showMainDialog(
                        controller: _txtController,
                        hintText: 'لطفا رمز جدید را وارد نمایید',
                        title: 'تغییر رمز برنامه',
                        context: context,
                        btnOk: () async {
                          user = LoginPasswordController(
                              password: _txtController.text);

                          users = await _db.getPassword();

                          print(users.length);
                          print(user.password);

                          if (users.length == 0) {
                            _db.createDatabase();
                            print('Created');
                          }
                          _db.setPassword(user);
                          print('OK');

                          Navigator.of(context).pop();
                        },
                        inputType: TextInputType.text);
                  },
                  imgUrl: 'assets/images/Password.svg',
                  text: 'رمز برنامه',
                  imageWidth: size.width * 0.15,
                  imageHeight: size.height * 0.15,
                ),
                Item(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AboutUS()));
                  },
                  imgUrl: 'assets/images/read-me.svg',
                  text: 'درباره',
                  imageWidth: size.width * 0.1,
                  imageHeight: size.height * 0.1,
                ),
                Item(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => HelpScreen()));
                  },
                  imgUrl: 'assets/images/Help.svg',
                  text: 'راهنما',
                  imageWidth: size.width * 0.2,
                  imageHeight: size.height * 0.2,
                ),
                Item(
                  onTap: () async {
                    try {
                      numbers = await _phoneDB.getPhoneNumber();
                      phone = numbers[0].phone;
                      showAlertSendSMS('ارسال دستور', context,
                          // If Click On * Yes * Button, then this method will be run.
                          () {
                        sendSMS(message: '(REL)', phoneNumber: phone);
                        Navigator.of(context).pop();
                        sendingSmsDialog(context: context);

                        refreshList(false);

                        // If Click On * No * Button, then this method will be run.
                      }, noButton: () {
                        //TODO: Complete Here
                        Navigator.of(context).pop();
                      });
                    } catch (e) {
                      sendingSmsDialog(
                          context: context,
                          content: 'خطا',
                          second: 2,
                          imgUrl: 'assets/images/cancel.svg');
                    }
                  },
                  imgUrl: 'assets/images/system.svg',
                  text: 'وضعیت سیستم',
                  imageWidth: size.width * 0.08,
                  imageHeight: size.height * 0.08,
                ),
              ],
            ),
          ),
        ),
      ));
}
