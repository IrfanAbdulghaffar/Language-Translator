import 'package:flutter/cupertino.dart';
import 'package:translator_app/utils/routes/routes_names.dart';
import 'package:translator_app/utils/shared_pref_instance.dart';

class SplashScreenViewModel extends ChangeNotifier{
  Future<void> navigateToNextScreen(BuildContext context)async{
    notifyListeners();
    BuildContext localContext = context;
    String? userId=SharedPreference.instance.getData("user_id");
    await Future.delayed(const Duration(seconds: 3));
    if(userId!=null&&userId!=""){
      Navigator.pushReplacementNamed(localContext, RoutesNames.home);
    }else{
      Navigator.pushReplacementNamed(localContext, RoutesNames.login);
    }
  }
}