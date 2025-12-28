import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:permission_handler/permission_handler.dart';

import '../ble/ble_service.dart';
import 'DeviceDashboardPage.dart';

class ScanDevicePage extends StatefulWidget {
  const ScanDevicePage({super.key});

  @override
  State<ScanDevicePage> createState() => _ScanDevicePageState();
}

class _ScanDevicePageState extends State<ScanDevicePage> {
  final BleService bleService = BleService();
  final List<DiscoveredDevice> devices = [];

  bool isScanning = false;
  String statusText = "Checking permissions...";

  @override
  void initState() {
    super.initState();
    _checkPermissionAndScan();
  }

  /// STEP 1: Ask location permission
  Future<void> _checkPermissionAndScan() async {
    final status = await Permission.location.request();

    if (status.isGranted) {
      statusText = "Scanning for devices...";
      setState(() {});
      _startScan();
    } else {
      setState(() {
        statusText = "Location permission is required for BLE scanning";
      });
    }
  }

  /// STEP 2: Start BLE scan
  void _startScan() {
    isScanning = true;
    print("🔍 BLE scan started");
    bleService.scanDevices().listen((device) {
      print("📡 Discovered device: ${device.name} (${device.id})");
      if (device.name.startsWith("UrHealth_")) {
        if (!devices.any((d) => d.id == device.id)) {
          print("✅ Added AQI device: ${device.name}");
          setState(() {
            devices.add(device);
          });
        }
      }
    }, onError: (error) {
      print("❌ Scan error: $error");
      setState(() {
        statusText = "Scan error: $error";
        isScanning = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan AQI Device"),
      ),
      body: devices.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isScanning) const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              statusText,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      )
          : ListView.builder(
        itemCount: devices.length,
        itemBuilder: (_, i) {
          final device = devices[i];
          return ListTile(
            leading: const Icon(Icons.bluetooth),
            title: Text(device.name),
            subtitle: Text(device.id),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DeviceDashboardPage(device),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
