import 'package:flutter/material.dart';
import 'package:translator_app/resources/components/app_colors.dart';

class CustomTextFormField extends StatelessWidget {
  final double? height;
  final double? width;
  final String? text;
  final Color? color;
  final TextEditingController controller ;



   CustomTextFormField({super.key, this.height, this.width, this.text, this.color, required this.controller,});
String get textValue => controller.text;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      height: height,
      decoration: BoxDecoration(
        color: AppColors.greyColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: text,
          hintStyle: TextStyle(color: AppColors.blackColor.withOpacity(0.3),),

        ),

      ),
    );
  }
}
