import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:translator_app/resources/components/app_colors.dart';

class Utils{
  static void flushBarErrorMessage(String message, BuildContext context){
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: Colors.red,
      timeInSecForIosWeb: 1,
      fontSize: 13.0,
    );
    // showFlushbar(context: context, flushbar: Flushbar(
    //   message: message,
    //   backgroundColor: AppColors.redColor,
    //   duration: const Duration(seconds: 3),
    //   padding: const EdgeInsets.all(15),
    //   margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
    //   borderRadius: BorderRadius.circular(15),
    //   forwardAnimationCurve: Curves.fastOutSlowIn,
    //   reverseAnimationCurve: Curves.easeInOut,
    //   icon: const Icon(Icons.error,color: Colors.white,),
    //   positionOffset: 20,
    //   flushbarPosition: FlushbarPosition.BOTTOM,
    // )..show(context));
  }

  static void flushBarSuccessMessage(String message, BuildContext context){
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: Colors.green,
      timeInSecForIosWeb: 1,
      fontSize: 13.0,
    );
    // showFlushbar(context: context, flushbar: Flushbar(
    //   message: message,
    //   backgroundColor: AppColors.greenColor,
    //   duration: const Duration(seconds: 5),
    //   padding: const EdgeInsets.all(15),
    //   margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
    //   borderRadius: BorderRadius.circular(15),
    //   forwardAnimationCurve: Curves.fastOutSlowIn,
    //   reverseAnimationCurve: Curves.easeInOut,
    //   icon: const Icon(Icons.done,color: Colors.white,),
    //   positionOffset: 20,
    //   flushbarPosition: FlushbarPosition.BOTTOM,
    // )..show(context));
  }
}