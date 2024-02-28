
import 'package:flutter/material.dart';

class AppColors{
  static const Color redColor = Colors.red;
  static  Color primary = Colors.blue.shade900;
  static const  Color secondary = Colors.orange;
  static const  Color whiteColor = Colors.white;
  static const  Color blackColor = Colors.black;
  static   Color greyColor = Colors.grey;
  static LinearGradient linearGradientColor(){
    List<Color> colors = [Color(0xff003366), Color(0xff003366)];
    List<double> stops = [0.0, 1.0];
    return LinearGradient(
      colors: colors,
      stops: stops,
      begin: Alignment.topLeft,
      end: Alignment.topRight
    );
  }
}