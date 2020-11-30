import 'package:animated_dialog/AnimatedDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smscontroller/Controller/SystemChangeNameController.dart';
import 'package:smscontroller/Screens/MainScreen/MainScreen.dart';
import '../constants.dart';

void showMainDialog({
  BuildContext context,
  String title = "",
  String hintText,
  String txtBtnOk = 'تایید',
  String txtBtnCancel = 'انصراف',
  int id = 0,
  TextEditingController controller,
  bool isEditing = false,
  Function btnOk,
  TextInputType inputType = TextInputType.phone,
  int maxLength = 100,
}) {
  Size size = MediaQuery.of(context).size;
  TextEditingController textEditingController = TextEditingController();

  List<SystemChaneNameController> finalNames = [];
  //Create DB Object
  SystemChangeNameHelper _changeNameDB = SystemChangeNameHelper();
  // State Controller
  SystemChaneNameController changeNameController;

  showDialog(
      context: context,
      child: AnimatedDialog(
        width: size.width * 0.9,
        height: size.height * 0.28,
        color: kWhiteColor,
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black87),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                    vertical: size.height * 0.02,
                    horizontal: size.width * 0.05),
                height: size.height * 0.06,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(size.width * 0.035),
                  color: kLoginScreenBackground,
                ),
                child: TextField(
                  controller: controller,
                  keyboardType: inputType,
                  style: kTextFieldStyle.copyWith(fontSize: size.width * 0.04),
                  textAlign: TextAlign.center,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(maxLength),
                  ],
                  decoration: InputDecoration(
                      hintText: hintText,
                      hintStyle: kTextFieldStyle.copyWith(
                          fontSize: size.width * 0.034),
                      border: InputBorder.none),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(txtBtnCancel),
                  ),
                  FlatButton(
                    onPressed: isEditing
                        ? () {
                            changeNameController = SystemChaneNameController(
                                id: id, name: controller.text);
                            _changeNameDB.setName(changeNameController);
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => MainScreen()));
                          }
                        : btnOk,
                    child: Text(txtBtnOk),
                  ),
                ],
              )
            ],
          ),
        ),
      ));
}
