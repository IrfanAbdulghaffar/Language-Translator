import 'package:flutter/material.dart';

import '../resources/components/app_colors.dart';


class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile',style: TextStyle(color: AppColors.whiteColor),),
        backgroundColor: AppColors.primary,
        iconTheme: const  IconThemeData(
          color: AppColors.whiteColor,
        ),
      ),
      body: const Column(

      ),
    );
  }
}
