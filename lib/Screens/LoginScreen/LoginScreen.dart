import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smscontroller/Components/RoundedTextField.dart';
import 'package:smscontroller/Controller/LoginPasswordController.dart';
import 'package:smscontroller/Controller/SystemChangeNameController.dart';
import 'package:smscontroller/Controller/SystemStateController.dart';
import 'package:smscontroller/Screens/MainScreen/MainScreen.dart';
import 'package:smscontroller/constants.dart';

class LoginScreen extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  List<LoginPasswordController> users = [];
  LoginPasswordHelper _db = LoginPasswordHelper();
  SystemStatusHelper statusDb = SystemStatusHelper();
  SystemChangeNameHelper changeNameDb = SystemChangeNameHelper();
  SystemChaneNameController changeNameController;
  String password;

  @override
  Widget build(BuildContext context) {
    TextEditingController _controller = TextEditingController();
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: kLoginScreenBackground,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SvgPicture.asset(
                'assets/images/LoginScreen_Character.svg',
                width: size.width * 0.85,
              ),
              RoundedTextField(
                value: (value) {},
                controller: _controller,
                isPasswordField: true,
                suffixIcon: Icons.lock_outline,
                hintText: 'لطفا رمز عبور خود را وارد نمایید',
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              Container(
                width: size.width * 0.35,
                height: size.height * 0.08,
                child: RaisedButton(
                  onPressed: () async {
                    var getResultStatus = await statusDb.getStatus();
                    if (getResultStatus.length == 0) {
                      statusDb.createDatabase();
                    }

                    var getResultChangeNames = await changeNameDb.getNames();

                    if (getResultChangeNames.length == 0) {
                      changeNameDb.createDatabase();
                      for (int i = 1; i <= 5; i++) {
                        changeNameController =
                            SystemChaneNameController(id: i, name: 'دستگاه $i');
                        changeNameDb.setName(changeNameController);
                      }
                    }

                    // Get Password
                    users = await _db.getPassword();
                    if (users.length != 0)
                      password = users[0].password;
                    else
                      password = '1234';

                    if (_controller.text == password) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MainScreen()));
                    } else {
                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                          backgroundColor: Colors.black87,
                          elevation: 10.0,
                          content: Text('رمز عبور نا معتبر است',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: kWhiteColor))));
                    }
                  },
                  elevation: 0.0,
                  child: Text('ورود'),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
