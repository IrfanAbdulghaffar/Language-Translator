import 'package:flutter/cupertino.dart';
import 'package:translator_app/utils/routes/routes_names.dart';

class SplashScreenViewModel extends ChangeNotifier{
  Future<void> navigateToNextScreen(BuildContext context)async{
    notifyListeners();
    BuildContext localContext = context;

    await Future.delayed(const Duration(seconds: 3));
    Navigator.pushNamed(localContext, RoutesNames.login);
  }
}