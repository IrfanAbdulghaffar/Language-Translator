import 'package:flutter/material.dart';
import 'package:translator_app/resources/components/app_colors.dart';
import 'package:translator_app/utils/routes/routes_names.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.menu),
        title: const  Text('home',style: TextStyle(color: AppColors.whiteColor),),
        backgroundColor: AppColors.primary,
        actions: [
          IconButton(onPressed: (){
            Navigator.pushNamed(context, RoutesNames.profile);
          }, icon: const Icon(Icons.person)),
        ],
        iconTheme: const  IconThemeData(
          color: AppColors.whiteColor,
        ),
      ),
    );
  }
}
