import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FlushbarExtension{

  static void oneMessageFlushbar(BuildContext context, String message){

    Flushbar(
      title: "Aral Mezunlar Derneği",
      message: message,
      duration: const Duration(seconds: 2, milliseconds: 500),
      isDismissible: true,
      icon: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: const FaIcon(FontAwesomeIcons.circleInfo, color: Colors.white),
      ),
      borderRadius: BorderRadius.circular(4),
      flushbarPosition: FlushbarPosition.BOTTOM,
      flushbarStyle: FlushbarStyle.FLOATING,
      positionOffset: 36.h,
      margin: EdgeInsets.symmetric(horizontal: 10.w),
      backgroundGradient: const LinearGradient(
        colors: [Colors.lightBlueAccent, Colors.blue],
      ),
    ).show(context);

  }

  static void oneMessageErrorFlushbar(BuildContext context, String message){

    Flushbar(
      title: "Aral Mezunlar Derneği",
      message: message,
      duration: const Duration(seconds: 2, milliseconds: 500),
      isDismissible: true,
      backgroundColor: Colors.red,
      icon: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: const FaIcon(FontAwesomeIcons.exclamation, color: Colors.white),
      ),
      borderRadius: BorderRadius.circular(4),
      flushbarPosition: FlushbarPosition.BOTTOM,
      flushbarStyle: FlushbarStyle.FLOATING,
      positionOffset: 36.h,
      margin: EdgeInsets.symmetric(horizontal: 10.w),
      backgroundGradient: const LinearGradient(
        colors: [Colors.red, Colors.redAccent],
      ),
    ).show(context);

  }


}