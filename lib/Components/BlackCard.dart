import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sendsms/sendsms.dart';
import 'package:sms/sms.dart';
import 'package:smscontroller/Components/MainDialog.dart';
import 'package:smscontroller/Controller/SystemNumberController.dart';
import 'package:smscontroller/Controller/SystemStateController.dart';
import 'package:smscontroller/Screens/MainScreen/MainScreen.dart';
import '../constants.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';

import 'CallAndSendSms.dart';

class BlackCard extends StatefulWidget {
  final String itemName;
  final String titleChangeName;
  final bool isTemporary;
  final Function changeName;
  final Function function;
  final bool isEdit;
  final int id;
  final bool isNull;
  final bool state;
  final Function longClick;
  String textChangeName;
  bool isOn;
  final String phoneNumber;
  final String command;

  BlackCard({
    this.itemName = 'Loading',
    this.isOn = true,
    this.isTemporary = false,
    this.titleChangeName = 'Loading',
    this.changeName,
    this.function,
    this.textChangeName = "خالی",
    this.isEdit = false,
    this.id,
    this.isNull = false,
    this.phoneNumber,
    this.command,
    this.state = false,
    this.longClick,
  });

  @override
  _BlackCardState createState() => _BlackCardState();
}

class _BlackCardState extends State<BlackCard> {
  static AudioCache player = new AudioCache();
  String alarmAudioPath = "tik.mp3";
  TextEditingController textEditingController = TextEditingController();
  String text;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: size.width * 0.015, horizontal: size.height * 0.015),
      height: size.height * 0.13,
      width: double.infinity,
      decoration: BoxDecoration(
          color: Color(0xFF535c68), borderRadius: BorderRadius.circular(15.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(
                  left: size.width * 0.03,
                  bottom: size.width * 0.05,
                  top: size.width * 0.05),
              child: GestureDetector(
                onLongPress: widget.longClick,
                child: LiteRollingSwitch(
                  iconOn: Icons.lightbulb_outline,
                  iconOff: Icons.power_settings_new,
                  textSize: size.width * 0.04,
                  textOn: 'روشن',
                  textOff: 'خاموش',
                  value: widget.isOn,
                  colorOn: widget.isTemporary == true
                      ? Colors.yellow[800]
                      : Color(0xFF4834d4),
                  colorOff: Color(0xFFbdc3c7),
                  onSwipe: (value) {},
                  animationDuration: Duration(milliseconds: 300),
                  onChanged: widget.isTemporary == true
                      ? (value) {
                          player.play(alarmAudioPath);
                        }
                      : widget.function,
                  onTap: widget.isTemporary == true
                      ? widget.function
                      : () {
                          player.play(alarmAudioPath);
                        },
                ),
              )),
          GestureDetector(
            onLongPress: () {
              showMainDialog(
                id: widget.id,
                isEditing: true,
                context: context,
                btnOk: widget.changeName,
                hintText: '. . . نام جدید را وارد نمایید',
                title: 'تغییر نام وسیله شماره ' + widget.titleChangeName,
                inputType: TextInputType.text,
                controller: textEditingController,
              );
              // Navigator.pop(context, textEditingController.text);
            },
            child: Padding(
              padding: EdgeInsets.only(
                  right: widget.isNull == true ? size.width * 0.1 : 0),
              child: Text(
                widget.itemName,
                style: TextStyle(color: kWhiteColor, fontSize: 20.0),
              ),
            ),
          )
        ],
      ),
    );
  }
}
