import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ur_iot_app/auth/LoginOrRegister.dart';

import '../pages/HomePage.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(), builder: (context,snapshot){
        //if user logged in
        if(snapshot.hasData){
          return const HomePage();
    }
        else{
          return const LoginOrRegister();
        }
    },
      ),
    );
  }
}
