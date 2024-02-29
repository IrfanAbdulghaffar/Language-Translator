import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:translator_app/utils/general_utils.dart';
import 'package:translator_app/utils/routes/routes_names.dart';

import '../utils/shared_pref_instance.dart';

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
Future<void> signupWithEmailandPassword(BuildContext context,{required String name,required String userName,required String email,required String address,required String phone, required String password})async {
  setSignupLoading(true);
  try {
    // UserCredential userCredential = await FirebaseAuth.instance
    // .signInWithEmailAndPassword(email: email, password: password);
    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);

    // Save additional user information to the real-time database
    DatabaseReference databaseReference = FirebaseDatabase.instance.reference();
    SharedPreference.instance.setData(key: "user_id",value:userCredential.user!.uid);
    databaseReference.child('users').child(userCredential.user!.uid).set({
      'name': name,
      'userName': userName,
      'email': email,
      'address': address,
      'phone': phone,
    });

    setSignupLoading(false);

    Navigator.pushNamed(context, RoutesNames.home);
    if (kDebugMode) {
      Utils.flushBarSuccessMessage('Signup successfully', context);
      print(userCredential.user.toString());
    }
  } catch (error) {
    setSignupLoading(false);
    if (kDebugMode) {
      Utils.flushBarErrorMessage(error.toString(), context);
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
        Utils.flushBarErrorMessage('Login successfully', context);
        print(userCredential.user.toString());
      }
    } catch (error) {
      setLoading(false);
      if (kDebugMode) {
        Utils.flushBarErrorMessage(error.toString(), context);
        print(error.toString());
      }
    }
  }

  Future<bool> updateProfile({
    required String name,
    required String userName,
    required String email,
    required String address,
    required String phone,
  }) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        DatabaseReference databaseReference = FirebaseDatabase.instance.reference();
        await databaseReference.child('users').child(user.uid).update({
          'name': name,
          'userName': userName,
          'email': email,
          'address': address,
          'phone': phone,
        });

        return true; // Update successful
      } else {
        return false; // User is null, update failed
      }
    } catch (error) {
      print('Error updating profile: $error');
      return false; // Update failed
    }
  }

}