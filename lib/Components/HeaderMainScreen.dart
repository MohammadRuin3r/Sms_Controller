import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sendsms/sendsms.dart';
import 'package:sms/sms.dart';
import 'package:smscontroller/Components/ShowMenu.dart';
import 'package:smscontroller/Controller/SystemNumberController.dart';
import 'package:smscontroller/Controller/SystemStateController.dart';
import 'package:smscontroller/Screens/MainScreen/MainScreen.dart';
import 'package:smscontroller/constants.dart';
import 'ShowDialog.dart';
import 'CallAndSendSms.dart';

class Header extends StatelessWidget {
  final List statusList;
  Header({this.statusList});
  @override
  Widget build(BuildContext context) {
    //List of phones
    List<SystemNumberController> numbers = [];
    //Create DB Object
    SystemPhoneHelper _phoneDB = SystemPhoneHelper();

    String systemState = '';

    String phone = '';
    //List Phones

    SystemStatusHelper _statusDB = SystemStatusHelper();
    // State Controller
    SystemStatusController statusController;

    Future getPhone() async {
      numbers = await _phoneDB.getPhoneNumber();
      phone = numbers[0].phone;
    }

    SmsReceiver smsReceiver = new SmsReceiver();
    Size size = MediaQuery.of(context).size;

    void refreshList(bool send) {
      smsReceiver.onSmsReceived.listen((msg) async {
        print(msg.address);

        String result = "";
        for (int i = 0; i < msg.body.length; i++) {
          if ("0123456789".contains(msg.body[i])) result += msg.body[i];
        }

        systemState = result.replaceAllMapped(
            new RegExp(r'(\d{1,1})(?=(\d{1})+(?!\d))'),
            (Match m) => '${m[1]},');

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

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: <Widget>[
          IconButton(
            onPressed: () {
              showAlertDialog(context, Icons.close, kRedColor, 'خروج',
                  'آیا میخواهید خارج شوید ؟ ', 'خیر', 'بله',
                  // This Method Run When You Click On * Yes Button *
                  () {
                SystemNavigator.pop();
                // This Method Run When You Click On  * No Button *
              }, () {
                Navigator.of(context).pop();
              });
            },
            icon: Icon(
              Icons.exit_to_app,
              size: size.height * 0.05,
            ),
          ),
          SizedBox(
            width: size.width * 0.02,
          ),
          IconButton(
            onPressed: () async {
              try {
                await getPhone();
                showAlertDialog(
                    context,
                    Icons.call,
                    kGreenColor,
                    'تماس با سیستم',
                    'آیا میخواهید با سیستم تماس بگیرید ؟ ',
                    'خیر',
                    'بله',
                    // This Method Run When You Click On * Yes Button *
                    () {
                  Navigator.of(context).pop();
                  callNumber(phone);
                }, () {
                  Navigator.of(context).pop();
                });
              } catch (e) {
                sendingSmsDialog(
                  second: 2,
                  context: context,
                  content: 'لطفا ابتدا شماره تلفن را ثبت کنید',
                  imgUrl: 'assets/images/Simcard.svg',
                );
              }
            },
            icon: Icon(
              Icons.call,
              color: Colors.green,
              size: size.height * 0.05,
            ),
          ),
          SizedBox(
            width: size.width * 0.02,
          ),
          IconButton(
            onPressed: () async {
              try {
                await getPhone();

                await Sendsms.onGetPermission();

                systemState = "";
                for (int i = 0; i < statusList.length; i++) {
                  systemState += statusList[i].toString();
                }

                showMainSmsDialog(
                    context: context,
                    phone: phone,
                    text: '(REL $systemState)',
                    title: 'ارسال دستور');

                refreshList(true);
              } catch (e) {
                sendingSmsDialog(
                  second: 2,
                  context: context,
                  content: 'لطفا ابتدا شماره تلفن را ثبت کنید',
                  imgUrl: 'assets/images/Simcard.svg',
                );
              }
            },
            icon: Icon(
              Icons.message,
              color: Colors.orangeAccent,
              size: size.height * 0.05,
            ),
          ),
          SizedBox(
            width: size.width * 0.02,
          ),
          IconButton(
            onPressed: () async {
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
            icon: Icon(
              Icons.refresh,
              size: size.height * 0.05,
            ),
          ),
          Spacer(),
          IconButton(
            onPressed: () => showDialogItems(context),
            icon: Icon(
              Icons.menu,
              size: size.height * 0.05,
            ),
          ),
        ],
      ),
    );
  }
}
