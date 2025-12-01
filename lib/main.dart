import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ur_iot_app/auth/auth.dart';
import 'package:ur_iot_app/firebase_options.dart';
import 'package:ur_iot_app/themes/lightMode.dart';
import 'package:ur_iot_app/themes/darkMode.dart';

const String GEMINI_API_KEY = "AIzaSyBnP2ISKl3gTR3UJk33mVevmWcZTvazZYg";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Hive for local storage
  await Hive.initFlutter();
  await Hive.openBox('healthData'); // stores sensor readings for graphs

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthPage(), // checks user login state
      theme: lightMode,
      //darkTheme: darkMode,
    );
  }
}
