import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:translator_app/utils/general_utils.dart';
import 'package:translator_app/utils/routes/routes_names.dart';

class AuthenticationViewModel extends ChangeNotifier{
  bool _loading = false;
  bool get loading => _loading;
  bool _signupLoading = false;
  bool get signupLoading => _signupLoading;
  setLoading(bool value){
    _loading = value;
    notifyListeners();
  }
  setSignupLoading(bool value){
    _signupLoading = value;
    notifyListeners();
  }
Future<void> signupWithEmailandPassword(String email, String password, BuildContext context)async {
  setSignupLoading(true);
  try {
    // UserCredential userCredential = await FirebaseAuth.instance
    //     .signInWithEmailAndPassword(email: email, password: password);
    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    setSignupLoading(false);
    Navigator.pushNamed(context, RoutesNames.home);
    if (kDebugMode) {
      Utils.flushbarErrorMessage('Signup successfully', context);
      print(userCredential.user.toString());
    }
  } catch (error) {
    setSignupLoading(false);
    if (kDebugMode) {
      Utils.flushbarErrorMessage(error.toString(), context);
      print(error.toString());
    }
  }
}
  Future<void> loginWithEmailandPassword(String email, String password, BuildContext context)async {
    setLoading(true);
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      setLoading(false);
      Navigator.pushNamed(context, RoutesNames.home);
      if (kDebugMode) {
        Utils.flushbarErrorMessage('Login successfully', context);
        print(userCredential.user.toString());
      }
    } catch (error) {
      setLoading(false);
      if (kDebugMode) {
        Utils.flushbarErrorMessage(error.toString(), context);
        print(error.toString());
      }
    }
  }
}