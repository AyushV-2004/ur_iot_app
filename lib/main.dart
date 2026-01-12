import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ur_iot_app/auth/auth.dart';
import 'package:ur_iot_app/firebase_options.dart';
import 'package:ur_iot_app/themes/lightMode.dart';
import 'package:ur_iot_app/themes/darkMode.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'ble/ble_connection_state.dart';
import 'ble/ble_data_provider.dart';
import 'ble/ble_device_provider.dart';


const String GEMINI_API_KEY = "AIzaSyBnP2ISKl3gTR3UJk33mVevmWcZTvazZYg";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  await Hive.openBox('healthData');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BleConnectionState()),
        ChangeNotifierProvider(create: (_) => BleDataProvider()),
        ChangeNotifierProvider(create: (_) => BleDeviceProvider()),
      ],
      child: const MyApp(),
    ),
  );
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
