import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ur_iot_app/pages/AboutUsPage.dart';
import 'package:ur_iot_app/pages/ScanDevicePage.dart';


class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  void logout() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text("S E T T I N G S"),
        backgroundColor: Theme.of(context).colorScheme.background,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 45),
        child: Column(
          children: [
            ListTile(
              leading: Icon(
                Icons.logout,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              title: const Text("L O G O U T"),
              onTap: () {
                logout();
              },
            ),
            ListTile(
              leading: Icon(
                Icons.person,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              title: const Text("A B O U T U S"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AboutUsPage(),
                  ),
                );
              },
              ),
            ListTile(
              leading: Icon(
                Icons.bluetooth_connected,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              title: const Text("C O N N E C T  D E V I C E"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ScanDevicePage(),
                  ),
                );
              },
            ),

          ],
        ),
      ),
    );
  }
}
