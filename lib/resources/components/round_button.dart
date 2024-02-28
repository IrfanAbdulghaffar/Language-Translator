import 'package:flutter/material.dart';
import 'package:translator_app/resources/components/app_colors.dart';

class RoundButton extends StatelessWidget {
  final String title;
  final bool loading;
  final VoidCallback? onPress;
  const RoundButton({super.key, required this.title, this.loading = false,  this.onPress});

  @override
  Widget build(BuildContext context) {
    LinearGradient myLinearGradient = AppColors.linearGradientColor();
    return  InkWell(
      onTap: onPress,
      child: Container(
        height: 57,

        margin: EdgeInsets.symmetric(horizontal: 57,vertical: 30),

        decoration: BoxDecoration(
          gradient: myLinearGradient,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(child:
        loading ? const CircularProgressIndicator() :
        Text(title,style: const TextStyle(color: AppColors.whiteColor,fontWeight: FontWeight.bold),),),
      ),
    );
  }
}
