import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './navigation.dart';
import './login.dart';


class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(  
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //user is logged in
          if (snapshot.hasData) {
            final uid = snapshot.data!.uid;
            return BottomTabBar(); // Pass the UID to the BottomTabBar widget
          }
          //user not logged in
          else{
            return LoginPage();
          }
        },
      )
    );
  }
}