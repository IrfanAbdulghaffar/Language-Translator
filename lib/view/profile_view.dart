import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:translator_app/utils/shared_pref_instance.dart';
import '../resources/components/app_colors.dart';
import '../utils/routes/routes_names.dart';


class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
   Map<String, dynamic>? userData;

  Future<Map<String, dynamic>> getUserData(String uid) async {
    DatabaseReference databaseReference = FirebaseDatabase.instance.reference();
    DatabaseEvent databaseEvent=await databaseReference.child('users').child(uid).once();
    DataSnapshot dataSnapshot = databaseEvent.snapshot;

    // Check if user data exists
    if (dataSnapshot.value != null) {
      return Map<String, dynamic>.from(dataSnapshot.value as dynamic);
    } else {
      return {};
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        Map<String, dynamic> data = await getUserData(user.uid);
        setState(() {
          userData = data;
        });
      }
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile',style: TextStyle(color: AppColors.whiteColor),),
        backgroundColor: AppColors.primary,
        iconTheme: const  IconThemeData(
          color: AppColors.whiteColor,
        ),
        actions: [
          IconButton(onPressed: (){
            Navigator.pushNamed(context, RoutesNames.editProfile,arguments: {"userData": userData}).then((value) {
              fetchUserData();
            });
          }, icon: const Icon(Icons.edit)),
        ],
      ),
      body: userData!=null
          ? Center(
            child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
            Text('Name: ${userData?['name']}'),
            Text('UserName: ${userData?['userName']}'),
            Text('Email: ${userData?['email']}'),
            Text('Address: ${userData?['address']}'),
            Text('Phone: ${userData?['phone']}'),
            // Add other user information widgets as needed
                    ],
                  ),
          )
          : Center(child: CircularProgressIndicator(color: AppColors.primary,)),
    );
  }
}
