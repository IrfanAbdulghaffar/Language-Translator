


import 'package:flutter/material.dart';
import 'package:translator_app/view/home_screen_view.dart';
import 'package:translator_app/view/login_view.dart';
import 'package:translator_app/view/profile_view.dart';
import 'package:translator_app/view/signup_view.dart';
import 'package:translator_app/view/splash_screen_view.dart';
import 'package:translator_app/utils/routes/routes_names.dart';

class Routes{
  static Route<dynamic> generateRoutes(RouteSettings settings){
    switch(settings.name){
      case RoutesNames.splash:
        return MaterialPageRoute(builder: (context) => const SplashScreen());
      case RoutesNames.login:
        return MaterialPageRoute(builder: (context) => const LoginView());
      case RoutesNames.signup:
        return MaterialPageRoute(builder: (context) => const SignupView());
      case RoutesNames.home:
        return MaterialPageRoute(builder: (context) => const HomeScreen());
      case RoutesNames.profile:
        return MaterialPageRoute(builder: (context) => const Profile());
      default:
        return MaterialPageRoute(builder: (_){
          return const Scaffold(
            body: Center(
              child: Text('No routes defined'),
            ),
          );
        });
    }
  }
}