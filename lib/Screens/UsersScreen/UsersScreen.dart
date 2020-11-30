import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smscontroller/Components/CallAndSendSms.dart';
import 'package:smscontroller/Components/MainDialog.dart';
import 'package:smscontroller/Components/RoundedButton.dart';
import 'package:smscontroller/Controller/SystemNumberController.dart';
import 'package:smscontroller/Controller/UsersController.dart';
import 'package:smscontroller/constants.dart';
import 'package:sms/sms.dart';

class UsersScreen extends StatefulWidget {
  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  List<String> users = List<String>();

  List<SystemUserController> dbUsers = [];
  SystemUserHelper _userDB = SystemUserHelper();
  SystemUserController userController;

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

  Future getUsers() async {
    dbUsers = await _userDB.getUsers();
    for (var value in dbUsers) {
      users.add(value.phone);
    }
  }

  String _formatReferenceCode(String code) {
    final Pattern pattern = RegExp(r'(.{11})(?!$)');
    return code.replaceAllMapped(pattern, (m) => '${m[0]}-');
  }

  SmsReceiver receiver = new SmsReceiver();
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () async {
      getUsers();
      setState(() {});
    });
  }

  void refreshList(String text) {
    receiver.onSmsReceived.listen((SmsMessage msg) async {
      if (msg.address == phone && msg.body.contains(text)) {
        sendingSmsDialog(
            second: 3,
            context: context,
            content: 'عملیات با موفقیت انجام شد',
            imgUrl: 'assets/images/successfuly_sent.svg');

        String result = "";

        for (int i = 0; i < msg.body.length; i++) {
          if ("0123456789".contains(msg.body[i])) result += msg.body[i];
        }

        result = _formatReferenceCode(result);
        users = result.split('-').toList();
        print(users);
        _userDB.deleteDB();
        _userDB.createDatabase();
        for (int i = 0; i < users.length; i++) {
          userController = SystemUserController(id: i + 1, phone: users[i]);
          _userDB.setUsers(userController);
        }
      } else if (msg.address == phone) {
        sendingSmsDialog(
            second: 1,
            context: context,
            content: 'عملیات با خطا مواجه شد',
            imgUrl: 'assets/images/cancel.svg');
      } else {
        print('Error !');
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final _scaffoldKey = GlobalKey<ScaffoldState>();
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        backgroundColor: kSilverLightColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RoundedButton(
                    text: 'بروزآوری',
                    icon: Icons.file_download,
                    onTap: () async {
                      //users.clear();
                      await getPhone();
                      //await getUsers();
                      setState(() {});
                      showMainSmsDialog(
                          context: context,
                          phone: phone,
                          text: '(MOBILE)',
                          title: 'بروزآوری');
                      //refreshList('USER:');
                    },
                  ),
                  RoundedButton(
                    text: 'کاربر جدید',
                    icon: Icons.person_add,
                    onTap: () async {
                      //users.clear();
                      await getPhone();
                      //await getUsers();
                      setState(() {});
                      if (users.length >= 5) {
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                            backgroundColor: Colors.black87,
                            elevation: 10.0,
                            content: Text(
                                'شما نمیتوانید بیش از 5 کاربر اضافه کنید',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: kWhiteColor))));
                      } else {
                        await getPhone();
                        showMainDialog(
                          controller: _controller,
                          context: context,
                          hintText: '. . . لطفا شماره مورد نظر را وارد نمایید',
                          btnOk: () {
                            Navigator.of(context).pop();
                            showMainSmsDialog(
                                context: context,
                                phone: phone,
                                text: '(MOBILE ${_controller.text})',
                                title: 'کاربر جدید');
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              Expanded(
                  child: ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, i) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: kLoginScreenBackground,
                          ),
                          margin: EdgeInsets.only(bottom: 10.0),
                          height: size.height * 0.08,
                          child: ListTile(
                            onLongPress: () async {
                              if (i == 0) {
                                _scaffoldKey.currentState.showSnackBar(SnackBar(
                                    backgroundColor: Colors.black87,
                                    elevation: 10.0,
                                    content: Text(
                                        'شما نمیتوانید کاربر مدیر را حذف کنید',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: kWhiteColor))));
                              } else {
                                setState(() async {
                                  await getPhone();
                                  print(users[i]);
                                  showMainSmsDialog(
                                      context: context,
                                      phone: phone,
                                      text: '(DELETE ${users[i]})',
                                      title: 'حذف کاربر');

                                  refreshList('USER:');
                                });
                              }
                            },
                            title: Text(
                              i == 0 ? '${users[i]} ( Admin ) ' : '${users[i]}',
                              style: TextStyle(color: Colors.white),
                            ),
                            leading: i == 0
                                ? Icon(
                                    Icons.verified_user,
                                    color: Colors.white,
                                    size: size.height * 0.04,
                                  )
                                : Icon(
                                    Icons.supervised_user_circle,
                                    color: Colors.white,
                                    size: size.height * 0.04,
                                  ),
                          ),
                        );
                      }))
            ],
          ),
        ),
      ),
    );
  }
}
