import 'package:flutter/material.dart';
import 'package:sendsms/sendsms.dart';
import 'package:sms/sms.dart';
import 'package:smscontroller/Components/BlackCard.dart';
import 'package:smscontroller/Components/CallAndSendSms.dart';
import 'package:smscontroller/Components/HeaderMainScreen.dart';
import 'package:smscontroller/Controller/SystemChangeNameController.dart';
import 'package:smscontroller/Controller/SystemNumberController.dart';
import 'package:smscontroller/Controller/SystemStateController.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
  final String text;
  MainScreen({this.text});
}

class _MainScreenState extends State<MainScreen> {
  List<SystemChaneNameController> finalNames = [];
  //Create DB Object
  SystemChangeNameHelper _changeNameDB = SystemChangeNameHelper();
  // State Controller
  SystemChaneNameController changeNameController;

  List<SystemStatusController> finalStates = [];
  //Create DB Object
  SystemStatusHelper _stateDB = SystemStatusHelper();
  // State Controller
  SystemStatusController stateController;

  String phone = '';
  //List of phones
  List<SystemNumberController> numbers = [];
  //Create DB Object
  SystemPhoneHelper _phoneDB = SystemPhoneHelper();

  var states = ['1', '1', '1', '1', '0'];

  bool stateOne;

  @override
  void initState() {
    super.initState();
    states.clear();
    Future.delayed(Duration(seconds: 1), () async {
      var phoneResult = await _phoneDB.getPhoneNumber();
      phone = phoneResult[0].phone;
      finalNames = await _changeNameDB.getNames();
      if (finalNames.length == 0) _changeNameDB.createDatabase();
      finalStates = await _stateDB.getStatus();

      if (finalStates.length != 0) {
        String result = finalStates[0].status;
        states = result.split(',');
        Future.delayed(Duration(milliseconds: 200), () {
          setState(() {});
        });
      } else if (finalStates.length == 0) {
        print('First Log');
        states = ['1', '1', '1', '1', '0'];
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String systemState = '';
    SystemStatusHelper _statusDB = SystemStatusHelper();
    // State Controller
    SystemStatusController statusController;

    SmsReceiver smsReceiver = new SmsReceiver();

    void refreshList(bool send) {
      try {
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
            statusController =
                SystemStatusController(id: 1, status: systemState);
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
      } catch (e) {
        print(e.toString());
      }
    }

    void sendS(int rel, int state) async {
      await Sendsms.onGetPermission();
      try {
        showMainSmsDialog(
            context: context,
            phone: phone,
            text: '(REL $rel $state)',
            title: 'ارسال دستور');

        refreshList(false);
      } catch (e) {
        sendingSmsDialog(
            context: context,
            content: 'خطا',
            second: 2,
            imgUrl: 'assets/images/cancel.svg');
      }
    }

    return SafeArea(
      child: Scaffold(
        body: states.length == 0
            ? Center(
                child: CircularProgressIndicator(
                backgroundColor: Colors.white,
              ))
            : SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Header(statusList: states),
                    BlackCard(
                      command: '1',
                      phoneNumber: phone,
                      isNull: finalNames[0].name.length > 0 ? true : false,
                      id: 1,
                      isEdit: true,
                      titleChangeName: 'یک',
                      itemName: finalNames[0].name.length > 0
                          ? finalNames[0].name
                          : 'دستگاه شماره یک',
                      isOn: states[0] == '1' ? true : false,
                      function: (value) {
                        stateOne = value;

                        states[0] =
                            value == true ? states[0] = '1' : states[0] = '0';
                      },
                      state: stateOne,
                      longClick: () {
                        sendS(1, stateOne ? 1 : 0);
                        refreshList(false);
                      },
                    ),
                    BlackCard(
                      command: '2',
                      phoneNumber: phone,
                      isNull: finalNames[1].name.length > 0 ? true : false,
                      id: 2,
                      isEdit: true,
                      titleChangeName: 'دو',
                      itemName: finalNames[1].name.length > 0
                          ? finalNames[1].name
                          : 'دستگاه شماره دو',
                      isOn: states[1] == '1' ? true : false,
                      function: (value) {
                        stateOne = value;

                        states[1] =
                            value == true ? states[1] = '1' : states[1] = '0';
                      },
                      state: stateOne,
                      longClick: () {
                        sendS(2, stateOne ? 1 : 0);
                        refreshList(false);
                      },
                    ),
                    BlackCard(
                      command: '3',
                      phoneNumber: phone,
                      isNull: finalNames[2].name.length > 0 ? true : false,
                      id: 3,
                      isEdit: true,
                      titleChangeName: 'سه',
                      itemName: finalNames[2].name.length > 0
                          ? finalNames[2].name
                          : 'دستگاه شماره سه',
                      isOn: states[2] == '1' ? true : false,
                      function: (value) {
                        stateOne = value;

                        states[2] =
                            value == true ? states[2] = '1' : states[2] = '0';
                      },
                      state: stateOne,
                      longClick: () {
                        sendS(3, stateOne ? 1 : 0);
                        refreshList(false);
                      },
                    ),
                    BlackCard(
                      command: '4',
                      phoneNumber: phone,
                      isNull: finalNames[3].name.length > 0 ? true : false,
                      id: 4,
                      isEdit: true,
                      titleChangeName: 'چهار',
                      itemName: finalNames[3].name.length > 0
                          ? finalNames[3].name
                          : 'دستگاه شماره چهار',
                      isOn: states[3] == '1' ? true : false,
                      function: (value) {
                        stateOne = value;
                        states[3] =
                            value == true ? states[3] = '1' : states[3] = '0';
                      },
                      state: stateOne,
                      longClick: () {
                        sendS(4, stateOne ? 1 : 0);
                        refreshList(false);
                      },
                    ),
                    BlackCard(
                      command: '5',
                      phoneNumber: phone,
                      isNull: finalNames[4].name.length > 0 ? true : false,
                      id: 5,
                      isEdit: true,
                      titleChangeName: 'پنج',
                      isTemporary: true,
                      itemName: finalNames[4].name.length > 0
                          ? finalNames[4].name
                          : 'دستگاه شماره پنج',
                      isOn: false,
                      function: () async {
                        await Sendsms.onGetPermission();

                        try {
                          numbers = await _phoneDB.getPhoneNumber();
                          phone = numbers[0].phone;
                          showAlertSendSMS('ارسال دستور', context,
                              // If Click On * Yes * Button, then this method will be run.
                              () {
                            setState(
                              () {
                                sendSMS(
                                    message: '(REL 5 1)', phoneNumber: phone);
                                Navigator.of(context).pop();
                                sendingSmsDialog(context: context);
                              },
                            );
                            // If Click On * No * Button, then this method will be run.
                          }, noButton: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => MainScreen()));
                          });
                        } catch (e) {
                          sendingSmsDialog(
                              context: context,
                              content: 'خطا',
                              second: 2,
                              imgUrl: 'assets/images/cancel.svg');
                        }
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
