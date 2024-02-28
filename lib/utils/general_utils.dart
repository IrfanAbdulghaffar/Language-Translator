import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:flutter/material.dart';
import 'package:translator_app/resources/components/app_colors.dart';

class Utils{
  static void flushbarErrorMessage(String message, BuildContext context){
    showFlushbar(context: context, flushbar: Flushbar(
      message: message,
      backgroundColor: AppColors.redColor,
      duration: const Duration(seconds: 3),
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
      borderRadius: BorderRadius.circular(15),
      forwardAnimationCurve: Curves.fastOutSlowIn,
      reverseAnimationCurve: Curves.easeInOut,
      icon: const Icon(Icons.error,color: Colors.white,),
      positionOffset: 20,
      flushbarPosition: FlushbarPosition.TOP,
    )..show(context));
  }
}