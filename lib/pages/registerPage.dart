import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ur_iot_app/Components/Button.dart';
import 'package:ur_iot_app/Components/textField.dart';

import '../helper/HelperMessage.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;


  const RegisterPage({super.key,required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController usernameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController ConfirmpwController = TextEditingController();

  Future<void> registerUser() async {

    //show loading circle
    showDialog(context: context, builder: (context) => const Center(
      //child: CircularProgressIndicator(),
    ),
    );

    //make sure password match
    if (passwordController.text != ConfirmpwController.text){
      Navigator.pop(context);

    //show error message
    displayMessageToUser("Passwords don't match",context);
    }

    //if passwords do match
else{
    //try creating user
    try {
    UserCredential? userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
    email: emailController.text, password: passwordController.text,);

    //pop loading cycle
    Navigator.pop(context);
    }on FirebaseAuthException catch(e){
    //pop loading cycle
    Navigator.pop(context);
    displayMessageToUser(e.code, context);
    }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            // Makes it scrollable when keyboard appears
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 25),

                // Title
                Text(
                  "Create Account!",
                  style: GoogleFonts.manrope(fontSize: 45),
                ),
                const SizedBox(height: 10),

                // Subtitle
                Text(
                  "Join us and start your journey!",
                  style: GoogleFonts.manrope(fontSize: 20),
                ),

                const SizedBox(height: 50),

                // Username
                MyTextField(
                  hintText: "Username",
                  obscureText: false,
                  controller: usernameController,
                ),
                const SizedBox(height: 12),

                // Email
                MyTextField(
                  hintText: "Email",
                  obscureText: false,
                  controller: emailController,
                ),
                const SizedBox(height: 15),

                // Password
                MyTextField(
                  hintText: "Password",
                  obscureText: true,
                  controller: passwordController,
                ),
                const SizedBox(height: 15),

                // Confirm Password
                MyTextField(
                  hintText: "Confirm Password",
                  obscureText: true,
                  controller: ConfirmpwController,
                ),

                const SizedBox(height: 25),

                // Register button
                MyButton(text: "Register", onTap: registerUser),

                const SizedBox(height: 25),

                // Login redirect
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        " Login Here",
                        style: TextStyle(
                          color: Color(0xFF1B52D7),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 50), // extra space for keyboard
              ],
            ),
          ),
        ),
      ),
    );
  }
}
