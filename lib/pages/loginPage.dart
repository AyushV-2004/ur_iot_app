import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ur_iot_app/Components/Button.dart';
import 'package:ur_iot_app/Components/textField.dart';
import 'package:ur_iot_app/helper/HelperMessage.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

 const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  void login() async{
    showDialog(context: context,builder: (context)=> const Center(
      // child: CircularProgressIndicator(),
    ),
    );
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text);

      //pop loading cycle
      if(context.mounted) Navigator.pop(context);
    }
    on FirebaseAuthException catch(e){
      //pop loading cycle
      Navigator.pop(context);
      displayMessageToUser(e.code, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            //logo
            children: [
          //     Icon(
          //       Icons.person,
          //       size: 80,
          //       color: Theme.of(context).colorScheme.inversePrimary,
          // ),

          const SizedBox(height: 25),

          //app name
          Text("Hello User!",style: GoogleFonts.manrope(
            fontSize: 45,
          ),
          ),
          const SizedBox(height: 10),

          //app name
            Text("Welcome back, you've been missed!",style: GoogleFonts.manrope(
                fontSize: 20),
          ),
            const SizedBox(height: 40),

            //email
            MyTextField(hintText: "Email", obscureText: false, controller: emailController),
            const SizedBox(height: 15),
            //password
            MyTextField(hintText: "Password", obscureText: true, controller: passwordController),

              const SizedBox(height: 7),
          //forgot password
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("Forgot Password",style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary),
                  ),
                ],
              ),

            const SizedBox(height: 25),
            //sign in
            MyButton(text: "Login", onTap: login,),

              const SizedBox(height: 25),
              //don't have account
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?",style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary),
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text("  Register Here",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B52D7),
                    ),),
                  ),
                ],
              ),
          ],
          ),
        ),
      ),
    );
  }
}
